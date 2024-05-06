#!/usr/bin/env bash
# Lists matching commits with fzf.
# Preview contains the changes in the commit.
# Enter lists files changed in the commit + preview of file contents.
# Options wizardry by Juri Pakaste /via Koodiklinikka

set -euo pipefail

export SHELL=/bin/bash

git log -G$@ --oneline | fzf \
    --preview-window=bottom,80% \
    --preview "echo {} | sed 's/ .*//g' | xargs git show --color" \
    --bind 'enter:execute(commit=$(echo {} | sed "s/ .*//g") && git diff-tree --no-commit-id --name-only $commit -r | fzf --preview-window=bottom,80% --preview "git show --color $commit -- $(git rev-parse --show-toplevel)/\{}")'
