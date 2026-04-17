# SPEC

## Goal

Turn this repository into a long-term maintainable public showcase of selected content from the local Codex home directory.

## In Scope

- publish a reviewed copy of local `AGENTS.md`
- publish local agent role files
- publish non-system local skills
- document the repository structure and publishing boundary
- provide a repeatable refresh workflow for future updates

## Out Of Scope

- mirroring the full `.codex` directory
- publishing secrets, runtime state, or private machine-specific configuration
- auto-deleting published files during sync
- publishing `.system/` assets by default

## Acceptance

- the repository clearly states what is being showcased and what is excluded
- a maintainer can refresh published content from local `.codex` with a documented script
- the maintenance workflow uses repo-local `tmp/` only
- the architecture and repo-specific rules are documented
- future updates can be performed without reconstructing the process from memory
