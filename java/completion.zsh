compdef _jdk jdk

# zsh 5.9's bundled _java completion predates Java's source-file launcher: it
# completes main classes and jars, but not `java path/to/Main.java`. Keep the
# native completion and add Java source files while completing the launch
# target (rather than later arguments passed to the application).
_java_with_source() {
  local ret=1
  local word
  local -i expects_value=0
  local -i has_target=0
  local -i uses_jar_or_module=0

  _java "$@" && ret=0

  for word in "${words[@]:1:$((CURRENT - 2))}"; do
    if (( expects_value )); then
      expects_value=0
      continue
    fi

    case "$word" in
      -jar|-m|--module)
        uses_jar_or_module=1
        ;;
      -cp|-classpath|--class-path|-p|--module-path|--upgrade-module-path|--module-source-path|--add-modules|--limit-modules|--add-reads|--add-exports|--add-opens|--patch-module|--enable-native-access|--source)
        expects_value=1
        ;;
      --*=*|-*)
        ;;
      *)
        has_target=1
        ;;
    esac
  done

  if (( !expects_value && !has_target && !uses_jar_or_module )); then
    _files -g '*.java(-.)' && ret=0
  fi

  return ret
}

compdef _java_with_source java
