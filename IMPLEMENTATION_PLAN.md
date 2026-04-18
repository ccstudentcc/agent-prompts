# IMPLEMENTATION_PLAN

## Stage 1: Reframe the AGENTS task

- status: completed
- work: replace the stale sync-repair task docs with the current AGENTS-maintenance contract, scope, and acceptance targets
- verify: read `SPEC.md`, `IMPLEMENTATION_PLAN.md`, and `TASK_STATUS.md` and confirm they now describe the AGENTS cleanup round

## Stage 2: Audit the active layers

- status: completed
- work: read the named `agents-md-improver` skill, its routing references, the active `AGENTS.md` files, and adjacent docs that may own neighboring guidance
- verify: confirm which files are live guidance, which are fixture inputs, and where stale assumptions or missing local deltas exist

## Stage 3: Apply the minimal AGENTS edits

- status: completed
- work: trim or rewrite root guidance where it is stale, and add local `AGENTS.md` files only where subtree-specific ownership or sync rules are non-obvious
- verify: inspected the edited files and confirmed the new subtree files add only local ownership and sync guidance

## Stage 4: Final verification

- status: completed
- work: run focused file reads and `git status --short`, then review the edited hierarchy against the skill checklist
- verify: confirmed the intended AGENTS edits and task-doc updates; `git status --short` still includes earlier in-progress repo changes outside this AGENTS pass
