#!/bin/sh
set -e

# --- Install Ruby via rbenv if needed ---
if command -v rbenv &> /dev/null; then
  # Check if has rbenv ruby
  RBENV_HAS_VERSION=$(rbenv versions --bare)
  if [ -z "$RBENV_HAS_VERSION" ]; then
    # Get latest Ruby version
    RUBY_VERSION=$(rbenv install -l | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | tail -1)
    echo "Installing latest Ruby version: $RUBY_VERSION via rbenv..."
    rbenv install --skip-existing $RUBY_VERSION
    rbenv global $RUBY_VERSION
    rbenv rehash
  else
    echo "rbenv Ruby version already exists, skipping installation."
  fi
else
  echo "rbenv not found, will use system Ruby."
fi

# --- Install CocoaPods ---
if ! command -v pod &> /dev/null; then
  echo "Installing CocoaPods..."
  gem install cocoapods
  # If using rbenv, rehash
  [ -n "$RBENV_HAS_VERSION" ] && rbenv rehash
fi

echo "CocoaPods version: $(pod --version)"
