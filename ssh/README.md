# SSH Configuration

This directory contains SSH configuration that will be symlinked to `~/.ssh/config`.

## SSH Keys

SSH keys are **NOT** stored in this repository for security reasons. You'll need to set them up manually on each machine.

### Generate SSH Key

```bash
# Generate ED25519 key (recommended)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Or RSA key (if ED25519 not supported)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### Add to SSH Agent

```bash
# Start ssh-agent
eval "$(ssh-agent -s)"

# Add key to agent (macOS)
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Add key to agent (Linux)
ssh-add ~/.ssh/id_ed25519
```

### Add to Services

- **GitHub**: https://github.com/settings/keys
- **GitLab**: https://gitlab.com/-/profile/keys
- **Bitbucket**: https://bitbucket.org/account/settings/ssh-keys/

## Custom Hosts

Edit `config.symlink` to add your custom SSH hosts.

