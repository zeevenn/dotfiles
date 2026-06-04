#!/bin/sh

if command -v brew >/dev/null 2>&1; then
  brew install watchman 2>/dev/null || true
fi

exit 0
