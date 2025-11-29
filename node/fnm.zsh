# fnm(Fast Node Manager) configuration
# see: https://github.com/Schniz/fnm

if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
fi
