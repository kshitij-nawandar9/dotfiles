# 📝 Neovim + LazyVim Quick Start Guide

> Your complete guide to using Neovim with LazyVim

---

## 🎯 The Basics: Understanding Vim Modes

Neovim has different **modes** for different tasks:

| Mode | Purpose | How to Enter | Indicator |
|------|---------|--------------|-----------|
| **NORMAL** | Navigate & execute commands | `Esc` | Default |
| **INSERT** | Type/edit text | `i` | `-- INSERT --` |
| **VISUAL** | Select text | `v` | `-- VISUAL --` |
| **COMMAND** | Run commands | `:` | `:` at bottom |

**Golden Rule:** Press `Esc` to go back to NORMAL mode from anywhere.

---

## 🚀 Quick Start: First 5 Minutes

### Open a File
```bash
nvim filename.txt
nvim .                  # Open current directory
```

### Basic Editing
1. Press `i` to enter INSERT mode
2. Type your text
3. Press `Esc` to exit INSERT mode
4. Type `:w` and press `Enter` to save
5. Type `:q` and press `Enter` to quit

**Or combine:** `:wq` to save and quit

---

## ⌨️  Essential Keybindings

### The Leader Key: `Space`

In LazyVim, `Space` is your **Leader** key. Press it to see available commands!

---

## 📁 File Navigation

| Keys | Action |
|------|--------|
| `Space + e` | Toggle file explorer (Neo-tree) |
| `Space + E` | Focus file explorer |
| `Space + ff` | **Find files** (fuzzy search) |
| `Space + fr` | Recent files |
| `Space + fg` | Find text in files (grep) |
| `Space + /` | Search in current file |
| `Space + ,` | Switch between open buffers |

**In File Explorer:**
- `Enter` - Open file
- `a` - Create new file
- `d` - Delete file
- `r` - Rename file
- `q` - Close explorer

---

## 📝 Basic Movement (NORMAL mode)

### Character Movement
```
     k (up)
     ↑
h ← • → l
     ↓
   j (down)
```

| Key | Movement |
|-----|----------|
| `h` | Left |
| `j` | Down |
| `k` | Up |
| `l` | Right |

### Word Movement
| Key | Movement |
|-----|----------|
| `w` | Next word |
| `b` | Previous word |
| `e` | End of word |

### Line Movement
| Key | Movement |
|-----|----------|
| `0` | Start of line |
| `^` | First non-blank character |
| `$` | End of line |
| `gg` | Top of file |
| `G` | Bottom of file |
| `12G` | Go to line 12 |

### Screen Movement
| Key | Movement |
|-----|----------|
| `Ctrl + u` | Page up |
| `Ctrl + d` | Page down |
| `zz` | Center screen on cursor |

---

## ✏️  Editing Text

### Entering INSERT Mode
| Key | Action |
|-----|--------|
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `I` | Insert at start of line |
| `A` | Insert at end of line |
| `o` | New line below |
| `O` | New line above |

### Deleting (in NORMAL mode)
| Key | Action |
|-----|--------|
| `x` | Delete character |
| `dd` | Delete line |
| `dw` | Delete word |
| `d$` | Delete to end of line |
| `d0` | Delete to start of line |

### Copy & Paste
| Key | Action |
|-----|--------|
| `yy` | Copy (yank) line |
| `yw` | Copy word |
| `p` | Paste after cursor |
| `P` | Paste before cursor |

### Undo & Redo
| Key | Action |
|-----|--------|
| `u` | Undo |
| `Ctrl + r` | Redo |

---

## 🎨 Visual Mode (Selecting Text)

| Key | Action |
|-----|--------|
| `v` | Start visual mode (character) |
| `V` | Start visual line mode |
| `Ctrl + v` | Start visual block mode |

**Once in Visual mode:**
- Move cursor to select text
- `y` - Copy selection
- `d` - Delete selection
- `>` - Indent right
- `<` - Indent left

---

## 🔍 Search & Replace

### Search
| Key | Action |
|-----|--------|
| `/text` | Search forward for "text" |
| `?text` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `*` | Search word under cursor |

### Replace
```
:%s/old/new/g       - Replace all in file
:%s/old/new/gc      - Replace all with confirmation
:s/old/new/g        - Replace in current line
```

---

## 🪟 Window & Tab Management

### Split Windows
| Key | Action |
|-----|--------|
| `Space + \|` | Split vertical |
| `Space + -` | Split horizontal |
| `Ctrl + h` | Move to left window |
| `Ctrl + j` | Move to down window |
| `Ctrl + k` | Move to up window |
| `Ctrl + l` | Move to right window |
| `Space + wd` | Close window |

### Tabs
| Key | Action |
|-----|--------|
| `Space + <tab> + l` | Last tab |
| `Space + <tab> + ]` | Next tab |
| `Space + <tab> + [` | Previous tab |
| `Space + <tab> + d` | Close tab |

---

## 💻 Code Editing (LazyVim Specific)

### LSP (Language Server - Code Intelligence)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Show references |
| `K` | Show hover documentation |
| `Space + ca` | Code actions |
| `Space + cr` | Rename symbol |
| `]d` | Next diagnostic (error) |
| `[d` | Previous diagnostic |

### Comments
| Key | Action |
|-----|--------|
| `gcc` | Toggle comment (line) |
| `gc` (in visual) | Toggle comment (selection) |

### Code Formatting
| Key | Action |
|-----|--------|
| `Space + cf` | Format file |

---

## 🔧 Git Integration (Lazygit)

| Key | Action |
|-----|--------|
| `Space + gg` | Open Lazygit |
| `Space + gf` | Git file history |
| `]h` | Next git hunk |
| `[h` | Previous git hunk |

**Inside Lazygit:**
- `Space` - Stage/unstage file
- `c` - Commit
- `p` - Push
- `P` - Pull
- `q` - Quit Lazygit

---

## 📋 Buffer Management

Buffers = open files in memory

| Key | Action |
|-----|--------|
| `Space + ,` | Switch buffers |
| `Space + bd` | Delete buffer (close file) |
| `[b` | Previous buffer |
| `]b` | Next buffer |

---

## ⚙️  LazyVim Specific Commands

| Key | Action |
|-----|--------|
| `Space + l` | Open Lazy plugin manager |
| `Space + cm` | Mason (install LSP servers) |
| `Space + xx` | Trouble (error list) |
| `Space + uC` | Choose colorscheme |
| `Space + ?` | Help (shows all keymaps) |

---

## 🎓 Learning Path: Day by Day

### Day 1: Basic Navigation
- Practice `hjkl` movement
- Use `i` to insert, `Esc` to exit
- Save with `:w`, quit with `:q`
- Open file explorer with `Space + e`

### Day 2: File Operations
- `Space + ff` to find files
- `Space + /` to search
- `dd` to delete lines
- `yy` to copy, `p` to paste

### Day 3: Better Editing
- Try `o` for new line
- Use `A` to append at end
- Practice `w` and `b` for word movement
- Try visual mode with `v`

### Day 4: Code Features
- `gd` to jump to definitions
- `K` to see documentation
- `gcc` to comment lines
- `Space + ca` for code actions

### Week 2: Advanced
- Learn split windows
- Master git integration
- Customize your config
- Install language-specific plugins

---

## 🛠️ Customization

### Install Language Support

1. Open Neovim: `nvim`
2. Press `Space + x` - Opens LazyExtras menu
3. Select language packs:
   - `lang.typescript`
   - `lang.python`
   - `lang.go`
   - `lang.rust`
   - etc.

### Install LSP Servers

1. Press `Space + cm` - Opens Mason
2. Navigate with `j/k`
3. Press `i` on a server to install
   - `typescript-language-server`
   - `pyright` (Python)
   - `gopls` (Go)
   - `rust-analyzer`

### Change Theme

```
Space + uC
```
Use arrow keys to preview, Enter to select.

---

## 🐛 Common Issues

### Can't exit Neovim?
- Press `Esc`
- Type `:q!` and press Enter (force quit without saving)

### Accidentally in weird mode?
- Press `Esc` multiple times
- Should return to NORMAL mode

### Text is selected strangely?
- You're in VISUAL mode
- Press `Esc` to exit

### Commands not working?
- Make sure you're in NORMAL mode (press `Esc`)
- Commands only work in NORMAL mode

---

## 💡 Pro Tips

### Tip 1: Don't Use Arrow Keys
Force yourself to use `hjkl`. You'll be faster in a week!

### Tip 2: Use Relative Line Numbers
Already enabled! Jump 5 lines down: `5j`

### Tip 3: Learn One Thing Daily
Don't try to learn everything at once. Master one keybinding per day.

### Tip 4: Use Which-Key
Press `Space` and wait. LazyVim shows all available commands!

### Tip 5: Practice with :Tutor
Run `:Tutor` inside Neovim for interactive lessons.

---

## 🎯 Common Workflows

### Workflow 1: Quick Edit
```bash
nvim file.txt
i                    # Insert mode
# Type your changes
Esc
:wq                 # Save and quit
```

### Workflow 2: Code Development
```bash
nvim .              # Open current directory
Space + e           # File explorer
# Navigate to file, press Enter
i                   # Start editing
# Make changes
Esc
Space + cf          # Format code
:w                  # Save
Space + gg          # Open Lazygit
# Stage, commit, push
```

### Workflow 3: Search & Replace
```bash
nvim .
Space + fg          # Search in files
# Type search term
Enter on result
:%s/old/new/gc      # Replace with confirmation
:wa                 # Save all files
```

---

## 📚 Cheat Sheet (Print This!)

```
MODES:              MOVEMENT:           EDITING:
i    - Insert       h/j/k/l - arrows   dd - Delete line
v    - Visual       w/b     - words    yy - Copy line
Esc  - Normal       gg/G    - top/bot  p  - Paste
:    - Command      0/$     - line     u  - Undo

LAZYVIM:            FILES:              CODE:
Space + e  - Explorer   Space + ff - Find     gd - Definition
Space + /  - Search     Space + ,  - Buffers  K  - Docs
Space + gg - Git        :w  - Save            gcc - Comment
Space + ?  - Help       :q  - Quit            Space + ca - Actions
```

---

## 🔗 Resources

- **LazyVim Docs**: https://www.lazyvim.org/
- **Neovim Basics**: Run `:Tutor` inside Neovim
- **Video Tutorial**: https://www.youtube.com/watch?v=stqUbv-5u2s
- **Keymaps**: Press `Space + ?` inside Neovim

---

## 🎮 Practice Exercise

Try this to get started:

1. `nvim practice.txt`
2. Press `i` and type: "Hello Neovim!"
3. Press `Esc`
4. Type `:w` to save
5. Press `o` to create new line
6. Type: "I'm learning Vim!"
7. Press `Esc`
8. Type `gg` to go to top
9. Type `yy` to copy first line
10. Type `G` to go to bottom
11. Type `p` to paste
12. Type `:wq` to save and quit

Congratulations! You've done basic Vim operations! 🎉

---

**Remember:** Vim has a learning curve, but after a week of practice, you'll be much faster than any regular editor!

**Start small, practice daily, and you'll master it!** 🚀
