---
name: codex-parallel-dispatch
description: This skill should be used when the user asks to "use subagents", "delegate this", "split this into agents", "parallelize the work", "have one agent review and another implement", or otherwise explicitly requests multi-agent coordination in Codex. Use it only when the task can be decomposed into bounded sidecars without overlapping writes, shared mutable state, or critical-path dependency.
---

# Dispatching Parallel Agents

This is a main-agent skill. Optimize for routing, containment, and integration.
Prefer the live tool surface over this file if they ever disagree.

## When to Use
Classification: core

Use this skill when all of the following are true:

- The user explicitly wants delegation, subagents, or parallel agent work.
- The task can be decomposed into independent sidecars with clear non-overlap boundaries.
- Delegation will remove a real bottleneck such as bounded review, disjoint implementation, or independent investigation.

## When NOT to Use
Classification: core

Do not use this skill when any of the following apply:

- The user wants depth or thoroughness but did not ask for delegation.
- The next step is a single blocking task that the main thread should do directly.
- The work depends on tightly coupled edits, unresolved tradeoffs, or shared mutable state.
- The agent count would be inflated for appearance rather than for real parallel value.

## Quick Operating Recipe
Classification: core

1. Confirm that delegation was explicitly requested.
2. Decompose the task by artifact, dimension, phase, risk, and write authority.
3. Pick the smallest multi-agent architecture that fully covers the independent sidecars.
4. Keep blocking synthesis on the main thread; dispatch the rest with strict contracts.
5. Integrate, verify, and close children promptly.

## Additional Resources
Classification: core

Consult these files only when they are relevant to the current task:

- `references/role-contracts.md` — role selection and output-shape reminders aligned with `$HOME/.codex/agents/*.toml`
- `references/architecture-patterns.md` — reusable multi-agent architecture templates by task shape
- `references/operating-procedures.md` — orchestration sequence and runtime-constraint details kept out of the main flow
- `references/quality-bar.md` — critical/major/minor issue standards for improving this skill
- `references/improvement-loop.md` — the review-fix-verify loop for iterating on this skill safely
- `references/runtime-notes.md` — verified runtime-specific notes, caveats, and operational implications
- `references/writing-patterns.md` — the writing/prose/slides specialization kept out of the main flow
- `examples/prompt-packets.md` — concrete child prompt packets for reviewer, default, and worker flows
- `examples/scenario-catalog.md` — example task decompositions and recommended child layouts

## Runtime Surface
Classification: reference-only

Current child-management tools in this session:

- `spawn_agent(agent_type?, fork_context?, message?|items?, model?, reasoning_effort?)`
- `send_input(target, interrupt?, message?|items?)`
- `wait_agent(targets, timeout_ms?)`
- `resume_agent(id)`
- `close_agent(target)`

Current supported `spawn_agent.agent_type` values in this session:

- `default`
- `explorer`
- `planner`
- `refactor`
- `reviewer`
- `worker`

Local role contracts live under `$HOME/.codex/agents/*.toml`. 

## Dispatch Gate
Classification: core

All five must be YES before spawning any subagent:

1. User explicitly requested subagents, delegation, or parallel agent work?
2. At least one bounded sidecar task exists, and any additional child tasks are independent?
3. Each subtask has a concrete goal, scope, and return format?
4. Tasks run without overlapping file edits, shared resources, or sequential dependency?
5. Main thread's next step remains clear after dispatch?

If any answer is NO, keep everything in the main agent.

## Pattern Selection
Classification: core

```text
Task type?
├─ Same task, multiple runs for consensus/safety -> VOTING
│   (e.g., security review, vulnerability scan, content moderation)
│
├─ Independent subtasks, disjoint scope -> SECTIONING
│   └─ Subtasks known and bounded?
│       ├─ YES -> spawn specialized agents (see roles below)
│       └─ NO  -> keep in main agent; decompose first
│
└─ Output needs iterative refinement with clear criteria -> EVALUATOR-OPTIMIZER
    (generator agent + evaluator agent in a loop)
```

Codex note:

- This runtime supports SECTIONING directly.
- VOTING and EVALUATOR-OPTIMIZER are orchestration patterns, not dedicated runtime roles.
- Do not use those patterns unless the user explicitly asked for delegation and the loop or parallelism is still bounded and worth the overhead.
- If the target file set is already known and stable, skip `explorer`; do not dispatch it just to make the workflow look more parallel.

## Effort Scaling
Classification: core

Treat these as conservative heuristics, not quotas. Start smaller when uncertain.
In this runtime, one bounded child is better than several vague ones, but under-dispatch is also a failure mode.
If the task naturally decomposes into multiple independent sidecars, do not collapse it to one child just because the user did not specify a count.
Use more than 4 children only when the user explicitly asked for broad delegation and the scopes stay truly disjoint.

| Complexity | Typical subagents | Guidance |
|------------|-------------------|----------|
| Single fact / single file | 1 | Prefer one bounded child or keep it on the main thread |
| Comparison / multi-file bounded | 2-4 | Use only when scopes are clearly disjoint |
| Broad exploration / complex research | 4+ | Escalate gradually; do not jump here by default |

## Implicit Child-Count Policy
Classification: core

When the user explicitly asks for delegation but does not specify how many children to use, infer the count from the task architecture rather than defaulting to one or two.

Rules:

1. Treat missing count as "choose the smallest architecture that fully covers the real independent sidecars", not as a preference for a single child.
2. Decide the layer structure before spawning: decomposition, parallel specialist work, writable revision, and final integration. Not every layer needs a child, but the architecture should be explicit.
3. If the task has 2 or more clearly different independent dimensions, files, or deliverables, the default plan should usually use 2-4 children rather than 1.
4. If only one true bounded sidecar exists after decomposition, use 1 child and say so mentally; do not inflate agent count for appearance.
5. If you choose only 1 child for a task that appears multi-dimensional, be able to justify why the other dimensions are either coupled, low-value, or better handled on the main thread.

Default architecture templates when count is unspecified:

- Single-file paper, report, or Beamer rewrite with meaningful review depth: usually 2-4 children across review dimensions first, then a writable `default` child or the main thread for the revision pass.
- Multi-file writing pack: usually one writable child per file, as long as files are disjoint, with optional reviewer children by dimension if the quality bar is high.
- Multi-module code change with disjoint write sets: usually one implementation child per module plus one reviewer if cross-module integration risk is non-trivial.
- Mixed investigation plus revision: keep the blocking decomposition or synthesis on the main thread, then dispatch the independent sidecars in parallel instead of serializing them through one child.

## General Decomposition Heuristics
Classification: core

Before choosing child count, decompose the task along the smallest set of independent axes that actually changes the work.

Common axes:

- Artifact axis: different files, modules, datasets, reports, or deliverables.
- Dimension axis: different quality questions such as correctness, evidence quality, performance, style, presentation, or security.
- Phase axis: exploration, planning, implementation, review, and integration.
- Risk axis: high-risk surfaces that deserve an independent reviewer even if implementation is already split.
- Authority axis: which steps require writable ownership versus read-only judgment.

Use these heuristics:

1. Split by artifact when write scopes are naturally disjoint.
2. Split by dimension when multiple specialists can assess the same artifact without overlapping writes.
3. Split by phase when one phase benefits from independent judgment before the next writable phase begins.
4. Add an independent reviewer when the consequence of a missed issue is high enough to justify the extra layer.
5. Keep synthesis, tradeoff resolution, and scope changes on the main thread unless a single bounded child can own them safely.

Practical default:

- If the task has one artifact and one dominant quality question, 1 child may be enough.
- If it has one artifact but 2-3 distinct quality questions, prefer multiple reviewer children by dimension, then one revision owner.
- If it has multiple disjoint artifacts, prefer one writable child per artifact, with optional reviewer children by dimension when stakes are high.
- If it mixes discovery and execution, keep the blocking decomposition local, then dispatch the independent sidecars in parallel.

## Standard Multi-Agent Collaboration Flow
Classification: core

Use this as the default collaboration pipeline whenever the user asks for delegation and the task is larger than a trivial single-sidecar handoff.

1. Main thread defines the objective, the independent axes, and the non-overlap boundary.
2. Main thread decides which work is blocking and must stay local.
3. Spawn parallel read-only or narrowly scoped specialist children for independent evidence gathering, review, or bounded implementation.
4. Collect outputs into a structured parent synthesis: deduplicate overlap, resolve contradictions, and decide the next writable owner.
5. Hand the resulting context packet to one writable owner per disjoint artifact, or keep the writable step on the main thread if the integration burden is high.
6. Run an independent review pass when the risk profile justifies it.
7. Integrate, verify, and close completed children promptly.

Failure-avoidance rules:

- Do not let multiple children compete to edit the same artifact.
- Do not let reviewers return generic commentary that cannot drive a next edit.
- Do not spawn extra children only to look busy; every child must remove a real bottleneck or add an independent judgment surface.
- Do not skip independent review when the task has multiple plausible failure modes and the cost of a miss is meaningful.

## Agent Roles - Routing Table
Classification: core

Choose the narrowest fitting role. If two roles both seem plausible, prefer the more specialized one.

| Role | Dispatch when | Do NOT dispatch when |
|------|---------------|----------------------|
| `explorer` | Map execution path, trace symbols, discover dependencies, bound impact | Real scope is still unknown and not yet decomposed |
| `planner` | Turn a known target area into a sequenced, risk-assessed execution plan | Target area is not yet established; run `explorer` first |
| `refactor` | Behavior-preserving structural cleanup inside a known local boundary | Work crosses modules, public interfaces, shared utilities, or hides behavior changes |
| `worker` | Bounded implementation inside a known, disjoint file/module set | Task touches shared utilities, global config, or public interfaces |
| `reviewer` | Post-implementation correctness, regressions, security, test gaps | Implementation is not yet stable enough to review |
| `default` | Narrow mixed tasks needing light investigation plus a small scoped deliverable | Complex, cross-boundary, or ambiguous work; keep in main agent |

Main agent owns complex synthesis, cross-module coordination, ambiguous debugging, approval-sensitive decisions, and any work that cannot be described as a stable bounded deliverable.

## Example Specialization - Writing, Prose, and Slide Work
Classification: reference-only

This is one example of the general framework above.
For document-heavy tasks, prefer multiple reviewer dimensions followed by one writable revision owner.
Keep the detailed writing-specific workflow, context-packet requirements, and escalation heuristics in `references/writing-patterns.md`.

## Escalation Signals - Pull Back Immediately
Classification: core

Return work to the main agent the moment any of these appear:

- Child task starts touching shared helpers, global config, or public interfaces
- Two sibling agents need the same files, cache, or output path
- The real problem is a single root cause spanning multiple subtasks
- Agent requires repeated clarifications, approvals, or tradeoff decisions from parent
- Task scope is no longer stable or bounded
- Child starts acting like a second orchestrator instead of a bounded specialist

## Runtime Facts Verified In This Session
Classification: reference-only

Keep only the operational takeaways here. Put the full verified list in `references/runtime-notes.md`.

Operational implication:

- Use `fork_context=false` for scope discipline and lower context load.
- Do not rely on `fork_context=false` for secrecy, sandboxing, or guaranteed context isolation.
- Treat `model` and `reasoning_effort` overrides as exceptional. Use them only when there is a concrete need.

## Child Contract
Classification: core

Every child task should specify all of the following:

1. Objective: one atomic question or deliverable.
2. Parallel rationale: why this work is independent from the parent's local work.
3. Allowed scope: exact files, directories, symbols, or artifacts.
4. Forbidden scope: explicit paths, modules, or actions that are out of bounds.
5. Write policy: whether edits are allowed and, if so, exactly where.
6. Assigned skills to follow: relevant skill names and paths when the task depends on a named or clearly matching skill workflow.
7. Required reviewer findings to address: mandatory when a writable child is fixing review feedback.
8. Checks: the only commands the child may run, if any.
9. Stop conditions: what should cause immediate handoff back to the main agent.
10. Return format: a strict schema with no intros, no progress diary, and no global summary.

If the contract is vague, do not spawn yet. Rewrite it first.

## Fork-Context Rule
Classification: core

Default to `fork_context=false`.

Use `fork_context=true` only when all of the following are true:

1. The child genuinely needs prior thread context that would be costly to restate.
2. A bounded packet of files, diffs, and instructions is not enough.
3. The child still has a narrow role and a strict return format.
4. The prompt explicitly forbids orchestration behavior, project-wide summaries, and further delegation.

Treat `fork_context=true` as a last resort for `default`, `explorer`, and `reviewer`.
Practical rule:

- If a bounded prompt packet already contains the needed files, goals, and constraints, prefer `fork_context=false`; do not enable `fork_context=true` just to be safe.
## Orchestration Sequence
Classification: reference-only

Keep the detailed step sequence and operational notes in `references/operating-procedures.md`.
Use the `Quick Operating Recipe` and `Standard Multi-Agent Collaboration Flow` above for the main-thread default.

## Codex Runtime Constraints
Classification: reference-only

Keep timeout policy, validation-environment notes, and write-safety details in `references/operating-procedures.md`.

## Forward Testing for This Skill
Classification: core

When revising this skill, validate it against raw example tasks rather than only reading the prose back to yourself.

Use at least these scenario classes:

- Single bounded sidecar: the skill should recommend 1 child or no child, not artificial layering.
- One artifact with multiple independent quality questions: the skill should recommend multiple reviewer dimensions plus one revision owner.
- Multiple disjoint artifacts: the skill should recommend one writable owner per artifact, not competing editors on the same file set.

Validation guidance:

- Prefer raw task prompts, output traces, and prompt packets over abstract discussion.
- Do not leak the intended answer or preferred architecture into the validation prompt unless the validation specifically requires it.
- Treat under-dispatch and over-dispatch as equally real failure modes.

## Prompt Skeleton
Classification: core

Use one compact template, but match the return shape to the selected role contract.
Before writing a child prompt, re-open the corresponding `$HOME/.codex/agents/<role>.toml` file if the exact output shape matters.
If you need concrete prompt examples, open `examples/prompt-packets.md`.

Role-specific return-shape reminders:

- `explorer`: request the structured exploration report defined in `explorer.toml`
- `planner`: request the execution-plan structure defined in `planner.toml`
- `reviewer`: request the review-summary and findings structure defined in `reviewer.toml`
- `worker`: request `Completion Report` or `Handover Report` aligned with `worker.toml`
- `refactor`: request `Completion Report` or `Handover Report` aligned with `refactor.toml`
- `default`: request `Completion Report`, `Re-dispatch Report`, or `Handover Report` aligned with `default.toml`

```text
You are a restricted `<role>` subagent.

Goal: <one atomic deliverable>
Parallel rationale: <why this is independent from the parent's local work>

Allowed scope:
- <path/symbol/artifact>

Forbidden:
- <out-of-scope paths/actions>
- No orchestration commentary
- No project-wide summary
- No further delegation

Write policy:
- <read-only OR exact editable files>

Assigned skills to follow:
- <skill name> - <path> - <why it applies>

Required reviewer findings to address:
- <finding or `none`>

Checks:
- <allowed commands only>

Return exactly:
<role-aligned output schema>

If blocked, return exactly:
<role-aligned handoff schema>
```

## Anti-Patterns
Classification: core

- Delegating because the task is hard rather than because it splits cleanly
- Sending overlapping file sets to multiple children
- Waiting immediately after spawn when local work exists
- Treating `fork_context=false` as a confidentiality or isolation guarantee
- Using `interrupt=true` for routine progress checks
- Letting children produce project-wide synthesis or orchestration commentary
- Giving `default` a sandbox-wide stabilization or prioritization task under parallel pressure when the deliverable is not tightly bounded
- Assuming `planner`, `explorer`, or `reviewer` cannot write merely because a local template labels them `read-only`
- Leaving completed children open longer than necessary
