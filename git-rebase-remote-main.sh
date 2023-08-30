#!/usr/bin/env bash
# Fetch remote and rebase current branch on the main branch.
# Current branch can be dirty (autostash is used).

set -euo pipefail
IFS=$'\n\t'

# run in debug mode with 'DEBUG=1 script_name'
if [[ -n ${DEBUG:-} ]]; then
  set -x
fi

REMOTE=$(git remote show)
MAIN_BRANCH=$(git symbolic-ref refs/remotes/"$REMOTE"/HEAD --short)

git remote update
git rebase --autostash "$MAIN_BRANCH"
