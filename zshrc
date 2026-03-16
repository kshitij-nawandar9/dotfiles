# Zsh Configuration

# ============================================
# PATH Configuration
# ============================================
# Add Cursor and VS Code CLI tools to PATH
# Note: Added in reverse order so VS Code's 'code' command takes precedence
export PATH="/Applications/Cursor.app/Contents/Resources/app/bin:$PATH"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# ============================================
# History Settings
# ============================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS          # Don't save duplicate commands
setopt HIST_FIND_NO_DUPS         # Don't show duplicates in search
setopt SHARE_HISTORY             # Share history across terminals
setopt INC_APPEND_HISTORY        # Add commands immediately (includes appending)

# ============================================
# Additional Options
# ============================================
setopt AUTO_CD                   # Type directory name to cd
setopt CORRECT                   # Command correction
setopt NO_BEEP                   # No annoying beep

# ============================================
# Useful Aliases
# ============================================
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias h='history'

# ============================================
# Completion Settings (Before plugins)
# ============================================
# Cache completion for 24 hours for faster startup
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case-insensitive
zstyle ':completion:*' menu select                       # Interactive menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colorful completion
zstyle ':completion:*' group-name ''                     # Group by type
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'  # Descriptions

# ============================================
# Antidote Plugin Manager
# ============================================
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# ============================================
# Git Aliases Helper
# ============================================
ghelp() {
  if [[ -z "$1" ]]; then
    echo "Git Aliases Help"
    echo "Usage: ghelp [search_term]"
    echo ""
    echo "Examples:"
    echo "  ghelp          - Show all git aliases"
    echo "  ghelp commit   - Search aliases containing 'commit'"
    echo "  ghelp branch   - Search aliases containing 'branch'"
    echo ""
    echo "💡 Use 'gdescribe <alias>' to see what an alias does"
    echo ""
    echo "All git aliases (${$(alias | grep "^g" | wc -l)} total):"
    alias | grep "^g" | column -t -s'='
  else
    echo "Git aliases matching '$1':"
    alias | grep "^g" | grep -i "$1" | column -t -s'='
  fi
}

# Show what a git alias does
gdescribe() {
  if [[ -z "$1" ]]; then
    echo "Usage: gdescribe <alias>"
    echo "Example: gdescribe gpsup"
    return
  fi

  local alias_def=$(alias "$1" 2>/dev/null)
  if [[ -z "$alias_def" ]]; then
    echo "Alias '$1' not found. Try: ghelp $1"
    return 1
  fi

  echo "$alias_def"
  echo ""
  echo "💡 For git command help: tldr git-<command>"
}

# ============================================
# Kubectl Aliases Helper
# ============================================
khelp() {
  if [[ -z "$1" ]]; then
    echo "Kubectl Aliases Help"
    echo "Usage: khelp [search_term]"
    echo ""
    echo "Examples:"
    echo "  khelp          - Show all kubectl aliases"
    echo "  khelp pod      - Search aliases containing 'pod'"
    echo "  khelp logs     - Search aliases containing 'logs'"
    echo ""
    echo "💡 Use 'kdescribe <alias>' to see what an alias does"
    echo ""
    echo "All kubectl aliases (${$(alias | grep "^k" | wc -l)} total):"
    alias | grep "^k" | column -t -s'='
  else
    echo "Kubectl aliases matching '$1':"
    alias | grep "^k" | grep -i "$1" | column -t -s'='
  fi
}

# Show what a kubectl alias does
kdescribe() {
  if [[ -z "$1" ]]; then
    echo "Usage: kdescribe <alias>"
    echo "Example: kdescribe kgp"
    return
  fi

  local alias_def=$(alias "$1" 2>/dev/null)
  if [[ -z "$alias_def" ]]; then
    echo "Alias '$1' not found. Try: khelp $1"
    return 1
  fi

  echo "$alias_def"
  echo ""
  echo "💡 For kubectl command help: kubectl --help"
}

# ============================================
# Key Bindings
# ============================================
# History prefix search with arrow keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# ============================================
# Starship Prompt
# ============================================
eval "$(starship init zsh)"

# ============================================
# Fish-like Autosuggestions
# ============================================
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'  # Grey color
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ============================================
# Syntax Highlighting (Must be last)
# ============================================
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
