---
description: "Audit a codebase for maintenance and modernization. Opinionated, interactive, stack-aware."
---

Run the code-overhaul-review skill against the current repo (or the path passed as $ARGUMENTS).

Examples:
  /code-overhaul-review                       Audit the current working directory
  /code-overhaul-review ~/projects/myapp      Audit a specific repo

The skill starts with Step 0 (scope assessment), offers three modes (SURGICAL, SYSTEMATIC, FULL AUDIT), and walks five sections — architecture, code quality, tests, performance, dependencies — pausing after each for your input. Addendums for Ruby on Rails and its frontend (HTML/CSS/Stimulus) activate automatically based on what's in the repo.
