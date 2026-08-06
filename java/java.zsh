# Java version management via /usr/libexec/java_home
# Installed JDKs live in /Library/Java/JavaVirtualMachines/

# Default to Java 17 (React Native)
if /usr/libexec/java_home -v 17 &>/dev/null; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17)
fi

# List installed JDKs and mark the one selected by JAVA_HOME.
_jdk_list() {
  local output line candidate_home
  local current_home="${JAVA_HOME:-$(/usr/libexec/java_home 2>/dev/null)}"
  local line_pattern='^[[:space:]]+[0-9]'
  local -i found_current=0

  output=$(/usr/libexec/java_home -V 2>&1) || return 1
  current_home="${current_home:A}"

  print -r -- 'Installed Java versions:'
  while IFS= read -r line; do
    [[ "$line" =~ $line_pattern ]] || continue
    line="${line#"${line%%[![:space:]]*}"}"
    candidate_home="${line##* }"

    if [[ "${candidate_home:A}" == "$current_home" ]]; then
      print -r -- "* $line [current]"
      found_current=1
    else
      print -r -- "  $line"
    fi
  done <<< "$output"

  if (( !found_current )); then
    print -r -- "* $current_home [current, not reported by java_home -V]"
  fi
}

# List or switch Java versions: jdk ls, jdk 17, jdk 21, jdk 8
jdk() {
  case "${1:-}" in
    ls|list)
      _jdk_list
      return
      ;;
    '')
      print -u2 'Usage: jdk <ls|list|version> (e.g. jdk ls, jdk 17, jdk 21, jdk 8)'
      return 1
      ;;
  esac

  local version=$1
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
  local -a commands versions
  commands=(
    'ls:list installed Java versions'
    'list:list installed Java versions'
  )
  versions=(${(f)"$(/usr/libexec/java_home -V 2>&1 | grep -oE '^\s+[0-9]+(\.[0-9]+)?' | awk '{v=$1; if(v~/^1\./) sub(/^1\./,"",v); else sub(/\..*/,"",v); print v}' | sort -un)"})

  _describe 'jdk command' commands
  _describe 'java version' versions
}
