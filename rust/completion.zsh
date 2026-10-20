# Loaded after compinit by zshrc.
if command -v rustup >/dev/null 2>&1; then
  eval "$(rustup completions zsh)"
  compdef _rustup rustup

  # Cargo's script invokes _cargo itself, so load it inside a completion call.
  _cargo() {
    eval "$(rustup completions zsh cargo)"
  }
  compdef _cargo cargo
fi
