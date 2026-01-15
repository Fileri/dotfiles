#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Detect OS
case "$(uname -s)" in
  Darwin) OS="macos" ;;
  Linux)  OS="linux" ;;
  *)      error "Unsupported OS" ;;
esac

info "Detected: $OS"

# =============================================================================
# macOS
# =============================================================================

if [[ "$OS" == "macos" ]]; then
  # Homebrew
  if ! command -v brew &> /dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  fi

  info "Installing packages..."
  brew install neovim tmux git ripgrep fd fzf lazygit zoxide starship chezmoi
  brew install --cask ghostty font-jetbrains-mono-nerd-font

  # FZF setup
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true
fi

# =============================================================================
# Linux
# =============================================================================

if [[ "$OS" == "linux" ]]; then
  if command -v apt &> /dev/null; then
    info "Installing packages (apt)..."
    sudo apt update
    sudo apt install -y neovim tmux git curl ripgrep fd-find fzf zsh

    # Starship
    command -v starship &> /dev/null || curl -sS https://starship.rs/install.sh | sh -s -- -y

    # Zoxide
    command -v zoxide &> /dev/null || curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

    # chezmoi
    command -v chezmoi &> /dev/null || sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
  fi

  # Nerd Font
  info "Installing Nerd Font..."
  mkdir -p ~/.local/share/fonts
  cd ~/.local/share/fonts
  [[ ! -f "JetBrainsMonoNerdFont-Regular.ttf" ]] && {
    curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip
    rm JetBrainsMono.zip
    fc-cache -fv
  }
  cd -
fi

# =============================================================================
# Common
# =============================================================================

# TPM
info "Installing tmux plugin manager..."
TPM_DIR="$HOME/.tmux/plugins/tpm"
[[ ! -d "$TPM_DIR" ]] && git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"

# Set zsh as default
if [[ "$SHELL" != *"zsh"* ]] && command -v zsh &> /dev/null; then
  info "Setting zsh as default shell..."
  ZSH_PATH=$(which zsh)
  grep -q "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
  chsh -s "$ZSH_PATH"
fi

success "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. chezmoi init --apply YOUR_GITHUB_USERNAME/dotfiles"
echo "  2. source ~/.zshrc"
echo "  3. tmux → Ctrl-a I (install plugins)"
echo "  4. nvim (plugins auto-install)"
