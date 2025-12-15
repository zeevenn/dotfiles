# Uses git's autocompletion for inner commands. Assumes an install of git's
# bash `git-completion` script at $completion below (this is where Homebrew
# tosses it, at least).
completion='$(brew --prefix)/share/zsh/site-functions/_git'

if test -f $completion
then
  source $completion
fi

# Make git aliases use git completion
# gsw -> git switch, gb -> git branch, etc.
compdef _git gsw=git-switch
compdef _git gco=git-checkout
compdef _git gb=git-branch
compdef _git gm=git-merge
compdef _git grb=git-rebase
