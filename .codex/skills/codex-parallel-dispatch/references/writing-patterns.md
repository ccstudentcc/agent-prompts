# Writing Patterns

Open this file only when the delegated task is primarily prose, slides, reports, or paper-style revision.

## Core Pattern

Use `reviewer` to find issues and `default` to apply fixes when the task is a constrained rewrite with evidence, tone, or boundary requirements.
In these cases, `default` is usually safer than `worker`.

## Review Topology

1. Split multiple parallel reviewers by review dimension rather than by file clone.
2. Good dimensions include `evidence rigor`, `style/humanization`, and `presentation/slide quality`.
3. For prose or slide work, the best writable split is usually by file, not by chapter or section.
4. When the user asks for delegated writing help but does not specify child count, do not default to one reviewer; start from the real architecture and often use multiple reviewers followed by one writable revision owner.

## Revision Packet Requirements

- Include the target file and the exact allowed write scope.
- Include `Assigned skills to follow:` with the relevant skill names and file paths.
- Include `Required reviewer findings to address:` as a checklist when the child is responding to review feedback.
- Include explicit must-keep boundaries, forbidden changes, and any evidence or citation limits that must survive the rewrite.
- If the packet cannot name the file, required findings, and preservation boundaries precisely, keep the revision on the main thread until the packet is ready.

## Escalation Heuristic for Context Drift

Trigger escalation from reviewer-only looping to a writable child with a full context packet when any of the following holds:

- Any 2 of these appear in the same review cycle: findings lack file locations, findings repeat prior rounds without narrowing, findings stay generic enough to fit many documents, or the parent cannot state an exact preservation boundary for the next edit.
- 2 consecutive reviewer rounds fail to produce materially new file-specific guidance.

## Reviewer Output Standard

Reviewer output should serve the next edit, not generic editorial commentary.
Ask for:

- exact location
- concrete risk
- precise rewrite guidance
