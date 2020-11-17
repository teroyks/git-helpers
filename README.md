# Git Helpers

My helper scripts for using `git`.

There is no installation needed, you can just download the scripts and run them.

## Update Local Repos

- fetches all remotes for the current repository
- removes remote-tracking references that no longer exist on the remote
- merges tracking remote branch into current local branch
- removes local branches whose remote branch was deleted since previous fetch

## Remove Orphan Branches

- removes local branches whose remote branch has been deleted

### Print Only

If you use the `-p` command-line flag, the script prints out a list of local repos that would be deleted without actually deleting anything.
