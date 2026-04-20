# code-overhaul-review

Opinionated, interactive health audit for a codebase. Challenges scope, surfaces the highest-leverage changes, files deferred work via beads.

## Structure

- `skills/code-overhaul-review/SKILL.md` -- the full protocol (Step 0, five review sections, stack addendums, outputs)
- `commands/code-overhaul-review.md` -- slash command entry point
- `install.sh` / `uninstall.sh` -- symlinks into `~/.claude/`

## Conventions

User-facing text should avoid AI writing patterns. Keep language direct and specific. No promotional phrasing, no filler. Lead with the action.

## Editing the skill

The skill file is self-contained: a single `SKILL.md` with a generic section and three stack-specific addendums (iOS/Swift, Go, Web/JS/CSS). When adding a new addendum:

1. Add it under a new `## Addendum: <stack>` heading at the end of the file.
2. Document its triggers (file globs, manifest files).
3. Mirror the five review sections (Step 0, Architecture, Code quality, Tests, Performance, Modernization) so the generic structure still holds.
4. Add a Summary row specific to the stack.
5. Add at least one anti-pattern.

Keep the generic section short. Addendums carry the stack-specific depth.

## Commit hygiene

Do not add Co-Authored-By trailers for AI tools. Commits should list only human authors.
