# Node.js PATH configuration

# Add global npm binaries to PATH
export PATH="$HOME/.npm-global/bin:$PATH"

# pnpm global bin path
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Yarn global bin path
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
