#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Code/dotfiles}"

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
  # Xcode Command Line Tools
  if ! xcode-select -p &> /dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Press any key after installation completes..."
    read -n 1
  fi

  # Homebrew
  if ! command -v brew &> /dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  fi

  # Install from Brewfile
  info "Installing packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"

  # FZF key bindings
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true

  # 1Password CLI setup
  if command -v op &> /dev/null; then
    if ! op account list &>/dev/null; then
      echo ""
      echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
      echo -e "${BLUE}│${NC}  ${GREEN}1Password Setup Required${NC}                                   ${BLUE}│${NC}"
      echo -e "${BLUE}├─────────────────────────────────────────────────────────────┤${NC}"
      echo -e "${BLUE}│${NC}  1. Open 1Password app                                       ${BLUE}│${NC}"
      echo -e "${BLUE}│${NC}  2. Settings → Developer → Enable 'CLI integration'         ${BLUE}│${NC}"
      echo -e "${BLUE}│${NC}  3. Settings → Developer → Enable 'SSH Agent'               ${BLUE}│${NC}"
      echo -e "${BLUE}│${NC}  4. Run: op signin                                          ${BLUE}│${NC}"
      echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
      echo ""
      read -p "Press any key after completing 1Password setup..." -n 1 -r
      echo
    else
      success "1Password CLI connected"
    fi

    # Verify required 1Password items exist
    info "Verifying 1Password secrets..."
    if ! op read "op://Development/Gemini API/credential" &>/dev/null; then
      error "Missing 1Password item: Development/Gemini API (credential field)\nCreate this item in 1Password before continuing."
    fi
    success "1Password secrets verified"
  fi

  # macOS defaults (optional)
  read -p "Apply macOS system preferences? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    "$DOTFILES_DIR/macos/defaults.sh"
  fi

  # Raycast setup reminder
  echo ""
  echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
  echo -e "${BLUE}│${NC}  ${GREEN}Raycast Setup${NC}                                              ${BLUE}│${NC}"
  echo -e "${BLUE}├─────────────────────────────────────────────────────────────┤${NC}"
  echo -e "${BLUE}│${NC}  1. Open Raycast                                             ${BLUE}│${NC}"
  echo -e "${BLUE}│${NC}  2. Sign in with your Raycast account                        ${BLUE}│${NC}"
  echo -e "${BLUE}│${NC}  3. Settings → Cloud Sync → Enable                           ${BLUE}│${NC}"
  echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
  echo ""
  read -p "Press any key after completing Raycast setup..." -n 1 -r
  echo

  # Google Cloud auth (for Vertex AI / Claude)
  echo ""
  echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
  echo -e "${BLUE}│${NC}  ${GREEN}Google Cloud Setup (for Claude via Vertex AI)${NC}              ${BLUE}│${NC}"
  echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
  if ! gcloud auth list 2>/dev/null | grep -q "ACTIVE"; then
    info "Authenticating with Google Cloud..."
    gcloud auth login
  else
    success "Google Cloud already authenticated"
  fi

  # Set GCloud project for Vertex AI
  info "Configuring GCloud project..."
  gcloud config set project ai-automat-id-play-38355
  gcloud config set compute/region europe-west1

  # Set active account if needed
  if ! gcloud config get-value account | grep -q "erik.fillipsveen@elvia.no"; then
    gcloud config set account erik.fillipsveen@elvia.no
  fi
  success "GCloud project configured"

  # Application default credentials for Vertex AI
  if [[ ! -f "$HOME/.config/gcloud/application_default_credentials.json" ]]; then
    info "Setting up application default credentials for Vertex AI..."
    gcloud auth application-default login
  else
    success "Application default credentials exist"
  fi

  # Arc browser reminder
  echo ""
  echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
  echo -e "${BLUE}│${NC}  ${GREEN}Arc Browser Setup${NC}                                          ${BLUE}│${NC}"
  echo -e "${BLUE}├─────────────────────────────────────────────────────────────┤${NC}"
  echo -e "${BLUE}│${NC}  1. Open Arc                                                  ${BLUE}│${NC}"
  echo -e "${BLUE}│${NC}  2. Sign in with your Arc account                            ${BLUE}│${NC}"
  echo -e "${BLUE}│${NC}  3. Your spaces and tabs will sync automatically             ${BLUE}│${NC}"
  echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
  echo ""
  read -p "Press any key to continue..." -n 1 -r
  echo

  # Tailscale setup (optional)
  read -p "Install and setup Tailscale? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! command -v tailscale &> /dev/null; then
      info "Installing Tailscale..."
      brew install --cask tailscale
    fi

    # Open Tailscale app (required for daemon to start)
    open -a Tailscale 2>/dev/null || true
    sleep 2

    # Check status with timeout to avoid hanging
    if ! timeout 3 tailscale status &>/dev/null; then
      echo ""
      echo -e "${BLUE}┌─────────────────────────────────────────────────────────────┐${NC}"
      echo -e "${BLUE}│${NC}  ${GREEN}Tailscale Setup${NC}                                            ${BLUE}│${NC}"
      echo -e "${BLUE}├─────────────────────────────────────────────────────────────┤${NC}"
      echo -e "${BLUE}│${NC}  1. Tailscale app should be opening                         ${BLUE}│${NC}"
      echo -e "${BLUE}│${NC}  2. Click 'Log in' and select 'Sign in with Apple'         ${BLUE}│${NC}"
      echo -e "${BLUE}│${NC}  3. Complete authentication                                 ${BLUE}│${NC}"
      echo -e "${BLUE}└─────────────────────────────────────────────────────────────┘${NC}"
      echo ""
      read -p "Press any key after completing Tailscale login..." -n 1 -r
      echo
    else
      success "Tailscale already connected"
    fi
  fi
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

    # 1Password CLI
    if ! command -v op &> /dev/null; then
      info "Installing 1Password CLI..."
      curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
        sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
        sudo tee /etc/apt/sources.list.d/1password.list
      sudo apt update && sudo apt install -y 1password-cli
    fi
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
  cd - > /dev/null
fi

# =============================================================================
# Common
# =============================================================================

# TPM (tmux plugin manager)
info "Installing tmux plugin manager..."
TPM_DIR="$HOME/.tmux/plugins/tpm"
[[ ! -d "$TPM_DIR" ]] && git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"

# Set zsh as default shell
if [[ "$SHELL" != *"zsh"* ]] && command -v zsh &> /dev/null; then
  info "Setting zsh as default shell..."
  ZSH_PATH=$(which zsh)
  grep -q "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
  chsh -s "$ZSH_PATH"
fi

# =============================================================================
# Apply dotfiles with chezmoi
# =============================================================================

info "Applying dotfiles with chezmoi..."

# Check if chezmoi config already has name/email
CHEZMOI_CONFIG="$HOME/.config/chezmoi/chezmoi.toml"
if [[ ! -f "$CHEZMOI_CONFIG" ]] || ! grep -q "name = " "$CHEZMOI_CONFIG" 2>/dev/null; then
  echo ""
  read -p "Your full name: " USER_NAME
  read -p "Your email address: " USER_EMAIL

  mkdir -p "$(dirname "$CHEZMOI_CONFIG")"
  cat > "$CHEZMOI_CONFIG" << EOF
[data]
    name = "$USER_NAME"
    email = "$USER_EMAIL"

[onepassword]
    command = "op"
    prompt = true
EOF
  success "Created chezmoi config"
fi

if [[ -d "$DOTFILES_DIR" ]]; then
  # Local dotfiles directory exists
  if [[ -d "$HOME/.local/share/chezmoi" ]]; then
    info "Chezmoi already initialized, re-initializing from source..."
    chezmoi init --apply --force --source="$DOTFILES_DIR"
  else
    info "Initializing chezmoi from local dotfiles..."
    chezmoi init --apply --force --source="$DOTFILES_DIR"
  fi
else
  # Fresh machine - clone from GitHub
  read -p "Enter your GitHub username for dotfiles repo: " GITHUB_USER
  chezmoi init --apply --force "$GITHUB_USER/dotfiles"
fi

# Verify dotfiles were applied successfully
info "Verifying dotfiles configuration..."
if [[ ! -f "$HOME/.zshrc" ]]; then
  error "Failed to generate .zshrc - chezmoi apply may have failed"
fi

# Verify GOOGLE_API_KEY is in .zshrc
if ! grep -q "export GOOGLE_API_KEY=" "$HOME/.zshrc"; then
  error "GOOGLE_API_KEY not found in .zshrc - check 1Password connection"
fi

success "Dotfiles verified - GOOGLE_API_KEY configured"

# =============================================================================
# PAI (Personal AI Infrastructure) Installation
# =============================================================================

if [[ "$OS" == "macos" ]]; then
  read -p "Install PAI (Personal AI Infrastructure)? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    PAI_INSTALLER_DIR="$HOME/Code/pai-installer"

    # Clone pai-installer if it doesn't exist
    if [[ ! -d "$PAI_INSTALLER_DIR" ]]; then
      info "Cloning PAI installer..."
      git clone git@github.com:Fileri/pai-installer.git "$PAI_INSTALLER_DIR"
    elif [[ -d "$PAI_INSTALLER_DIR/.git" ]]; then
      info "PAI installer already exists, pulling latest..."
      git -C "$PAI_INSTALLER_DIR" pull
    else
      info "PAI installer directory exists but is not a git repo, removing and cloning..."
      rm -rf "$PAI_INSTALLER_DIR"
      git clone git@github.com:Fileri/pai-installer.git "$PAI_INSTALLER_DIR"
    fi

    # Apply chezmoi to create config.json
    info "Generating PAI config.json..."
    chezmoi apply --force --source="$DOTFILES_DIR"

    # Check if config.json exists
    if [[ ! -f "$PAI_INSTALLER_DIR/config.json" ]]; then
      error "PAI config.json not found at $PAI_INSTALLER_DIR/config.json"
    fi

    # Run PAI installer
    info "Running PAI installer..."
    if command -v bun &> /dev/null; then
      (cd "$PAI_INSTALLER_DIR" && bun run install.ts)
      success "PAI installed successfully"
    else
      error "Bun not found. Install bun first: curl -fsSL https://bun.sh/install | bash"
    fi
  fi
fi

success "Installation complete!"
echo ""
echo -e "${GREEN}✓ Environment variables configured:${NC}"
echo "  - GOOGLE_API_KEY (for Gemini and image generation)"
echo ""
echo "Next steps:"
echo "  1. source ~/.zshrc                        # Reload shell (or restart terminal)"
echo "  2. echo \$GOOGLE_API_KEY                  # Verify API key is loaded"
echo "  3. tmux → Ctrl-a I                        # Install tmux plugins"
echo "  4. nvim                                   # Plugins auto-install"
echo ""
echo -e "${GREEN}✓ GCloud helpers available:${NC}"
echo "  - ai-console                              # SSH to ai-console via IAP"
echo "  - ai-console-sync start                   # Start mutagen sync"
echo "  - ai-console-sync status                  # Check sync status"
echo ""
echo "Switch dotfiles repo to SSH (if cloned via HTTPS):"
echo "  cd ~/Code/dotfiles && git remote set-url origin git@github.com:Fileri/dotfiles.git"
