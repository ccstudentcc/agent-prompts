# Skill Layer

This directory is the public skill layer for selected content from `C:\Users\chenpeng\.codex\skills\`.

It is intentionally mixed:

- some skill directories are synced public copies of local source skills
- some skill directories are maintained only in this repository and stay here even when they do not exist under the local Codex home

For agent-facing execution rules inside this subtree, see [AGENTS.md](AGENTS.md).

## Synced From Local Codex Home

The latest sync report shows these skill directories are copied from `C:\Users\chenpeng\.codex\skills\`:

- `article-writing`
- `canvas-design`
- `citation-management`
- `codex-parallel-dispatch`
- `data-visualization`
- `doc-coauthoring`
- `humanizer`
- `Humanizer-zh`
- `jupyter-notebook`
- `literature-review`
- `llm-prompt-optimizer`
- `markitdown`
- `minimax-pdf`
- `python-patterns`
- `python-performance-optimization`
- `python-testing`
- `skill-creator`
- `skill-improver`
- `skill-reviewer`

## Repo-Only Skill Directories

The latest sync report also shows these directories are currently repository-owned in this public showcase:

- `agents-md-improver`
- `algorithmic-art`
- `backend-patterns`
- `brainstorming`
- `cpp-coding-standards`
- `cpp-testing`
- `docx`
- `frontend-design`
- `minimax-docx`
- `minimax-xlsx`
- `pdf`
- `playwright`
- `pptx`
- `pptx-generator`
- `scientific-critical-thinking`
- `scientific-slides`
- `scientific-writing`
- `skill-development`
- `writing-plans`
- `xlsx`

## Reading Guide

- Start with `SKILL.md` inside a skill directory for the entrypoint workflow.
- Use local `references/`, `scripts/`, `assets/`, or `examples/` folders only when the skill points to them.
- Treat `evals/` or fixture files inside a skill as validation material, not as general repository guidance unless that skill says otherwise.

## Maintenance Boundary

- Refresh synced skills with `..\..\scripts\sync-public-codex.ps1` instead of hand-maintaining both copies.
- Keep repo-only skills reviewable in this repository and remove them manually only after confirming they should leave the public inventory.
