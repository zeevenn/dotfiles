#!/bin/sh

if ! fnm list | grep -q 'lts'; then
  echo "  Installing Node.js LTS..."
  fnm install --lts
fi

exit 0
