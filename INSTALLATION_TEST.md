# Installation Test Checklist

This document provides a checklist for testing the dotfiles installation.

## ✅ Pre-Installation Checklist

Before running `script/bootstrap`:

- [ ] Repository cloned to `~/.dotfiles`
- [ ] Backup existing dotfiles: `~/.zshrc`, `~/.gitconfig`, etc.
- [ ] Homebrew installed (or will be installed by bootstrap)

## ✅ Installation Steps

### 1. Run Bootstrap

```bash
cd ~/.dotfiles
script/bootstrap
```

**Expected output:**
- ✓ Installing Zinit
- ✓ Setup gitconfig (prompts for name/email)
- ✓ Linked multiple .symlink files to $HOME
- ✓ Installing dependencies (runs bin/dot)

**Verify:**
- [ ] `~/.zshrc` is a symlink to `~/.dotfiles/zsh/zshrc.symlink`
- [ ] `~/.gitconfig` is a symlink to `~/.dotfiles/git/gitconfig.symlink`
- [ ] `~/.local/share/zinit/zinit.git` exists

### 2. Install Dependencies

```bash
script/install
# or
brew bundle
```

**Verify:**
- [ ] New tools installed: `fnm`, `zoxide`, `fzf`, `eza`, `watchman`
- [ ] Check with: `which fnm zoxide fzf eza watchman`

### 3. Restart Shell

```bash
exec zsh
# or open a new terminal
```

## ✅ Functional Tests

### Shell Performance

```bash
# Test startup time (should be < 0.3s)
time zsh -i -c exit
```

**Expected:** ~0.2-0.3 seconds

### Zinit Plugins

```bash
# Check if plugins are loaded
zinit list
```

**Expected output:**
- zsh-users/zsh-autosuggestions
- zsh-users/zsh-syntax-highlighting
- paulirish/git-open

### Basic Aliases

```bash
# Git aliases
gs     # Should run 'git status'
ga     # Should run 'git add'
gc     # Should run 'git commit'

# Navigation
..     # Should cd up one level
ll     # Should list files with details
```

### Tool Integrations

```bash
# fnm (Node.js)
fnm --version

# zoxide (smart cd)
z --version

# fzf (fuzzy finder)
fzf --version

# eza (better ls)
eza --version
```

### Git Configuration

```bash
# Check git config
git config --get user.name
git config --get user.email

# Should show your name and email
```

### React Native Setup (if applicable)

```bash
# iOS Simulator
ios      # Should open iOS Simulator

# Android
echo $ANDROID_HOME    # Should show Android SDK path
adb --version         # Should work if Android SDK installed
```

### Python Setup

```bash
# Python
python --version
py --version     # Alias

# uv (if installed)
uv --version
```

### Node.js Setup

```bash
# fnm
fnm --version

# Install a Node version
fnm install 20
fnm use 20
node --version

# npm aliases
ni     # Should be 'npm install'
nr     # Should be 'npm run'
```

## ✅ Configuration Tests

### Local Configuration

```bash
# Create ~/.localrc for sensitive data
cat > ~/.localrc << 'EOF'
export TEST_VAR="test_value"
EOF

# Reload shell
source ~/.zshrc

# Test
echo $TEST_VAR    # Should output: test_value
```

### Git Local Configuration

```bash
# Check if gitconfig.local exists
ls -la ~/.gitconfig.local

# Should be created by bootstrap script
```

### SSH Configuration

```bash
# Check SSH config
ls -la ~/.ssh/config

# Should be a symlink to ~/.dotfiles/ssh/config.symlink
```

## ✅ Performance Benchmarks

### Startup Time Comparison

| Configuration | Expected Time |
|---------------|---------------|
| This setup    | ~0.2-0.3s     |
| Oh My Zsh     | ~1.0-2.0s     |

```bash
# Measure startup time
time zsh -i -c exit
```

### Plugin Loading

```bash
# Should see plugins loading asynchronously
# Type immediately after opening terminal - should work without delay
```

## ✅ Update Tests

### Update Zinit Plugins

```bash
zinit update
```

**Expected:**
- Updates all plugins
- Shows what changed

### Update Homebrew

```bash
brew update
brew upgrade
```

**Expected:**
- Updates formulas
- Upgrades installed packages

### Update Dotfiles

```bash
cd ~/.dotfiles
git pull
source ~/.zshrc
```

**Expected:**
- Latest changes applied
- No errors on reload

## ✅ Troubleshooting Tests

### If Zinit Not Found

```bash
# Check if Zinit installed
ls -la ~/.local/share/zinit/

# Reinstall
script/bootstrap
```

### If Plugins Not Loading

```bash
# Remove and reinstall
zinit delete --all
zinit update
```

### If Aliases Not Working

```bash
# Check if zshrc is sourced
source ~/.zshrc

# Check if file exists
ls -la ~/.dotfiles/zsh/aliases-custom.zsh
```

## 📋 Complete Module Checklist

Verify all modules are present and working:

- [ ] **zsh/** - Shell configuration
  - [ ] zshrc.symlink exists and is linked
  - [ ] zinit.zsh loads plugins
  - [ ] aliases-custom.zsh works
  
- [ ] **git/** - Git configuration
  - [ ] gitconfig.symlink is linked
  - [ ] git aliases work (`gs`, `ga`, etc.)
  
- [ ] **node/** - Node.js ecosystem
  - [ ] fnm lazy loads
  - [ ] npm aliases work
  - [ ] npmrc.symlink is linked
  
- [ ] **python/** - Python development
  - [ ] Python aliases work
  - [ ] uv lazy loads (if installed)
  
- [ ] **ruby/** - Ruby development
  - [ ] rbenv lazy loads (if installed)
  
- [ ] **react-native/** - Mobile development
  - [ ] iOS aliases work
  - [ ] Android aliases work
  
- [ ] **android/** - Android SDK
  - [ ] ANDROID_HOME set
  - [ ] adb in PATH
  
- [ ] **java/** - Java environment
  - [ ] JAVA_HOME set
  
- [ ] **ssh/** - SSH configuration
  - [ ] config.symlink is linked
  - [ ] README.md exists
  
- [ ] **proxy/** - Proxy settings
  - [ ] proxy_on/proxy_off functions work
  
- [ ] **homebrew/** - Package management
  - [ ] Brewfile exists
  - [ ] brew bundle works

## 🎯 Success Criteria

Installation is successful if:

1. ✅ Shell starts in < 0.3s
2. ✅ All symlinks created correctly
3. ✅ Zinit and plugins loaded
4. ✅ Basic commands work (git, node, etc.)
5. ✅ No errors on shell startup
6. ✅ Aliases and functions work
7. ✅ Tools accessible in PATH

## 📝 Known Issues

None currently. If you encounter issues, please check:
- README.md for setup instructions
- ARCHITECTURE.md for technical details
- SENSITIVE_DATA.md for configuration help

## 🚀 Next Steps After Installation

1. **Customize aliases** - Edit `zsh/aliases-custom.zsh`
2. **Add local config** - Create `~/.localrc` for secrets
3. **Install Node version** - Run `fnm install 20`
4. **Configure git local** - Edit `~/.gitconfig.local`
5. **Set up SSH keys** - See `ssh/README.md`
6. **Run updates regularly** - Use `dot` command

## 📞 Support

If tests fail:
1. Check error messages
2. Review ARCHITECTURE.md
3. Run `zsh -xv` to debug
4. Check GitHub issues

