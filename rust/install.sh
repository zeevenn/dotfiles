#!/usr/bin/env bash
# Install Rust through rustup; shell configuration is managed by dotfiles.
set -euo pipefail

if [[ "$(uname -s)" == Darwin ]] && ! xcode-select -p >/dev/null 2>&1; then
  echo "  Install Apple's command line tools first: xcode-select --install" >&2
  exit 1
fi

export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"

if ! command -v rustup >/dev/null 2>&1; then
  echo "  Installing rustup and Rust stable..."
  curl --proto '=https' --tlsv1.2 -fsS https://sh.rustup.rs |
    sh -s -- -y --no-modify-path --profile minimal --default-toolchain stable
elif ! rustup run stable rustc --version >/dev/null 2>&1; then
  rustup toolchain install stable --profile minimal
fi

# Preserve an existing default toolchain (including nightly or a pinned version).
if ! rustup default >/dev/null 2>&1; then
  rustup default stable
fi

# rust-src provides standard library sources for rust-analyzer.
rustup component add --toolchain stable rustfmt clippy rust-src rust-analyzer

echo "  Rust stable is ready. Open a new shell to load PATH and completions."
