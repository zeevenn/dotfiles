# Architecture

This document describes the design philosophy and structure of this dotfiles repository.

## Design Philosophy

### 1. Topical Organization

Everything is organized by topic (e.g., `git`, `node`, `python`). This makes it easy to:
- Find related configurations
- Add new topics
- Remove unused topics
- Understand what each part does

### 2. Fast Shell Startup

Speed is critical for developer productivity. We achieve fast startup through:

**Lazy Loading (Primary)**
- fnm, rbenv, uv are only initialized when first used
- Plugins loaded asynchronously with Zinit
- ~80% of speed improvement comes from this

**Minimal Plugin Usage**
- Only 3 Zinit plugins (autosuggestions, syntax highlighting, git-open)
- No heavy frameworks like Oh My Zsh
- Each plugin must justify its value

**Deferred Loading with Zinit**
- Plugins loaded after prompt appears
- User can start typing immediately
- Background loading completes in <1s

### 3. Secure by Default

Sensitive data never goes into version control:
- `*.local` files for machine-specific config
- `~/.localrc` for environment variables
- `.example` files as templates
- SSH keys never committed

### 4. Cross-Machine Sync

Easy to sync across multiple machines:
- Clone, bootstrap, done
- Brewfile for dependency management
- Minimal manual setup required

## Directory Structure

```
dotfiles/
├── bin/                    # Scripts in PATH
│   ├── dot                # Maintenance tool
│   └── git-*              # Git helper scripts
│
├── zsh/                   # Shell configuration
│   ├── zshrc.symlink     # Main config (→ ~/.zshrc)
│   ├── zinit.zsh         # Plugin configuration
│   ├── aliases.zsh       # Basic aliases
│   └── aliases-custom.zsh # Personal aliases
│
├── git/                   # Git configuration
│   ├── gitconfig.symlink # Main config (→ ~/.gitconfig)
│   └── gitignore.symlink # Global ignores (→ ~/.gitignore)
│
├── node/                  # Node.js ecosystem
│   ├── fnm.zsh           # Node version manager (lazy)
│   ├── npm.zsh           # npm aliases
│   ├── yarn.zsh          # Yarn aliases
│   └── npmrc.symlink     # npm config (→ ~/.npmrc)
│
├── python/                # Python development
│   ├── uv.zsh            # uv package manager (lazy)
│   └── aliases.zsh       # Python aliases
│
├── ruby/                  # Ruby development
│   └── rbenv.zsh         # rbenv manager (lazy)
│
├── react-native/          # Mobile development
│   └── aliases.zsh       # iOS/Android shortcuts
│
├── android/               # Android SDK
│   └── env.zsh           # ANDROID_HOME, paths
│
├── java/                  # Java environment
│   └── env.zsh           # JAVA_HOME
│
├── ssh/                   # SSH configuration
│   ├── config.symlink    # SSH config (→ ~/.ssh/config)
│   └── README.md         # Key setup guide
│
├── proxy/                 # Proxy settings
│   └── env.zsh           # Proxy toggle functions
│
├── macos/                 # macOS settings
│   └── set-defaults.sh   # System preferences
│
├── script/                # Installation scripts
│   ├── bootstrap         # Initial setup
│   └── install           # Install dependencies
│
├── Brewfile              # Homebrew dependencies
├── .gitignore            # Ignored files
└── README.md             # User documentation
```

## File Naming Conventions

### `.zsh` Files

Loaded automatically in this order:

1. **`*/path.zsh`** - First
   - Set up PATH
   - Must be fast
   - No external commands

2. **`*/*.zsh`** - Middle (except path, completion, zinit)
   - Aliases
   - Functions
   - Environment variables

3. **`*/completion.zsh`** - Last
   - Tab completion setup
   - Loaded after compinit

4. **`*/zinit.zsh`** - Special
   - Manually loaded before everything
   - Plugin configuration

### `.symlink` Files

Automatically symlinked to `$HOME`:
- `gitconfig.symlink` → `~/.gitconfig`
- `npmrc.symlink` → `~/.npmrc`
- `zshrc.symlink` → `~/.zshrc`

### `.sh` Files

Shell scripts (not auto-loaded):
- `install.sh` - Run by `script/install`
- `set-defaults.sh` - Run manually

## Script Responsibilities

### `script/bootstrap`

**Purpose**: Initial setup for a new machine

**What it does**:
1. Install Zinit
2. Set up git configuration (prompt for name/email)
3. Create all symlinks (*.symlink → $HOME)
4. Install Homebrew (macOS)
5. Run `bin/dot` for dependencies

**When to run**: Once per machine, or after major changes

### `script/install`

**Purpose**: Install/update dependencies

**What it does**:
1. Run `brew bundle` (install Brewfile dependencies)
2. Run all `*/install.sh` scripts in topics

**When to run**: After updating Brewfile, or manually

### `bin/dot`

**Purpose**: Daily maintenance tool

**Commands**:
- `dot` - Update everything (Homebrew, Zinit, dotfiles)
- `dot sync` - Sync dotfiles from git
- `dot update` - Update dependencies

**When to run**: Regularly (weekly/monthly)

## Plugin Management with Zinit

### Why Zinit?

- **Fast**: Asynchronous loading, compiled scripts
- **Modern**: Active development, good documentation
- **Powerful**: Turbo mode, snippets, ice modifiers
- **Popular**: Large community, many examples

### Plugin Loading Strategy

```zsh
# Immediate load (startup required)
zinit light paulirish/git-open

# Deferred load (non-critical)
zinit ice wait"0" lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"0" lucid
zinit light zsh-users/zsh-syntax-highlighting
```

**wait"0"**: Load after prompt appears (0 seconds)
**lucid**: Suppress loading messages

### Adding New Plugins

Edit `zsh/zinit.zsh`:

```zsh
# From GitHub (user/repo)
zinit light username/plugin-name

# With deferred loading
zinit ice wait"1" lucid
zinit light username/another-plugin

# From OMZ (without full OMZ)
zinit snippet OMZP::plugin-name
```

## Lazy Loading Pattern

Many tools are slow to initialize. We lazy load them:

### Before (Slow)

```zsh
# Runs on every shell startup (~200ms)
eval "$(fnm env)"
```

### After (Fast)

```zsh
# Only runs when 'fnm' is first called
fnm() {
  unset -f fnm node npm
  eval "$(command fnm env)"
  fnm "$@"
}
```

**Benefit**: Shell starts in ~10ms instead of ~210ms

### Tools Using Lazy Loading

- fnm (Node version manager)
- rbenv (Ruby version manager)
- uv (Python package manager)

## Sensitive Data Flow

```
Public Configs          Private Configs
(in git)               (not in git)

gitconfig.symlink  →   gitconfig.local.symlink
                       (name, email, tokens)

npmrc.symlink      →   npmrc.local
                       (auth tokens)

zshrc.symlink      →   ~/.localrc
                       (env vars, secrets)
```

**Rule**: Public config `[include]`s private config

**Example**:
```gitconfig
# gitconfig.symlink (public)
[include]
  path = ~/.gitconfig.local

# gitconfig.local.symlink (private, in .gitignore)
[user]
  name = Your Name
  email = your@email.com
```

## Adding New Topics

1. **Create directory**: `mkdir newtopic/`

2. **Add files**:
   ```
   newtopic/
   ├── env.zsh           # Environment variables
   ├── aliases.zsh       # Aliases
   ├── path.zsh          # PATH modifications
   └── config.symlink    # Config file
   ```

3. **That's it!** Files are auto-loaded by naming convention

## Testing

### Test Shell Startup Speed

```bash
# Measure startup time
time zsh -i -c exit

# Profile what's slow
zsh -xv 2>&1 | ts -i "%.s" | tee /tmp/zsh-profile.log
```

### Test Specific Topic

```bash
# Source just one file
source ~/.dotfiles/node/fnm.zsh

# Test function
fnm --version
```

### Test Symlinks

```bash
# Check if symlink exists and points correctly
ls -la ~ | grep ".gitconfig"
# Should show: .gitconfig -> /Users/you/.dotfiles/git/gitconfig.symlink
```

## Performance Targets

| Metric | Target | Current |
|--------|--------|---------|
| Shell startup | <300ms | ~200ms ✅ |
| First command | <500ms | ~400ms ✅ |
| Zinit update | <30s | ~20s ✅ |
| brew update | <60s | ~45s ✅ |

## Common Patterns

### Environment Variables

```zsh
# topic/env.zsh
export MY_VAR="value"
export PATH="$HOME/.mybin:$PATH"
```

### Aliases

```zsh
# topic/aliases.zsh
alias shortcut='long command'
```

### Conditional Loading

```zsh
# topic/tool.zsh
if command -v tool &> /dev/null; then
  # Configure tool
fi
```

### PATH Setup

```zsh
# topic/path.zsh
export PATH="$HOME/.mytool/bin:$PATH"
```

## Migration from Oh My Zsh

If migrating from OMZ:

1. **Keep**: OMZ plugins as Zinit plugins
   ```zsh
   # Instead of: plugins=(git docker)
   # Use:
   zinit snippet OMZP::git
   zinit snippet OMZP::docker
   ```

2. **Replace**: OMZ framework with Zinit
   - Faster
   - More control
   - Still compatible with OMZ plugins

3. **Review**: Aliases you actually use
   - OMZ has 100+ aliases per plugin
   - You probably use <10
   - Copy only what you need

## Troubleshooting

### Shell is slow

1. Profile startup: `zsh -xv 2>&1 | less`
2. Check for non-lazy-loaded tools
3. Remove unused plugins

### Command not found

1. Check PATH: `echo $PATH`
2. Check if file is executable: `ls -la ~/.dotfiles/bin/`
3. Reload shell: `source ~/.zshrc`

### Symlink not created

1. Check for existing file: `ls -la ~/.<name>`
2. Remove old file: `rm ~/.<name>`
3. Re-run bootstrap: `script/bootstrap`

## Future Improvements

- [ ] Add automated testing
- [ ] Add update notifications
- [ ] Add plugin auto-cleanup
- [ ] Add topic templates
- [ ] Add dotfiles doctor command

## References

- [Holman dotfiles](https://github.com/holman/dotfiles) - Original inspiration
- [Zinit docs](https://github.com/zdharma-continuum/zinit) - Plugin manager
- [Zsh guide](http://zsh.sourceforge.net/Guide/) - Shell documentation

