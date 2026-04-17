# Operating Procedures

Open this file when the task depends on step-by-step orchestration behavior, timeout handling, or runtime-specific operating discipline.

## Orchestration Sequence

```text
1. Decide what stays on the main thread BEFORE spawning anything
2. Split remaining work into sidecar subtasks with explicit scopes
3. Spawn narrow, self-contained agents with full delegation contracts
4. Start local non-overlapping work immediately - do not wait by reflex
5. Reuse a running agent only when follow-up truly needs its thread context
6. Wait only when blocked or when integration requires the result
7. On return: check scope compliance -> check file overlap -> run combined
   verification -> synthesize findings -> close completed agents immediately
```

Operational notes:

- `resume_agent(id)` is for real thread reuse, not routine status polling.
- Do not treat a closed agent as reusable until `resume_agent(id)` succeeds, and do not rely on a specific resumed status label; verify reuse by sending bounded follow-up work.
- `send_input(..., interrupt=true)` is for direction changes, not progress checks.
- If a child drifts, ignores scope, or starts acting like a second orchestrator, close it and continue locally or re-dispatch with a tighter contract.

## Codex Runtime Constraints

Timeout policy: set `wait_agent.timeout_ms` by task complexity. A timeout means none of the watched targets reached a final state within the current wait window. It is not a failure signal.

| Task complexity | timeout_ms | Examples |
|----------------|------------|----------|
| Complex | >= 900000 | Multi-file implementation, broad exploration |
| Medium | >= 600000 | Single-module change, focused review |
| Simple | >= 300000 | Single-file read, symbol lookup |

On timeout:

- Continue local main-thread work and return to wait later.
- Do not close the agent on first timeout.
- Close only after confirming the task has genuinely stalled or scope has changed.
- Treat timeout as non-final: continue meaningful main-thread work, then wait again or close later if appropriate.

Validation environment:

- For final verification, prefer the project's known stable interpreter, toolchain, or environment over a bare default `python` invocation.
- If the bare default interpreter fails but the project-specific environment succeeds, report that distinction explicitly instead of treating the task as unverified.

Write-safety:

- For safety-critical tasks, rely on isolated sandbox directories, explicit file-scope contracts, and post-run verification; do not rely on role `sandbox_mode` labels as the sole write barrier.
