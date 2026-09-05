# init-sdd-ralph 
##### version 1.0
---

### Adopting end-to-end Agile product development workflow into Spec-driven Development approach with Ralph
#### Principles
- Context management, not prompt engineering
- Structured, continuous development with any AI tools
- Focus on workflow in a real Agile team: Ideation, Product research and understanding, Backlog grooming, Prioritization, Design specification & handover, Technical planning, Development & testing
#### Anti-principles
- Lack of vision, north star goals, and untestable success criteria

#### Why is this important
- Agile was made to orchestrate a mess, but still deliver results
- AI workflow are sometime a mess and could become a rabbit hole that are unmantainable, unreadable, difficult to debug when things went south
- Focus on delivering value with less frustration, high accuracy, and efficient token usage

#### What I want to achieve:

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
