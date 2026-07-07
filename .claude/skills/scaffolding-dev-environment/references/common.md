# Version pinning & misc

## mise — pin every tool/runtime version

The single source of truth for toolchain versions, shared by local dev and CI. Pin
*everything* the project invokes — language runtimes, package managers, and CLI tools —
so "works on my machine" and "works in CI" stay identical.

Resolve the *current* stable of each tool at setup time — the keys below are the shape,
the values are placeholders, not versions to copy:

```toml
# mise.toml
[tools]
node      = "…"
pnpm      = "…"
python    = "…"
uv        = "…"
terraform = "…"
tflint    = "…"
tfsec     = "…"
pinact    = "…"
```

- **Match the precision CI uses.** Where CI's setup actions request an exact patch
  version (e.g. `terraform_version: "X.Y.Z"`), pin that same patch version in `mise.toml`
  so local and CI resolve to the identical build. Use a looser pin only where CI is also
  loose.
- A language-native pin file may also exist and should agree with mise: the
  `packageManager` field + `engines` in `package.json` for Node/pnpm.

## Other languages — apply the same shape

For Go, Rust, etc., this skill doesn't prescribe a specific config, but the *shape* is the
same four checks, each a single command, each wired into CI and pinned via mise:

| | format | lint | type/compile | test |
|---|---|---|---|---|
| **Go** | `gofmt`/`gofumpt` | `golangci-lint run` | `go build ./...` | `go test ./...` |
| **Rust** | `cargo fmt --check` | `cargo clippy -- -D warnings` | `cargo check` | `cargo test` |

Add a per-language CI job mirroring those commands (see ci-cd.md), a `gomod`/`cargo`
Dependabot ecosystem (see dependency-hygiene.md), and the toolchain version in `mise.toml`.
