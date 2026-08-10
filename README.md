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

- **Directory navigation** with:
  - `zoxide` bound to `cd` itself — jump anywhere from a few characters
  - `fzf` for interactive picking (`Ctrl+T`, `Ctrl+R`, `Alt+C`, `cdi`, `fcd`)
  - `fd` as the fast, `.gitignore`-aware directory walker behind both

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
wins.

**Keep `~/.zshrc.local` small.** Because it's seeded once and never overwritten,
whatever lands there is *frozen on every machine that has already run the
installer* — an improvement to it will silently never reach them. Only two kinds
of thing justify that cost:

1. **secrets and credentials**, which can't go in a public repo
2. **values that genuinely differ between machines**

Everything else — helper functions, aliases, toolchain setup that's the same
everywhere — belongs in `zshrc`, where re-running `install.sh` actually
propagates it. In practice that leaves `zshrc.local` holding just
`NODE_AUTH_TOKEN` and the Go block.

> ⚠️ `install.sh` copies `zshrc` over `~/.zshrc` unconditionally. Any edit you
> make directly to `~/.zshrc` is lost on the next run — edit `zshrc` in this
> repo and re-install, or put it in `~/.zshrc.local`. A timestamped backup is
> written to `~/.zshrc.backup.*` each time.

> ⚠️ The flip side: a change to `zshrc.local` in this repo reaches only *new*
> machines. To roll one out to a machine you already use, apply it to
> `~/.zshrc.local` by hand. This is the main reason to keep that file thin.

## 📁 Repo Layout

Repos live at `~/src/<host>/<org>/<repo>` — so `github.com/telematicaHQ/os` is at
`~/src/github.com/telematicaHQ/os`. The path is derivable from the repo URL and
vice versa, and it's what the per-directory git identity keys off.

```bash
gclone telematicaHQ/os   # clone to ~/src/github.com/telematicaHQ/os and cd in
repo os                  # jump to any repo under ~/src by name
```

`repo` jumps straight there on a single match and opens an `fzf` picker when
several repos match, rather than silently taking the first hit.

## 🧭 Directory Navigation

You rarely need to type or remember a full path. Three tools cover three
different situations:

| You want | Use | Notes |
|---|---|---|
| A directory you've visited before | `cd <few chars>` | zoxide, ranked by frecency |
| To browse everything you've visited | `cdi` | fzf picker over the zoxide database |
| A subdirectory of where you are | `Alt+C` | fzf, standard binding |
| Any directory under `~/src`, ever visited or not | `fcd [query]` | fzf over the whole tree |
| A repo by name | `repo <name>` | matches `~/src/<host>/<org>/<repo>` |
| To *open* a repo in your editor | `code <few chars>` | same shorthand as `cd` |

### `cd` is zoxide now

`cd` learns every directory you visit and ranks them, so a fragment is enough:

```bash
cd dot            # -> ~/src/github.com/kshitij-nawandar9/dotfiles
cd tele os        # -> ~/src/github.com/telematicaHQ/os   (keywords are ANDed)
cdi               # interactive picker over everything zoxide knows
```

Ordinary `cd` behaviour is untouched — `cd ..`, `cd ./sub`, `cd ~/src`, `cd -`
and paths with spaces all go to the real builtin. Only a *non-path* argument is
treated as a search. Scripts are unaffected: this is an interactive-shell
function, and non-interactive shells never source `~/.zshrc`.

> zoxide only knows where you've **already been**, so `cd foo` finds nothing on
> a fresh machine or for a repo you've never opened. That's what `fcd` is for —
> it searches the actual filesystem. Once you've landed somewhere once, `cd`
> gets you back.

### Cold search with `fcd`

```bash
fcd               # fzf over every directory under ~/src
fcd api           # same, pre-filtered — jumps immediately if only one matches
```

With multiple matches you get the picker with the best match already on top
(fzf's `--scheme=path` scores the final path segment highest, so
`dotfiles/nvim` outranks an incidental hit deep in a `node_modules`-adjacent
tree). `.git` and `node_modules` are excluded from the walk.

### Editors take the same shorthand

`code` accepts the same fragments `cd` does, so you can open a repo without
knowing where it lives:

```bash
code dot          # opens ~/src/github.com/kshitij-nawandar9/dotfiles
code tele os      # opens ~/src/github.com/telematicaHQ/os
```

The wrapper is deliberately conservative, because `code` is also how you create
a new file. An argument reaches zoxide only when **every** argument is a bare
word — no leading dash, no slash, no dot, and nothing that already exists on
disk — *and* zoxide recognises it. Everything else is passed straight through:

| Command | Behaviour |
|---|---|
| `code newfile.ts` | stock — creates the file, never redirected (has a dot) |
| `code src/app.ts` | stock — has a slash |
| `code .` / `code ~/src` | stock — the path exists |
| `code --diff a.ts b.ts` | stock — starts with a dash |
| `code existingdir` | stock — a local directory always beats the database |
| `code unknownword` | stock — zoxide has no match, so nothing is substituted |
| `code dot` | resolved via zoxide |

Wrappers are defined only for editors actually installed on the machine, so
nothing shadows a missing command. `cursor` is included in the list and will
start working automatically if you install it.

### Keybindings from fzf

- `Ctrl+T` — insert a file path into the current command line
- `Ctrl+R` — fuzzy history search (replaces the default reverse-search)
- `Alt+C` — cd into a subdirectory of the current directory

`Alt+C` needs `macos_option_as_alt yes` in `kitty.conf` — already set. Your
`↑`/`↓` prefix history search is unaffected; fzf only takes `Ctrl+R`.

Everything above is guarded by `command -v`, so `zshrc` stays portable to a
machine where these tools aren't installed — you just get plain `cd` back.

## 📗 TypeScript / Node Setup

### Version switching

`fnm` runs with `--use-on-cd`, so entering a repo switches Node to whatever its
`.nvmrc` pins. Nothing to remember per project. It hooks `chpwd` rather than the
`cd` command itself, so it fires on a zoxide jump (`cd os`) exactly as it does
on a literal `cd ./path`.

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
haven't been built. There's a `t` helper for `npx turbo` in `zshrc`.

## 🐹 Go Setup (secondary)

`GOPATH` stays at `~/go` and holds only the module cache and binaries — source
lives under `~/src` like everything else. The Go block stays in `zshrc.local`
because `GOPRIVATE` is org-specific rather than portable, and it is
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

- `zshrc` - Zsh configuration (portable layer, always overwritten on install).
  Includes the zoxide/fzf navigation block — see [Directory Navigation](#-directory-navigation)
- `zshrc.local` - Machine-local layer, deliberately minimal: `NODE_AUTH_TOKEN`
  and the Go/`GOPRIVATE` block. Seeds `~/.zshrc.local` only if absent — never
  clobbered, and therefore never updated on an existing machine either
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

### `cd <name>` says "no match found"

zoxide only knows directories you've actually visited. On a fresh machine its
database is empty, so seed it by navigating normally for a bit — or use `fcd`,
which searches the filesystem instead of the history.

If it's a directory you *have* visited, check what zoxide recorded:

```bash
zoxide query -l | grep -i <name>     # what it knows
zoxide query -l -s | head            # with frecency scores
```

### `cd` jumps to the wrong directory

Two directories match and the wrong one scores higher. Either add a second
keyword (`cd tele os` instead of `cd os`), or correct the ranking:

```bash
zoxide remove /path/you/never/want    # drop a stale entry
```

Deleted directories are pruned automatically on the next failed jump.

### `Alt+C` does nothing

The terminal is sending `ç` instead of a real Alt. In Kitty this needs
`macos_option_as_alt yes` (already in `kitty/kitty.conf`); in Terminal.app it's
Settings → Profiles → Keyboard → "Use Option as Meta key".

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
