#!/usr/bin/env bash
#
# Install GitHub CLI extensions.

set -e

if ! command -v gh >/dev/null 2>&1; then
  echo "gh not installed, skipping GitHub CLI extensions"
  exit 0
fi

if gh extension list | awk '{ print $1 " " $2 }' | grep -qx "gh notify"; then
  echo "gh notify already installed"
else
  echo "Installing gh notify extension..."
  gh extension install meiji163/gh-notify
fi

