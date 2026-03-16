# 🪟 Aerospace Window Manager Guide

> Keyboard-driven tiling window manager for macOS (like i3 for Linux)

---

## 🎯 What is Aerospace?

Aerospace automatically arranges your windows in a tiled layout and lets you control everything with keyboard shortcuts. No more dragging windows around!

**Benefits:**
- ⌨️  Fully keyboard-driven (no mouse needed)
- 🪟 Automatic window tiling
- 📊 Multiple workspaces (like virtual desktops)
- 🚀 Faster workflow once you learn it

---

## 🚀 Getting Started

### 1. Launch Aerospace

Aerospace should auto-start after installation. If not:

```bash
open -a AeroSpace
```

**You won't see anything!** Aerospace runs in the background.

### 2. Grant Accessibility Permissions

1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Find **AeroSpace** in the list
3. Toggle it **ON**
4. Restart AeroSpace

---

## ⌨️  Essential Keybindings

> All commands use `Alt` (Option) key

### 🧭 Window Focus (Navigate Between Windows)

```
Alt + h     - Focus window to the LEFT
Alt + j     - Focus window BELOW
Alt + k     - Focus window ABOVE
Alt + l     - Focus window to the RIGHT
```

**Think Vim:** `hjkl` for navigation!

---

### 🚚 Move Windows

```
Alt + Shift + h     - Move window LEFT
Alt + Shift + j     - Move window DOWN
Alt + Shift + k     - Move window UP
Alt + Shift + l     - Move window RIGHT
```

---

### 📋 Workspaces (Virtual Desktops)

```
Alt + 1     - Go to workspace 1
Alt + 2     - Go to workspace 2
Alt + 3     - Go to workspace 3
...         - Up to workspace 9
```

**Think of workspaces as separate desktops:**
- Workspace 1: Browser
- Workspace 2: Code editor
- Workspace 3: Terminal
- Workspace 4: Slack/Communication
- etc.

---

### 📦 Move Window to Workspace

```
Alt + Shift + 1     - Move current window to workspace 1
Alt + Shift + 2     - Move current window to workspace 2
Alt + Shift + 3     - Move current window to workspace 3
...                 - Up to workspace 9
```

---

### 🎨 Layout Management

```
Alt + /            - Toggle between horizontal/vertical split
Alt + ,            - Toggle accordion layout
Alt + f            - Toggle fullscreen
Alt + Shift + Space - Toggle floating/tiling
```

---

### 📏 Resize Mode

```
Alt + r            - Enter RESIZE mode
  (then use:)
  h / l            - Decrease/increase width (big steps)
  j / k            - Increase/decrease height (big steps)
  Shift + h/j/k/l  - Fine-tune resize (small steps)
  Esc or Enter     - Exit resize mode
```

---

### 🔧 System Commands

```
Alt + Shift + c    - Reload Aerospace config
Alt + Shift + e    - Close current window
Alt + Enter        - Open new Terminal
```

---

## 🎓 Beginner Workflow Examples

### Example 1: Basic Window Navigation

1. Open **Safari**
2. Press `Alt + Enter` to open **Terminal**
3. Aerospace automatically tiles them side-by-side
4. Press `Alt + h` to focus Safari
5. Press `Alt + l` to focus Terminal

**You've navigated without touching the mouse!** 🎉

---

### Example 2: Using Workspaces

1. Press `Alt + 1` - Workspace 1
2. Open **Safari** here
3. Press `Alt + 2` - Workspace 2
4. Open **VS Code** here
5. Press `Alt + 3` - Workspace 3
6. Open **Terminal** here
7. Press `Alt + 1` to go back to Safari

**Now you can switch instantly between different contexts!**

---

### Example 3: Organizing Windows

1. Open **3 Terminal windows**
2. Aerospace tiles them automatically
3. Press `Alt + h/j/k/l` to navigate between them
4. Press `Alt + Shift + h` to move one left
5. Press `Alt + r` to enter resize mode
6. Press `l` a few times to make it wider
7. Press `Esc` to exit resize mode

---

### Example 4: Full Workflow

**Scenario:** Setting up dev environment

1. `Alt + 1` - Go to workspace 1
2. Open **Browser** (for docs)
3. `Alt + 2` - Go to workspace 2
4. Open **Neovim/Editor** (for coding)
5. `Alt + Enter` - Open Terminal in same workspace
6. They tile automatically side-by-side
7. `Alt + 3` - Go to workspace 3
8. Open **Slack/Chat**

**Now:**
- `Alt + 1` = Docs
- `Alt + 2` = Coding + Terminal
- `Alt + 3` = Communication

**Switch instantly!**

---

## 📚 Layout Concepts

### Tiling Layout (Default)

Windows automatically tile to fill space:

```
┌─────────┬─────────┐
│         │         │
│    A    │    B    │
│         │         │
├─────────┴─────────┤
│                   │
│         C         │
└───────────────────┘
```

### Floating Layout

Windows can overlap (like normal macOS):

```
  ┌──────────┐
  │    A     │
  └──────────┘
    ┌──────────┐
    │    B     │
    └──────────┘
```

Toggle with: `Alt + Shift + Space`

---

## 🎯 Productivity Tips

### Tip 1: Dedicated Workspaces

Assign specific tasks to workspaces:
- **1**: Communication (Email, Slack)
- **2**: Development (Editor + Terminal)
- **3**: Browser (Research, docs)
- **4**: Design (Figma, etc.)
- **5**: Music/Background apps

### Tip 2: Master Focus Movement First

Before learning everything, just master:
- `Alt + h/j/k/l` for navigation
- `Alt + 1/2/3` for workspaces

That alone will boost productivity!

### Tip 3: Use Fullscreen Sparingly

`Alt + f` for fullscreen is great for:
- Presentations
- Reading documentation
- Video calls

But tiling is usually more productive.

### Tip 4: Floating for Dialogs

Some apps work better floating:
- System Preferences
- Activity Monitor
- Small utilities

Toggle with: `Alt + Shift + Space`

---

## 🔧 Configuration

Your config is at: `~/.config/aerospace/aerospace.toml`

### Change Keybindings

Edit the config file:

```toml
# Change focus from Alt+h to Cmd+h
cmd-h = 'focus left'
```

### Change Gaps

```toml
[gaps]
inner.horizontal = 20  # Bigger gap between windows
inner.vertical =   20
outer.left =       20
outer.bottom =     20
outer.top =        20
outer.right =      20
```

### Reload Config

After editing: `Alt + Shift + c`

---

## 🐛 Troubleshooting

### Keybindings not working?

1. Check **System Settings** → **Privacy & Security** → **Accessibility**
2. Make sure **AeroSpace** is enabled
3. Restart AeroSpace: `killall AeroSpace && open -a AeroSpace`

### Windows not tiling?

Some apps don't work well with tiling:
- System Preferences (set to float by default)
- Some Adobe apps
- Games

Solution: Toggle floating with `Alt + Shift + Space`

### AeroSpace not starting?

```bash
# Check if running
ps aux | grep -i aerospace

# Start manually
open -a AeroSpace
```

---

## 📖 Quick Reference Card

```
FOCUS WINDOWS:          MOVE WINDOWS:           WORKSPACES:
Alt + h/j/k/l          Alt + Shift + h/j/k/l   Alt + 1-9

LAYOUTS:                RESIZE:                 SYSTEM:
Alt + /    (split)      Alt + r (enter mode)    Alt + Shift + c (reload)
Alt + ,    (accordion)  h/j/k/l (resize)        Alt + Shift + e (close)
Alt + f    (fullscreen) Esc     (exit)          Alt + Enter     (terminal)
```

---

## 🎯 Learning Path

### Week 1: Basic Navigation
- Practice `Alt + h/j/k/l` daily
- Try switching workspaces `Alt + 1/2/3`
- Get comfortable with window focus

### Week 2: Window Management
- Move windows with `Alt + Shift + h/j/k/l`
- Move windows between workspaces
- Try resize mode `Alt + r`

### Week 3: Advanced
- Customize keybindings
- Set up your workspace workflow
- Adjust gaps and layouts

---

## 💡 Common Workflows

### Workflow: Web Development

```
Alt + 1    → Browser (for testing)
Alt + 2    → Editor + Terminal (side by side)
Alt + 3    → Browser (for docs)
Alt + 4    → Slack
```

### Workflow: Writing/Research

```
Alt + 1    → Browser (research)
Alt + 2    → Editor (writing)
Alt + 3    → Notes app
```

### Workflow: Data Science

```
Alt + 1    → Jupyter Notebook
Alt + 2    → Terminal + VS Code
Alt + 3    → Documentation browser
```

---

## 🚀 Next Steps

1. **Launch Aerospace**: `open -a AeroSpace`
2. **Grant permissions**: System Settings → Privacy → Accessibility
3. **Open 2-3 apps** and watch them tile
4. **Practice navigation**: `Alt + h/j/k/l`
5. **Try workspaces**: `Alt + 1`, `Alt + 2`, `Alt + 3`

---

## 🔗 Resources

- **Official Docs**: https://nikitabobko.github.io/AeroSpace/guide
- **Config Reference**: https://nikitabobko.github.io/AeroSpace/config-reference
- **GitHub**: https://github.com/nikitabobko/AeroSpace

---

**Remember:** The first few days will feel slow. After a week, you'll be faster than ever! 🚀

**Start with just 3 commands:**
1. `Alt + h/l` to navigate
2. `Alt + 1/2` to switch workspaces
3. `Alt + Shift + e` to close windows

Master these first, then gradually add more!
