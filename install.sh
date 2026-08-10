#!/bin/bash
# Dotfiles Installation Script
# Run this on any new Mac to replicate your shell setup

set -e

echo "🚀 Starting dotfiles installation..."

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✓ Homebrew already installed"
fi

# Install required packages
echo "📦 Installing shell tools..."
brew install starship zsh-autosuggestions zsh-syntax-highlighting antidote tldr

# Directory navigation: zoxide replaces `cd`, fzf is the interactive picker,
# fd is the fast directory/file walker both of them feed from.
echo "🧭 Installing navigation tools..."
brew install zoxide fzf fd

# Install dev tooling
echo "🛠  Installing dev tooling..."
brew install gh git-delta jq

# Node / TypeScript — the primary stack. fnm reads .nvmrc per repo.
echo "📗 Installing Node toolchain..."
brew install fnm
eval "$(fnm env --shell bash)"
fnm install 24
fnm default 24

# Docker runtime for local infra (Postgres, Redis, Kafka, Temporal).
echo "🐳 Installing OrbStack..."
brew install --cask orbstack

# Go — optional, only used by a minority of repos. Comment out if unneeded.
echo "🐹 Installing Go toolchain..."
brew install go
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install honnef.co/go/tools/cmd/staticcheck@latest

# Install Nerd Font
echo "🔤 Installing JetBrains Mono Nerd Font..."
brew install --cask font-jetbrains-mono-nerd-font

# Install Kitty terminal
echo "🐱 Installing Kitty terminal..."
brew install --cask kitty

# Install Neovim
echo "📝 Installing Neovim..."
brew install neovim

# Install Aerospace
echo "🪟 Installing Aerospace window manager..."
brew install --cask nikitabobko/tap/aerospace

# Backup existing configs
echo "💾 Backing up existing configs..."
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
[ -f ~/.config/starship.toml ] && cp ~/.config/starship.toml ~/.config/starship.toml.backup.$(date +%Y%m%d_%H%M%S)
[ -f ~/.gitconfig ] && cp ~/.gitconfig ~/.gitconfig.backup.$(date +%Y%m%d_%H%M%S)

# Copy configs
echo "📝 Installing dotfiles..."
cp zshrc ~/.zshrc
cp zsh_plugins.txt ~/.zsh_plugins.txt
cp gitconfig ~/.gitconfig
cp gitignore_global ~/.gitignore_global
# Never clobber machine-local overrides (Go paths, work env, GOPRIVATE).
[ -f ~/.zshrc.local ] || cp zshrc.local ~/.zshrc.local

# Create the repo tree: ~/src/<host>/<org>/<repo> mirrors the import path.
mkdir -p ~/src/github.com/telematicaHQ ~/src/github.com/kshitij-nawandar9
mkdir -p ~/.config
cp starship.toml ~/.config/starship.toml

# Copy a config directory's *contents* into place, creating the target first.
# `cp -R src dest` nests as dest/src when dest already exists, so the plain form
# quietly produces ~/.config/nvim/nvim on every run after the first. The
# trailing `/.` copies what's inside src instead, which is idempotent.
# Files you added locally and that aren't in the repo are left alone.
install_config_dir() {
  local src="$1" dest="$2"
  mkdir -p "$dest"
  cp -R "$src/." "$dest/"
}

install_config_dir kitty ~/.config/kitty
install_config_dir nvim ~/.config/nvim
install_config_dir aerospace ~/.config/aerospace

echo "✅ Installation complete!"
echo ""
echo "To activate the new shell:"
echo "  source ~/.zshrc"
echo ""
echo "Or restart your terminal."
