#!/usr/bin/env bash
#
# Install JDKs via Homebrew with interactive vendor/version selection.

set -e

if ! command -v brew &>/dev/null; then
  echo "  Homebrew not found, skipping Java installation"
  exit 0
fi

VENDORS=(
  "zulu           (Azul, popular for macOS/ARM)"
  "temurin        (Eclipse Adoptium, community)"
  "corretto       (Amazon)"
  "oracle-jdk     (Oracle, commercial)"
  "microsoft-openjdk (Microsoft)"
  "graalvm-jdk    (Oracle GraalVM, native-image)"
  "semeru-jdk-open (IBM OpenJ9)"
  "sapmachine-jdk (SAP)"
)
VERSIONS=(8 11 17 21 25)

# Interactive mode with gum
if [[ -t 0 ]] && command -v gum &>/dev/null; then
  selected_vendors=$(gum choose --no-limit --header="Select JDK vendors:" "${VENDORS[@]}") || true
  [[ -z "$selected_vendors" ]] && echo "  No vendor selected, skipping" && exit 0

  selected_versions=$(gum choose --no-limit --header="Select Java versions:" "${VERSIONS[@]}") || true
  [[ -z "$selected_versions" ]] && echo "  No version selected, skipping" && exit 0

  # Install selected combinations
  while IFS= read -r vendor_line; do
    vendor=$(echo "$vendor_line" | awk '{print $1}')
    while IFS= read -r version; do
      cask="${vendor}@${version}"
      if brew info --cask "$cask" &>/dev/null; then
        echo "  Installing $cask..."
        brew install --cask "$cask" 2>/dev/null || true
      else
        echo "  $cask not available, skipping"
      fi
    done <<< "$selected_versions"
  done <<< "$selected_vendors"

  # Set default version
  mapfile -t version_arr <<< "$selected_versions"
  default_version=$(gum choose --header="Set default JAVA_HOME version:" "${version_arr[@]}") || true
  if [[ -n "$default_version" ]] && /usr/libexec/java_home -v "$default_version" &>/dev/null; then
    echo "  Default: Java $default_version"
  fi
else
  # Non-interactive fallback: install common defaults
  brew install --cask zulu@17 2>/dev/null || true
  brew install --cask temurin@21 2>/dev/null || true
fi

exit 0
