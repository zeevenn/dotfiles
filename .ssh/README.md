# SSH Configuration

This directory will be symlinked to `~/.ssh/` during bootstrap. Files in this directory will be available at `~/.ssh/`.

## Files

- `config` - Main SSH configuration file (symlinked to `~/.ssh/config`)
- `config.local.example` - Template for machine-specific SSH config
- `README.md` - This file

## SSH Keys

SSH keys are **NOT** stored in this repository for security reasons. The bootstrap script will help you generate them.

### Generate SSH Key (via bootstrap)

The `script/bootstrap` will prompt you to generate an SSH key if one doesn't exist.

Or manually:

```bash
# Generate ED25519 key (recommended)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Or RSA key (if ED25519 not supported)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### Add to SSH Agent

The bootstrap script automatically adds your key to ssh-agent.

Or manually:

```bash
# Start ssh-agent
eval "$(ssh-agent -s)"

# Add key to agent (macOS)
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Add key to agent (Linux)
ssh-add ~/.ssh/id_ed25519
```

### Add to Services

- **GitHub**: <https://github.com/settings/keys>
- **GitLab**: <https://gitlab.com/-/profile/keys>
- **Bitbucket**: <https://bitbucket.org/account/settings/ssh-keys/>

## Custom Hosts

Edit `config` to add your custom SSH hosts, or create `config.local` for machine-specific configuration.
