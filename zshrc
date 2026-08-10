# Zsh Configuration

# ============================================
# Homebrew
# ============================================
# Must come first: everything below lives under the brew prefix.
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# ============================================
# PATH Configuration
# ============================================
# Claude Code and other user-installed binaries
export PATH="$HOME/.local/bin:$PATH"
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
# Node / TypeScript  (primary stack)
# ============================================
# fnm with --use-on-cd auto-switches to the version in .nvmrc on cd. The hook is
# a chpwd hook, so it still fires when zoxide's `cd` jumps you somewhere.
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

# Turborepo: run a task with its dependencies built first. Running
# `npm run <task> -w <pkg>` directly skips the task graph, so unbuilt workspace
# packages surface as bogus "cannot find module @repo/*" errors.
t() { npx turbo "$@"; }

# ============================================
# Repo Layout
# ============================================
# Repos live at ~/src/<host>/<org>/<repo>, mirroring the canonical repo path.
export SRC="$HOME/src"

# gclone telematicaHQ/foo  ->  clone to ~/src/github.com/telematicaHQ/foo and cd
gclone() {
  local slug="${1:?usage: gclone <org>/<repo> [host]}" host="${2:-github.com}"
  local dest="$SRC/$host/$slug"
  [ -d "$dest" ] || git clone "git@$host:$slug.git" "$dest" || return 1
  cd "$dest"
}

# repo <name>  ->  jump to any repo under ~/src by directory name.
# Exactly one match jumps straight there; several open an fzf picker rather
# than silently taking the first hit and landing you in the wrong repo.
repo() {
  local -a matches
  matches=(${(f)"$(find "$SRC" -mindepth 3 -maxdepth 3 -type d -name "*$1*" 2>/dev/null)"})
  case ${#matches} in
    0) echo "no repo matching '$1' under $SRC" >&2; return 1 ;;
    1) cd "${matches[1]}" ;;
    *) if command -v fzf >/dev/null; then
         local d
         d=$(print -l -- "${matches[@]}" | fzf --prompt='repo> ') || return
         [ -n "$d" ] && cd "$d"
       else
         cd "${matches[1]}"
       fi ;;
  esac
}

# ============================================
# Directory Navigation (zoxide + fzf)
# ============================================
# Both blocks are guarded, so this file stays portable to a machine where
# neither tool is installed — you just fall back to plain `cd`.

# zoxide takes over `cd` itself: it remembers every directory you visit and
# ranks them by frecency, so a few characters are enough to jump anywhere.
#   cd dot        -> ~/src/github.com/kshitij-nawandar9/dotfiles
#   cd tele os    -> ~/src/github.com/telematicaHQ/os   (multiple keywords AND)
#   cdi           -> interactive fzf picker over everything zoxide knows
# Literal paths are still handled by the real builtin, so `cd ..`, `cd ./foo`,
# `cd -` and shell scripts behave exactly as before.
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

if command -v fzf >/dev/null; then
  # Ctrl+T  insert a file path into the current command line
  # Ctrl+R  fuzzy history search
  # Alt+C   cd into a subdirectory of $PWD
  # (Alt+C needs `macos_option_as_alt yes` in kitty.conf — it's already set.)
  source <(fzf --zsh)

  export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --info=inline'

  # fd is faster than find and respects .gitignore. Skip .git and node_modules
  # explicitly — they're the two directory trees never worth walking here.
  if command -v fd >/dev/null; then
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git --exclude node_modules'
    export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git --exclude node_modules'
  fi

  # --scheme=path scores whole paths rather than flat strings, which ranks the
  # match in the final segment above incidental hits deep in a vendor tree.
  export FZF_ALT_C_OPTS='--scheme=path'
  export FZF_CTRL_T_OPTS='--scheme=path'

  # fcd [query] — fuzzy-cd to any directory under ~/src, however deep, whether
  # or not you've ever visited it. This is the cold-start counterpart to `cd`:
  # zoxide only knows where you've been, fcd searches the whole tree.
  fcd() {
    local root="${SRC:-$HOME/src}" dir finder
    if command -v fd >/dev/null; then
      finder=(fd --type d --hidden --exclude .git --exclude node_modules . "$root")
    else
      finder=(find "$root" -type d -not -path '*/.git/*' -not -path '*/node_modules/*')
    fi
    # --select-1 skips the picker when the query already narrows it to one hit;
    # with several hits you get the list, best match already on top.
    dir=$("${finder[@]}" 2>/dev/null \
      | fzf --scheme=path --query="${1:-}" --select-1 --exit-0) || return
    [ -n "$dir" ] && cd "$dir"
  }
fi

# ============================================
# Editors take the same shorthand as `cd`
# ============================================
# `code dot` opens the dotfiles repo; `code tele os` opens the os monorepo.
#
# Resolution is deliberately conservative, because these commands are also how
# you create a new file. An argument is only sent to zoxide when EVERY argument
# is a bare word — no leading dash, no slash, no dot, and not something that
# already exists on disk — and zoxide actually recognises it. So `code .`,
# `code src/app.ts`, `code newfile.ts`, `code --diff a b` and a bare `code` all
# keep their stock meaning, and an unrecognised word is passed through
# untouched rather than being silently redirected somewhere surprising.
if command -v zoxide >/dev/null; then
  __zoxide_editor() {
    local editor="$1"; shift
    (( $# )) || { command "$editor"; return }

    local a
    for a in "$@"; do
      [[ $a == -* || $a == */* || $a == *.* || -e $a ]] && { command "$editor" "$@"; return }
    done

    local dir
    if dir=$(zoxide query -- "$@" 2>/dev/null) && [[ -n $dir ]]; then
      command "$editor" "$dir"
    else
      command "$editor" "$@"
    fi
  }

  # Defined only for editors present on this machine, so the wrapper never
  # shadows a command that isn't there.
  for _zed in code cursor; do
    command -v "$_zed" >/dev/null \
      && eval "${_zed}() { __zoxide_editor ${_zed} \"\$@\" }"
  done
  unset _zed
fi

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

# ============================================
# Machine-local overrides (not tracked verbatim)
# ============================================
# Language toolchains, work-specific env, anything not portable.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
