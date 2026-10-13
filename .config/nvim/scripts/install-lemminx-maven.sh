#!/usr/bin/env bash
set -euo pipefail

# The Maven extension ships with LemMinX 0.30.1; keep the server versions aligned.
maven_version=0.12.0
server_version=0.30.1
destination="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lemminx-maven/$maven_version"
repository=https://repo.eclipse.org/content/repositories/lemminx-releases/org/eclipse/lemminx
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT

curl --fail --location --retry 2 --silent --show-error \
  "$repository/lemminx-maven/$maven_version/lemminx-maven-$maven_version-zip-with-dependencies.zip" \
  --output "$temporary/maven.zip"
curl --fail --location --retry 2 --silent --show-error \
  "$repository/org.eclipse.lemminx/$server_version/org.eclipse.lemminx-$server_version-uber.jar" \
  --output "$temporary/server.jar"

mkdir -p "$destination/lib"
unzip -oq "$temporary/maven.zip" -d "$destination/lib"
mv "$temporary/server.jar" "$destination/server.jar"
printf 'Installed LemMinX Maven %s at %s\n' "$maven_version" "$destination"
