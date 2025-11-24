#!/usr/bin/env bash

# dotfiles common helper function library

# Get dotfiles directory
get_dotfiles_dir() {
  local script_path="${BASH_SOURCE[1]}"
  local script_dir="$(cd "$(dirname "$script_path")" && pwd)"
  echo "$(cd "$script_dir/../.." && pwd)"
}

# Create symlink
link_file() {
  local src="$1"
  local dst="$2"
  
  # Ensure source file exists
  if [ ! -e "$src" ]; then
    echo "⚠️  Source file does not exist: $src"
    return 1
  fi
  
  # If target exists and is not a symlink, backup
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    local backup="${dst}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "⚠️  Backing up existing file: $dst -> $backup"
    mv "$dst" "$backup"
  fi
  
  # If already correct symlink, skip
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "✓   Symlink already exists: $dst"
    return 0
  fi
  
  # Create symlink
  echo "🔗 Creating symlink: $dst -> $src"
  ln -sf "$src" "$dst"
}

# Check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if macOS
is_macos() {
  [[ "$OSTYPE" == "darwin"* ]]
}

# Check if Linux
is_linux() {
  [[ "$OSTYPE" == "linux-gnu"* ]]
}

# Add path to PATH (if not exists)
add_to_path() {
  local path_to_add="$1"
  local shell_config="$2"
  
  if [ -z "$shell_config" ]; then
    # Auto-detect shell config file
    if [ -f "$HOME/.zshrc" ]; then
      shell_config="$HOME/.zshrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      shell_config="$HOME/.bash_profile"
    elif [ -f "$HOME/.bashrc" ]; then
      shell_config="$HOME/.bashrc"
    else
      echo "⚠️  Shell config file not found"
      return 1
    fi
  fi
  
  # Check if already in PATH
  if grep -q "$path_to_add" "$shell_config" 2>/dev/null; then
    echo "✓   PATH already contains: $path_to_add"
    return 0
  fi
  
  # Add to config file
  echo "export PATH=\"$path_to_add:\$PATH\"" >> "$shell_config"
  echo "✓   Added $path_to_add to PATH (in $(basename $shell_config))"
}

# Print colored messages
info() {
  echo "ℹ️  $1"
}

success() {
  echo "✅ $1"
}

warning() {
  echo "⚠️  $1"
}

error() {
  echo "❌ $1" >&2
}

# Ask user for confirmation
ask() {
  local prompt="$1"
  local default="${2:-n}"
  
  if [ "$default" = "y" ]; then
    local prompt_text="$prompt [Y/n]: "
  else
    local prompt_text="$prompt [y/N]: "
  fi
  
  read -p "$prompt_text" response
  response=${response:-$default}
  
  if [[ "$response" =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

