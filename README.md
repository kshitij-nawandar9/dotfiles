# 🐚 My Shell Dotfiles

Beautiful Zsh setup with Fish-like features and Starship prompt.

## 📦 What's Included

- **Aerospace window manager** with:
  - Tiling window management for macOS
  - Keyboard-driven workflow (i3-like)
  - Multiple workspaces
  - Vim-style navigation (hjkl)

- **Neovim + LazyVim** with:
  - IDE-like experience out of the box
  - LSP support for code intelligence
  - Treesitter for syntax highlighting
  - File explorer, fuzzy finder, git integration
  - Modern plugin management

- **Kitty terminal** with:
  - GPU-accelerated rendering
  - Tokyo Night Storm theme
  - Tabs and window management
  - macOS-friendly keybindings

- **Zsh configuration** with:
  - Fish-like autosuggestions
  - Syntax highlighting
  - Better history management
  - Smart completions
  - Useful aliases

- **Starship prompt** with:
  - Git status indicators
  - Directory info
  - Command duration
  - Language version info

- **JetBrains Mono Nerd Font** for icons

## 🚀 Quick Start (New Machine)

### Option 1: Automated Install

```bash
cd ~/dotfiles
./install.sh
```

### Option 2: Manual Install

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install packages
brew install starship zsh-autosuggestions zsh-syntax-highlighting neovim
brew install --cask font-jetbrains-mono-nerd-font kitty nikitabobko/tap/aerospace

# 3. Copy configs
cp zshrc ~/.zshrc
mkdir -p ~/.config
cp starship.toml ~/.config/starship.toml
cp -r kitty ~/.config/kitty
cp -r nvim ~/.config/nvim
cp -r aerospace ~/.config/aerospace

# 4. Reload shell
source ~/.zshrc
```

## 📤 Backing Up to GitHub

To use this on multiple machines, push to GitHub:

```bash
cd ~/dotfiles
git init
git add .
git commit -m "Initial dotfiles commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/dotfiles.git
git push -u origin main
```

## 📥 Installing from GitHub (Future Machines)

```bash
# Clone your dotfiles
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run install script
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## 📝 Files

- `zshrc` - Zsh configuration
- `starship.toml` - Starship prompt config
- `kitty/` - Kitty terminal config
- `nvim/` - Neovim + LazyVim config
- `aerospace/` - Aerospace window manager config
- `NEOVIM_GUIDE.md` - **Complete Neovim tutorial**
- `NEOVIM_QUICK_REF.md` - **Quick Neovim cheat sheet**
- `AEROSPACE_GUIDE.md` - **Complete Aerospace tutorial**
- `install.sh` - Automated installation script
- `README.md` - This file

## 🎨 Customization

### Change Prompt Colors

Edit `~/.config/starship.toml`:

```toml
[directory]
style = "bold cyan"  # Change to: red, green, yellow, blue, magenta, etc.
```

### Add More Aliases

Edit `~/.zshrc` and add under the "Aliases" section:

```zsh
alias myalias='command here'
```

### Using Kitty Terminal

After install, open Kitty from Applications. The config is already set!

**Kitty Keybindings:**
- `Cmd+T` - New tab
- `Cmd+W` - Close tab
- `Cmd+Enter` - New window
- `Cmd+1/2/3` - Switch to tab 1/2/3
- `Cmd+Plus/Minus` - Increase/decrease font size

### Using Neovim + LazyVim

**First Launch:**
```bash
nvim
```
LazyVim will automatically install all plugins (takes 1-2 minutes).

**Essential Keybindings:**
- `Space` - Leader key (opens command menu)
- `Space + e` - File explorer
- `Space + ff` - Find files
- `Space + /` - Search in files
- `Space + gg` - Open Lazygit
- `:q` - Quit
- `:w` - Save

**Learn more:** Run `:Tutor` inside Neovim for basics

### Using Aerospace Window Manager

**First Launch:**
1. Grant Accessibility permissions:
   - System Settings → Privacy & Security → Accessibility
   - Enable AeroSpace
2. Restart Aerospace: `open -a AeroSpace`

**Essential Keybindings:**
- `Alt + h/j/k/l` - Focus window (left/down/up/right)
- `Alt + 1/2/3` - Switch to workspace 1/2/3
- `Alt + Shift + h/j/k/l` - Move window
- `Alt + Shift + 1/2/3` - Move window to workspace
- `Alt + r` - Resize mode
- `Alt + f` - Fullscreen

**Learn more:** See `AEROSPACE_GUIDE.md` for complete guide

## 🔄 Keeping Dotfiles Updated

After making changes to your configs:

```bash
# Copy latest configs to dotfiles
cp ~/.zshrc ~/dotfiles/zshrc
cp ~/.config/starship.toml ~/dotfiles/starship.toml

# If using git
cd ~/dotfiles
git add .
git commit -m "Update configs"
git push
```

## ✨ Features

### Autosuggestions
- Type and see grey suggestions from history
- Press `→` (right arrow) to accept

### Syntax Highlighting
- Green = valid command
- Red = invalid command

### History Search
- Type `git` then press `↑` to search history for commands starting with "git"

### Smart Completions
- Press `Tab` to see completions with descriptions
- Use arrow keys to select

## 🛠️ Troubleshooting

### Icons not showing
- Make sure JetBrains Mono Nerd Font is installed
- Set it in your terminal settings

### Autosuggestions not working
- Check if plugin is sourced: `grep autosuggestions ~/.zshrc`
- Reload shell: `source ~/.zshrc`

### Starship not showing
- Check installation: `starship --version`
- Check if initialized: `grep starship ~/.zshrc`

## 📚 Resources

- [Starship Documentation](https://starship.rs/)
- [Zsh Documentation](https://zsh.sourceforge.io/)
- [Nerd Fonts](https://www.nerdfonts.com/)

---

**Made with ❤️ for productivity**
