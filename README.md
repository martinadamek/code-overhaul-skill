# code-overhaul

Opinionated, interactive health audit for a codebase. The skill scans the repo, forces a scope decision up front, then walks architecture, code quality, tests, performance, and dependencies. It pauses after every section for your input and files deferred work as beads issues. Stack-specific addendums for iOS/Swift, Go, and Web/JS/CSS activate based on what's in the repo. Monorepos with mixed stacks get every matching addendum, and findings are tagged per module.

Current skill version: **2.1.0**.

## What it does differently

Most "review this codebase" prompts produce a long list with no prioritization and no commitment. This one is structured around four rules:

1. **Decide scope before work.** Step 0 measures the repo (warnings, deprecations, TODO density, dep drift, complexity hotspots) and offers three modes: SURGICAL (one theme, one session), SYSTEMATIC (section by section, ≤4 issues each), FULL AUDIT (everything, phased roadmap). Once you pick, there's no silent scope reduction.
2. **Lead with a recommendation.** Every finding lists 2–3 options including "defer", each labelled with effort, risk, blast radius, and maintenance cost, plus a direct "Recommendation: B. Here's why:" line. No "here are some options, what do you think?".
3. **Pause at every section.** The skill stops after architecture, code quality, tests, performance, and dependencies. It doesn't barrel through five sections and dump a wall of findings.
4. **Map findings to engineering preferences.** Every recommendation cites which principle it serves (DRY, explicit-over-clever, platform-over-third-party, minimal diff, and so on) so you're not arguing about taste.

Deferred work goes straight into beads with file and line references, current state, where to start, and prereqs. No follow-up paste job.

## Review sections

Each section has its own stop point and its own stack-specific depth when an addendum applies.

| Section | What it covers |
| --- | --- |
| **Architecture** | Module boundaries, layering violations, data flow, concurrency, scaling bottlenecks, security boundaries, dependency graph |
| **Code quality** | DRY, error handling, naming, tech debt hotspots, over- and under-engineering, dead code, stale diagrams, warnings |
| **Tests** | Critical flow coverage, edge cases, execution time, isolation, missing categories, mock strategy |
| **Performance** | Startup, memory, hot-path latency, I/O patterns, network efficiency, build time, binary/bundle size |
| **Dependencies and modernization** | Outdated, unmaintained, or replaceable deps, language version floor, toolchain hygiene, CI health |

## Stack addendums

Triggers are file markers in the repo. When more than one stack matches, every applicable addendum runs and findings are tagged per module.

- **iOS / Swift.** Triggered by `*.swift`, `*.xcodeproj`, `*.xcworkspace`, or `Package.swift` with Apple targets. Covers force-unwrap audit, structured concurrency adoption boundary, `@Observable`/`ObservableObject` consistency, SwiftLint violations, launch time analysis, XCTest vs Swift Testing, and replaceable deps (Kingfisher to AsyncImage, Alamofire to URLSession, SnapKit to AutoLayout, RxSwift to Combine).
- **Go.** Triggered by `go.mod` and `*.go`. Covers unchecked errors, interface pollution, package boundaries, context propagation, `go vet` / `staticcheck` / `govulncheck` findings, race detector status, goroutine leak risk, mutex contention, generics overuse, and toolchain audit.
- **Web / JavaScript / CSS.** Triggered by `package.json`, `tsconfig.json`, or any of `*.{js,ts,jsx,tsx,css,scss,html}`. Covers `any` count, TS strict mode readiness, component hierarchy, state management consistency, CSS specificity chaos, accessibility gaps, bundle size, Core Web Vitals, and modernization opportunities like native nesting, `:has()`, container queries, `<dialog>`, and View Transitions.

Adding a new addendum means appending one section to `skills/code-overhaul/SKILL.md`. See `CLAUDE.md` for the pattern.

## Required outputs

At the end of a session you get:

- **Impact/effort matrix.** DO FIRST / PLAN CAREFULLY / IF TIME / SKIP quadrants, with deterministic placement from severity + effort.
- **NOT in scope.** One-line reason per deferred or cap-exceeded item.
- **What already exists.** Underused utilities, helpers, and patterns already in the codebase.
- **Deferred work → Beads.** Ready-to-run `bd create` commands linked with `bd dep add`, confirmed in a single batched prompt.
- **Diagrams.** ASCII for dependency graphs, data flow, and state machines, plus a list of files that need inline diagrams.
- **Failure modes.** Realistic production failures per codepath: test covers it, handling exists, failure silent or visible. Rows marked `no / no / silent` escalate to critical.
- **Migration / rollback.** For every L blast-radius change: incremental plan, rollback, coexistence, verification.
- **Execution order.** Numbered, respecting inter-change dependencies, impact/effort priority, tests-before-refactor, and every-step-shippable.
- **Completion summary.** Compact ASCII box with counts per section, severity totals, and stack-specific rows.

## Install

### Via `npx skills` (recommended)

```bash
npx skills add ehmo/code-overhaul-skill
```

The CLI fetches the repo, discovers `skills/code-overhaul/SKILL.md` from its frontmatter `name:` field, and installs it into the right directory for your agent.

Install only the skill (no slash command) for a specific agent:

```bash
npx skills add ehmo/code-overhaul-skill -a claude-code
```

Companion commands:

```bash
npx skills list
npx skills update ehmo/code-overhaul-skill
npx skills remove ehmo/code-overhaul-skill
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

`skills/code-overhaul/SKILL.md` is plain markdown with YAML frontmatter. Drop it into whatever instruction format your agent uses. The `allowed-tools` list in the frontmatter (Read, Grep, Glob, Bash) maps to standard capabilities; AskUserQuestion is assumed to be built-in.

## Usage

Audit the current working directory:

```
/code-overhaul
```

Audit a specific project:

```
/code-overhaul ~/path/to/project
```

Pass a mode explicitly to skip the interactive prompt:

```
/code-overhaul systematic ~/path/to/project
```

Resume a previously paused audit:

```
/code-overhaul resume ~/path/to/project
```

First move: the skill runs Preflight and Step 0 (repo health, dependency landscape, language version floor, tech debt concentration, complexity check) and asks you to pick SURGICAL, SYSTEMATIC, or FULL AUDIT. Commit fully to the chosen mode.

From there, each section ends with a single section-close question: Approve, Revise, or Pause. Findings use three-part IDs like `3.2B` (section 3, finding 2, option B). Approvals are batched at the section close; you don't answer a prompt per finding. At the end you get the matrix, diagrams, deferred-beads commands, and the summary box.

## Requirements

- An AI coding agent that supports the skill format (Claude Code, or anything that reads `SKILL.md` frontmatter and the `AskUserQuestion` / `Read` / `Grep` / `Glob` / `Bash` tools).
- Optional: [beads](https://github.com/steveyegge/beads) (`bd`) if you want the "Deferred work → Beads" section to actually file issues. Without it, the same commands print as a plain checklist.

## Limitations

The skill is interactive by design. It stops at every section. If you want a single-pass dump, this isn't it.

The stack-detection addendums don't cover every ecosystem. Current coverage is iOS/Swift, Go, and Web/JS/CSS. Adding Rust, Python, Kotlin, or Elixir is one new addendum section per stack (see `CLAUDE.md`).

ASCII diagrams are intentional. They render anywhere a terminal does, they paste cleanly into code review, and they age better than image attachments.

## Uninstall

```bash
./uninstall.sh
```

Removes symlinks from `~/.claude/`.

## License

MIT
