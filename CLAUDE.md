# dotfiles

Cross-platform terminal configuration managed with chezmoi.

## Stack
- **Shell:** zsh + starship
- **Terminal:** Ghostty
- **Multiplexer:** tmux + TPM
- **Editor:** Neovim + lazy.nvim
- **Theme:** Catppuccin Mocha
- **Font:** JetBrains Mono Nerd Font
- **Secrets:** 1Password CLI

## Structure
```
.
├── install.sh              # Bootstrap script (macOS + Linux)
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
│   │   └── config.tmpl      # 1Password SSH agent
│   ├── dot_zshrc.tmpl
│   ├── dot_gitconfig.tmpl
│   └── dot_gitignore_global
└── .chezmoi.toml.tmpl      # Chezmoi config with 1Password
```

## Bootstrap (Fresh Machine)

```bash
# One-liner (after pushing to GitHub)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/YOUR_USER/dotfiles/main/install.sh)"

# Or clone and run
git clone https://github.com/YOUR_USER/dotfiles ~/Code/dotfiles
cd ~/Code/dotfiles && ./install.sh
```

## Commands
```bash
./install.sh              # Install dependencies
chezmoi apply             # Apply dotfiles
chezmoi edit ~/.zshrc     # Edit config
chezmoi update            # Pull and apply updates
```

## 1Password Secrets

Secrets are managed via 1Password CLI. In templates:
```
{{ onepasswordRead "op://Vault/Item/field" }}
```

Example in `.zshrc.tmpl`:
```bash
export OPENAI_API_KEY="{{ onepasswordRead "op://Development/OpenAI/api-key" }}"
```

## Notes

### Neovim 0.11+ Treesitter API
Neovim 0.11+ uses a new treesitter API. Use `require("nvim-treesitter").setup({})` instead of the old `require("nvim-treesitter.configs").setup({})`.

### Claude Code Stale Shell
Claude Code's Bash tool maintains a persistent shell session. If the working directory is moved/deleted, commands will fail with "Path does not exist". Workarounds:
- Use Task tool with Bash subagent (fresh shell)
- Prefix commands with explicit `cd /path && ...`
- Restart Claude Code session
