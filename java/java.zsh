# Java version management via /usr/libexec/java_home
# Installed JDKs live in /Library/Java/JavaVirtualMachines/

# Default to Java 17 (React Native)
if /usr/libexec/java_home -v 17 &>/dev/null; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17)
fi

# Switch Java version: jdk 17, jdk 21, jdk 8
jdk() {
  local version=${1:?"Usage: jdk <version> (e.g. jdk 17, jdk 21, jdk 8)"}
  # Java 8 and below use 1.x versioning
  [[ "$version" -le 8 ]] 2>/dev/null && version="1.${version}"
  # Verify the version actually exists (java_home returns highest if no match)
  if ! /usr/libexec/java_home -V 2>&1 | grep -q "^ *${version}"; then
    echo "Java $1 not found. Installed versions:"
    /usr/libexec/java_home -V
    return 1
  fi
  export JAVA_HOME=$(/usr/libexec/java_home -v "$version")
  echo "JAVA_HOME=$JAVA_HOME"
}

# Auto-switch when entering a directory with .java-version
_java_version_chpwd() {
  if [[ -f .java-version ]]; then
    local version
    version=$(<.java-version)
    [[ "$version" -le 8 ]] 2>/dev/null && version="1.${version}"
    if /usr/libexec/java_home -V 2>&1 | grep -q "^ *${version}"; then
      export JAVA_HOME=$(/usr/libexec/java_home -v "$version")
    fi
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _java_version_chpwd

# Tab completion for jdk function (registered in java/completion.zsh)
_jdk() {
  local versions
  versions=(${(f)"$(/usr/libexec/java_home -V 2>&1 | grep -oE '^\s+[0-9]+(\.[0-9]+)?' | awk '{v=$1; if(v~/^1\./) sub(/^1\./,"",v); else sub(/\..*/,"",v); print v}' | sort -un)"})
  _describe 'java version' versions
}
