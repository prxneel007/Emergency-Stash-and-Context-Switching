#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")" && pwd)
MODE=${1:-}
DEMO=$(mktemp -d "$ROOT/run-XXXXXX")
exec > >(tee "$DEMO/transcript.txt") 2>&1
mkdir "$DEMO/repository"
cd "$DEMO/repository"
checkpoint() {
  printf '\n=== %s ===\n' "$1"
  if [ "$MODE" = "--interactive" ]; then
    read -r -p 'Take your screenshot, then press Enter to continue. ' answer
  fi
}
run() { printf '\n$'; printf ' %q' "$@"; printf '\n'; "$@"; }
run git init -b main
git config user.name 'Student Demo'
git config user.email 'student@example.invalid'
git config core.autocrlf false
printf 'def average(values):\n    return sum(values) / len(values)\n' > app.py
printf '# Feature workspace: expense summary\n' > feature.py
run git add app.py feature.py
run git commit -m 'Initial demo application and tracked feature placeholder'
run git switch -c feature/expense-summary
cat >> feature.py <<'PY'
def expense_summary(expenses):
    totals = {}
    count = 0
    largest = 0
    for expense in expenses:
        category = expense.get("category", "Other")
        amount = expense.get("amount", 0)
        totals.setdefault(category, 0)
        totals[category] += amount
        count += 1
        largest = max(largest, amount)
    grand_total = sum(totals.values())
    average = grand_total / count if count else 0
    report = {}
    report["totals"] = totals
    report["count"] = count
    report["largest"] = largest
    report["average"] = average
    report["grand_total"] = grand_total
    raise NotImplementedError("Finish formatting and returning the report")
PY
run git diff --numstat
run git diff
run git status
BEFORE=$(git hash-object feature.py)
cp feature.py "$DEMO/feature-before.py"
git diff --binary > "$DEMO/before.patch"
checkpoint '1: Exactly 20 added lines, unfinished and unstaged'
run git stash push -m 'WIP: 20-line expense summary before urgent fix'
run git stash list
run git status
run git switch main
run git status
test -z "$(git status --porcelain)"
checkpoint '2: Stash exists; main is clean before the emergency fix'
printf 'def average(values):\n    if not values:\n        return 0\n    return sum(values) / len(values)\n' > app.py
run git diff
run git add app.py
run git commit -m 'Fix emergency empty-list division by zero'
run git status
run git stash list
test -z "$(git status --porcelain)"
checkpoint '3: Emergency fix committed; main is clean; stash retained'
run git switch feature/expense-summary
run git stash list
run git stash pop
run git stash list
run git status
run git diff --numstat
AFTER=$(git hash-object feature.py)
git diff --binary > "$DEMO/after.patch"
run cmp "$DEMO/feature-before.py" feature.py
run cmp "$DEMO/before.patch" "$DEMO/after.patch"
test "$BEFORE" = "$AFTER"
test "$(git status --porcelain)" = ' M feature.py'
test -z "$(git stash list)"
git diff --cached --exit-code
printf '\nPASS: identical file bytes and diff; changes are unstaged; stash is empty.\nBefore: %s\nAfter:  %s\n' "$BEFORE" "$AFTER"
run git log --all --oneline --decorate --graph
checkpoint '4: Exact unfinished workspace restored on feature branch'
printf '\nCompleted repository: %s\nEvidence: %s/transcript.txt\n' "$PWD" "$DEMO"
