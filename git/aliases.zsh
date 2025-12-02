# The rest of my fun git aliases
alias g='git'
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gf='git fetch'
alias gp='git push origin HEAD'

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'

alias ga='git add'
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -a -m'
alias gco='git checkout'
alias gcl='git clone'
alias gcp='git cherry-pick'
alias gb='git branch'
alias gst='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias ge='git-edit-new'
alias gsw='git switch'
alias gm='git merge'
alias gr='git rebase'
alias gsh='git stash'
alias gshp='git stash pop'
alias gshl='git stash list'
alias gsha='git stash apply'
