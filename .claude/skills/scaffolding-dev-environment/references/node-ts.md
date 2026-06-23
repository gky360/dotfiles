# Node / TypeScript tooling

Recommended default stack: **pnpm** (package manager, version-pinned and enforced),
**TypeScript** in `strictest` mode, and **vite-plus** (`vp`) as the single front-end for
lint (eslint+unicorn+oxc+import), format (oxfmt), typecheck, and unit test (vitest).

The requirement is **four checks runnable from CI**: format, lint, typecheck, unit test.
`vp` bundles all four behind one config; if the repo already uses biome/eslint+prettier
directly, respect it and just ensure all four exist and run in CI.

> **Versions:** numbers below are illustrative. At setup time, resolve the *current*
> stable of node / pnpm / each dev dep and pin those — don't copy a number from this doc.

## Package manager: pnpm, pinned and enforced

In the root `package.json`:

```jsonc
{
  "type": "module",
  "scripts": {
    "preinstall": "npx only-allow pnpm", // block npm/yarn from installing
    "build": "vp run -r build"
  },
  "devDependencies": { "@tsconfig/bases": "<latest>", "vite-plus": "<latest>" },
  "engines": { "node": ">=<current major>", "pnpm": ">=<current major>" },
  "packageManager": "pnpm@<exact current>" // exact pin; Corepack/CI use this
}
```

Pin `node` and `pnpm` in `mise.toml` too (see common.md). For a monorepo, add
`pnpm-workspace.yaml` with `packages: ["packages/*"]`.

## Commands (the four checks)

```bash
vp install --frozen-lockfile  # install from the lockfile
vp check                      # format-check + lint + typecheck in one pass
vp fmt                        # apply formatting
vp test                       # vitest unit tests
```

`vp check` is the CI gate (it already covers format/lint/typecheck); `vp test` runs the
unit tests. See ci-cd.md for the job.

## tsconfig — strictest base

Per package, extend the shared strict bases and emit nothing (checks only):

```jsonc
{
  // nodeNN base should match the project's node major version
  "extends": ["@tsconfig/bases/strictest", "@tsconfig/bases/nodeNN", "@tsconfig/bases/node-ts"],
  "compilerOptions": {
    "module": "esnext",
    "moduleResolution": "bundler",
    "noEmit": true,
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules", "**/*.test.ts"]
}
```

## vite.config.ts — reusable baseline

Drop this in as the starting `vite.config.ts`. The `rules` block is the curated set of
preference tweaks; keep it. The `overrides` array here covers the generic cases (config
files, test files) — add project-specific overrides (framework, package paths) only as
needed.

```ts
import { defineConfig } from "vite-plus";

const ignorePatterns = ["**/*.local.json"];
const defaultLintPlugins = ["eslint", "typescript", "unicorn", "oxc", "import", "node", "promise"] as const;

export default defineConfig({
  resolve: { tsconfigPaths: true },
  staged: { "*": "vp check --fix" },
  lint: {
    ignorePatterns,
    plugins: [...defaultLintPlugins],
    options: { denyWarnings: true, reportUnusedDisableDirectives: "warn", typeAware: true, typeCheck: true },
    categories: {
      correctness: "error", suspicious: "warn", pedantic: "warn", perf: "warn",
      style: "warn", restriction: "warn", nursery: "warn",
    },
    rules: {
      "eslint/capitalized-comments": "off",
      "eslint/complexity": "off",
      "eslint/id-length": "off",
      "eslint/max-classes-per-file": "off",
      "eslint/max-lines": "off",
      "eslint/max-params": "off",
      "eslint/max-statements": "off",
      "eslint/no-console": ["error", { allow: ["info", "warn", "error"] }],
      // Forbid the built-in Date global; use Temporal. Bans new Date()/Date.now()/Date.parse() at once.
      "eslint/no-restricted-globals": ["error", { name: "Date", message: "Use Temporal, not Date." }],
      "eslint/no-continue": "off",
      "eslint/no-duplicate-imports": "off",
      "eslint/no-inline-comments": "off",
      "eslint/no-magic-numbers": "off",
      "eslint/no-ternary": "off",
      "eslint/no-undef": "off",
      "eslint/no-undefined": "off",
      "eslint/no-warning-comments": "off",
      "eslint/require-await": "off",
      "eslint/sort-imports": "off",
      "eslint/sort-keys": "off",
      "import/exports-last": "off",
      "import/group-exports": "off",
      "import/max-dependencies": "off",
      "import/no-named-export": "off",
      "import/no-nodejs-modules": "off",
      "import/prefer-default-export": "off",
      "oxc/no-async-await": "off",
      "oxc/no-optional-chaining": "off",
      "oxc/no-rest-spread-properties": "off",
      "typescript/explicit-function-return-type": ["error", { allowExpressions: true, allowTypedFunctionExpressions: true }],
      "typescript/prefer-readonly-parameter-types": "off",
    },
    overrides: [
      { files: ["**/*.config.{js,ts}"], rules: { "import/no-default-export": "off", "node/no-process-env": "off" } },
      { files: ["**/*.{spec,test}.{ts,tsx}"], plugins: [...defaultLintPlugins, "vitest"] },
      { files: ["**/*.{spec,test}.{ts,tsx}"], rules: { "eslint/max-lines-per-function": "off" } },
    ],
  },
  fmt: { ignorePatterns, jsdoc: true, sortImports: true, sortTailwindcss: true },
  test: { silent: "passed-only" },
});
```

## Markdown-only repos

For docs/wiki repos with no app code, the Node side may just be **markdownlint-cli2**:
`.markdownlint-cli2.jsonc` plus `pnpm exec markdownlint-cli2 "**/*.md"`. Treat that as the
"lint" check and wire it into CI the same way.
