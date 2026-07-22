# Prefer zsh's native Git completion over Homebrew's Bash-completion wrapper.
# This must run before compinit so _git is registered from the native zsh path.
fpath=(${fpath:#/opt/homebrew/share/zsh/site-functions})
