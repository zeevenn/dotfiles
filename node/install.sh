#!/bin/sh

# Install Node.js LTS
if ! fnm list | grep -q 'lts'; then
  echo "  Installing Node.js LTS..."
  fnm install --lts
fi

# Install global npm packages
if command -v npm > /dev/null 2>&1; then
  # PicGo CLI for image upload
  if ! command -v picgo > /dev/null 2>&1; then
    echo "  Installing picgo..."
    npm install -g picgo
  fi
fi

exit 0
