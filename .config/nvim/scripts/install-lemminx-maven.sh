#!/usr/bin/env bash
set -euo pipefail

# The Maven extension ships with LemMinX 0.30.1; keep the server versions aligned.
maven_version=0.12.0
server_version=0.30.1
destination="${1:-${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lemminx-maven/$maven_version}"
repository=https://repo.eclipse.org/content/repositories/lemminx-releases/org/eclipse/lemminx
ready="$destination/.ready-$server_version"
if [[ -f "$ready" && -s "$destination/server.jar" && -s "$destination/lib/lemminx-maven-$maven_version.jar" ]]; then
  printf 'LemMinX Maven %s is already installed at %s\n' "$maven_version" "$destination"
  exit 0
fi
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT

curl --fail --location --retry 2 --connect-timeout 15 --max-time 180 --silent --show-error \
  "$repository/lemminx-maven/$maven_version/lemminx-maven-$maven_version-zip-with-dependencies.zip" \
  --output "$temporary/maven.zip"
curl --fail --location --retry 2 --connect-timeout 15 --max-time 180 --silent --show-error \
  "$repository/org.eclipse.lemminx/$server_version/org.eclipse.lemminx-$server_version-uber.jar" \
  --output "$temporary/server.jar"

# Validate downloads before publishing them; mark ready only after all jars exist.
mkdir -p "$temporary/lib"
unzip -oq "$temporary/maven.zip" -d "$temporary/lib"
test -s "$temporary/lib/lemminx-maven-$maven_version.jar"
unzip -tq "$temporary/server.jar" >/dev/null
mkdir -p "$destination/lib"
mv -f "$temporary/lib/"* "$destination/lib/"
mv "$temporary/server.jar" "$destination/server.jar"
touch "$ready"
printf 'Installed LemMinX Maven %s at %s\n' "$maven_version" "$destination"
