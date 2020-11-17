#!/bin/bash
# Remove local branches if their remote branch is gone

function usage {
  echo "Usage: $(basename $0) [-ph]" 2>&1
  echo "Remove local brances if remote branch is gone"
  echo '   -p   print only, do not remove branch'
  echo '   -h   output this help message'
}

function get_orphans {
  git branch -v |  # branch info, including tracking branches \
  grep ' \[gone] ' # tracking branch does not exist any more
}

function branch_name {
  awk -F' ' '{ print $1; }' # print first field (separated by spaces)
}

function commit_message {
  echo "$1" | sed 's/^.*gone] //'
}

# script only works inside a git repository

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "ERROR: not inside a Git repository"
    exit 64 # EX_USAGE
}

# expected arguments
optstring=":ph"

PRINT=

while getopts ${optstring} arg; do
  case ${arg} in
    h)
      usage
      exit
      ;;
    p) PRINT=true ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 2
      ;;
  esac
done

# refresh repositorys
git fetch --all --prune

# cache print output in file to format the list better
[ -n "$PRINT" ] && TMPFILE=$(mktemp)

while IFS= read -r line
do
  local_branch_name=$(echo "$line" | branch_name)

  if [ -z "$local_branch_name" ]; then
    echo "ERROR: could not parse local branch name from:" >&2
    echo "$line" >&2
    exit 1
  fi

  commit_message=$(commit_message "$line")

  if [ -n "$PRINT" ]; then
    echo "$local_branch_name|$commit_message" >> "$TMPFILE"
  else
    git branch -d "$local_branch_name"
  fi
done < <(get_orphans)

[ -n "$PRINT" ] && {
  column -t -s '|' "$TMPFILE"
  rm "$TMPFILE" 
}
