#!/bin/sh

if ! fnm list | grep -q 'lts'; then
  fnm install --lts
fi

exit 0
