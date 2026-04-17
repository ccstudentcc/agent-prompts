# Architecture Patterns

Open this file when the main question is how many children to use and how to layer them.

## Pattern 1: One Artifact, Multiple Review Dimensions

Use when one file or artifact has several independent quality questions.

- Main thread: define the artifact boundary and the review dimensions
- Children: multiple `reviewer` children, one per dimension
- Writable owner: one `default` child or the main thread
- Good fit: paper rewrite, report revision, risky config diff, single PR with multiple concern types

Why this works:

- Reviewers do not overlap writes
- Independent judgment surfaces reduce blind spots
- One writable owner prevents conflicting edits

## Pattern 2: Multiple Disjoint Artifacts

Use when different files or modules can be edited independently.

- Main thread: confirm file boundaries and integration constraints
- Children: one writable owner per artifact (`worker`, `refactor`, or `default`)
- Optional extra layer: one `reviewer` after implementation if risk is meaningful

Why this works:

- Write ownership is simple
- Parallelism is real rather than decorative
- Integration remains manageable

## Pattern 3: Explore Then Implement

Use when the implementation target is not yet known.

- Main thread: keep ownership of the initial request and stop conditions
- Child 1: `explorer` to map the path or affected files
- Child 2: `worker` or `default` only after the boundary is known
- Optional: `reviewer` after implementation

Do not skip the exploration phase if the write target is still guesswork.

## Pattern 4: Plan Then Execute

Use when the task is non-trivial but the files are roughly known.

- Main thread: state objective and constraints
- Child 1: `planner` for safe sequencing, scope, and verification
- Child 2..N: writable children for disjoint execution slices
- Final: optional `reviewer`

Best for:

- multi-step code changes
- migrations inside a known boundary
- risky but bounded refactors

## Pattern 5: Investigate Plus Revise

Use when the task mixes evidence gathering with a final rewrite or patch.

- Main thread: own synthesis and contradiction resolution
- Children: independent readers/reviewers for evidence gathering
- Writable owner: one `default` or `worker` child after the packet is ready

This pattern is often better than serializing everything through one broad `default` child.

## Pattern 6: High-Risk Independent Review

Use when the cost of a miss is high enough to justify one more layer.

- Implementation may already be split
- Add a separate `reviewer` for correctness/regression/security
- Keep the reviewer read-only and file-scoped

Examples:

- benchmark logic
- cache semantics
- public-facing report conclusions
- cross-module behavior-preserving refactors

## Anti-Patterns

- Multiple writable children editing the same artifact
- A single over-broad child doing mapping, planning, implementation, and review
- Reviewers returning generic comments with no next-step value
- Dispatching more children just because the user said "parallelize" without checking independence
