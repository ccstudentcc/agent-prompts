# TASK_STATUS

## Current Goal

Make the repository maintainable as a long-lived public showcase of selected local `.codex` content.

## Completed

- initialized the Git repository and created the public GitHub repo
- published the current `.codex/AGENTS.md`
- copied local agent role files into `.codex/agents/`
- copied non-system local skills into `.codex/skills/`
- rewrote the root `README.md` as a public showcase entrypoint
- added repo-specific `AGENTS.md` and `ARCHITECTURE.md`
- added `SPEC.md`, `IMPLEMENTATION_PLAN.md`, and `TASK_STATUS.md` for maintenance tracking
- added `docs/maintenance.md` as the long-term refresh runbook
- added `scripts/sync-public-codex.ps1` and verified it with `-PlanOnly`
- updated the sync contract so same-name published skills are overwritten, while repo-only skill directories are preserved by default

## In Progress

- reviewing the current repository diff before the next commit

## Next

- stage the intended public changes
- verify staged files and commit when ready
- use the sync script for future refreshes instead of manual copying
