# Sensitive Data Handling

This dotfiles repository uses several mechanisms to keep sensitive data out of version control.

## 1. ~/.localrc

Any environment variables or sensitive configuration should go in `~/.localrc`, which is automatically sourced by `~/.zshrc` but is **not** tracked by git.

**Example `~/.localrc`:**

```bash
# API tokens
export GITHUB_TOKEN="your_token_here"
export NPM_TOKEN="your_token_here"

# Proxy settings
export HTTP_PROXY="http://proxy.company.com:8080"
export HTTPS_PROXY="http://proxy.company.com:8080"

# Custom environment variables
export CUSTOM_VAR="value"

# Use your fork for git-open
export GIT_OPEN_REPO="YOUR_USERNAME"
```

## 2. *.local Pattern

Any file ending with `.local` or `.local.symlink` is ignored by git. This is used for:

- `git/gitconfig.local.symlink` - Personal git config (name, email, tokens)
- `node/npmrc.local` - NPM authentication tokens
- Any other local overrides

## 3. Example Files

For files that need local configuration, we provide `.example` files:

- `git/gitconfig.local.symlink.example` - Template for git config
- `node/npmrc.local.example` - Template for npm config

**To use:**

```bash
cp git/gitconfig.local.symlink.example git/gitconfig.local.symlink
# Edit and fill in your details
```

## 4. SSH Keys

SSH keys are **never** stored in this repository. Generate them on each machine:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

See `ssh/README.md` for more details.

## 5. Environment Files

Standard `.env` and `.env.local` files are ignored by git.

## What's Safe to Commit?

✅ **Safe:**
- Public configuration (editor settings, aliases, etc.)
- Shell functions and scripts
- Application defaults
- Example/template files (*.example)

❌ **Never commit:**
- API tokens or passwords
- SSH keys
- Personal email/name
- Company-specific proxy settings
- Private repository URLs
- Any credentials

## Checking for Sensitive Data

Before committing:

```bash
git diff
```

If you accidentally committed sensitive data:

```bash
# Remove from git but keep locally
git rm --cached <file>

# Add to .gitignore
echo "<file>" >> .gitignore

# Commit
git commit -m "Remove sensitive file from tracking"
```

For more serious leaks, consider using [git-filter-repo](https://github.com/newren/git-filter-repo) or [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/).

