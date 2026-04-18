# Published Role Copies

- Treat `.toml` files in this directory as published copies of `C:\Users\chenpeng\.codex\agents\`, not a second source of truth.
- Make durable role changes in the local source first, then refresh this directory with `..\..\scripts\sync-public-codex.ps1` instead of hand-maintaining both copies.
- If the role inventory changes, keep `.codex/agents/README.md` aligned in the same pass.
