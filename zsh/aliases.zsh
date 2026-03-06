alias reload='. ~/.zshrc'

alias cls='clear' # Good 'ol Clear Screen command

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias zshconfig='code ~/dotfiles'

# === Modern CLI tools (if installed via Brewfile) ===
# ls replacement with eza
if command -v eza &> /dev/null; then
  alias ls='eza'
  alias ll='eza -l'
  alias la='eza -la'
  alias lt='eza --tree'
fi

# cd replacement with zoxide (init is in zshrc.symlink at the end)
if command -v zoxide &> /dev/null; then
  alias cd='z'
fi
