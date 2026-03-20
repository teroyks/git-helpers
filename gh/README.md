# GitHub CLI

[`gh`](https://github.com/cli/cli) helpers.

## Code Completion

[`gh.fish`](./gh.fish) – some additions to the standard Fish shell autocompletions:

- `gh pr checkout <TAB>` – autocomplete open PR

## My Review Requests

```shell
gh search prs --review-requested @me --state open
```
