# Terraform tooling

Recommended checks: **`terraform fmt`** (style), **`terraform validate`** (config
validity), **tflint** (lint + provider rules), **tfsec** (security/misconfig scan), plus
a **`plan` job on PRs** that posts the diff as a comment. All run in CI as separate jobs
and are pinned via mise (see common.md).

## Commands

```bash
terraform fmt -check -recursive   # style (drop -check to apply)
terraform init -backend=false     # init without a backend, for validate
terraform validate -no-color      # config validity
tflint --init && tflint --recursive
tfsec .                           # security scan
```

Pin the versions so CI is reproducible. Resolve the *current* stable of each at setup
time — don't copy stale numbers:

```toml
# mise.toml
[tools]
terraform = "…"
tflint    = "…"
tfsec     = "…"
```

## tfsec config

Suppress only with documented, scoped exclusions in `.tfsec/config.yml`:

```yaml
exclude:
  # Bucket uses Google-managed encryption, not customer-managed keys — accepted.
  - google-storage-bucket-encryption-customer-key
```

## CI wiring

Trigger on push/PR with a `paths:` filter on `terraform/**` so it only runs when infra
changes. Each static check is its own fast, independently-signalling job:

- `fmt` — `terraform fmt -check -recursive`
- `validate` — `terraform init -backend=false` then `terraform validate` (matrix over envs if multiple)
- `lint` — `tflint --init` then `tflint --recursive`
- `security` — `tfsec` (e.g. `aquasecurity/tfsec-action`, SHA-pinned)

A **`plan` job is part of the baseline**: on PRs only, after the static
jobs pass, it authenticates to the cloud via OIDC / Workload Identity Federation (no
long-lived keys, a read-only plan service account), runs `terraform plan`, and posts the
output as a PR comment so the diff is reviewable before merge. Skip it for
`dependabot[bot]` actors (no cloud auth). Leave the `apply` job to the repo's deploy
workflow — that's genuinely deploy-specific. See ci-cd.md for the overall workflow shape.