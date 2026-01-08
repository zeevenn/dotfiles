# Use zsh's built-in git completion
# Ensure completion system is loaded
autoload -Uz compinit
compinit -i

# Make git aliases use git completion
# gsw -> git switch, gb -> git branch, etc.
compdef _git g='git'
compdef _git gsw=git-switch
compdef _git gco=git-checkout
compdef _git gb=git-branch
compdef _git gm=git-merge
compdef _git grb=git-rebase
