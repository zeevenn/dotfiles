# React Native Android requires Java 17
# JAVA_HOME is set in java/java.zsh; this is just a safety check
if [[ -z "$JAVA_HOME" ]] && /usr/libexec/java_home -v 17 &>/dev/null; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17)
fi
