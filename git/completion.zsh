# Use zsh's built-in git completion (not bash-completion wrapper)
# Remove Homebrew's bash-completion-based _git from fpath
fpath=(${fpath:#/opt/homebrew/share/zsh/site-functions})

# Make git aliases use git completion
# gsw -> git switch, gb -> git branch, etc.
compdef _git g='git'
compdef _git gsw=git-switch
compdef _git gco=git-checkout
compdef _git gb=git-branch
compdef _git gm=git-merge
compdef _git grb=git-rebase
