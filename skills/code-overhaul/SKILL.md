---
name: code-overhaul-review
version: 1.0.0
description: |
  Audit a codebase for maintenance and modernization. Challenges scope,
  reviews architecture/quality/tests/performance/dependencies, files
  deferred work via bd. Language-specific addendums for iOS/Swift, Go,
  Web/JS/CSS, and Ruby on Rails activate automatically based on what's
  in the repo. Supports monorepos with mixed stacks.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - AskUserQuestion
---

# Code Overhaul Review

Audit this codebase for maintenance, modernization, and overhaul. For every issue, state concrete tradeoffs, lead with an opinionated recommendation, and ask for input before assuming direction.

Health check, not feature review. Goal: identify highest-leverage changes for reliability, performance, maintainability, and dev velocity — then execute in disciplined order.

**Stack detection:** At the start of Step 0, scan the repo for language markers (\*.swift/Xcode projects, go.mod, package.json/tsconfig, Gemfile/bin/rails). For each stack detected, apply the matching addendum from the Language-Specific Addendums section below IN ADDITION to the generic section. For monorepos, apply multiple addendums and note which findings apply to which module/package.

## Priority hierarchy

Context low? Step 0 > Impact/effort matrix > Test diagram > Recommendations > Rest. Never skip Step 0 or the matrix.

## Engineering preferences

- DRY — flag repetition aggressively.
- Well-tested non-negotiable; too many > too few.
- "Engineered enough" — not fragile, not over-abstracted.
- More edge cases, not fewer; thoughtfulness > speed.
- Explicit over clever.
- Minimal diff: fewest new abstractions and files touched.
- Performance is a feature. Profile before and after.
- Prefer platform/stdlib over third-party when feasible.
- Deprecation warnings are bugs. Fix proactively.
- Build time matters. Justify anything that slows it.

## Diagrams

ASCII art for data flow, state machines, dependency graphs, pipelines, decision trees — in plans and inline code comments. Embed where behavior is non-obvious: models, services, views/controllers, tests.

**Diagram maintenance is part of the change.** Stale diagrams are worse than none. Flag even outside scope.

## BEFORE YOU START

### Step 0: Scope Assessment

1. **Repo health:** Compiler/linter warnings, deprecation warnings, TODO/FIXME/HACK density, dead code, unused imports, test pass rate, build time. (Add stack-specific tools per addendum.)
2. **Dependency landscape:** All third-party deps, current vs. latest. Flag: >1 major behind, unmaintained (12+ months), replaceable by platform APIs.
3. **Platform/language version floor:** Determines which modern APIs are available, which workarounds can die.
4. **Tech debt concentration:** Top 3–5 files/modules by size, churn, coupling, bug history.
5. **Complexity check:** >15 files or >3 new abstractions → challenge scope.

Offer three modes:

1. **SURGICAL:** One theme, minimal blast radius, one session.
2. **SYSTEMATIC:** Section-by-section interactive, ≤4 issues per section.
3. **FULL AUDIT:** All sections, all issues. Phased roadmap.

**Once chosen, commit fully.** No silent scope reduction.

## Review Sections

### 1. Architecture

Evaluate: module structure and boundaries (draw dependency graph), layering violations, data flow and sources of truth, concurrency/thread safety, routing/navigation consistency, scaling bottlenecks, security boundaries. For each major boundary: one realistic production failure and whether current code handles it. Identify where ASCII diagrams belong. Apply stack addendum.

**STOP.** AskUserQuestion. Do NOT proceed until user responds.

### 2. Code quality

Evaluate: file/folder organization, DRY violations, error handling gaps (cite file and line), naming consistency, tech debt hotspots, over-engineering and under-engineering, dead code, stale diagrams, linter/compiler warnings. Apply stack addendum.

**STOP.** AskUserQuestion. Do NOT proceed until user responds.

### 3. Tests

Diagram all critical flows, pipelines, state transitions, branching. For each: test exists? meaningful? edge cases covered? fast and reliable? Also: test distribution, execution time (flag slow tests), isolation, missing categories, mock strategy. Apply stack addendum.

**STOP.** AskUserQuestion. Do NOT proceed until user responds.

### 4. Performance

Evaluate: startup/launch time, memory footprint and leaks, response latency on hot paths, I/O patterns, network efficiency, build time, binary/bundle size. Apply stack addendum.

**STOP.** AskUserQuestion. Do NOT proceed until user responds.

### 5. Dependencies and modernization

Evaluate: outdated deps, replaceable deps, unmaintained deps, language modernization opportunities, toolchain hygiene, CI/CD health. Apply stack addendum.

**STOP.** AskUserQuestion. Do NOT proceed until user responds.

## For each issue

- File/line references.
- 2–3 options including "defer."
- Per option, one line: effort, risk, blast radius, maintenance burden.
- **Lead with directive:** "Do B. Here's why:"
- **Map to engineering preference** in one sentence.
- **AskUserQuestion:** "We recommend [LETTER]: [reason]" then `A) ... B) ... C) ...`. Label: NUMBER + LETTER (e.g., "3B").

## Required outputs

### Impact/effort matrix

```
                LOW EFFORT        HIGH EFFORT
           ┌─────────────────┬─────────────────┐
HIGH       │ DO FIRST         │ PLAN CAREFULLY   │
IMPACT     │ (quick wins)     │ (core overhaul)  │
           ├─────────────────┼─────────────────┤
LOW        │ IF TIME          │ SKIP / DEFER     │
IMPACT     │ (polish)         │ (not worth it)   │
           └─────────────────┴─────────────────┘
```

### NOT in scope

Deferred work, one-line rationale each.

### What already exists

Underused utilities, helpers, or patterns already in the codebase.

### Deferred work → Beads

```bash
bd create "<title>" -t <type> -p <priority> -d "<what, why, current state, where to start, prereqs>" -l "tech-debt,overhaul"
```

Ask before filing. Link with `bd dep add`.

### Diagrams

Before/after dependency graphs, refactored data flow, state machines. Identify files needing inline diagrams.

### Failure modes

Per modified codepath: one realistic failure → test covers it? error handling? user-visible or silent? No test + no handling + silent → **critical gap**.

### Migration / rollback

Incremental or all-or-nothing? Rollback plan? Old/new coexistence? Verification?

### Execution order

Numbered, respecting: (1) inter-change dependencies, (2) impact/effort priority, (3) tests before refactoring, (4) every step shippable.

### Completion summary

```
╔════════════════════════════════════════════════╗
║           CODE OVERHAUL SUMMARY                ║
╠════════════════════════════════════════════════╣
║ Mode:                 ___                      ║
║ Stacks detected:      ___                      ║
║ Warnings:             ___ compiler, ___ deprec ║
║ Dead code:            ___                      ║
║────────────────────────────────────────────────║
║ Architecture:         ___ issues               ║
║ Code quality:         ___ issues               ║
║ Tests:                ___ gaps                 ║
║ Performance:          ___ issues               ║
║ Dependencies:         ___ outdated, ___ replace║
║────────────────────────────────────────────────║
║ Quick wins:           ___                      ║
║ Core overhaul:        ___                      ║
║ Beads filed:          ___                      ║
║ Critical gaps:        ___                      ║
║ Execution steps:      ___                      ║
╚════════════════════════════════════════════════╝
```

Add stack-specific rows from addendums (e.g., force-unwrap count, `any` count, race-clean status).

## Retrospective learning

Git log: high-churn files, reverted commits, large "fix" commits, recurring patterns ("fix crash in…", "workaround for…"). Aggressive on historically problematic areas.

## Formatting

NUMBER issues, LETTERS for options. Recommended first. One sentence per option. Pause after each section.

## Unresolved decisions

List at end: "Unresolved decisions that may bite you later." Never silently default.

## Anti-patterns

- Big bang rewrites → incremental.
- Refactoring without tests → characterization tests FIRST.
- Gold plating → health, not perfection.
- Chasing new hotness → solve concrete problems only.
- Breaking the build → every commit compiles and passes tests.

---

# Language-Specific Addendums

Apply these when the corresponding stack is detected. For monorepos, apply all matching addendums and tag each finding with its module.

---

## Addendum: iOS / Swift

**Triggers:** _.swift files, _.xcodeproj, \*.xcworkspace, Package.swift with Apple platform targets.

### Step 0 additions

- Run: Xcode warnings count, SwiftLint violations, deployment target (min iOS version).
- Deployment target determines: SwiftUI API surface, structured concurrency availability, which UIKit workarounds can die.
- Dep audit specifics: SPM/CocoaPods/Carthage. Replaceable: Kingfisher→AsyncImage, Alamofire→URLSession async/await, SnapKit→modern AutoLayout, RxSwift→Combine/async-await, KeychainAccess→native keychain, SwiftyJSON→Codable, IQKeyboardManager→native keyboard avoidance.

### Architecture additions

- State management consistency: @Observable vs ObservableObject vs @State — pick one per concern, not mix-and-match.
- Navigation: NavigationStack vs coordinator pattern vs mixed — consistent?
- Concurrency model: structured concurrency adoption boundary vs legacy GCD/completion handlers. Where is the migration line?
- Core Data / SwiftData stack health. Extension targets sharing code correctly?

### Code quality additions

- **Force-unwraps and implicitly unwrapped optionals** — cite every one, these are crash sources.
- `try?` swallowing errors silently. Empty catch blocks.
- Retain cycle risks: missing `[weak self]` in closures, non-weak delegate properties.
- Unused @objc exposure, stale Storyboard/XIB connections, dead IBOutlets/IBActions.
- Massive ViewControllers/Views (>300 lines).
- Protocol-oriented over-engineering: protocol with one conformer, unnecessary associated types.

### Test additions

- XCTest vs Swift Testing adoption. UI test reliability (flag >10s per UI test).
- Test host app dependency — can unit tests run without app launch?
- Core Data tests using in-memory stores? Network tests using URLProtocol mocks?
- Total suite time matters with large test counts — flag >60s.
- Missing: snapshot tests for complex layouts, accessibility audit tests.

### Performance additions

- **Launch:** Pre-main (dylib loading, +load, static initializers) and post-main. Synchronous main-thread work in `didFinishLaunching`?
- **Main thread:** File I/O, JSON parsing, image decoding, Core Data fetches on main.
- **Scrolling:** Cell reuse, async image loading, Auto Layout ambiguity, offscreen rendering (cornerRadius + clipsToBounds).
- **Media:** Image downsample before display? PhotoKit fetch efficiency? Unnecessary format conversions?
- **Build:** Slowest files via `-Xfrontend -debug-time-function-bodies`. Complex type inference. SPM resolution time.
- **Binary:** Unused asset catalog entries, embedded resources that could be on-demand.

### Modernization additions

- Structured concurrency: async/await, actors, task groups.
- @Observable macro (iOS 17+), #Preview macros, @Entry for EnvironmentValues.
- Typed throws (Swift 6), strict concurrency checking readiness.
- Xcode hygiene: unused build phases, stale schemes, code signing drift, build settings at wrong level.

### Summary additions

Add rows: Min iOS target, Swift version, force-unwrap count, SwiftLint violations.

### Extra anti-pattern

- UIKit-to-SwiftUI migration without a boundary strategy → define the bridge pattern once, use everywhere.

---

## Addendum: Go

**Triggers:** go.mod, \*.go files.

### Step 0 additions

- Run: `go vet`, `staticcheck`, `golangci-lint`, `govulncheck ./...`, `go mod tidy` drift check.
- Go version in go.mod determines: range-over-func (1.23+), log/slog (1.21+), errors.Join (1.20+), generics depth, loop variable fix (1.22+).
- Dep audit specifics: `go list -m -u all`. Replaceable: gorilla/mux→stdlib 1.22+ routing, logrus→log/slog, pkg/errors→fmt.Errorf %w, testify→stdlib testing, go-playground/validator→custom, gorm→sqlc/sqlx, cobra→stdlib flag for simple CLIs.

### Architecture additions

- Package boundaries: `internal/` usage correct? Circular dep risks?
- Interface pollution: too many interfaces defined by implementor rather than consumer. Accept interfaces, return structs.
- Dependency injection: wire, manual, or scattered `init()`?
- Graceful shutdown chain: signal → context cancellation → resource cleanup.
- Error propagation: sentinel vs typed vs wrapping — consistent?
- Context: values vs cancellation — abuse?

### Code quality additions

- **Unchecked errors:** `_ = foo()` — cite every one unless justified with comment.
- Naked returns in complex functions.
- Package-level globals and `init()` abuse.
- Naming: Go conventions (MixedCaps, 1-2 char receivers, lowercase single-word packages). Stuttering (`user.UserService`).
- Over-engineering: interfaces with one implementation, unnecessary generics, Options pattern for 2 config values.
- Under-engineering: 2000+ line files, >5 params, `any`/`interface{}` where generics clarify.

### Test additions

- Table-driven tests consistent? `t.Helper()` used? Subtests with `t.Run()`?
- Integration tests tagged `//go:build integration`?
- **Race detector:** `go test -race` passing? This is a gate, not optional.
- Benchmarks for hot paths (`BenchmarkX`). Fuzz tests for parsers (`FuzzX`).
- Golden files for complex output. `testdata/` organized?
- Mocking: interfaces at boundaries only, not mocking everything. `httptest` for handlers.

### Performance additions

- **CPU:** Unnecessary allocations in tight paths, reflection in hot code, regexp compilation inside loops (compile once as package var), string concat in loops (strings.Builder).
- **Memory:** Goroutine leaks (unbounded spawn without context cancel), sync.Pool opportunities, slice pre-alloc (`make([]T, 0, cap)`), string↔[]byte in hot paths.
- **Concurrency:** Mutex contention (RWMutex? atomic?), channel buffer sizing, goroutine fan-out without limits (errgroup), context propagation gaps.
- **I/O:** Connection pool sizing, prepared statement reuse, N+1 queries, HTTP client reuse (not per-request), response body not closed, bufio for files.
- **Build:** CGO (slows build, complicates cross-compile), unnecessary `go generate`.
- **Binary:** `-ldflags "-s -w"`, `-trimpath`, unused dep bloat.

### Modernization additions

- Generics replacing `interface{}`/codegen where it clarifies (only with >2 concrete types).
- range-over-func (1.23+), log/slog, errors.Join, loop variable fix (1.22+) — remove workarounds.
- iter package (1.23+), any/comparable constraints.
- Toolchain: Makefile/Taskfile hygiene, golangci-lint config freshness, CI (test, vet, lint, race, vulncheck).

### Summary additions

Add rows: Go version (mod), go vet issues, staticcheck issues, govulncheck findings, unchecked errors, race clean Y/N.

### Extra anti-patterns

- Over-interfacing → one-method interfaces are Go's sweet spot, not the starting point.
- Premature generics → only when >2 concrete types and pattern is proven.

---

## Addendum: Web / JavaScript / CSS

**Triggers:** package.json, tsconfig.json, _.js, _.ts, _.jsx, _.tsx, _.css, _.scss, \*.html files.

### Step 0 additions

- Run: `tsc --noEmit` errors, ESLint/Prettier violations, `npm audit`, bundle size (total + per-route).
- TypeScript strict mode on? If not, migration path is high-priority.
- Browser floor (browserslist) determines: CSS nesting, :has(), container queries, structuredClone, AbortSignal.any, Promise.withResolvers.
- Dep audit: `npm outdated`. Replaceable: moment→Temporal/date-fns, lodash→native (Array.at, Object.groupBy, structuredClone), axios→fetch, classnames→clsx/template literals, uuid→crypto.randomUUID, node-fetch→native fetch (Node 18+).

### Architecture additions

- Component hierarchy (draw tree). State management: local vs global, prop drilling vs context vs store — consistent?
- Data fetching: per-component vs route-level vs centralized? Caching/dedup? Loading/error states?
- API layer: fetch calls scattered or centralized?
- SSR/SSG/CSR boundaries if applicable. Error boundary placement.
- Build config complexity. Environment handling.

### Code quality additions

**JS/TS:**

- **`any` types** — cite every one, these defeat TypeScript.
- `as` assertions bypassing safety. Loose equality (`==`).
- Uncaught promise rejections. Missing error boundaries.
- Barrel file bloat killing tree-shaking. Unused exports (`ts-prune`).
- Component files >300 lines.

**CSS:**

- Specificity wars, `!important` proliferation.
- Magic numbers without custom properties. Duplicated values needing design tokens.
- Unused CSS. Inconsistent naming (BEM vs utility vs random).
- z-index: documented scale or chaos? Media queries: scattered or centralized?
- CSS-in-JS vs stylesheets vs utility — consistent approach?

**HTML/Accessibility:**

- Semantic HTML (div soup?). ARIA: missing or wrong. Keyboard nav, focus management, color contrast, alt text, form labels, heading hierarchy.

### Test additions

- Unit (Jest/Vitest) for logic. Component (Testing Library) for behavior — flag `getByTestId` overuse, prefer `getByRole`/`getByText`.
- E2E (Playwright/Cypress) for critical paths. Visual regression for complex layouts.
- MSW for network mocking — consistent? Snapshot tests: useful or noise?
- Accessibility tests (axe-core). Suite speed: flag >30s total, >5s individual.

### Performance additions

- **Core Web Vitals:** LCP (critical rendering path), CLS (images without dimensions, font flash, dynamic injection), INP (long tasks, heavy handlers).
- **Bundle:** Per-route splits, tree-shaking effective?, dynamic imports for below-fold, duplicate deps, `source-map-explorer` analysis.
- **Loading:** Critical CSS inlined? Render-blocking resources? Font strategy (font-display, preload)? Images (WebP/AVIF, srcset, lazy load, explicit dimensions)?
- **Runtime:** Unnecessary re-renders (missing memo where measured), DOM thrashing, event listener cleanup, Web Worker opportunities, requestAnimationFrame for visual updates.
- **Caching:** Service worker strategy, HTTP headers, CDN, stale-while-revalidate, asset fingerprinting.
- **Network:** API waterfall (sequential→parallel), overfetching, missing pagination.

### Modernization additions

- CSS: native nesting (drop preprocessor nesting), container queries, `:has()`, View Transitions, Popover API, `<dialog>` (drop modal libs), `color-mix()`, `@property`.
- TS: strict mode path, `satisfies`, template literal types, discriminated unions, `using` (5.2+).
- Platform: structuredClone, Object.groupBy, Set methods, import attributes.
- Toolchain: bundler currency (Webpack→Vite?), Node version, package manager consistency, monorepo tooling, preview deployments.

### Summary additions

Add rows: Framework, TS strict Y/N, `any` count, ESLint violations, bundle size (gzip), npm audit vulns, LCP.

### Extra anti-patterns

- Premature abstraction → don't build a component system for 3 buttons.
- CSS reset whack-a-mole → fix the specificity model, not symptoms.
- `any` as escape hatch → every `any` is deferred debt with compound interest.
- Framework churn → migrate when solving a concrete problem, not for novelty.

---

## Addendum: Ruby on Rails

**Triggers:** `Gemfile`, `config/application.rb`, `bin/rails`, `Rakefile`, `db/schema.rb`, `.ruby-version`, `*.rb` files with Rails idioms.

### Step 0 additions

- Run: `bin/rubocop`, `bin/brakeman`, `bin/bundler-audit check --update`, `bundle outdated --strict`, `bin/rails stats`, `bin/rails notes` (TODO/FIXME/HACK density).
- Ruby version (`.ruby-version`) and Rails version (`Gemfile.lock`) determine modernization surface:
  - Rails 8.x: Solid trio (Queue/Cache/Cable), built-in auth generator, Kamal 2, Propshaft default.
  - Rails 7.1+: `params.expect`, encrypted attributes, async queries (`load_async`), `Current` model pattern.
  - Ruby 3.2+: pattern matching, `Data.define`, anonymous block forwarding, endless methods, rightward assignment.
- Dep audit — replaceable by vanilla Rails / native tools (flag ONLY when repo is otherwise on recent Rails; do not recommend ripping out working dependencies without cause):
  - `paperclip`/`carrierwave` → Active Storage
  - `devise` → Rails 8 built-in auth or custom passwordless (only if repo shows 37signals-style signals)
  - `pundit`/`cancancan` → predicate methods on models (same caveat)
  - `sidekiq` + Redis → Solid Queue (Rails 8+, modest throughput)
  - `redis-rails` → Solid Cache
  - `sprockets`/`webpacker` → Propshaft + import maps / jsbundling-rails
  - `jquery-rails`/`turbolinks` → Turbo + Stimulus
  - `paranoia`/`acts_as_paranoid` → hard delete or `discarded_at` (unless compliance requires soft delete)
  - `draper` and decorator gems → helpers + partials
- Rails-specific tech-debt hotspots: models/controllers >300 lines, migrations with model references, fixtures/factories with cyclic dependencies, schema.rb churn, `app/services/` growth rate.

### Style detection (for gated rules below)

Rails is the most opinion-fractured stack this skill covers. Before flagging style, detect alignment:

- **37signals-aligned signals:** Solid Queue/Cache/Cable in `Gemfile`, Minitest + fixtures, rich model concerns (`app/models/<model>/` subdirs), Hotwire-only frontend, absent or sparse `app/services/`, custom auth (no Devise), `Current` model for request-scoped state, UUID/UUIDv7 primary keys.
- **Industry-mainstream signals:** RSpec + FactoryBot, Devise, Sidekiq + Redis, `app/services/` as a core pattern, Pundit/CanCanCan, ViewComponent.

Fire the "37signals-style" rules below only when the repo already shows ≥2 aligned signals. In a Devise-using codebase, do NOT recommend ripping out Devise. In a mainstream codebase, flag *inconsistency* (e.g., half service objects / half rich models for overlapping concerns), not wholesale style conversion. The opinionated items below are adapted from the [37signals coding style guide](https://github.com/marckohlbrugge/unofficial-37signals-coding-style-guide).

### Architecture additions

**Core (apply always):**

- **Thin controllers, rich models.** Flag controllers doing transactions, enqueuing multiple jobs, multi-model writes, or conditional business logic. The action orchestrates; domain logic lives on the model.
- **Callback discipline.** Cross-model `after_create`/`after_save` chains, `after_commit` racing with background jobs (`enqueue_after_transaction_commit` missing when jobs read freshly-written rows).
- **Active Job adapter consistency.** Solid Queue, Sidekiq, GoodJob — pick one. Note if dev/test uses `:inline` while prod uses a queue (masks ordering bugs).
- **Transaction boundaries.** Nested transactions, jobs enqueued inside transactions, mailers sent mid-transaction.
- **Authorization placement.** Predicate on model (`editable_by?`) vs policy class vs ad-hoc `before_action` — consistent?
- **Multi-tenancy.** Scoping at query layer, middleware, or forgotten in places? `default_scope` is a footgun — justify or flag.
- **Turbo/Stimulus vs SPA drift.** Hotwire-committed apps should not have stray React islands; SPA-committed apps should not have rogue Turbo frames. Either is fine; mixing without a boundary is not.
- **Engine / module boundaries.** For apps >50k LOC, are module seams defined? Packwerk or `app/<domain>/` separation where warranted?
- **Diagrams warranted:** request → controller → model → view flow on a critical path; background-job lifecycle (enqueue → commit → worker → retry → failure); tenant-scoping boundary.

**37signals-style (gated):**

- State as records, not booleans. `closed`/`archived`/`published` columns → consider a state table when "who" and "when" matter (ORM: `has_one :closure`). Do NOT recommend this for trivial flags.
- Service object sprawl (`app/services/` with many single-caller, single-method POROs) → push behavior into domain models. Rule of three before extracting.
- `delegated_type` over traditional polymorphic associations for heterogeneous collections needing pagination.

### Code quality additions

**Core:**

- **N+1 queries.** Grep for associations iterated without `includes`/`preload`/`eager_load`. Configure Bullet in dev/test if absent. Cite file:line per hit.
- **Missing indexes.** Every `belongs_to` indexed? Every frequently-filtered column? Cross-check `db/schema.rb` against `where`/`find_by` call sites.
- **DB constraints vs AR validations.** Uniqueness validation without a unique index → race condition. `presence: true` without `NOT NULL` → inconsistency. Cite both.
- **Strong params on Rails 7.1+.** Flag `params.require(:x).permit(...)` → recommend `params.expect(x: [...])` (returns 400 instead of 500 on malformed input).
- **Brakeman findings.** Every unresolved warning: triage as real / false-positive / accepted-risk. SSRF on outbound requests, mass assignment, open redirects, unsafe reflection, YAML.load, SQL injection — cite file:line.
- **`rescue` discipline.** Bare `rescue` catches `Exception` (including `SystemExit`); `rescue => e` catches `StandardError` broadly. Flag both when narrower rescue would do. Rescues that swallow `ActiveRecord::RecordInvalid` silently are bugs.
- **Fat everything.** Controllers/models >300 lines, actions >20 lines, methods >15 lines.
- **Unscoped finders with user input.** `Model.find(params[:id])` without tenant/user scoping → IDOR. Recommend `current_user.models.find(params[:id])` pattern.
- **Callback side effects.** Mailers sent in `after_save`, jobs enqueued in `before_destroy` — brittle, test-hostile, transaction-unsafe.
- **Migration hygiene.** Unreversible migrations without explicit `reversible`, model references in migrations (break on future schema drift), missing `strong_migrations` guards for lock-heavy operations on large tables.
- **Zeitwerk compliance.** Files not matching autoload expectations, stray `require_dependency`/`require` in app code.
- **Negative scope naming.** `scope :not_deleted`, `scope :unarchived` → invert to positive (`:active`, `:live`).
- **Stale diagrams/comments.** Class-level comments describing old behavior; ERD drift from actual schema.

**37signals-style (gated):**

- Service objects reviewed one-by-one for "earning their keep"; collapse single-caller, single-method services into model methods.
- `dependent: :destroy` where `:delete_all` suffices (no callbacks) — destroy runs N queries, delete_all runs one.
- `StringInquirer` for action/status string columns compared frequently (`event.action.completed?` vs `event.action == "completed"`).

### Test additions

**Core:**

- **Framework consistency.** Minitest OR RSpec, not both. Mixed presence → flag.
- **Factory/fixture consistency.** FactoryBot *or* fixtures. Mixed → fragmented setup patterns.
- **System tests for Hotwire paths.** Every Turbo Stream/Frame interaction needs a browser-level test or the feature is untested.
- **Request tests over controller tests.** Controller tests exercise less; request tests go through the full middleware stack.
- **Parallelization.** `parallelize(workers: :number_of_processors)` in test helper; flag absence for suites >30s.
- **N+1 detection in test env.** Bullet with `raise = true` in test mode catches N+1s at PR time.
- **Transactional tests.** `use_transactional_tests = true` default; if disabled, why?
- **Flaky-test quarantine.** Runtime, flakiness rate, hot-spot files from CI data if available.
- **Fixture/factory hygiene.** References to non-existent associations, circular `association` chains, factories that hit external services, fixtures with hard-coded dates that rot.
- **Missing test categories.** Mailer tests, job tests, auth-bypass/IDOR integration tests, system tests for critical flows.
- **Suite speed.** Flag >60s unit+integration, >5min with system tests.

**37signals-style (gated):**

- Fixtures over factories (deterministic IDs, loaded once, faster boot).
- `assert_difference`/`assert_changes` over manual before/after assertions.
- Integration tests as the primary level (domain through model tests, flows through integration).

### Performance additions

**Core:**

- **Database:** N+1s, missing indexes, missing counter caches (`counter_cache: true` on frequently-counted associations), missing `touch: true` for cache-key propagation.
- **Query patterns:** `.pluck` vs `.select` for projection, `find_each` for large iterations, `update_all`/`delete_all` for bulk operations (with callback tradeoff noted), `in_batches` for destructive operations.
- **View rendering:** Uncached collection partials (`cached: true`), Russian-doll caching opportunities, `cache` blocks keyed on stale attributes.
- **Boot time:** Bootsnap enabled, `eager_load = true` in prod, `cache_classes = true` where expected, autoloader warnings noted.
- **Memory:** Per-request bloat from wide `select *` on large tables, missing `select`/`pluck` in hot paths, `Marshal` round-trips in jobs.
- **Asset pipeline:** Propshaft vs Sprockets choice justified, import maps for small JS vs bundler when code-splitting matters, missing `<link rel="preload">` for critical assets.
- **Job hygiene:** Solid Queue/Sidekiq job timeouts set, idempotency on retry, `discard_on`/`retry_on` specified, not swallowing all exceptions.
- **HTTP caching:** ETags configured (`etag`, `stale_when_importmap_changes`), `fresh_when`/`stale?` on show actions. Missing = users re-download unchanged pages.

**37signals-style (gated):**

- **Write-time over read-time.** Compute roll-ups at save, not at view time; denormalize counts where hot; precompute enums where presentation is expensive.
- `enqueue_after_transaction_commit` on adapter or per-job — prevents race where the job runs before the transaction commits.
- Money as integer (microcents) not float/decimal — if codebase already leans this way.

### Modernization additions

- **Rails 8 features:** Solid trio replacing Redis for small-medium scale, built-in authentication generator (new apps), Kamal 2 for deploy, Propshaft default, `allow_browser versions: :modern` for baseline browser gating, `stale_when_importmap_changes` for HTTP cache invalidation on JS updates.
- **Rails 7.1+ features:** `params.expect`, encrypted attributes (`encrypts :column`), async queries (`.load_async`), `Current` thread-isolation for request-scoped state.
- **Ruby 3.x:** Pattern matching for parsing responses, `Data.define` for value objects, anonymous block forwarding (`...`), endless methods for one-liners, rightward assignment.
- **Hotwire current practice:** Turbo morph (`method: :morph`), View Transitions API, `<dialog>` element over JS modal libs, `requestSubmit` for progressive enhancement.
- **Zeitwerk strictness:** `config.autoloader = :zeitwerk` (Rails 6+ default), no `require_dependency` carryovers.
- **`strict_loading`** on associations to catch N+1s at development time before they ship.
- **Active Record 7+:** `normalizes`, `generates_token_for`, `with` (CTEs), `composite_primary_keys`.
- **Toolchain:** Ruby version inside security-support window, Rails version current, `bundler-audit` and `brakeman` in CI, Dependabot/Renovate for bundle + npm.

### Summary additions

Add rows: Ruby version, Rails version, test framework, Rubocop violations, Brakeman warnings, bundler-audit findings, missing-index count, N+1 risks flagged, 37signals-style alignment (Y/partial/N).

### Extra anti-patterns

- **Fat everything.** Fat controller → extract to model. Fat model → extract concern first, service object as last resort. Fat view → partial + helper.
- **Callback web.** `after_*` hooks across 4+ models for one user action → promote to an explicit orchestration method on a model, or a domain event.
- **Service object sprawl.** Single-caller, single-method `FooCreator`/`FooHandler` classes are anemic wrappers; push into the model unless orchestration crosses clear boundaries.
- **Premature microservices / engines.** Splitting a monolith before it hurts is a speedrun to worse problems.
- **Symptom patching.** Retry for a race → fix the race. Rescue/log for a nil → fix the producer. Cache-bust for stale view → fix the `touch` chain.
- **Soft-delete by default.** Without compliance/audit requirement, soft deletes create a parallel schema with missing constraints. Default to hard delete; add `discarded_at` only when required.
- **Negative naming.** `not_deleted`, `unpublished`, `is_not_archived` → invert (`active`, `draft`, `live`).
- **Mixing Turbo and SPA without a boundary.** Commit to Hotwire or commit to the SPA; drifting between them doubles the frontend surface area.
- **Ignoring Brakeman.** Every unaddressed warning is a deferred security review. Zero-warning baseline is the goal.
