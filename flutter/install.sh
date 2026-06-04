#!/bin/sh

if command -v brew >/dev/null 2>&1; then
  brew tap leoafarias/fvm 2>/dev/null || true
  brew install fvm 2>/dev/null || true
fi

exit 0
