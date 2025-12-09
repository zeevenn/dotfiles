#!/bin/sh
#
# Install React Native iOS dependencies

# CocoaPods - iOS dependency manager
if ! command -v pod &> /dev/null; then
  echo "  Installing CocoaPods..."
  gem install cocoapods
fi
