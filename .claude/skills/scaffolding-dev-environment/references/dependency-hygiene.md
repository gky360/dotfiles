# Dependency hygiene

Three complementary mechanisms keep dependencies fresh **and** resistant to
supply-chain attacks:

1. **Dependabot** — opens grouped update PRs on a schedule.
2. **pinact** — pins GitHub Actions to commit SHAs (a tag can be re-pointed; a SHA can't).
3. **New-version adoption delay** — refuse to install versions published *just now*, so a
   compromised fresh release ages out before it reaches you (pnpm `minimumReleaseAge`,
   Dependabot `cooldown`).

## Dependabot — `.github/dependabot.yml`

One `updates` entry per ecosystem present, each pointed at the manifest's directory. All
ecosystems run weekly. Group minor+patch into a single PR (separately for version vs.
security updates) to cut noise, and add a `cooldown` so brand-new releases age before a PR
is raised.

```yaml
version: 2
updates:
  - package-ecosystem: 'github-actions'
    directory: '/'
    schedule:
      interval: weekly
      day: friday
      time: '12:00'
      timezone: Asia/Tokyo
    cooldown:
      default-days: 7
    groups:
      minor-updates:
        update-types: ['minor', 'patch']

  - package-ecosystem: 'npm'          # or 'uv' (py), 'terraform', 'gomod', 'cargo', ...
    directory: '/node'                # the dir containing the manifest/lockfile
    schedule:
      interval: weekly
      day: friday
      time: '12:00'
      timezone: Asia/Tokyo
    cooldown:
      default-days: 7
    versioning-strategy: increase     # for npm and uv; omit for terraform/github-actions
    groups:
      minor-updates:
        applies-to: version-updates
        update-types: ['minor', 'patch']
      security-minor-updates:
        applies-to: security-updates
        update-types: ['minor', 'patch']
```

Repeat the second block per language ecosystem (`uv` → `/py`, `terraform` → `/terraform`,
etc.), adjusting `directory`. Keep `versioning-strategy: increase` for `npm` and `uv`;
drop it for `terraform`. Drop ecosystems the repo doesn't have.

## pinact — `pinact.yaml`

```yaml
version: 3
files:
  - pattern: .github/workflows/*.yaml
  - pattern: .github/workflows/*.yml
```

Run `pinact run` to rewrite every `uses: owner/action@vX` into `uses: owner/action@<sha> # vX`.
Keep the trailing `# vX.Y.Z` comment so Dependabot still reads the version. CI enforces
this with a `pinact` job (see ci-cd.md) that fails if anything is unpinned — so a PR can't
introduce a mutable tag.

## New-version adoption delay (supply-chain)

Dependabot's `cooldown` covers *update PRs*, but a fresh malicious version can still land
via a normal `install` that resolves a `^`/`~` range. Close that gap at the package
manager:

- **pnpm** (v10.16+): set `minimumReleaseAge` so the resolver skips versions newer than N
  minutes. In `pnpm-workspace.yaml` (monorepo) or the root `package.json` pnpm config:

  ```yaml
  # pnpm-workspace.yaml
  minimumReleaseAge: 1440          # minutes (here, 1 day)
  # minimumReleaseAgeExclude:       # allowlist trusted packages that may update instantly
  #   - "@my-scope/*"
  ```

- **uv** (Python): set `exclude-newer` in `pyproject.toml` to refuse resolving releases
  newer than a cutoff — a rolling window like `"1 week"` both makes resolution
  reproducible and ages out brand-new releases:

  ```toml
  # pyproject.toml
  [tool.uv]
  exclude-newer = "1 week"
  ```

- **Other ecosystems**: there's no universal equivalent. For most, Dependabot `cooldown`
  plus SHA/lockfile pinning is the available defense — note the gap rather than implying
  parity.
