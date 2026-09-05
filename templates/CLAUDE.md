# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Where things live

| File | Role |
|------|------|
| `PRD.md` | Project constitution: product scope, stack, boundaries |
| `AGENTS.md` | Permanent repo memory: conventions, invariants, gotchas. Read before editing code. |
| `README.md` | Folder structure and how to run the Ralph loop |
| `specs/specs.md` | Roadmap index; one directory per epic |
| `specs/[$epic-name]/*` | Active epic: `spec.md`, `plan.md`, `db.md`, `uix.md`, `prd.json`, `progress.txt` |
| `scripts/ralph/ralph.sh` | Autonomous execution loop (`--tool`, `--epic`, max iterations) |
| `scripts/ralph/CLAUDE.md` | Prompt template for each fresh Ralph iteration |

## Current state

{{CURRENT_STATE_PLACEHOLDER}}

## Commands

Run from the repo root unless stated otherwise.

| Task | Command |
|------|---------|
| Install | `{{INSTALL_CMD}}` |
| Dev | `{{DEV_CMD}}` |
| Build | `{{BUILD_CMD}}` |
| Typecheck | `{{TYPECHECK_CMD}}` |
| Test | `{{TEST_CMD}}` |

## Product: {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

Full spec lives in `PRD.md`. Read it before implementing any feature — invariants that shape
architecture belong in `AGENTS.md`, not repeated here.
