# code-overhaul

Opinionated, interactive health audit for a codebase. Challenges scope, picks the highest-leverage changes, files deferred work through beads.

## Structure

- `skills/code-overhaul/SKILL.md` -- the full protocol (Preflight, Step 0, five review sections, stack addendums, outputs).
- `commands/code-overhaul.md` -- slash command entry point.
- `install.sh` / `uninstall.sh` -- symlinks into `~/.claude/`.
- `skills/code-overhaul/eval/` -- rubric, grader prompt, and scenarios used to verify the skill.

## Conventions

User-facing text must avoid AI writing patterns. Keep language direct and specific. No promotional phrasing, no filler. Lead with the action. Directive verbs (*must*, *do*, *stop*) are reserved for the skill's instructions to the agent, not for the README or CLAUDE notes.

## Editing the skill

The skill file is self-contained: one `SKILL.md` with a generic section and three stack-specific addendums (iOS/Swift, Go, Web/JS/CSS). When adding a new addendum:

1. Add it under a new `## Addendum: <stack>` heading at the end of the file.
2. Document its triggers (file globs, manifest files).
3. Mirror the five review sections (Step 0, Architecture, Code quality, Tests, Performance, Modernization) so the generic structure still holds.
4. Add a Summary row specific to the stack.
5. Add at least one anti-pattern.

Keep the generic section short. Addendums carry the stack-specific depth.

After changing SKILL.md, re-run the grader in `eval/GRADER.md` against `eval/RUBRIC.md` to confirm the skill still passes.

## Commit hygiene

Do not add Co-Authored-By trailers for AI tools. Commits list human authors only.
