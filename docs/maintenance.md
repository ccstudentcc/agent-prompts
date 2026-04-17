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

   By default this reads repo-local `config.json`. Keep `config.json` local and use committed `config.example.json` as the template.

2. Preview actual copy operations with PowerShell-native `WhatIf` when needed:

   `.\scripts\sync-public-codex.ps1 -WhatIf`

3. Run the sync:

   `.\scripts\sync-public-codex.ps1`

4. Review the public delta:

   `git status --short`

5. Inspect the changed files before commit, especially:

- `README.md`
- `ARCHITECTURE.md`
- `.codex/agents/`
- `.codex/skills/`
- binary assets such as fonts and images

6. If the public inventory changed, update:

- `README.md`
- `.codex/agents/README.md`
- `.codex/skills/README.md`
- `ARCHITECTURE.md`

7. Stage, verify, commit, and push.

## Useful Options

- `-WhatIf`: use PowerShell's native preview mode for copy operations
- `-ConfigPath <path>`: load an alternate JSON config instead of repo-local `config.json`
- `-RepoRoot <path>`: run the script from outside the repository while still targeting this repo
- `-PublishedCodexDir <path>`: publish to a different `.codex` destination when needed
- `-CodexRoot <path>`: sync from a non-default local Codex home
- `-AsJson`: emit JSON for automation-friendly plan or result handling
- `-IncludeSystemSkills`: include `.system/` if a reviewed workflow explicitly needs it

## Notes

- `config.example.json` is the committed template; local `config.json` stays ignored by Git and is the default place for persistent sync settings.
- Command-line parameters override config values when both are present.
- The sync script is intentionally non-destructive. It overwrites same-name files but does not delete published copies automatically.
- For `.codex/skills/`, repository-only skill directories are preserved by default even if they disappear from the local source.
- The script is designed for Windows PowerShell 7 workflows and uses PowerShell-native `-WhatIf` / `-Confirm` behavior via `SupportsShouldProcess`.
- Temporary review or export artifacts should stay under repo-local `tmp/`.
