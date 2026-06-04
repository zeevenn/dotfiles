#!/bin/sh
if ! command -v starship > /dev/null 2>&1; then
  echo "  Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi
