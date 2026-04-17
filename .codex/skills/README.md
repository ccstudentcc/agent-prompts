# Skills Index

This directory is the public index for the skill layer currently installed under `C:\Users\chenpeng\.codex\skills\`.

The local skill tree includes both system-provided assets and user-facing reusable skills. This repository publishes the non-system skill directories and keeps the `.system/` subtree out of scope for the public snapshot.

## Workflow And Orchestration

- `codex-parallel-dispatch`
- `doc-coauthoring`
- `llm-prompt-optimizer`
- `skill-creator`
- `skill-improver`
- `skill-reviewer`

## Writing, Research, And Citation

- `article-writing`
- `citation-management`
- `literature-review`
- `humanizer`
- `Humanizer-zh`
- `markitdown`
- `minimax-pdf`

## Python, Testing, And Analysis

- `python-patterns`
- `python-performance-optimization`
- `python-testing`
- `jupyter-notebook`
- `data-visualization`

## Design And Media

- `canvas-design`

## System Layer

The local skills directory also contains a `.system/` subtree. Those assets are treated separately from the public-facing showcase because they are runtime-provided and may change independently of this repository.

## Refresh

The public skill snapshot should be refreshed from the local source with `..\..\scripts\sync-public-codex.ps1`, then reviewed before commit. The script copies non-system skill directories forward, overwrites same-name content, and keeps repository-only skill directories unless they are removed manually after review.

## Current Publishing Policy

This directory now publishes:

- the current visible non-system skill inventory
- the functional grouping of the skills
- the public copies of those skill directories

The `.system/` subtree is intentionally excluded because it belongs to the runtime layer and may drift independently of the user-maintained public skill set.
