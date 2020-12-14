# Git Helpers

My helper scripts for using `git`.

There is no installation needed, you can just download the scripts and run them.

If you link the scripts somewhere on your path (without the `.sh` file extension) you can use them like native git commands, for example:

```shellsession
git update-local-repos
```

## [Update Local Repos](git-update-local-repos.sh)

- fetches all remotes for the current repository
- removes remote-tracking references that no longer exist on the remote
- merges tracking remote branch into current local branch
- removes local branches whose remote branch was deleted since previous fetch

## [Remove Orphan Branches](git-remove-orphan-branches.sh)

- removes local branches whose remote branch has been deleted
- very much a beta, use at own risk

### Print Only

If you use the `-p` command-line flag, the script prints out a list of local repos that would be deleted without actually deleting anything.

## Example

Example output of a repo update:

```shellsession
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
