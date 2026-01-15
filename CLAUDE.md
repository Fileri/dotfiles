# dotfiles

Cross-platform terminal configuration managed with chezmoi.

## Stack
- **Shell:** zsh + starship
- **Terminal:** Ghostty
- **Multiplexer:** tmux + TPM
- **Editor:** Neovim + lazy.nvim
- **Theme:** Catppuccin Mocha
- **Font:** JetBrains Mono Nerd Font

## Structure
```
home/
├── dot_config/
│   ├── ghostty/config
│   ├── tmux/tmux.conf
│   ├── nvim/
│   └── starship.toml
├── dot_zshrc.tmpl
├── dot_gitconfig.tmpl
└── dot_gitignore_global
```

## Key Features
- Claude Code optimized (auto-reload, diffview.nvim)
- Cross-platform (macOS + Linux/GCE)
- Seamless tmux + Neovim navigation

## Commands
```bash
./install.sh              # Install dependencies
chezmoi apply             # Apply dotfiles
chezmoi edit ~/.zshrc     # Edit config
chezmoi update            # Pull and apply updates
```
