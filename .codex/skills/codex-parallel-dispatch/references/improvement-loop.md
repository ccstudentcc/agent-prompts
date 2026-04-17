# Improvement Loop

Open this file when iterating on `codex-parallel-dispatch` after a real use, review pass, or user complaint.

## Standard Loop

1. Review the current skill and collect concrete issues.
2. Categorize each issue as `critical`, `major`, or `minor`.
3. Fix all critical issues first.
4. Fix all major issues before claiming the skill is healthy.
5. Evaluate minor issues one by one instead of batch-applying them.
6. Verify the revised skill with structure checks and forward tests.
7. Stop only when the quality bar is met.

## What to Collect During Review

- Trigger failures: the skill did not load or was not selected when it should have been
- Scope failures: the skill encouraged delegation when it should not have, or discouraged it when it should have
- Architecture failures: the skill pushed an obviously weak child layout
- Prompt-packet failures: examples were too vague to drive good child behavior
- Drift failures: `SKILL.md`, `references/`, and `examples/` no longer match

## Verification Checklist

After each revision, verify at least the following:

- The main file still has a clean entrypoint structure
- Every `reference-only` topic is either linked or intentionally retained in the main file
- Every file linked from `Additional Resources` exists
- Prompt examples still match the intended role contracts
- At least one forward test is performed for the type of issue that was fixed

## Minimum Forward-Test Set

Use raw task prompts rather than abstract discussion whenever possible.

- Single bounded sidecar task: the skill should not invent unnecessary layering
- One artifact with multiple dimensions: the skill should recommend multiple review surfaces plus one revision owner
- Multiple disjoint artifacts: the skill should recommend one writable owner per artifact

## Stop Condition

Stop the iteration when:

- No critical issues remain
- No major issues remain
- Remaining issues are minor and consciously deferred
- The revised structure is simpler or clearer than before, not merely longer
