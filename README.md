# code-overhaul-review

Opinionated, interactive health audit for a codebase. The skill scans the repo, forces a scope decision up front, walks architecture / code quality / tests / performance / dependencies — pausing after each section for your input — and files deferred work as beads issues. Stack-specific addendums for iOS/Swift, Go, and Web/JS/CSS activate automatically based on what's in the repo. Monorepos with mixed stacks get all matching addendums.

Current skill version: **1.0.0**.

## What it does differently

Most "review this codebase" prompts produce a long list with no prioritization and no commitment. This one is structured around four rules:

1. **Decide scope before work.** Step 0 measures the repo (warnings, deprecations, TODO density, dep drift, complexity hotspots) and offers three modes: SURGICAL (one theme, one session), SYSTEMATIC (section by section, ≤4 issues each), FULL AUDIT (everything, phased roadmap). Once you pick, there's no silent scope reduction.
2. **Lead with a recommendation.** For each issue: 2–3 options including "defer", each labeled with effort/risk/blast radius, plus a direct "Do B. Here's why:" — then AskUserQuestion. No "here are some options, what do you think?"
3. **Pause at every section.** The skill stops after architecture, code quality, tests, performance, and dependencies. It doesn't barrel through five sections and dump a wall of findings.
4. **Map findings to engineering preferences.** Every recommendation cites which principle it serves (DRY, explicit-over-clever, platform-over-third-party, minimal diff, etc.) so you're not arguing about taste.

Deferred work goes straight into beads with file/line references, current state, where to start, and prereqs — no follow-up paste job.

## Review sections

Each section has its own stop point and its own stack-specific depth when an addendum applies.

| Section | What it covers |
| --- | --- |
| **Architecture** | Module boundaries, layering violations, data flow, concurrency, scaling bottlenecks, security boundaries, dependency graph |
| **Code quality** | DRY, error handling, naming, tech debt hotspots, over- and under-engineering, dead code, stale diagrams, warnings |
| **Tests** | Critical flow coverage, edge cases, execution time, isolation, missing categories, mock strategy |
| **Performance** | Startup, memory, hot-path latency, I/O patterns, network efficiency, build time, binary/bundle size |
| **Dependencies and modernization** | Outdated/unmaintained/replaceable deps, language version floor, toolchain hygiene, CI health |

## Stack addendums

Triggers are file markers in the repo. More than one stack → all applicable addendums apply, findings are tagged per module.

- **iOS / Swift** — Triggered by `*.swift`, `*.xcodeproj`, `*.xcworkspace`, `Package.swift` with Apple targets. Covers force-unwrap audit, structured concurrency adoption boundary, `@Observable`/`ObservableObject` consistency, SwiftLint violations, launch time analysis, XCTest vs Swift Testing, replaceable deps (Kingfisher → AsyncImage, Alamofire → URLSession, SnapKit → AutoLayout, RxSwift → Combine, etc.).
- **Go** — Triggered by `go.mod`, `*.go`. Covers unchecked errors, interface pollution, package boundaries, context propagation, `go vet` / `staticcheck` / `govulncheck` findings, race detector status, goroutine leak risk, mutex contention, generics overuse, toolchain audit.
- **Web / JavaScript / CSS** — Triggered by `package.json`, `tsconfig.json`, `*.{js,ts,jsx,tsx,css,scss,html}`. Covers `any` count, TS strict mode readiness, component hierarchy, state management consistency, CSS specificity chaos, accessibility gaps, bundle size, Core Web Vitals, modernization opportunities (native nesting, `:has()`, container queries, `<dialog>`, View Transitions, etc.).

Adding a new addendum is a matter of appending one section to `skills/code-overhaul-review/SKILL.md`. See `CLAUDE.md` for the pattern.

## Required outputs

At the end of a session you get:

- **Impact/effort matrix** — DO FIRST / PLAN CAREFULLY / IF TIME / SKIP quadrants
- **NOT in scope** — one-line rationale per deferred item
- **What already exists** — underused utilities, helpers, patterns already in the codebase
- **Deferred work → Beads** — ready-to-run `bd create` commands, linked with `bd dep add`
- **Diagrams** — ASCII before/after for dependency graphs, data flow, state machines; plus which files need inline diagrams
- **Failure modes** — realistic production failures per codepath, whether a test covers them, whether handling exists, whether failure is silent
- **Migration / rollback** — incremental vs all-or-nothing, rollback plan, coexistence strategy, verification
- **Execution order** — numbered, respecting inter-change dependencies, impact/effort priority, tests-before-refactor, every-step-shippable
- **Completion summary** — compact ASCII box with counts per section, plus stack-specific rows

## Install

### Via `npx skills` (recommended)

```bash
npx skills add ehmo/code-overhaul-review
```

The CLI fetches the repo, discovers `skills/code-overhaul-review/SKILL.md` from its frontmatter `name:` field, and installs it into the right directory for your agent.

Install only the skill (no slash command) for a specific agent:

```bash
npx skills add ehmo/code-overhaul-review -a claude-code
```

Companion commands:

```bash
npx skills list
npx skills update ehmo/code-overhaul-review
npx skills remove ehmo/code-overhaul-review
```

### Claude Code (manual install)

```bash
git clone git@github.com:ehmo/code-overhaul-skill.git
cd code-overhaul-skill
./install.sh
```

Creates symlinks in `~/.claude/` for the skill and slash command. The script checks that Claude Code is installed first.

Non-default config directory:

```bash
export CLAUDE_DIR=/custom/path
./install.sh
```

### Other agents

`skills/code-overhaul-review/SKILL.md` is plain markdown with YAML frontmatter. Drop it into whatever instruction format your agent uses. The `allowed-tools` list in the frontmatter (Read, Grep, Glob, Bash, AskUserQuestion) maps to standard capabilities.

## Usage

Audit the current working directory:

```
/code-overhaul-review
```

Audit a specific project:

```
/code-overhaul-review ~/path/to/project
```

First move: the skill runs Step 0 (repo health, dependency landscape, language version floor, tech debt concentration, complexity check) and asks you to pick SURGICAL, SYSTEMATIC, or FULL AUDIT. Commit fully to the chosen mode.

From there, each section ends with a `STOP` and `AskUserQuestion`. You pick options by NUMBER+LETTER (e.g. `3B`). At the end you get the matrix, diagrams, deferred-beads commands, and the summary box.

## Requirements

- An AI coding agent that supports the skill format (Claude Code, or anything that reads `SKILL.md` frontmatter and the `AskUserQuestion` / `Read` / `Grep` / `Glob` / `Bash` tools)
- Optional: [beads](https://github.com/steveyegge/beads) (`bd`) if you want the "Deferred work → Beads" section to actually file issues. Without it, the same commands are printed for you to run later.

## Limitations

The skill is interactive by design — it stops at every section. If you want a single-pass dump, this isn't it.

The stack-detection addendums don't cover every ecosystem. Current coverage: iOS/Swift, Go, Web/JS/CSS. Adding Rust, Python, Kotlin, Elixir, etc. is one new addendum section per stack (see `CLAUDE.md`).

ASCII diagrams are intentional. They render in every terminal, every code review tool, and every chat interface — and they age better than image attachments.

## Uninstall

```bash
./uninstall.sh
```

Removes symlinks from `~/.claude/`.

## License

MIT
