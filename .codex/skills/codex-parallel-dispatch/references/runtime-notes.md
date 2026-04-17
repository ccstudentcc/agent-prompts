# Runtime Notes

Open this file when a dispatch decision depends on runtime-specific behavior rather than general orchestration guidance.

## Verified Facts

These are direct experiments, not assumptions:

- Omitting `agent_type` still spawns a child successfully; the runtime falls back to the default role.
- `agent_type="refactor"` launches and can complete a bounded behavior-preserving refactor task.
- `spawn_agent(items=[{type="text", ...}])` works.
- `send_input(items=[{type="text", ...}])` works.
- `resume_agent(id)` can reopen a completed child and accept more input.
- `send_input(..., interrupt=true)` can redirect an in-flight child to a new task.
- `wait_agent(targets=[...])` can watch multiple children and, in multi-target waits, returns the first child that reaches a final state rather than waiting for the whole set.
- `close_agent(target)` cleanly shuts down completed children and returns the prior final status.
- A closed completed agent can be resumed and reused; in testing, `resume_agent(id)` returned `pending_init` and the resumed agent successfully accepted new input.
- `spawn_agent(model=..., reasoning_effort=...)` was accepted by the runtime on a `default` child, but this session did not prove whether the override changed the actual underlying model choice.
- `fork_context=false` should not be treated as a hard isolation boundary. In a probe, a child launched with `fork_context=false` still appeared able to identify the current thread request.
- In a medium-task comparison, `fork_context=true` added context noise and did not improve accuracy when the child already had a sufficient prompt packet.
- Local agent-template `sandbox_mode` values should not be treated as hard enforcement; a role labeled `read-only` produced a real file write in sandbox testing.
- Under concurrent stress, a broad `default` prompt can drift into pseudo-orchestration; prefer narrower roles or pull back and re-dispatch when this appears.
