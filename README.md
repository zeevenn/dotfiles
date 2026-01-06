# dotfiles

Mac setup for development. Inspired by [Zach Holman](https://github.com/holman)'s [dotfiles](https://github.com/holman/dotfiles).

## What's inside

- **Shell & Terminal**: Zsh (with Zinit plugin manager), Tmux, Ghostty terminal
- **Editor**: Neovim with complete configuration (Including LSP, Treesitter, Git integration, AI and etc.)
- **Basic Tools**: Git configuration and SSH setup
- **Development Tools**: Node.js, Python, Ruby, Docker, React Native
- **System**: macOS defaults, proxy configuration, useful commands and scripts

## Topical

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say,
"Java" — you can simply add a `java` directory and put files in there.

And some special filenames have special meanings:

- **bin/**: Anything in `bin/` will get added to your `$PATH`
- **topic/\*.zsh**: Any `.zsh` files get loaded into your environment
- **topic/path.zsh**: Loaded first to setup `$PATH`
- **topic/completion.zsh**: Loaded last to setup autocomplete
- **topic/\*.symlink**: Gets symlinked to `$HOME` (e.g., `gitconfig.symlink` → `~/.gitconfig`)
- **topic/install.sh**: Executed when you run `script/install`

## Quick Start

### Bootstrap

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the bootstrap script (setup configs and symlinks)
script/bootstrap

# Install dependencies
script/install

# Now restart shell
exec zsh
```

### Sync Dotfiles

If you want to sync your dotfiles with the latest version from the original repository, run `dot`,
you can find this script in `bin/`.

```bash
dot
```

## ZSH Plugins

Plugins are managed by [Zinit](https://github.com/zdharma-continuum/zinit) in `zsh/zinit.zsh`:

- `zsh-users/zsh-autosuggestions` - Command suggestions as you type
- `zsh-users/zsh-syntax-highlighting` - Syntax highlighting
- `paulirish/git-open` - Open repo in browser

Update plugins:

```bash
zinit update
```

## Customization

### Private Configuration

Sensitive data goes in `~/.localrc` (automatically sourced firstly, not tracked):

```bash
# ~/.localrc
export GITHUB_TOKEN="your_token"
export NPM_TOKEN="your_token"
```

### Add New Topics

Create a new directory (e.g., `rust/`) and add files:

- `rust/env.zsh` - Environment variables
- `rust/aliases.zsh` - Aliases
- `rust/path.zsh` - PATH additions
- `rust/cargo.symlink` - Symlink to `~/.cargo`

They'll be automatically loaded!

## License

MIT - see [LICENSE](LICENSE)
