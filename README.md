# dotfiles

Cross-platform dotfiles for a unified terminal experience across macOS and Linux (including GCE instances).

## Features

- **Unified look** with Catppuccin Mocha theme across all tools
- **Ghostty** terminal emulator configuration
- **tmux** with session management and vim-style navigation
- **Neovim** configured for modern development with Claude Code integration
- **chezmoi** for cross-platform dotfile management
- **Nerd Fonts** for icons and ligatures

## Quick Start

### One-Line Install

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME/dotfiles
```

### Manual Install

```bash
# 1. Install chezmoi
brew install chezmoi  # macOS
# or
sh -c "$(curl -fsLS get.chezmoi.io)"  # Linux

# 2. Initialize and apply
chezmoi init https://github.com/YOUR_GITHUB_USERNAME/dotfiles.git
chezmoi diff
chezmoi apply
```

## Prerequisites

### macOS

```bash
brew install neovim tmux git curl ripgrep fd fzf lazygit zoxide starship
brew install --cask ghostty font-jetbrains-mono-nerd-font
```

### Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install -y neovim tmux git curl ripgrep fd-find fzf zsh

# Nerd Font
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
unzip JetBrainsMono.zip && fc-cache -fv
```

## Structure

```
.
├── .chezmoi.toml.tmpl      # Machine-specific variables
├── .chezmoiignore          # Files to ignore per OS
├── home/
│   ├── dot_config/
│   │   ├── ghostty/config  # Terminal config
│   │   ├── tmux/tmux.conf  # tmux configuration
│   │   ├── nvim/           # Neovim config
│   │   └── starship.toml   # Prompt config
│   ├── dot_zshrc.tmpl      # Shell config
│   └── dot_gitconfig.tmpl  # Git config
└── install.sh              # Bootstrap script
```

## Key Bindings

### tmux (prefix: Ctrl-a)

| Key | Action |
|-----|--------|
| `Ctrl-a c` | New window |
| `Ctrl-a \|` | Split vertical |
| `Ctrl-a -` | Split horizontal |
| `Ctrl-a x` | Kill pane |
| `Ctrl-h/j/k/l` | Navigate panes |

### Neovim (leader: Space)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>e` | File explorer |
| `<leader>gg` | Lazygit |
| `<leader>dd` | Open diffview |

## Claude Code Workflow

```
┌─────────────────────────────────────────┐
│ tmux session: project-name              │
├──────────────────────┬──────────────────┤
│     Neovim           │   Claude Code    │
│     (editing)        │   (AI assistant) │
└──────────────────────┴──────────────────┘
```

- Auto-reload files changed by Claude Code
- `diffview.nvim` for reviewing AI changes
- Seamless pane navigation

## License

MIT
