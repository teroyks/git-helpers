#!/usr/bin/env bash
# Fetch remote and reset current branch to match the remote one.

set -euo pipefail
IFS=$'\n\t'

# run in debug mode with 'DEBUG=1 script_name'
if [[ -n ${DEBUG:-} ]]; then
  set -x
fi

REMOTE=$(git remote show)
CURRENT_BRANCH=$(git branch --show-current)

git fetch && git reset --hard "$REMOTE/$CURRENT_BRANCH"
