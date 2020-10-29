#!/bin/bash
# Update all repositories from origin, prune deleted remotes.
# Delete local repositories that match a deleted remote branch
# Update the current repository to match origin

# initialize

REPO_STATUS_FILE=/tmp/git-repo-fetch-status
LOCAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)
REMOTE_BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref @{u})

# update repositories
# skip if local cache already exists

if [[ -f "$REPO_STATUS_FILE" ]]; then
    echo "Repository status file $REPO_STATUS_FILE found - skipping update"
else
    git fetch --all --prune > "$REPO_STATUS_FILE" || {
        echo "ERROR: Fetch failed - check (and remove) status file $REPO_STATUS_FILE before trying again." >&2
        exit 1
    }
fi

cat "$REPO_STATUS_FILE"

# delete local repos if remote repository was deleted

DELETED_REMOTES=$(grep "\- \[deleted\]" $REPO_STATUS_FILE | sed 's/.* -> //')

for repo in $DELETED_REMOTES; do
    local_repo=$(basename $repo)
    if [[ -n $(git branch | grep "^ *$local_repo\$") ]]; then
        # local repository with the same name as deleted remote repository found
        git branch --delete "$local_repo"
    fi
done

# delete local repo update cache file

rm "$REPO_STATUS_FILE" || echo "WARNING: Could not remove cache file $REPO_STATUS_FILE" >&2

# update current repository to match origin

if [[ -n $REMOTE_BRANCH ]]; then
    git merge "$REMOTE_BRANCH"
else
    echo "No tracking branch - skipping update"
fi

git status
