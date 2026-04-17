# Maintenance Workflow

## Goal

Keep this repository aligned with the public subset of `C:\Users\chenpeng\.codex\` without relying on memory or ad hoc manual copying.

## Source Paths

- `C:\Users\chenpeng\.codex\AGENTS.md`
- `C:\Users\chenpeng\.codex\agents\`
- `C:\Users\chenpeng\.codex\skills\`

## Publishing Boundary

Publish by default:

- `.codex/AGENTS.md`
- `.codex/agents/*.toml`
- non-system `.codex/skills/*`

Do not publish by default:

- `.system/`
- `config.toml`
- sessions, memories, caches, logs, or other local runtime state
- anything containing credentials, headers, or machine-specific secrets

## Refresh Workflow

1. Preview the sync plan:

   `.\scripts\sync-public-codex.ps1 -PlanOnly`

2. Run the sync:

   `.\scripts\sync-public-codex.ps1`

3. Review the public delta:

   `git status --short`

4. Inspect the changed files before commit, especially:

- `README.md`
- `ARCHITECTURE.md`
- `.codex/agents/`
- `.codex/skills/`
- binary assets such as fonts and images

5. If the public inventory changed, update:

- `README.md`
- `.codex/agents/README.md`
- `.codex/skills/README.md`
- `ARCHITECTURE.md`

6. Stage, verify, commit, and push.

## Notes

- The sync script is intentionally non-destructive. It overwrites same-name files but does not delete published copies automatically.
- For `.codex/skills/`, repository-only skill directories are preserved by default even if they disappear from the local source.
- Temporary review or export artifacts should stay under repo-local `tmp/`.
