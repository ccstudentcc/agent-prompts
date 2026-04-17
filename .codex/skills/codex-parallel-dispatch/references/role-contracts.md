# Role Contracts

Open this file when role selection or output shape is the main source of uncertainty.
These summaries are aligned to the live templates under `C:\Users\chenpeng\.codex\agents\`.

## Quick Routing Table

| Role | Best for | Avoid when | Write mode | Expected return |
|------|----------|------------|------------|-----------------|
| `explorer` | Execution-path tracing, symbol lookup, file-impact mapping | The affected files are already known; the task is implementation or review | Read-only | `Exploration Summary` report with exact file/line evidence |
| `planner` | Sequencing, scoping, risk framing before implementation | The task is trivial, already implementation-ready, or post-implementation review | Read-only | `Plan Summary` with steps, risks, verification, and key files |
| `reviewer` | Post-implementation defect finding, regressions, edge cases, missing tests | The implementation is not stable enough to review | Read-only | `Review Summary` plus severity-ranked findings |
| `default` | Narrow mixed tasks: light investigation plus synthesis, artifact inspection, or small scoped edits | The task clearly belongs to explorer, planner, worker, or reviewer; or it crosses boundaries | Workspace write | `Completion`, `Re-dispatch`, or `Handover` report |
| `worker` | Bounded implementation inside a known local module/file set | Shared utilities, global config, public interfaces, scaffolding, or broad cross-module work | Workspace write | `Completion` or `Handover` report |
| `refactor` | Behavior-preserving cleanup in a known local boundary | Behavior is unclear, user-visible behavior changes are intended, or the blast radius is broad | Workspace write | `Completion` or `Handover` report focused on preserved behavior |

## Role Selection Rules

1. Choose `explorer` when the main unknown is "where does this flow go?"
2. Choose `planner` when the main unknown is "what is the safe order of operations?"
3. Choose `reviewer` when the work already exists and needs an independent defect pass.
4. Choose `worker` when the implementation boundary is known and the task is clearly local.
5. Choose `refactor` only when behavior should stay the same.
6. Choose `default` only when the task is real but does not cleanly match a more specialized role.

## Output-Shape Reminder

When the child's exact return structure matters, re-open the real `.toml` file rather than relying on memory.
This is especially important for:

- `reviewer`, where severity labels and finding fields need to stay parseable
- `planner`, where `## Key Files` must remain the final section
- `default`, where the child may need to return `Re-dispatch Report` instead of forcing progress

## Common Misroutes

- Asking `reviewer` to critique an unfinished design or draft implementation
- Asking `worker` to cross module or ownership boundaries
- Asking `default` to act like a second orchestrator
- Asking `explorer` to fix code instead of map it
- Asking `refactor` to hide behavior changes inside a "cleanup"
