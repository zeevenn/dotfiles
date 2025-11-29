# Zinit plugin configurations
# Fast startup with deferred loading

# === External Tools ===

# git-open - Open repo in browser
zinit light paulirish/git-open

# === Zsh Enhancements ===

# Autosuggestions (deferred for faster startup)
zinit ice wait"0" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# Syntax highlighting (must be loaded after all other plugins, deferred)
zinit ice wait"0" lucid
zinit light zsh-users/zsh-syntax-highlighting

# === Optional: OMZ Plugins (without full OMZ) ===
# Uncomment to use specific OMZ plugins
# zinit ice wait"1" lucid
# zinit snippet OMZP::colored-man-pages

