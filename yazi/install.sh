#!/usr/bin/env bash
#
# Install yazi plugins and themes

set -e

if ! command -v ya &>/dev/null; then
  echo "yazi not installed, skipping yazi setup"
  exit 0
fi

echo "Installing yazi plugins and themes..."

ya pkg install

echo "yazi setup complete!"
