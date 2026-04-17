# agent-prompts

This repository is a public-facing showcase of the working materials under my local Codex home, centered on:

- `C:\Users\chenpeng\.codex\AGENTS.md`
- `C:\Users\chenpeng\.codex\agents\`
- `C:\Users\chenpeng\.codex\skills\`

It is not a raw mirror of the full `.codex` directory. The goal here is to present the reusable parts clearly, keep private or machine-specific state out of scope, and make the structure understandable to other people.

## What This Repository Shows

### 1. Global working rules

The file [`.codex/AGENTS.md`](.codex/AGENTS.md) is the public version of the main Codex working contract I use in local Windows + PowerShell repositories.

It focuses on:

- language and response conventions
- safety boundaries
- PowerShell and filesystem rules
- change scope discipline
- validation and Git habits
- when to use MCP and how to handle configuration safely

### 2. Agent roles

The directory [`.codex/agents/`](.codex/agents/README.md) documents the role split used by the local agent runtime and includes published copies of the current role files from `C:\Users\chenpeng\.codex\agents\`:

- `default.toml`
- `explorer.toml`
- `planner.toml`
- `refactor.toml`
- `reviewer.toml`
- `worker.toml`

These files are small enough and stable enough to publish directly in this repository.

### 3. Skills

The directory [`.codex/skills/`](.codex/skills/README.md) is the public skill layer for selected content under `C:\Users\chenpeng\.codex\skills\`.

The current local skill set includes workflow, writing, research, Python, visualization, and design-oriented skills such as:

- `codex-parallel-dispatch`
- `doc-coauthoring`
- `llm-prompt-optimizer`
- `article-writing`
- `citation-management`
- `python-testing`
- `data-visualization`
- `humanizer`
- `Humanizer-zh`

This repository now includes published copies of the non-system skill directories under `.codex/skills`. The `.system/` subtree remains out of scope for the public snapshot.

## Publishing Boundary

This repository is intentionally selective.

Included here:

- reusable rules
- role descriptions
- public-facing summaries of local skills
- reference material that shaped the published rules

Not included here by default:

- secrets, tokens, or headers
- machine-specific config state
- local caches or runtime metadata
- private prompts that are not ready to publish
- full local `.codex` internals copied without review

## Repository Layout

- [`.codex/AGENTS.md`](.codex/AGENTS.md): published global Codex working rules
- [`.codex/agents/`](.codex/agents/README.md): public copies and index of local agent roles
- [`.codex/skills/`](.codex/skills/README.md): public copies and index of non-system local skills
- [`references/`](references/andrej-karpathy-skills/CLAUDE.md): reference documents that informed the published rules
- [`AGENTS.md`](AGENTS.md): repo-specific publishing and maintenance rules
- [`ARCHITECTURE.md`](ARCHITECTURE.md): source-of-truth and update flow
- [`docs/maintenance.md`](docs/maintenance.md): refresh and review checklist
- [`config.example.json`](config.example.json): committed example for the local sync configuration
- [`scripts/sync-public-codex.ps1`](scripts/sync-public-codex.ps1): repeatable sync script for long-term updates

## Long-Term Maintenance

This repository is set up to be maintained over time rather than refreshed manually from memory.

The intended path is:

1. preview the local-to-public sync with `.\scripts\sync-public-codex.ps1 -PlanOnly`
2. optionally preview file operations with `.\scripts\sync-public-codex.ps1 -WhatIf`
3. run the sync when the plan looks right
4. review `git status` and diffs
5. update inventory docs if the public surface changed
6. commit and push

By default the script reads repo-local `config.json`, which stays local and is ignored by Git. The committed template is [`config.example.json`](config.example.json).

Use `-ConfigPath` to point at another JSON file when you want a different publish target or source Codex home.

The script also supports `-RepoRoot`, `-PublishedCodexDir`, `-CodexRoot`, and `-AsJson` for more reusable Windows/pwsh workflows. Command-line parameters override values loaded from `config.json` or a file passed with `-ConfigPath`.

The architecture and maintenance workflow are documented in [ARCHITECTURE.md](ARCHITECTURE.md) and [docs/maintenance.md](docs/maintenance.md).

## Notes

- Line endings are normalized with [`.gitattributes`](.gitattributes).
- Temporary files should stay under project-local `tmp/` and remain untracked.
- This repository is meant to be understandable even if the reader does not have access to my local `.codex` directory.
