#!/usr/bin/env bash
# Remove a merged branch even if the commits do not match.
# Tests merging the branch to see if there are actual changes.
# If there are no changes, the branch is deleted with force (-D).
# Note: you might want to try normal deletion with -d first,
#       and only use this script if that fails.
# git branch -d <branch_name> || git delete-merged-branch.sh <branch_name>

set -euo pipefail
IFS=$'\n\t'

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# run in debug mode with 'DEBUG=1 script_name'
if [[ -n ${DEBUG:-} ]]; then
    set -x
fi

branch_name="${1:-}"

if [[ -z "$branch_name" ]]; then
    echo "Usage: $0 <branch_name>" >/dev/stderr
    exit 1
fi

echo "Checking if the branch is merged..."

# stash staged changes before playing around with merge
if git diff-index --quiet HEAD --; then
    stashed_changes=
else
    stashed_changes=1
fi

if [[ "${stashed_changes}" ]]; then
    echo "Stashing changes..."
    git stash -m "⚙️ git-delete-merged-branch: stash before deleting merged branch"
fi

if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}Could not stash changes${NC}" >/dev/stderr
    exit 1
fi

# testing if merging the branch would really have any effect

if git merge --no-commit --no-ff "$branch_name"; then
    if git diff-index --quiet HEAD --; then
        echo -e "✅ ${GREEN}No changes after merging -- deleting the branch...${NC}"
        git branch -D "$branch_name"
    else
        echo -e "🚫 ${RED}The branch contains code changes -- not deleted${NC}"
    fi
    # aborting merge (skip if there was nothing to merge)
    if [[ -e ".git/MERGE_HEAD" ]]; then
        git merge --abort
    fi
fi

# putting everything back to normal

if [[ "${stashed_changes}" ]]; then
    echo "Restoring working tree..."
    git stash pop
fi
