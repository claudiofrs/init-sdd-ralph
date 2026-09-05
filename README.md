# init-sdd-ralph 
##### version 1.0
---

### Adopting end-to-end Agile product development workflow into Spec-driven Development approach with Ralph
#### Principles
- Context management, not prompt engineering
- Structured, continuous development with AI tools
- Focus on workflow in a real Agile team: Ideation, Product research and understanding, Backlog grooming, Prioritization, Design specification & handover, Technical planning, Development & testing
#### Anti-principles
- Lack of vision, north star goals, and untestable success criteria

#### Why is this important
- Agile was made to orchestrate a mess, but still deliver results
- AI workflow are sometime a mess and could become a rabbit hole that are unmantainable, unreadable, difficult to debug when things went south
- Focus on delivering value with less frustration, high accuracy, and efficient token usage

#### What I want to achieve:

#### Workflow:
1. Research Synthesist
2. Business Requirement Draft
3. Product Requirement Draft
4. Requirement Grilling
5. PRD Generation
6. Roadmap Planning
7. TRD Generation
8. Epics & User Story Declaration
10. User Acceptance Test
11. Release

```
## Phase 1: SPECIFY (Ideate & Define)
1. `/claude init` - Bootstrap local system hooks.
2. Generate PRD using ProductOS AI generator.
3. Paste output as `PRD.md` at repository root (The Global Constitution).
4. Run a `/grill-me` session with Claude on the `PRD.md` to challenge assumptions.
5. Update and lock `PRD.md` with non-goals and system constraints.

## Phase 2: ROADMAP (The Index)
1. Generate `specs/specs.md` containing your prioritised epic table.
2. Initialize active epic directory: `specs/epic-name/`.
3. Generate `specs/epic-name/spec.md` (Functional scope, user journeys, non-goals).

## Phase 3: DESIGN (The Contracts)
1. Create `specs/epic-name/db.md` mapping out explicit schemas and tables.
2. Create `specs/epic-name/uix.md` pasting your Figma URLs and layout tokens.
*(Note: API contracts are deferred to the Plan stage).*

## Phase 4: DEVELOP (The Tactical Loop)
1. **Prioritise**: Prompt Claude to read `specs/specs.md` and `PRD.md` to advise on dependencies.
2. **Technical Plan**: Run `/plan` against your active feature spec, db, and uix files:
   > `/plan Read @/specs/epic-name/spec.md, db.md, and uix.md. Write technical blueprint to @/specs/epic-name/plan.md.`
3. **Decompose**: Run `/tasks` against the technical plan to generate the checklist:
   > `/tasks Generate atomic, test-driven checklists from @/specs/epic-name/plan.md. Output to @/specs/epic-name/tasks.md.`
4. **Groom**: Review `tasks.md`. Split any tasks estimated longer than 15 minutes.
5. **Execute**: Run `/build` task-by-task, verifying with unit tests after each vertical slice.
```


```my-project/
├── .gitignore                # Strictly ignore local .env, secrets, and system caches!
├── CLAUDE.md                 # Lightweight system router pointing to global rules
├── PRD.md                    # Root Project Constitution (tech stack, global boundaries)
├── AGENTS.md                 # Permanent repository memory for coding conventions & gotchas
├── scripts/
│   └── ralph/
│       ├── ralph.sh          # Ralph's bash-based autonomous execution loop
│       └── CLAUDE.md         # Prompt template Claude Code reads on every fresh iteration
└── specs/                    # The feature workspace directory
    ├── specs.md              # Living roadmap index and active prioritization table
    └── auth/                 # Isolated directory for the active epic
        ├── uix.md            # Figma frame references & design tokens
        ├── db.md             # DB structures & schema rules
        ├── spec.md           # Epic-specific functional requirements (Sub-PRD)
        ├── plan.md           # Generated technical plan (TRD)
        ├── prd.json          # Ralph's machine-readable JSON task checklist
        └── progress.txt      # Append-only learnings saved across iterations
```
