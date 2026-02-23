---
description: When and how to commit code changes. Build and commit on every plan; break large plans into multiple commits at natural boundaries.
alwaysApply: true
---

# Commit Workflow

## When to Commit

### Per-Plan Rule
Every plan implementation must **build**, then **commit**:

1. **Build** — Run the project build (e.g. Godot headless `--path <project> --headless --quit`, or the repo’s standard build command) and fix any errors before committing.
2. **Commit** — Produce at least one commit. Large plans should be broken into **multiple commits** at natural boundaries — don’t try to land an entire plan in a single giant commit.

Do not commit without a successful build.

**Build:** If the build command isn't available (e.g. tool not on PATH), try reasonable alternatives (full path to the executable, or a project-documented location) so the build can succeed; don't skip the build or stop at "command not found."

**Commit:** Produce the commit in the same session, right after a successful build. Don't report "build succeeded" and stop; complete the workflow with the commit.

### Natural Commit Boundaries

Split a plan into separate commits when there are distinct phases, such as:

- **Data/resources first, then logic**: e.g., commit new `.tres` files, then commit the code that uses them
- **Infrastructure, then features**: e.g., commit a new autoload/scene manager, then commit the scenes that depend on it
- **Per-system or per-feature**: e.g., commit map data changes separately from battle config changes if they can stand alone
- **Per-progression stage**: e.g., commit Prog 0-1 enemies separately from Prog 2-3 enemies in a large balance pass

### What Counts as a Logical Unit

A commit should be a **cohesive piece of functionality** that makes sense on its own:

- A new class, enemy, or ability set is fully implemented
- A battle's enemy tuning passes validation
- A system (e.g., reactions, grid, combat) is added or meaningfully changed
- A bug fix is complete and verified
- A balance pass for a progression stage is locked
- A refactor is finished and the code still works
- Cursor rules or skills are added or updated
- A new scene and its supporting scripts are wired up

Do **not** wait for the user to ask. Do **not** commit half-finished work or mid-debugging states.

## Commit Message Format

Use the conventional commit style matching this repo:

```
<type>: <concise description of what changed and why>
```

Types:
- `feat` — new feature or capability
- `fix` — bug fix
- `balance` — stat/ability tuning or balance changes
- `refactor` — code restructuring with no behavior change
- `chore` — project config, rules, skills, tooling
- `docs` — documentation only

Keep the message to 1-2 sentences focused on the **why**, not a file list.

## Before Committing

1. Verify the change works (build succeeds, simulator runs, no obvious regressions)
2. Stage only the files related to the logical unit — don't bundle unrelated changes
3. Never commit files containing secrets (.env, credentials, keys)
