# Claude AI configuration
# Put your sensitive configuration in claude.local

# Source local configuration if it exists
if [[ -f "$HOME/.dotfiles/zsh/claude.local" ]]; then
  source "$HOME/.dotfiles/zsh/claude.local"
fi
