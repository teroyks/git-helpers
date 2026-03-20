# Additions to the default 'gh' completions

function __fish_gh_open_prs
    gh pr list --state open --json number,title | jello -rl '[f"{entry.number}\t{entry.title}" for entry in _]'
end

complete -c gh --exclusive --condition "__fish_seen_subcommand_from checkout" -a '(__fish_gh_open_prs)'
