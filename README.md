# dotfiles

My personal dotfiles for macOS development. Optimized for fast shell startup and efficient development workflow.

Inspired by [Zach Holman](https://github.com/holman)'s [dotfiles](https://github.com/holman/dotfiles).

## Features

- 🚀 **Fast Shell Startup** - ~0.2s with Zinit and lazy loading
- 🎯 **Topical Organization** - Everything organized by topic (git, node, python, etc.)
- 🔌 **Plugin Management** - Zinit for modern Zsh plugin management
- 🛠️ **Complete Dev Stack** - Node.js, Python, React Native, Ruby, and more
- 🔒 **Secure** - Sensitive data kept out of version control
- 🔄 **Easy Sync** - Sync your configuration across multiple machines

## Quick Start

### Install

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the bootstrap script
script/bootstrap
```

This will:
1. Install Zinit (Zsh plugin manager)
2. Create symlinks for all `.symlink` files to your home directory
3. Set up git configuration (will prompt for name and email)

### Install Dependencies

```bash
# Install Homebrew packages and casks
brew bundle

# Or use the included script
script/install
```

## What's Inside

### Core

- **zsh/** - Shell configuration with Zinit plugins
  - Fast startup with lazy loading
  - Modern completions and syntax highlighting
  - Custom aliases and functions
- **git/** - Git configuration and aliases
- **bin/** - Useful scripts and tools

### Development Tools

- **node/** - Node.js, npm, yarn, pnpm configuration
  - fnm for fast Node version management
  - Package manager aliases
- **python/** - Python and uv configuration
- **ruby/** - Ruby and rbenv configuration (lazy loaded)

### Mobile Development

- **react-native/** - React Native shortcuts and aliases
- **android/** - Android SDK environment
- **java/** - Java environment setup
- **xcode/** - Xcode and iOS development

### System

- **macos/** - macOS system defaults
- **ssh/** - SSH configuration
- **proxy/** - Proxy settings with easy toggle
- **homebrew/** - Homebrew installation and configuration

## Structure

### Special Files

- **bin/**: Anything in `bin/` will get added to your `$PATH`
- **topic/\*.zsh**: Any `.zsh` files get loaded into your environment
- **topic/path.zsh**: Loaded first to setup `$PATH`
- **topic/completion.zsh**: Loaded last to setup autocomplete
- **topic/\*.symlink**: Gets symlinked to `$HOME` (e.g., `gitconfig.symlink` → `~/.gitconfig`)
- **topic/install.sh**: Executed when you run `script/install`

### Zinit Plugins

Plugins are managed by [Zinit](https://github.com/zdharma-continuum/zinit) in `zsh/zinit.zsh`:

- `zsh-users/zsh-autosuggestions` - Command suggestions as you type
- `zsh-users/zsh-syntax-highlighting` - Syntax highlighting
- `paulirish/git-open` - Open repo in browser

Update plugins:

```bash
zinit update
```

## Customization

### Add Your Own Aliases

Edit `zsh/aliases-custom.zsh`:

```bash
alias myproject='cd ~/Projects/myproject'
alias deploy='./scripts/deploy.sh'
```

### Private Configuration

Sensitive data goes in `~/.localrc` (automatically sourced, not tracked):

```bash
# ~/.localrc
export GITHUB_TOKEN="your_token"
export NPM_TOKEN="your_token"
```

See [SENSITIVE_DATA.md](SENSITIVE_DATA.md) for more details.

### Add New Topics

Create a new directory (e.g., `rust/`) and add files:

- `rust/env.zsh` - Environment variables
- `rust/aliases.zsh` - Aliases
- `rust/path.zsh` - PATH additions
- `rust/cargo.symlink` - Symlink to `~/.cargo`

They'll be automatically loaded!

## Maintenance

### Daily Update

```bash
dot
```

This will:
- Update Homebrew and packages
- Update Zinit plugins
- Update dotfiles from git

### Manual Commands

```bash
# Update Zinit plugins only
zinit update

# Update Homebrew
brew update && brew upgrade

# Update dotfiles
cd ~/.dotfiles && git pull
```

## Key Commands

### Shell

- `reload` - Reload shell configuration
- `..` / `...` - Navigate up directories
- `gs`, `ga`, `gc`, `gp`, `gl` - Git shortcuts

### React Native

- `ios` - Open iOS Simulator
- `rnios` - Run on iOS
- `rnandroid` - Run on Android
- `metro` - Start Metro bundler
- `pod` - Install iOS dependencies

### Tools

- `ls`, `ll`, `la` - Enhanced with `eza`
- `cd` - Enhanced with `zoxide` (smart jumps)

## Performance

Shell startup comparison:

| Configuration | Startup Time |
|---------------|--------------|
| Oh My Zsh     | ~1.5s        |
| This setup    | ~0.2s ⚡     |

Improvements from:
- Zinit with deferred loading (80%)
- Lazy loading fnm, rbenv, etc. (15%)
- Minimal plugin usage (5%)

## Troubleshooting

### Shell is slow

```bash
# Check what's taking time
time zsh -i -c exit

# Profile startup
zsh -xv 2>&1 | less
```

### Zinit not found

```bash
# Reinstall Zinit
cd ~/.dotfiles
script/bootstrap
```

### Plugins not working

```bash
# Reinstall plugins
zinit delete --all
zinit update
```

## Credits

- [Zach Holman](https://github.com/holman) - Original dotfiles structure
- [Zinit](https://github.com/zdharma-continuum/zinit) - Plugin manager
- [Holman dotfiles](https://github.com/holman/dotfiles) - Inspiration

## License

MIT - see [LICENSE](LICENSE)
