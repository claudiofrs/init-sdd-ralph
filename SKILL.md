---
name: init-sdd-ralph
description: "Bootstrap a repo for the Spec-Driven-Development + Ralph autonomous-loop workflow: creates PRD.md/AGENTS.md/CLAUDE.md/README.md, specs/ roadmap structure, and scripts/ralph/ (ralph.sh + iteration prompt). Use when starting a new project that will be built epic-by-epic with the Ralph agent loop, or retrofitting this workflow onto an existing repo. Triggers on: init sdd ralph, set up ralph workflow, bootstrap ralph loop, scaffold spec-driven-development."
user-invocable: true
---

# Init SDD + Ralph

Scaffolds a repo for **Spec-Driven Development (SDD) with the Ralph autonomous execution
loop**: layered docs (constitution → conventions → roadmap → epic spec/plan/checklist) plus
the bash loop that drives a coding agent through one user story at a time.

This is the bootstrap step only. It does not write the first epic's `spec.md`/`plan.md`/
`prd.json` — see "Starting the first epic" below for that, once the repo skeleton exists.

---

## Step 1 — Gather the minimum

Don't ask more than this. Infer what you can (project name from the directory name or an
existing `package.json`), ask only what's genuinely ambiguous:

- **Project name** (default: current directory's basename).
- **One-line product description.**
- **First epic name** (kebab-case, e.g. `scaffold` for a from-scratch project). This becomes
  `{{DEFAULT_EPIC}}`.
- **Coding agent tool**: `claude` or `amp` (default `claude`).

If the repo already has code and its own commands (install/dev/build/typecheck/test), read
its `package.json` / build files yourself to fill `{{INSTALL_CMD}}` etc. — don't ask the user
to retype commands you can discover.

## Step 2 — Check before clobbering

Before writing anything, check whether `CLAUDE.md`, `AGENTS.md`, `PRD.md`, or `specs/` already
exist in the target repo. If any do, stop and ask the user whether to merge/skip rather than
overwrite — these are likely hand-tuned already.

## Step 3 — Create the folder structure

```
<repo-root>/
├── CLAUDE.md
├── AGENTS.md
├── PRD.md
├── README.md
├── scripts/
│   └── ralph/
│       ├── ralph.sh          (chmod +x)
│       └── CLAUDE.md
└── specs/
    └── specs.md
```

Copy each file from this skill's `templates/` directory into the matching repo path, replacing
placeholders as you copy:

| Placeholder | Source |
|---|---|
| `{{PROJECT_NAME}}` | Step 1 answer |
| `{{PROJECT_DESCRIPTION}}` | Step 1 answer |
| `{{PROJECT_DIR_NAME}}` | repo root's directory name |
| `{{DEFAULT_EPIC}}` | Step 1 answer (kebab-case) |
| `{{INSTALL_CMD}}` / `{{DEV_CMD}}` / `{{BUILD_CMD}}` / `{{TYPECHECK_CMD}}` / `{{TEST_CMD}}` | discovered from the repo, or a sensible placeholder like `pnpm install` if the repo doesn't exist yet |
| `{{CURRENT_STATE_PLACEHOLDER}}` | one sentence: "No application code exists yet. The active epic is `{{DEFAULT_EPIC}}`." (adjust if retrofitting onto existing code) |
| `{{INVARIANT_PLACEHOLDER}}` / `{{STACK_CONVENTION_PLACEHOLDER}}` | leave the bracketed prose as-is — these get filled in as the project actually makes those decisions, not invented now |

`templates/ralph.sh` and `templates/ralph-CLAUDE.md` are copied to `scripts/ralph/ralph.sh` and
`scripts/ralph/CLAUDE.md` respectively (note the rename on the second file). Make `ralph.sh`
executable (`chmod +x`).

`templates/specs.md` → `specs/specs.md`. `templates/PRD.md` → root `PRD.md`.

Do **not** create `specs/{{DEFAULT_EPIC}}/` yet — that directory (`spec.md`, `plan.md`,
`prd.json`, `progress.txt`) is the first epic's own scaffolding, done in Step 4, and it needs
real product decisions, not placeholders.

## Step 4 — Fill in PRD.md together with the user

`PRD.md` is the one file this skill cannot template meaningfully — it's the actual product
decision. Walk the user through it now (or tell them it's a stub to fill in later, their
choice): Overview, Goals, Planned stack, Invariants, Out of scope. Keep it to what's actually
decided; leave sections the user hasn't decided yet as an empty bullet rather than inventing
content.

Once `PRD.md` has real invariants, copy them verbatim into `AGENTS.md`'s "Invariants" section
too — that's the file Ralph iterations actually read on every run; `PRD.md` is for humans
planning epics.

## Step 5 — Explain the epic lifecycle (tell the user, don't do it yet)

1. `specs/specs.md` lists an epic as "planned".
2. Author `specs/<epic>/spec.md` (functional requirements, scope / out-of-scope — a sub-PRD
   for just this epic) and `specs/<epic>/plan.md` (technical plan: file trees, exact values,
   one section per story, in dependency order). Add `db.md` / `uix.md` only if the epic
   touches a schema or has UI mockups to reference.
3. Convert the plan into `specs/<epic>/prd.json` — see **Story rules** below. This is the
   file Ralph actually reads/writes each iteration.
4. Flip the epic's row in `specs/specs.md` to "in progress".
5. Run `./scripts/ralph/ralph.sh --tool claude --epic <epic-name> <max-iterations>`.
6. When every story in `prd.json` has `passes: true` and Ralph emits
   `<promise>COMPLETE</promise>`, flip `specs/specs.md`'s row to "done, merged to main" and
   move to the next epic.

## Step 6 — Offer to scaffold the first epic's files now

If the user wants to start immediately, create `specs/{{DEFAULT_EPIC}}/spec.md` and `plan.md`
with them (real content, not a template — this is planning work, do it inline in the
conversation) then write `prd.json` following the rules below. Don't run `ralph.sh` yourself
unless the user explicitly asks — it's a long-running autonomous loop that commits to git on
their behalf; that's their call to kick off, not something to do silently as a side effect of
running this skill.

If the user also wants the epic's *code* implemented now, by you rather than by
`ralph.sh` — first check whether the current branch already is `<branchName>` (the same
value just written into `prd.json`), e.g. `git branch --show-current`. If it already is,
keep working there; don't create or switch branches again. If it isn't yet, `git checkout
-b <branchName>` before making any code edits — mirroring step 3 of
`scripts/ralph/CLAUDE.md`. Don't implement the epic on the wrong branch and move it
afterward as cleanup — check, then branch if needed, then edit.

---

## Story rules (apply whenever writing or converting a `prd.json`)

**Format**, one entry per story:

```json
{
  "id": "US-001",
  "title": "Short title",
  "description": "As a [user], I want [feature] so that [benefit]",
  "acceptanceCriteria": ["Verifiable criterion", "…", "Typecheck passes"],
  "priority": 1,
  "passes": false,
  "notes": ""
}
```

- **Size**: each story must finish in ONE Ralph iteration (one context window, no memory of
  prior iterations beyond git history + `AGENTS.md` + `progress.txt`). If you can't describe
  the change in 2-3 sentences, split it. "Build the dashboard" → schema, then queries, then
  components, then filters, each its own story.
- **Order**: `priority` follows dependency order — schema/migrations first, then
  backend/server logic, then UI that consumes it, then aggregating views. A story must never
  depend on a later-priority story.
- **Acceptance criteria must be checkable**, not vague. "Works correctly" is bad; "Filter
  dropdown has options: All, Active, Completed" is good. Always end with `"Typecheck passes"`
  (+ `"Tests pass"` for testable logic). Any story touching UI must include `"Verify in
  browser using dev-browser skill"` if that skill exists in the target environment.
- **New stories**: `passes: false`, `notes: ""`. `branchName` in the file's root: derive from
  the epic name, kebab-case, prefixed `ralph/` (e.g. `ralph/chat-session`).
- **Archiving**: if `prd.json` already exists for this epic dir with a *different*
  `branchName` than the one you're about to write, archive first — `ralph.sh` does this
  automatically on its next run, but if you're hand-editing between epics, copy the old
  `prd.json`/`progress.txt` into `specs/<epic>/archive/<date>-<old-branch-name>/` yourself and
  reset `progress.txt` to a fresh header before overwriting.

## Files in this skill

- `templates/CLAUDE.md`, `templates/AGENTS.md`, `templates/README.md`, `templates/PRD.md`,
  `templates/specs.md` — root-level doc skeletons.
- `templates/ralph.sh` — the loop script, copy verbatim (already generic/parametrized by
  `--epic`).
- `templates/ralph-CLAUDE.md` — per-iteration agent prompt, copy to `scripts/ralph/CLAUDE.md`.
