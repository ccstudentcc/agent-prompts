# SPEC

## Goal

Use the local `agents-md-improver` workflow to tighten the active `AGENTS.md` hierarchy in this repository so each layer carries only the smallest durable rules that belong there.

## In Scope

- inspect the real instruction chain for this checkout: repo root, `.codex/`, and relevant subdirectories
- decide which guidance belongs at the repository root versus narrower local `AGENTS.md` files
- trim or rewrite stale root guidance when a concrete path or document assumption is no longer true
- add minimal subdirectory `AGENTS.md` files only where local ownership or sync behavior is genuinely non-obvious
- keep task docs aligned with the current AGENTS-maintenance round

## Out Of Scope

- changing the user-home source of truth under `C:\Users\chenpeng\.codex\`
- rewriting eval fixture `AGENTS.md` files unless the eval scenarios themselves need to change
- broad README or architecture rewrites unless required to complete an AGENTS boundary move cleanly
- unrelated code, sync-script, or published-snapshot cleanup

## Acceptance

- the active AGENTS layers are clearly separated into inherited guidance and local delta
- root `AGENTS.md` stays concise and avoids stale or overly specific routing that no longer matches the repo
- any newly added subdirectory `AGENTS.md` files provide real local execution value instead of duplicating parent rules
- `agents-md-improver` local guidance remains compatible with the parent layers
- verification includes concrete file reads and `git status --short`
