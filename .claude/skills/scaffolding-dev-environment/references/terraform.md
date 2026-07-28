# Terraform tooling

Recommended checks: **`terraform fmt`** (style), **`terraform validate`** (config
validity), **tflint** (lint + provider rules), **trivy** (misconfiguration scan), plus
a **`plan` job on PRs** that posts the diff as a comment. All run in CI as separate jobs
and are pinned via mise (see common.md).

> **Versions:** numbers below are illustrative. At setup time, resolve the *current*
> stable of each tool and pin that — don't copy a number from this doc, it will be stale.

## Repository layout

Infra lives under `terraform/`, where an **environment composes reusable modules**:

```text
terraform/
├── .tflint.hcl
├── .trivyignore
├── envs/
│   └── dev/               # one per environment; the only place terraform is run
│       ├── backend.tf     # remote state
│       ├── locals.tf      # every environment-specific value, hardcoded
│       ├── main.tf        # module blocks only
│       ├── outputs.tf providers.tf versions.tf
│       └── .terraform.lock.hcl   # committed
└── modules/
    └── <name>/            # may nest by category, e.g. storage/standard
        └── main.tf outputs.tf variables.tf versions.tf
```

- **Environments hold no variables and no `.tfvars`.** Values are literals in
  `envs/<env>/locals.tf`; the env layer only wires modules together, and a value you can
  only learn by opening a tfvars file is a value you can't review in a diff. `*.tfvars`
  stays gitignored (the standard Terraform gitignore already does this).
- **`versions.tf` in every directory** pins `required_version` and `required_providers`
  with `~>` constraints; keep `required_version` consistent with the `terraform` pin in
  `mise.toml`. Commit `.terraform.lock.hcl` per env — modules never get `init`-ed directly,
  so they have none.
- A module wrapping a single resource names it `this` (`google_project.this`). Every
  `variable` and `output` carries a `description` (`<<-EOT` heredoc if multi-line).
- `backend.tf` can't reference variables or module outputs, so the bucket name is spelled
  out literally — comment *why* it's duplicated.

## Commands

```bash
terraform fmt -check -recursive            # style, from terraform/ (drop -check to apply)
tflint --init && tflint --recursive        # lint + provider rules
trivy config .                             # misconfiguration scan
cd envs/<env>
terraform init -backend=false -input=false # init without a backend, for validate
terraform validate -no-color               # config validity
terraform plan                             # needs cloud credentials
```

Pin the versions so CI is reproducible:

```toml
# mise.toml
[tools]
terraform = "…"
tflint    = "…"
trivy     = "…"
```

## tflint config — `terraform/.tflint.hcl`

The bundled `terraform` ruleset covers language and style rules; the provider ruleset is a
separate plugin that must be version-pinned and sourced explicitly:

```hcl
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "google" {   # or "aws" / "azurerm" — match the provider actually used
  enabled = true
  version = "…"
  source  = "github.com/terraform-linters/tflint-ruleset-google"
}
```

- `tflint --init` downloads the ruleset from GitHub releases, so CI must pass
  `GITHUB_TOKEN` to that step or it rate-limits.
- Run with `--recursive` so modules are linted too, not just the env you happen to be in.

## trivy config — `terraform/.trivyignore`

`trivy config .` needs no config file — it's driven by CLI flags. Accepted findings go in
`.trivyignore`, one check ID per line. **Every entry needs a reason and a re-review
trigger**; an ignore file that only lists IDs is indistinguishable from ignoring the scan:

```text
# Accepted misconfiguration findings. Each entry needs a reason and the condition that
# should bring it back up for review.

# <why this control is not worth its cost in this environment — the threat it defends
# against, and what already covers that threat here. Re-review when <condition>.>
<CHECK-ID>
```

## CI wiring — `.github/workflows/terraform.yaml`

Terraform gets its own workflow with a `paths:` filter so it only runs when infra changes.
Each static check is its own fast, independently-signalling job; `plan` waits on all four.
`<sha> # vX.Y.Z` placeholders are filled by pinact (see dependency-hygiene.md):

```yaml
name: Terraform

on:
  push:
    branches: [main]
    paths: ["terraform/**", ".github/workflows/terraform.yaml"]
  pull_request:
    branches: [main]
    paths: ["terraform/**", ".github/workflows/terraform.yaml"]

permissions:
  contents: read

env:
  # Keep in sync with mise.toml.
  TF_VERSION: "<terraform version>"
  TFLINT_VERSION: "v<tflint version>"
  TRIVY_VERSION: "v<trivy version>"
  # Outputs of terraform/envs/<env> — see the cloud auth section below.
  WIF_PROVIDER: projects/<number>/locations/global/workloadIdentityPools/github-actions/providers/github
  TERRAFORM_PLAN_SA: terraform-plan@<project>.iam.gserviceaccount.com

jobs:
  fmt:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: terraform
    steps:
      - uses: actions/checkout@<sha> # vX.Y.Z
      - uses: hashicorp/setup-terraform@<sha> # vX.Y.Z
        with:
          terraform_version: ${{ env.TF_VERSION }}
          terraform_wrapper: false
      - run: terraform fmt -check -recursive

  lint:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: terraform
    steps:
      - uses: actions/checkout@<sha> # vX.Y.Z
      - uses: terraform-linters/setup-tflint@<sha> # vX.Y.Z
        with:
          tflint_version: ${{ env.TFLINT_VERSION }}
      - name: tflint --init
        # Downloading the provider ruleset from GitHub releases needs a token.
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: tflint --init
      - run: tflint --recursive --no-color

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@<sha> # vX.Y.Z
      - uses: aquasecurity/trivy-action@<sha> # vX.Y.Z
        with:
          version: ${{ env.TRIVY_VERSION }}
          scan-type: config
          scan-ref: terraform
          trivyignores: terraform/.trivyignore
          exit-code: "1"

  validate:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        env: [dev] # every environment under terraform/envs
    defaults:
      run:
        working-directory: terraform/envs/${{ matrix.env }}
    steps:
      - uses: actions/checkout@<sha> # vX.Y.Z
      - uses: hashicorp/setup-terraform@<sha> # vX.Y.Z
        with:
          terraform_version: ${{ env.TF_VERSION }}
          terraform_wrapper: false
      # -backend=false so validation needs no cloud credentials.
      - run: terraform init -backend=false -input=false
      - run: terraform validate -no-color

  plan:
    if: github.event_name == 'pull_request'
    needs: [fmt, lint, security, validate]
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
      pull-requests: write
    concurrency: # cancel superseded plans when a PR is pushed to repeatedly
      group: terraform-plan-dev-${{ github.ref }}
      cancel-in-progress: true
    defaults:
      run:
        working-directory: terraform/envs/dev
    steps:
      - uses: actions/checkout@<sha> # vX.Y.Z
      - uses: google-github-actions/auth@<sha> # vX.Y.Z
        with:
          workload_identity_provider: ${{ env.WIF_PROVIDER }}
          service_account: ${{ env.TERRAFORM_PLAN_SA }}
      - uses: hashicorp/setup-terraform@<sha> # vX.Y.Z
        with:
          terraform_version: ${{ env.TF_VERSION }}
          terraform_wrapper: false
      - run: terraform init -input=false
      - name: terraform plan
        # -lock=false because the plan SA is read-only and cannot write the lock object.
        run: |
          set -o pipefail
          terraform plan -no-color -input=false -lock=false | tee plan.txt
      - name: Comment plan on PR
        # Dependabot PRs get a read-only GITHUB_TOKEN regardless of the permissions block
        # above, so createComment would fail — skip the comment, keep the plan.
        if: ${{ !cancelled() && github.actor != 'dependabot[bot]' }}
        uses: actions/github-script@<sha> # vX.Y.Z
        with:
          script: |
            const fs = require('fs');
            const limit = 60000; // a comment body is capped around 65k characters
            let plan = fs.readFileSync('terraform/envs/dev/plan.txt', 'utf8');
            if (plan.length > limit) plan = plan.slice(0, limit) + '\n... (truncated)';
            await github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: `#### Terraform plan (dev)\n\n<details><summary>Show plan</summary>\n\n\`\`\`terraform\n${plan}\n\`\`\`\n\n</details>`,
            });
```

- `terraform_wrapper: false` everywhere — the wrapper mangles exit codes and output.
- The static four need no cloud credentials at all; only `plan` authenticates. That's why
  `validate` uses `-backend=false`, and why the four run in parallel with nothing beyond
  `contents: read`.
- Dependabot raises PRs for the `terraform` ecosystem, and those *do* get an OIDC token
  (same-repo branch), so the plan itself still runs — only the comment step is skipped.
- Terraform manifests are spread across `envs/` and `modules/`, so the Dependabot entry
  needs `directories:` (plural, globbable) rather than a single `directory:` — see
  dependency-hygiene.md.

## Cloud auth — OIDC / Workload Identity Federation

CI authenticates with short-lived OIDC tokens; **no long-lived service account keys are
ever created**. Manage the federation itself in Terraform, alongside everything else:

- The provider **MUST** carry an `attribute_condition` fixing the repository
  (`assertion.repository == "<owner>/<repo>"`). Without it, any GitHub repository in the
  world can mint tokens against the pool.
- **Two service accounts, split by privilege.** `terraform-plan` is read-only (viewer plus
  a security-reviewer role) and bound to the repository attribute — that's what the `plan`
  job assumes. An apply identity, where one exists, binds to a composite
  `repository_environment` attribute instead, so only a job declaring `environment: <env>`
  can assume it.
- **Bootstrap is manual, once.** The state bucket and the project can't be created by the
  apply that stores its state in them — create them by hand and `terraform import` them.
  Record the procedure in the README; it's the one step not reproducible from the code.
- Surface `workload_identity_provider` and the service account emails as outputs of
  `envs/<env>`, with descriptions naming the workflow `env:` keys they feed.

`apply` stays out of this workflow — deployment is genuinely repo-specific (see ci-cd.md).
If a repo does apply from CI, gate the job on a GitHub Environment and run `terraform plan
-out=tfplan` followed by `terraform apply tfplan`, so what gets applied is exactly what was
reviewed.
