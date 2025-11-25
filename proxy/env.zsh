# Proxy configuration
# Uncomment and configure if behind corporate proxy

# HTTP/HTTPS Proxy
# export HTTP_PROXY="http://proxy.company.com:8080"
# export HTTPS_PROXY="http://proxy.company.com:8080"
# export http_proxy="$HTTP_PROXY"
# export https_proxy="$HTTPS_PROXY"

# No proxy for local addresses
# export NO_PROXY="localhost,127.0.0.1,*.local"
# export no_proxy="$NO_PROXY"

# Proxy functions for easy toggle
proxy_on() {
  export HTTP_PROXY="http://proxy.company.com:8080"
  export HTTPS_PROXY="http://proxy.company.com:8080"
  export http_proxy="$HTTP_PROXY"
  export https_proxy="$HTTPS_PROXY"
  export NO_PROXY="localhost,127.0.0.1,*.local"
  export no_proxy="$NO_PROXY"
  echo "✓ Proxy enabled"
}

proxy_off() {
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset http_proxy
  unset https_proxy
  unset NO_PROXY
  unset no_proxy
  echo "✓ Proxy disabled"
}

proxy_status() {
  if [ -n "$HTTP_PROXY" ]; then
    echo "Proxy: $HTTP_PROXY"
  else
    echo "Proxy: disabled"
  fi
}

