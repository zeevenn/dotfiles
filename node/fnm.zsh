# fnm (Fast Node Manager) configuration
# Lazy load fnm for faster shell startup

if command -v fnm &> /dev/null; then
  # Add fnm to PATH
  export PATH="$HOME/.local/share/fnm:$PATH"
  
  # Lazy load fnm
  # Only initialize when fnm/node/npm is actually called
  fnm() {
    unset -f fnm node npm npx
    eval "$(command fnm env --use-on-cd)"
    fnm "$@"
  }
  
  node() {
    unset -f fnm node npm npx
    eval "$(command fnm env --use-on-cd)"
    node "$@"
  }
  
  npm() {
    unset -f fnm node npm npx
    eval "$(command fnm env --use-on-cd)"
    npm "$@"
  }
  
  npx() {
    unset -f fnm node npm npx
    eval "$(command fnm env --use-on-cd)"
    npx "$@"
  }
fi

