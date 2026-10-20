# Prefer rustup's tools, including when Homebrew also provides Rust binaries.
typeset -U path
path=("${CARGO_HOME:-$HOME/.cargo}/bin" $path)
