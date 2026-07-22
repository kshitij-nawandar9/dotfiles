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

- **TypeScript / Node development environment** with:
  - `fnm` with `--use-on-cd` — auto-switches Node version per repo `.nvmrc`
  - `NODE_AUTH_TOKEN` wired from the `gh` token for private GitHub Packages
  - OrbStack as the Docker runtime for local infra
  - Neovim LSP for TypeScript, ESLint, Prettier, Tailwind, SQL, Docker

- **Repo organization** with:
  - `~/src/<host>/<org>/<repo>` layout, mirroring the canonical repo path
  - `gclone` / `repo` shell helpers for cloning and jumping between repos

- **Go toolchain** (secondary — used by a minority of repos):
  - `go`, `gopls`, `dlv` (debugger), `staticcheck` (linter)
  - `GOPRIVATE` preconfigured for private org modules, set only if Go is present

- **Git configuration** with:
  - Per-directory identity (work email applies only inside the work org tree)
  - Sane defaults: rebase-on-pull, auto-upstream, prune, `zdiff3` conflicts
  - SSH rewrite scoped to your own orgs
  - Global gitignore

- **JetBrains Mono Nerd Font** for icons

## 🚀 Quick Start (New Machine)

Run these in **Terminal.app**, not an editor-embedded shell — the Homebrew
installer needs a real TTY to prompt for your password.

```bash
# 1. Install Homebrew, then clone and install in one go
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

mkdir -p ~/src/github.com/kshitij-nawandar9
git clone https://github.com/kshitij-nawandar9/dotfiles.git \
  ~/src/github.com/kshitij-nawandar9/dotfiles
cd ~/src/github.com/kshitij-nawandar9/dotfiles
./install.sh

# 2. Authenticate GitHub (generates and uploads an SSH key for you)
gh auth login          # GitHub.com -> SSH -> generate key -> web browser

# 3. Reload
source ~/.zshrc
```

Then create `~/.gitconfig-work` with your work identity (see
[Git Identity](#-git-identity) below), and you're done.

## 🧱 How the Zsh Config Is Layered

There are two shell files, and the distinction matters:

| File | Tracked? | Overwritten by `install.sh`? | Holds |
|---|---|---|---|
| `~/.zshrc` | yes, as `zshrc` | **always** | Portable config — aliases, plugins, prompt |
| `~/.zshrc.local` | seeded from `zshrc.local` | **never, if it exists** | Machine-specific — toolchains, work env, secrets |

`~/.zshrc` sources `~/.zshrc.local` as its very last line, so anything there
wins. Put machine-specific things (`GOPRIVATE`, API tokens, per-client paths)
in `~/.zshrc.local` and re-running `install.sh` will leave them alone.

> ⚠️ `install.sh` copies `zshrc` over `~/.zshrc` unconditionally. Any edit you
> make directly to `~/.zshrc` is lost on the next run — edit `zshrc` in this
> repo and re-install, or put it in `~/.zshrc.local`. A timestamped backup is
> written to `~/.zshrc.backup.*` each time.

## 📁 Repo Layout

Repos live at `~/src/<host>/<org>/<repo>` — so `github.com/telematicaHQ/os` is at
`~/src/github.com/telematicaHQ/os`. The path is derivable from the repo URL and
vice versa, and it's what the per-directory git identity keys off.

```bash
gclone telematicaHQ/os   # clone to ~/src/github.com/telematicaHQ/os and cd in
repo os                  # jump to any repo under ~/src by name
```

## 📗 TypeScript / Node Setup

### Version switching

`fnm` runs with `--use-on-cd`, so entering a repo switches Node to whatever its
`.nvmrc` pins. Nothing to remember per project.

```bash
fnm install 24 && fnm default 24    # baseline
node --version                      # verify inside a repo
```

### Private GitHub Packages

Repos pulling private scopes (e.g. `@telematicahq/*` from `npm.pkg.github.com`)
read `NODE_AUTH_TOKEN` from the environment. `zshrc.local` populates it from the
`gh` token, which needs the `read:packages` scope:

```bash
gh auth refresh -s read:packages     # one-time, needs a real terminal
```

Without it, `npm install` fails with a **403** on the private package.

### Turborepo gotcha

In a Turborepo monorepo, run tasks through `turbo`, not `npm -w`:

```bash
turbo check-types --filter=backend      # builds workspace deps first ✅
npm run check-types -w backend          # skips the task graph ❌
```

The second form reports dozens of bogus `Cannot find module '@repo/*'` errors
(and cascading `implicitly has an 'any' type`) simply because dependent packages
haven't been built. There's a `t` alias for `npx turbo` in `zshrc.local`.

## 🐹 Go Setup (secondary)

`GOPATH` stays at `~/go` and holds only the module cache and binaries — source
lives under `~/src` like everything else. The Go block in `zshrc.local` is
guarded by `command -v go`, so it's inert on machines without Go.

`GOPRIVATE` lists **both casings** of the org, because Go matches it against the
module path exactly as written in `go.mod` while GitHub is case-insensitive.
Combined with the SSH rewrite in `gitconfig`, `go mod download` authenticates
over SSH with no tokens involved.

## 🔑 Git Identity

`gitconfig` sets the personal identity globally and layers the work identity on
top **only inside the work org directory**:

```gitconfig
[includeIf "gitdir/i:~/src/github.com/telematicaHQ/"]
	path = ~/.gitconfig-work
```

`~/.gitconfig-work` is **not tracked here** — that keeps a work email out of a
public repo. Create it by hand on each machine:

```bash
cat > ~/.gitconfig-work <<'EOF'
[user]
	email = you@work.example
EOF
```

If the file is missing, git silently ignores the include, so the config stays
portable to machines that don't need it.

Verify both resolve correctly:

```bash
git -C ~/src/github.com/telematicaHQ/any-repo config user.email   # work
git -C ~/src/github.com/kshitij-nawandar9/dotfiles config user.email  # personal
```

> `gitdir/i` is the case-insensitive form. It matters because macOS filesystems
> are case-insensitive, so `cd`-ing to a differently-cased path would otherwise
> silently skip the work identity.

### SSH rewrite scope

```gitconfig
[url "git@github.com:telematicaHQ/"]
	insteadOf = https://github.com/telematicaHQ/
```

Scoped deliberately to your own orgs. A blanket
`git@github.com: insteadOf https://github.com/` rewrites **every** GitHub URL to
SSH, which breaks any tool cloning a public repo over https — including the
Homebrew installer, which fails with `Permission denied (publickey)` on a
machine that has no key yet.

## 📤 Pushing Changes

```bash
cd ~/src/github.com/kshitij-nawandar9/dotfiles
git add .
git commit -m "Update configs"
git push
```

## 📝 Files

- `zshrc` - Zsh configuration (portable layer, always overwritten on install)
- `zshrc.local` - Machine-local layer: Go env, `GOPRIVATE`, `gclone`/`repo`
  helpers. Seeds `~/.zshrc.local` only if absent — never clobbered
- `gitconfig` - Git defaults + per-directory identity
- `gitignore_global` - Global gitignore (`.DS_Store`, editor cruft, `__debug_bin*`)
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

Edit the files **in this repo**, then re-run `./install.sh` to push them out.
Copying the other direction also works if you edited a config in place:

```bash
cd ~/src/github.com/kshitij-nawandar9/dotfiles
cp ~/.config/starship.toml starship.toml
cp ~/.gitconfig gitconfig

git add . && git commit -m "Update configs" && git push
```

Do **not** copy `~/.zshrc.local` back into `zshrc.local` without reading the
diff — the live file is where machine-specific values accumulate, and some of
them (work paths, tokens) don't belong in a public repo.

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

### Homebrew install fails with `Permission denied (publickey)`
A global SSH rewrite in `~/.gitconfig` is redirecting Homebrew's https clone to
SSH. Confirm with:

```bash
git ls-remote --get-url https://github.com/Homebrew/brew   # must stay https
```

If it prints `git@github.com:...`, your `insteadOf` is unscoped. Use the
per-org form shown in [SSH rewrite scope](#ssh-rewrite-scope).

If the install already half-completed, `/opt/homebrew` exists but is empty. It's
owned by you at that point, so no `sudo` is needed to finish it:

```bash
git -C /opt/homebrew fetch --force origin
git -C /opt/homebrew reset --hard origin/main
```

### Homebrew install aborts with `Need sudo access`
You're running it through a pipe or non-TTY shell, so `sudo` can't prompt. Run
it in Terminal.app directly. (Check you're an admin with `id -Gn | grep admin`.)

### A command vanished after running `install.sh`
`install.sh` overwrites `~/.zshrc` wholesale. If a `PATH` entry lived only in
your local `~/.zshrc`, it's gone. Restore from the backup it made:

```bash
ls -t ~/.zshrc.backup.*
```

Then move the missing line into `~/.zshrc.local` so it survives next time.

### `go mod download` fails with 410 Gone or a checksum mismatch
The module path's casing doesn't match `GOPRIVATE`, or the repo is private and
the SSH rewrite isn't applying. Check both:

```bash
echo $GOPRIVATE
git ls-remote --get-url https://github.com/telematicaHQ/some-repo  # want git@...
```

### Commits show the wrong email
The per-directory identity only applies under the work org path. Check with
`git config user.email` inside the repo. Note that `git commit --amend`
preserves the original author — use `--amend --reset-author` to correct it.

## 📚 Resources

- [Starship Documentation](https://starship.rs/)
- [Zsh Documentation](https://zsh.sourceforge.io/)
- [Nerd Fonts](https://www.nerdfonts.com/)

---

**Made with ❤️ for productivity**
