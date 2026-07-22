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

# Install Go toolchain
echo "🐹 Installing Go toolchain..."
brew install go gh git-delta jq
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
cp -r kitty ~/.config/kitty
cp -r nvim ~/.config/nvim
cp -r aerospace ~/.config/aerospace

echo "✅ Installation complete!"
echo ""
echo "To activate the new shell:"
echo "  source ~/.zshrc"
echo ""
echo "Or restart your terminal."
