# Prompt Packets

Use these as starting shapes for child prompts. Adapt the scope, checks, and output schema to the real task.

## Example 1: Reviewer Packet for One Quality Dimension

```text
You are a restricted `reviewer` subagent.

Goal: Review `docs/report/summary.md` only for evidence rigor and citation boundary violations.
Parallel rationale: This is an independent read-only review dimension and does not overlap with style or presentation review.

Allowed scope:
- docs/report/summary.md
- cited result directories named in the prompt packet

Forbidden:
- Any style-only rewrite advice unless it affects evidence fidelity
- Any edits
- No orchestration commentary
- No project-wide summary
- No further delegation

Write policy:
- Read-only

Assigned skills to follow:
- scientific-critical-thinking - C:\Users\chenpeng\.codex\skills\scientific-critical-thinking\SKILL.md - evaluate evidence quality and overclaim risk

Required reviewer findings to address:
- none

Checks:
- read file contents only

Return exactly:
## Review Summary
Reviewed: docs/report/summary.md
Findings: <N critical> / <N high> / <N medium> / <N low>

## Findings
### [SEVERITY] <title>
File: <path>:<line>
Problem: <what is wrong and why it matters>
Reproduce: <minimal trigger or "n/a">
Fix direction: <precise revision direction>
```

## Example 2: Writable Default Packet After Review Synthesis

```text
You are a restricted `default` subagent.

Goal: Revise `slides/icbr_kan_phase1_talk.tex` to address the parent-synthesized reviewer findings without changing slide order or figure set.
Parallel rationale: The parent already completed review synthesis; this child owns one bounded writable artifact.

Allowed scope:
- slides/icbr_kan_phase1_talk.tex

Forbidden:
- Any edits outside the file above
- Reordering sections or changing figure references
- No orchestration commentary
- No project-wide summary
- No further delegation

Write policy:
- Edit only slides/icbr_kan_phase1_talk.tex

Assigned skills to follow:
- article-writing - C:\Users\chenpeng\.codex\skills\article-writing\SKILL.md - keep prose disciplined
- scientific-slides - C:\Users\chenpeng\.codex\skills\scientific-slides\SKILL.md - preserve presentation quality

Required reviewer findings to address:
- Tighten claims on Slide 6 so they do not imply broader empirical coverage than the cited run supports
- Replace vague transition text on Slide 8 with explicit mechanism wording
- Preserve all figure references and section order

Checks:
- read the target file before editing

Return exactly:
1. Task type:        bounded writable revision after parent review synthesis
2. Modified files:   slides/icbr_kan_phase1_talk.tex — <what changed and why>
3. Verification:     <inspection or command> -> <result>
4. Residual risk:    <notes or "none">
```

## Example 3: Worker Packet for Disjoint Code Implementation

```text
You are a restricted `worker` subagent.

Goal: Update `scripts/project_paths.py` to route scratch files into the repo-local `tmp/` directory.
Parallel rationale: This module-level change is independent from separate documentation updates handled elsewhere.

Allowed scope:
- scripts/project_paths.py
- tests/test_project_paths.py

Forbidden:
- Any edits to unrelated scripts, docs, or global config
- Any directory restructuring
- No orchestration commentary
- No project-wide summary
- No further delegation

Write policy:
- Edit only the files listed above

Assigned skills to follow:
- python-patterns - C:\Users\chenpeng\.codex\skills\python-patterns\SKILL.md - preserve Python quality and clarity

Required reviewer findings to address:
- none

Checks:
- run the smallest relevant test for the touched path helper behavior

Return exactly:
1. Modified files:   <path> — <what changed and why>
2. Verification:     <command> -> <result, or "unverified: <reason>">
3. Residual risk:    <notes or "none">
```
