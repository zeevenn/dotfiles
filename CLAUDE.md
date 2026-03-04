# Dotfiles

Personal dotfiles for macOS.

## Structure

- `.config/` - XDG configs (nvim, tmux, ghostty, etc.) → symlinked to `~/.config/`
- `.ssh/` - SSH config → symlinked to `~/.ssh/`
- `topic/*.zsh` - Shell configs auto-loaded by zsh
- `topic/*.symlink` - Symlinked to `$HOME`
- `topic/install.sh` - Run by `script/install`
- `bin/` - Added to `$PATH`

## Neovim (LazyVim)

This config is based on [LazyVim](https://github.com/LazyVim/LazyVim).

### Key Locations

- User config: `.config/nvim/lua/`
  - `config/` - options, keymaps, autocmds
  - `plugins/` - plugin overrides and additions
- **LazyVim source code** (for reference): `~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/`
  - `plugins/` - default plugin specs
  - `util/` - utility modules (format, lsp, etc.)
  - `config/` - default keymaps, autocmds, options

### When Editing Neovim Config

**Always check LazyVim source** at `~/.local/share/nvim/lazy/LazyVim/` to understand:

- Default values and behaviors
- Available options for plugin specs
- Utility functions like `LazyVim.lsp`, `LazyVim.format`

### Installed Plugins Location

All lazy.nvim managed plugins: `~/.local/share/nvim/lazy/`
