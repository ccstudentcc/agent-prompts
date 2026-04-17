# Architecture

## Purpose

This repository is the public, reviewable layer of a local Codex workspace. It is designed to present reusable rules, role definitions, and selected skills from `C:\Users\chenpeng\.codex\` without exposing private runtime state.

## Source Of Truth

The authoritative local sources are:

- `C:\Users\chenpeng\.codex\AGENTS.md`
- `C:\Users\chenpeng\.codex\agents\`
- `C:\Users\chenpeng\.codex\skills\`

This repository is downstream from those paths. It should not become an independent second source of truth for the same artifacts.

## Published Layers

### 1. Root documentation

- `README.md`: public entrypoint and repository purpose
- `ARCHITECTURE.md`: maintenance structure and data flow
- `AGENTS.md`: repo-specific publishing rules
- `SPEC.md`, `IMPLEMENTATION_PLAN.md`, `TASK_STATUS.md`: task-control documents for larger maintenance work

### 2. Published Codex rules

- `.codex/AGENTS.md`: public copy of the main local Codex working contract

### 3. Agent role layer

- `.codex/agents/*.toml`: public copies of the local role definitions
- `.codex/agents/README.md`: role inventory and publishing notes

### 4. Skill layer

- `.codex/skills/`: public copies of non-system local skills
- `.codex/skills/README.md`: grouped skill index and publishing boundary

### 5. Reference layer

- `references/`: external or comparative material that informed the published content

## Excluded Layers

The following stay out of scope unless manually reviewed and intentionally published:

- `.codex/.system/`
- `.codex/config.toml`
- `.codex/sessions/`
- `.codex/memories/`
- runtime caches, local logs, and host-specific state

## Update Flow

The intended maintenance flow is:

1. Refresh from the local `.codex` source paths with `scripts/sync-public-codex.ps1`
2. Review the resulting Git diff
3. Update inventory or boundary docs if the public surface changed
4. Commit and push only after the published scope is confirmed

## Design Choice

The sync path is intentionally conservative:

- copy forward from local source to published directories
- overwrite same-name published files during refresh
- do not auto-delete published content
- keep repo-only skill directories until they are removed manually after review

This reduces the chance of accidental destructive syncs while keeping the maintenance workflow repeatable.
