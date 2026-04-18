# TASK_STATUS

## Current Goal

Improve the repository’s active `AGENTS.md` hierarchy using the local `agents-md-improver` skill, keeping each layer small, durable, and correctly scoped.

## Current Truth

- the live execution chain for real work in this repo is the root `AGENTS.md`, the published `.codex/AGENTS.md`, and any narrower subtree files such as `.codex/skills/agents-md-improver/AGENTS.md`
- `evals/files/**/AGENTS.md` under `agents-md-improver` are fixture inputs, not live repository guidance
- the root `AGENTS.md` no longer hardcodes a missing `.codex/skills/README.md` path and now points more generally to the relevant published-layer index docs
- `.codex/agents/AGENTS.md` now owns the local rule that role files are published copies and should be refreshed from `C:\Users\chenpeng\.codex\agents\`
- `.codex/skills/AGENTS.md` now owns the local rule that this subtree mixes synced skills with repo-only skills, so edit location depends on ownership
- `.codex/skills/agents-md-improver/AGENTS.md` now states explicitly that this skill directory is repo-owned in this checkout
- `.codex/skills/README.md` now exists as the human-facing skill-layer index and ownership summary that the root docs were already linking to

## Latest Verified Evidence

- read the named skill entrypoint plus `references/layer-selection.md`, `references/update-workflow.md`, and `references/review-checklist.md`
- confirmed the active AGENTS files at `AGENTS.md`, `.codex/AGENTS.md`, and `.codex/skills/agents-md-improver/AGENTS.md`
- verified that the human-facing docs and maintenance notes expect a real `.codex/skills/README.md` index page, then added that missing file
- verified the edited text in `AGENTS.md`, `.codex/agents/AGENTS.md`, `.codex/skills/AGENTS.md`, and `.codex/skills/agents-md-improver/AGENTS.md`
- added `.codex/skills/README.md` with the current synced-skill list and repo-only skill list derived from `tmp/sync-public-codex/last-sync-report.json`
- `git status --short` now shows the intended AGENTS/task-doc edits plus earlier in-progress repo changes from the prior sync-repair work

## In Progress

- none

## Next

- inspect the final diff before any commit
- optionally decide later whether the skill index should stay curated manually or be generated from the sync report
