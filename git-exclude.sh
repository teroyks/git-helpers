#!/usr/bin/env bash
# Exclude file pattern locally (without touching .gitignore)

set -e  # exit on non-zero exit status
set -u  # error on unset variables or parameters
set -o pipefail  # set pipeline return value to last non-zero status

# run in debug mode with 'DEBUG=1 script_name'
if [[ -n ${DEBUG:-} ]]; then
  set -x
fi

GIT_ROOT=$(git rev-parse --show-toplevel)
EXCLUDE_FILE="$GIT_ROOT/.git/info/exclude"

if [[ ! -f "$EXCLUDE_FILE" ]]; then
  touch "$EXCLUDE_FILE"
fi

if [[ -n ${1:-} ]]; then
    if grep --quiet "^$1$" "$EXCLUDE_FILE"; then
        echo "Already excluded: $1"
    else
      echo "$1" >> "$EXCLUDE_FILE"
    fi
else
    echo "Usage: git exclude <pattern>" >&2
    exit 1
fi
