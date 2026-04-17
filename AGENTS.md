# Repo Rules

- This repository is a public showcase of selected content from `C:\Users\chenpeng\.codex\`, not a blind mirror of the whole home directory.
- Source of truth for published content is local `C:\Users\chenpeng\.codex\AGENTS.md`, `C:\Users\chenpeng\.codex\agents\`, and non-system parts of `C:\Users\chenpeng\.codex\skills\`.
- Published copies live under repo-local `.codex/AGENTS.md`, `.codex/agents/`, and `.codex/skills/`.
- Never publish `config.toml`, `sessions/`, `memories/`, `.system/`, tokens, headers, or machine-specific runtime state.
- Keep temporary export or review artifacts under repo-local `tmp/`; never use system temp paths.
- Prefer `scripts/sync-public-codex.ps1` for refreshes instead of ad hoc copying.
- The sync script is intentionally non-destructive: it overwrites same-name published files, but does not delete repo copies just because the local source changed.
- Treat `.codex/skills/` as append-preserving by default; repo-only skill directories stay until they are removed manually after review.
- If the public inventory changes, update `README.md`, `.codex/agents/README.md`, `.codex/skills/README.md`, and `ARCHITECTURE.md` in the same pass.
- Review binary asset diffs carefully before commit, especially fonts and images under `.codex/skills/`.
- Before commit, check `git status --short` and `git diff --cached --name-only` to confirm the snapshot matches the intended public boundary.
