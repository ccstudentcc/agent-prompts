# Scenario Catalog

Use these examples to sanity-check whether the planned child layout is proportional to the real task.

## Scenario 1: Single File, Multiple Quality Questions

Task shape:

- One paper draft
- Three independent review dimensions: evidence rigor, style, presentation
- One final revision owner

Recommended layout:

- Main thread: define the preservation boundary
- Child A: `reviewer` for evidence rigor
- Child B: `reviewer` for style/humanization
- Child C: `reviewer` for presentation quality
- Child D: `default` writable revision owner, or keep the writable step on the main thread

Why not one child:

- One child tends to blur multiple dimensions and miss independent review value

## Scenario 2: Three Disjoint Files

Task shape:

- `README.md`
- `ARCHITECTURE.md`
- `CONTRIBUTING.md`

Recommended layout:

- Main thread: define cross-file consistency rules
- One writable child per file
- Optional `reviewer` after implementation if consistency risk is high

Why not split by section:

- File ownership is cleaner and avoids overlapping writes

## Scenario 3: Unknown Root Cause

Task shape:

- User wants a fix, but the failing path is not yet mapped

Recommended layout:

- Main thread: keep ownership of the problem statement
- `explorer` to map the path
- Optional `planner` if sequencing remains non-obvious
- Writable child only after the scope is known

Why not dispatch multiple workers immediately:

- Parallel wrong guesses are still wrong

## Scenario 4: Multi-Module But Disjoint Implementation

Task shape:

- Two local modules need separate edits
- Shared utility code is out of scope

Recommended layout:

- Main thread: confirm the shared boundary must remain untouched
- Child A: `worker` for module one
- Child B: `worker` for module two
- Optional `reviewer` for integration risk

Why this works:

- Write sets stay disjoint
- Integration burden stays on the parent

## Scenario 5: Behavior-Preserving Cleanup

Task shape:

- Known local boundary
- Goal is structure, not behavior change

Recommended layout:

- Main thread: define the behavior contract
- `refactor` child for the cleanup
- Optional `reviewer` if the contract is subtle

Why not use worker:

- The point is preserving behavior, not introducing new functionality
