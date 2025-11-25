# uv (Python package manager) configuration
# Lazy load for faster shell startup

if command -v uv &> /dev/null; then
  # Lazy load uv and uvx
  uv() {
    unset -f uv uvx
    # uv is fast enough, no complex initialization needed
    command uv "$@"
  }
  
  uvx() {
    unset -f uv uvx
    command uvx "$@"
  }
fi

