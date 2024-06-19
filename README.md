# Git Helpers

My helper scripts for using `git`.

There is no installation needed, you can just download the scripts and run them.

If you link the scripts somewhere on your path (without the `.sh` file extension) you can use them like native git commands, for example:

```shell
git update-local-repos
```

## [Update Local Repos](git-update-local-repos.sh)

- fetches all remotes for the current repository
- removes remote-tracking references that no longer exist on the remote
- merges tracking remote branch into current local branch
- removes local branches whose remote branch was deleted since previous fetch
- uses the ‘delete merged branch’ helper if available

## [Delete Merged Branch](git-delete-merged-branch.sh)

- force-deletes a local branch if it has been merged into the current branch
- checks actual diff between branches, not just the commit history

## [Rebase Remote Main Branch](git-rebase-remote-main.sh)

- use before pushing a branch to remote
- makes sure everything is up to date with the remote main branch
  - should work with any main branch (e.g. `main` or `master`)
- local workspace can be dirty (autostashes local changes)
  - you need to fix conflicts yourself, though
- as always after rebasing, push changes with [`--force-with-lease`](https://git-scm.com/docs/git-push#Documentation/git-push.txt---force-with-leaseltrefnamegt)

## [Remove Orphan Branches](git-remove-orphan-branches.sh)

- removes local branches whose remote branch has been deleted
- very much a beta, use at own risk

## [Reset Current Branch to Remote](git-reset-to-remote.sh)

- fetches the remote branch and resets the local branch to it
- handy when remote history has been rewritten
- use with caution, as it will discard all local changes

### Print Only

If you use the `-p` command-line flag, the script prints out a list of local repos that would be deleted without actually deleting anything.

## Example

Example output of a repo update:

```shell
$ git update-local-repos
Fetching origin
From my.git.server:project/myrepo
 - [deleted]             (none)     -> origin/some-other-branch
 - [deleted]             (none)     -> origin/another-feature-branch
 - [deleted]             (none)     -> origin/my-merged-feature
   06cfade85..072f1dd9e  master        -> origin/master
   2b1f19248..d8e6fc728  updated-dev-branch -> origin/updated-dev-branch
 * [new branch]          another-new-branch -> origin/another-new-branch

* * *

Updating 06cfade85..072f1dd9e
Fast-forward
 composer.json                                                                 |   3 +-
 composer.lock                                                                 | 407 ++++++++++++++++++-------------------
 docs/MyVeryFineFlowChart.puml                                                 |   7 +
 .../packages/lib/JustAnotherConfigurationFile.json                            |   6 +
 packages/vendor/Foo/Product/lib/ProductConfiguration.json                     |  10 +-
 5 files changed, 222 insertions(+), 211 deletions(-)

* * *

Deleted branch my-merged-feature (was 4d6a645a3).

* * * Current Status * * *

On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
```
