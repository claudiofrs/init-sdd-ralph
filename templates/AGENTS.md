# AGENTS.md

Permanent repo memory. Read before editing code. Update this file (not `progress.txt`)
when you discover a pattern, gotcha, or convention future iterations must know — keep
entries general and reusable, not story-specific.

## Invariants (never violate)

- {{INVARIANT_PLACEHOLDER}} — hard constraints from `PRD.md` that shape architecture and are
  easy to violate by accident. Copy them here verbatim as they're decided, don't paraphrase
  loosely.

## Stack conventions

- {{STACK_CONVENTION_PLACEHOLDER}} — package manager, monorepo layout, port numbers, ORM/DB
  choice, anything a fresh Ralph iteration needs to not rediscover from scratch.

## Ralph loop

- One epic at a time under `specs/<epic-name>/` (`spec.md`, `plan.md`, `prd.json`,
  `progress.txt`). `specs/specs.md` is the roadmap index of which epic is active.
- Run with `scripts/ralph/ralph.sh --tool claude --epic <name> [max_iterations]`.
- Each iteration is a fresh agent with no memory beyond git history, this file, and
  `specs/<epic>/progress.txt`. Keep stories small enough to finish in one context window.
