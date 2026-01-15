# dotfiles

Cross-platform terminal configuration managed with chezmoi, with 1Password secrets integration.

## Features

- **Shell:** zsh + starship prompt
- **Terminal:** Ghostty
- **Multiplexer:** tmux + TPM
- **Editor:** Neovim + lazy.nvim
- **Theme:** Catppuccin Mocha
- **Font:** JetBrains Mono Nerd Font
- **Secrets:** 1Password CLI + SSH Agent
- **Signing:** SSH commit signing via 1Password

## Quick Start

### Fresh Machine (One-Liner)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/YOUR_USER/dotfiles/main/install.sh)"
```

### Existing Machine

```bash
git clone https://github.com/YOUR_USER/dotfiles ~/Code/dotfiles
cd ~/Code/dotfiles
./install.sh
```

## What the Install Script Does

### macOS

| Step | Description |
|------|-------------|
| 1 | Install Xcode Command Line Tools |
| 2 | Install Homebrew |
| 3 | Install packages from Brewfile |
| 4 | Setup FZF key bindings |
| 5 | Guide 1Password CLI setup |
| 6 | Apply macOS system preferences (optional) |

### Linux (apt-based)

| Step | Description |
|------|-------------|
| 1 | Install packages via apt |
| 2 | Install Starship, Zoxide, chezmoi |
| 3 | Install 1Password CLI |
| 4 | Install JetBrains Mono Nerd Font |

### Common (both)

| Step | Description |
|------|-------------|
| 1 | Install tmux plugin manager (TPM) |
| 2 | Set zsh as default shell |
| 3 | Apply dotfiles with chezmoi |

## 1Password Setup

The install script will prompt you to set up 1Password CLI:

1. Open **1Password app**
2. Go to **Settings → Developer**
3. Enable **"Integrate with 1Password CLI"**
4. Enable **"SSH Agent"**
5. Run `op signin` in terminal

### Required 1Password Items

| Vault | Item | Fields | Used For |
|-------|------|--------|----------|
| Development | Gemini API | credential | `GEMINI_API_KEY`, `GOOGLE_API_KEY` |
| Development | INWX | username, password | `inwx()` CLI wrapper |
| Development | GitHub | (SSH Key) | SSH auth + commit signing |

### SSH Agent

SSH keys in 1Password are automatically available via the SSH agent. Config location:

```
~/.config/1Password/ssh/agent.toml
```

## Structure

```
.
├── install.sh              # Bootstrap script
├── Brewfile                # macOS packages (declarative)
├── macos/
│   └── defaults.sh         # macOS system preferences
├── home/
│   ├── dot_config/
│   │   ├── ghostty/config
│   │   ├── tmux/tmux.conf
│   │   ├── nvim/
│   │   └── starship.toml
│   ├── private_dot_ssh/
│   │   └── config.tmpl     # SSH config with 1Password agent
│   ├── dot_zshrc.tmpl
│   ├── dot_gitconfig.tmpl
│   └── dot_gitignore_global
└── .chezmoi.toml.tmpl      # Chezmoi config
```

## Packages Installed (Brewfile)

| Category | Packages |
|----------|----------|
| CLI Tools | git, neovim, tmux, starship, chezmoi |
| Modern CLI | ripgrep, fd, fzf, zoxide, eza, bat, lazygit |
| ZSH Plugins | zsh-autosuggestions, zsh-syntax-highlighting |
| Markdown | glow, grip |
| Development | node, bun, go, python |
| AI Tools | gemini-cli, claude-code |
| Cloud | google-cloud-sdk |
| Security | 1password, 1password-cli |
| Apps | arc, ghostty, raycast |
| Fonts | font-jetbrains-mono-nerd-font |

## Key Bindings

### tmux (prefix: Ctrl-a)

| Key | Action |
|-----|--------|
| `Ctrl-a c` | New window |
| `Ctrl-a \|` | Split vertical |
| `Ctrl-a -` | Split horizontal |
| `Ctrl-a x` | Kill pane |
| `Ctrl-h/j/k/l` | Navigate panes |
| `Ctrl-a I` | Install plugins |

### Neovim (leader: Space)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>e` | File explorer |
| `<leader>gg` | Lazygit |
| `<leader>dd` | Open diffview |

## Post-Install

After installation completes:

```bash
# Reload shell
source ~/.zshrc

# Install tmux plugins
# In tmux, press: Ctrl-a I

# Open neovim (plugins auto-install)
nvim
```

## Updating

```bash
# Pull latest and apply
chezmoi update

# Or manually
cd ~/Code/dotfiles
git pull
chezmoi apply
```

## macOS System Preferences

The `macos/defaults.sh` script configures:

- **Dock:** Auto-hide, no recent apps, smaller icons
- **Finder:** Show path bar, hidden files, list view
- **Keyboard:** Fast key repeat, no auto-correct
- **Screenshots:** Save to ~/Desktop/Screenshots as PNG

Run manually:

```bash
./macos/defaults.sh
```

## License

MIT
