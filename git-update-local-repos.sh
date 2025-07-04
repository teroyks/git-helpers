#!/bin/bash
# Update all repositories from origin, prune deleted remotes.
# Delete local repositories that match a deleted remote branch
# Update the current repository to match origin

# define helpers

is_inside_git_repo() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

is_on_main_branch() {
    current_branch=$(git branch --show-current)
    test "$current_branch" = "main" || test "$current_branch" = "master"
}

local_repo_exists() {
    git branch | grep "^ *$1\$"
}

print_separator() {
    echo
    echo "* * *"
    echo
}

# sanity check

is_inside_git_repo || {
    echo "ERROR: not inside a Git repository"
    exit 64 # EX_USAGE
}

is_on_main_branch || {
    echo "ERROR: not on main branch"
    exit 64 # EX_USAGE
}

# initialize

REPO_STATUS_FILE=/tmp/git-repo-fetch-status
# LOCAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)
REMOTE=$(git remote show)
REMOTE_BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref "@{u}")

# update repositories
# skip if local cache already exists

if [[ -f "$REPO_STATUS_FILE" ]]; then
    echo "Repository status file $REPO_STATUS_FILE found - skipping update"
else
    git fetch --all --prune >"$REPO_STATUS_FILE" 2>&1 || {
        echo "ERROR: Fetch failed - check (and remove) status file $REPO_STATUS_FILE before trying again." >&2
        exit 1
    }
fi

cat "$REPO_STATUS_FILE"
print_separator

# update current repository to match origin

if [[ -n $REMOTE_BRANCH ]]; then
    git merge "$REMOTE_BRANCH"
else
    echo "No tracking branch - skipping update"
fi

# delete local repos if remote repository was deleted

DELETED_REMOTES=$(grep "\- \[deleted\]" $REPO_STATUS_FILE | sed 's/.* -> //')
[[ -n $DELETED_REMOTES ]] && print_separator

for repo in $DELETED_REMOTES; do
    local_repo=${repo#"$REMOTE"/}
    if [[ -n $(local_repo_exists "$local_repo") ]]; then
        # local repository with the same name as deleted remote repository found
        # try normal deletion at first (without the helpful hint if the command fails),
        # if it fails, check if all changes have been merged and delete forcefully
        git -c advice.forceDeleteBranch= branch --delete "$local_repo" || git-delete-merged-branch "$local_repo"
    fi
done

# delete local repo update cache file

rm "$REPO_STATUS_FILE" || echo "WARNING: Could not remove cache file $REPO_STATUS_FILE" >&2

EM='\033[0;32m' # Emphasis - green
NC='\033[0m'    # No Color

echo
echo -e "${EM}* * * Current Status * * *${NC}"
echo
git status
