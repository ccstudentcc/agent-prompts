# Agent Roles

This directory documents the role split currently used by the local Codex runtime under `C:\Users\chenpeng\.codex\agents\` and includes published copies of the current role files.

The live local setup currently includes six role files:

| Role file | Purpose |
| --- | --- |
| `default.toml` | General fallback role for bounded mixed tasks that do not fit a narrower role cleanly. |
| `explorer.toml` | Read-only codebase mapping, symbol discovery, and execution-path tracing before edits. |
| `planner.toml` | Pre-implementation planning, scoping, sequencing, and risk surfacing. |
| `refactor.toml` | Behavior-preserving structural cleanup inside a bounded file or module scope. |
| `reviewer.toml` | Post-implementation review focused on correctness, regressions, edge cases, and missing validation. |
| `worker.toml` | Bounded implementation work inside a known module or limited write scope. |

## Why This Directory Exists

The public repository is meant to show how the local `.codex` setup is organized, not just to archive prompts.

Publishing the role layer separately makes two things easier to understand:

- how work is decomposed before any sub-agent is used
- how different roles are expected to constrain scope, output, and review behavior

## Refresh

The published role files are meant to be refreshed from the local source through `..\..\scripts\sync-public-codex.ps1`, then reviewed as normal Git diffs.

## Current Publishing Policy

This directory now publishes:

- the current role inventory
- the live `.toml` role definitions copied into this repository
- the intended responsibility split between planning, exploration, implementation, refactor, and review

If a local role later grows machine-specific or sensitive content, the public copy should become a reviewed export instead of a blind mirror.
