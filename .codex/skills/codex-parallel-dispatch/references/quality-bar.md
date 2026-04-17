# Quality Bar

Open this file when revising `codex-parallel-dispatch` and deciding which issues must be fixed now versus later.

## Severity Levels

### Critical

Fix immediately. These issues break triggering, loading, or safe use of the skill.

- Broken or misleading frontmatter `description`
- Missing or invalid referenced file paths
- Main guidance that contradicts the live runtime or the referenced `agents/*.toml`
- A prompt template or rule that encourages overlapping writes, unsafe delegation, or main-thread abandonment

### Major

Fix before calling the skill healthy. These issues do not break loading, but they significantly reduce reliability.

- Main `SKILL.md` no longer behaves like an entrypoint and absorbs too much detail
- `core` versus `reference-only` boundaries are unclear or inconsistent
- Rules in the main file and examples/reference files drift apart
- Child-count guidance causes systematic under-dispatch or over-dispatch
- The skill lacks a clear `When to Use` or `When NOT to Use` boundary
- Reference files exist but are not discoverable from the main file

### Minor

Evaluate before fixing. These issues may improve readability, but they are not automatically worth the cost.

- Small wording or ordering improvements
- Compression opportunities that do not change behavior
- Extra examples that are helpful but not necessary
- Style preferences that do not affect trigger quality or execution safety

## Acceptance Standard

Treat the skill as healthy when all of the following are true:

- No critical issues remain
- No unresolved major issues remain
- Remaining issues are consciously accepted minor issues
- The main file still reads like an entrypoint rather than a handbook dump
- References and examples are discoverable and aligned with the main guidance

## Decision Rule for Minor Issues

Before fixing a minor issue, ask:

1. Does this improve real skill use, or just make the prose feel nicer?
2. Does this reduce ambiguity, token load, or misuse risk?
3. Could this create extra structure without proportional value?

If the answer is mostly "no", leave the minor issue alone.
