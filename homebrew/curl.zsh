# Use Homebrew curl instead of system curl
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# For compilers to find curl
export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"

# For pkgconf to find curl
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"
