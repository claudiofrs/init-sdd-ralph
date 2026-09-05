#!/bin/bash
# Ralph Wiggum - Long-running AI agent loop, epic-scoped.
# Usage: ./ralph.sh [--tool amp|claude] [--epic <name>] [max_iterations]
#        ./ralph.sh --list

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SPECS_DIR="$REPO_ROOT/specs"

TOOL="claude"
EPIC="{{DEFAULT_EPIC}}"
MAX_ITERATIONS=10
LIST_MODE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --tool)
      TOOL="$2"
      shift 2
      ;;
    --tool=*)
      TOOL="${1#*=}"
      shift
      ;;
    --epic)
      EPIC="$2"
      shift 2
      ;;
    --epic=*)
      EPIC="${1#*=}"
      shift
      ;;
    --list)
      LIST_MODE=true
      shift
      ;;
    *)
      if [[ "$1" =~ ^[0-9]+$ ]]; then
        MAX_ITERATIONS="$1"
      fi
      shift
      ;;
  esac
done

if $LIST_MODE; then
  echo "Epics with a prd.json under specs/:"
  echo ""
  for dir in "$SPECS_DIR"/*/; do
    name="$(basename "$dir")"
    prd="$dir/prd.json"
    [ -f "$prd" ] || continue
    total=$(jq '.userStories | length' "$prd")
    done_count=$(jq '[.userStories[] | select(.passes == true)] | length' "$prd")
    branch=$(jq -r '.branchName // "?"' "$prd")
    status="in progress"
    [ "$total" -gt 0 ] && [ "$done_count" -eq "$total" ] && status="complete"
    echo "  $name — $done_count/$total stories passing — $status — branch: $branch"
  done
  exit 0
fi

if [[ "$TOOL" != "amp" && "$TOOL" != "claude" ]]; then
  echo "Error: Invalid tool '$TOOL'. Must be 'amp' or 'claude'."
  exit 1
fi

EPIC_DIR="$SPECS_DIR/$EPIC"
PRD_FILE="$EPIC_DIR/prd.json"
PROGRESS_FILE="$EPIC_DIR/progress.txt"
ARCHIVE_DIR="$EPIC_DIR/archive"
LAST_BRANCH_FILE="$EPIC_DIR/.last-branch"
PROMPT_TEMPLATE="$SCRIPT_DIR/$([ "$TOOL" == "amp" ] && echo prompt.md || echo CLAUDE.md)"

if [ ! -f "$PRD_FILE" ]; then
  echo "Error: no prd.json at $PRD_FILE. Run --list to see available epics."
  exit 1
fi

# Archive previous run if branchName changed since last invocation for this epic
if [ -f "$LAST_BRANCH_FILE" ]; then
  CURRENT_BRANCH=$(jq -r '.branchName // empty' "$PRD_FILE")
  LAST_BRANCH=$(cat "$LAST_BRANCH_FILE")
  if [ -n "$CURRENT_BRANCH" ] && [ -n "$LAST_BRANCH" ] && [ "$CURRENT_BRANCH" != "$LAST_BRANCH" ]; then
    DATE=$(date +%Y-%m-%d)
    FOLDER_NAME=$(echo "$LAST_BRANCH" | sed 's|^ralph/||')
    ARCHIVE_FOLDER="$ARCHIVE_DIR/$DATE-$FOLDER_NAME"
    echo "Archiving previous run: $LAST_BRANCH"
    mkdir -p "$ARCHIVE_FOLDER"
    [ -f "$PRD_FILE" ] && cp "$PRD_FILE" "$ARCHIVE_FOLDER/"
    [ -f "$PROGRESS_FILE" ] && cp "$PROGRESS_FILE" "$ARCHIVE_FOLDER/"
    echo "   Archived to: $ARCHIVE_FOLDER"
    echo "# Ralph Progress Log — $EPIC" > "$PROGRESS_FILE"
    echo "Started: $(date)" >> "$PROGRESS_FILE"
    echo "---" >> "$PROGRESS_FILE"
  fi
fi

CURRENT_BRANCH=$(jq -r '.branchName // empty' "$PRD_FILE")
[ -n "$CURRENT_BRANCH" ] && echo "$CURRENT_BRANCH" > "$LAST_BRANCH_FILE"

if [ ! -f "$PROGRESS_FILE" ]; then
  echo "# Ralph Progress Log — $EPIC" > "$PROGRESS_FILE"
  echo "Started: $(date)" >> "$PROGRESS_FILE"
  echo "---" >> "$PROGRESS_FILE"
fi

echo "Starting Ralph - Epic: $EPIC - Tool: $TOOL - Max iterations: $MAX_ITERATIONS"

for i in $(seq 1 "$MAX_ITERATIONS"); do
  echo ""
  echo "==============================================================="
  echo "  Ralph Iteration $i of $MAX_ITERATIONS ($TOOL, epic: $EPIC)"
  echo "==============================================================="

  PROMPT=$(sed \
    -e "s#{{EPIC}}#$EPIC#g" \
    -e "s#{{PRD_FILE}}#specs/$EPIC/prd.json#g" \
    -e "s#{{PROGRESS_FILE}}#specs/$EPIC/progress.txt#g" \
    "$PROMPT_TEMPLATE")

  if [[ "$TOOL" == "amp" ]]; then
    OUTPUT=$(echo "$PROMPT" | amp --dangerously-allow-all 2>&1 | tee /dev/stderr) || true
  else
    OUTPUT=$(echo "$PROMPT" | claude --dangerously-skip-permissions --print 2>&1 | tee /dev/stderr) || true
  fi

  if echo "$OUTPUT" | grep -qE '^[[:space:]]*<promise>COMPLETE</promise>[[:space:]]*$'; then
    echo ""
    echo "Ralph completed all tasks for epic '$EPIC'!"
    echo "Completed at iteration $i of $MAX_ITERATIONS"
    exit 0
  fi

  echo "Iteration $i complete. Continuing..."
  sleep 2
done

echo ""
echo "Ralph reached max iterations ($MAX_ITERATIONS) without completing epic '$EPIC'."
echo "Check $PROGRESS_FILE for status."
exit 1
