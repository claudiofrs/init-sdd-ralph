# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}} Built autonomously with Ralph.

Read `PRD.md` for the product, `AGENTS.md` for the conventions and invariants.

## Running Ralph

```bash
./scripts/ralph/ralph.sh --tool claude --epic {{DEFAULT_EPIC}} 30
```

Arguments: `--tool amp|claude` (default `claude`), `--epic <name>` (default `{{DEFAULT_EPIC}}`),
and a bare number for max iterations (default `10`). Requires `jq`.

Run `./scripts/ralph/ralph.sh --list` to see every valid `--epic` value — every `specs/<name>/`
directory that has a `prd.json`, with its story pass count, status, and branch.

Each iteration is a fresh agent: it reads the epic's `prd.json`, picks the highest-priority
story with `passes: false`, implements it, runs the quality checks, commits, and appends its
learnings to `progress.txt`. The loop stops when the agent emits `<promise>COMPLETE</promise>`.
Progress lives in `specs/<epic>/progress.txt`.

`specs/specs.md` is the roadmap index: one epic is active at a time, in the order decided
there (see `specs/trd.md` if the project has a longer multi-phase plan).

## Folder structure

```
{{PROJECT_DIR_NAME}}/
├── CLAUDE.md                 # Router pointing to the docs below
├── PRD.md                    # Project constitution (product scope, stack, boundaries)
├── AGENTS.md                 # Permanent repo memory: conventions & gotchas
├── README.md                 # This file
├── scripts/
│   └── ralph/
│       ├── ralph.sh          # Autonomous execution loop
│       └── CLAUDE.md         # Prompt template for each fresh iteration
└── specs/
    ├── specs.md               # Roadmap index — one epic active at a time
    └── {{DEFAULT_EPIC}}/      # Active epic
        ├── spec.md             # Functional requirements (sub-PRD)
        ├── plan.md             # Technical plan, one section per story
        ├── prd.json            # Machine-readable story checklist Ralph reads/writes
        └── progress.txt        # Append-only learnings across iterations
```
