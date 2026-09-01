# 🚀 My Dotfiles

> Personal development environment setup for macOS with Ghostty, TMUX, and Zsh (Powerlevel10k)

![macOS](https://img.shields.io/badge/macOS-000000?style=flat&logo=apple&logoColor=white)
![Ghostty](https://img.shields.io/badge/Ghostty-Terminal-blue)
![TMUX](https://img.shields.io/badge/TMUX-Multiplexer-green)
![Zsh](https://img.shields.io/badge/Zsh-Shell-orange)

## ✨ Features

-   **Ghostty Terminal** - Modern GPU-accelerated terminal
-   **TMUX** - Persistent terminal sessions with custom keybindings
-   **Zsh + Oh My Zsh** - Enhanced shell experience
-   **Powerlevel10k** - Beautiful and fast prompt theme
-   **Optimized for macOS** - Keyboard shortcuts that don't conflict with system

## 📦 What's Included

```
dotfiles/
├── ghostty/
│   ├── config                  # Ghostty configuration
│   └── start-session.sh        # TMUX session auto-start script
├── tmux/
│   └── .tmux.conf              # TMUX configuration
├── zsh/
│   └── .zshrc                  # Zsh configuration
├── macos/
│   └── airplay-hisense-proxy.sh # AirPlay fix for Hisense VIDAA TV
├── claude/
│   ├── output-styles/caveman.md # Caveman output style (terse prose)
│   ├── commands/caveman.md      # /caveman slash command
│   ├── caveman-toggle.sh        # Toggles Caveman prose + ponytail together
│   └── install-caveman-ponytail.sh # Installs both into ~/.claude
├── install.sh                   # Automated installation script
└── README.md                    # This file
```

## 🎯 Quick Start

### One-line Installation

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### Manual Installation

If you prefer to install manually:

1. **Install Homebrew** (if not installed):

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

2. **Install TMUX**:

    ```bash
    brew install tmux
    ```

3. **Install Ghostty**:

    - Download from [ghostty.org](https://ghostty.org)

4. **Install Oh My Zsh**:

    ```bash
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

5. **Install Powerlevel10k**:

    ```bash
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ```

6. **Install Zsh plugins**:

    ```bash
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    ```

7. **Copy config files**:

    ```bash
    cp tmux/.tmux.conf ~/.tmux.conf
    cp zsh/.zshrc ~/.zshrc
    mkdir -p ~/.config/ghostty
    cp ghostty/config ~/.config/ghostty/config
    cp ghostty/start-session.sh ~/.config/ghostty/start-session.sh
    chmod +x ~/.config/ghostty/start-session.sh
    ```

8. **Restart your terminal** or run:
    ```bash
    source ~/.zshrc
    ```

## ⌨️ TMUX Keybindings

### Window Management

| Shortcut                  | Action                |
| ------------------------- | --------------------- |
| `Ctrl+a` then `Tab`       | Next window           |
| `Ctrl+a` then `Shift+Tab` | Previous window       |
| `Ctrl+a` then `0-9`       | Jump to window number |
| `Ctrl+a` then `n`         | New window            |
| `Ctrl+a` then `q`         | Close window          |

### Pane Management (Splits)

| Shortcut           | Action                      |
| ------------------ | --------------------------- |
| `Ctrl+a` then `\|` | Split vertically            |
| `Ctrl+a` then `-`  | Split horizontally          |
| `Ctrl+a` then `x`  | Close pane                  |
| `Alt+Arrows`       | Navigate panes (no prefix!) |

### Other Commands

| Shortcut          | Action                          |
| ----------------- | ------------------------------- |
| `Ctrl+a` then `r` | Reload TMUX config              |
| `Ctrl+a` then `[` | Scroll mode (press `q` to exit) |

## 🎨 Customization

### TMUX Session Layout

Edit `ghostty/start-session.sh` to customize your workspace layout:

```bash
# Example: Add a new window
$TMUX_BIN new-window -t main:5 -n "My Project" -c ~/Projects/my-project
```

### Ghostty Theme

Edit `ghostty/config` to change the theme:

```
theme = Laser              # Change this
background-opacity = 0.8
background-blur-radius = 30
```

### Zsh Aliases

Add your custom aliases in `zsh/.zshrc` at the bottom:

```bash
alias myalias='my command'
```

## 🔧 Troubleshooting

### TMUX not starting automatically

Make sure the startup script is executable:

```bash
chmod +x ~/.config/ghostty/start-session.sh
```

### Powerlevel10k prompt issues in TMUX

Run the configuration wizard:

```bash
p10k configure
```

### Colors look wrong

Ensure your terminal is set to use true color:

```bash
echo $TERM  # Should be "tmux-256color" inside TMUX
```

### AirPlay: Hisense VIDAA TV missing from Screen Mirroring

The TV's AirPlay 2 receiver is fine (port 7000 is open and answers `/info`) — what
fails is **discovery**: this Wi-Fi drops mDNS multicast (224.0.0.251), so the TV's
Bonjour announcement never reaches the Mac. Note that `ping` to the TV always fails
because the TV drops ICMP; that is not a network problem.

Workaround — ask the TV for the TXT record it *would* advertise and register it
locally, bypassing multicast entirely:

```bash
./macos/airplay-hisense-proxy.sh start      # then: Control Center -> Screen Mirroring
./macos/airplay-hisense-proxy.sh status
./macos/airplay-hisense-proxy.sh stop
./macos/airplay-hisense-proxy.sh diag       # 30s tcpdump, pinpoints the root cause (needs sudo)
./macos/airplay-hisense-proxy.sh install-agent   # persist across reboot
```

The real fix is upstream: either IGMP Snooping on the router, or Internet Sharing
interfering with `mDNSResponder`. Run `diag` to find out which.

## 🦴 Claude Code: Caveman + ponytail

Two settings that cover different halves of the same taste, driven by one switch.

- **Caveman** is an [output style](https://docs.claude.com/en/docs/claude-code/output-styles):
  how the agent *talks*. No preamble, no closing recap, no praise; answer in the
  first words. Code, commands, paths, identifiers, error text and stated risks are
  never compressed — brevity is not allowed to buy a vaguer answer.
- **[ponytail](https://github.com/DietrichGebert/ponytail)** is a plugin: what the
  agent *builds*. It climbs a YAGNI ladder before writing code — does this need to
  exist, is it already in the codebase, does the stdlib or a native platform feature
  cover it, can it be one line — and never simplifies away validation, error
  handling, security or accessibility.

ponytail's own skill file says to pair it with Caveman, which is what this setup
does: `/caveman` writes both settings at once so they cannot drift apart.

### Install

```bash
./claude/install-caveman-ponytail.sh              # install and enable both
./claude/install-caveman-ponytail.sh --no-enable  # install only
```

It copies the output style, the slash command and the toggle script into
`~/.claude` (backing up anything it replaces), rewrites the absolute paths in the
command for your home directory, and installs the ponytail plugin through Claude
Code's plugin manager. ponytail is deliberately *not* vendored here — it has its
own release cadence, so only the glue lives in this repo.

Needs `claude` and `python3`, plus `node` on the **non-interactive** shell's PATH
for ponytail's lifecycle hooks (relevant for nvm and Nix users).

### Usage

| Command | Effect |
|---|---|
| `/caveman on` | Both on, ponytail at `full` |
| `/caveman on lite` | Caveman prose + ponytail names the lazier option, you pick |
| `/caveman on ultra` | Caveman prose + YAGNI extremist |
| `/caveman off` | Both off |
| `/caveman` | Toggle |
| `/caveman status` | Report both |

The ponytail level applies immediately; an output style change may need a new
session. `/ponytail lite|full|ultra|off` still changes the code side alone.

The toggle writes three places: `outputStyle` in `~/.claude/settings.json`,
the live mode in `~/.claude/.ponytail-active`, and `defaultMode` in
`~/.config/ponytail/config.json` (so it survives a restart).

## 🤝 Contributing

Feel free to fork and customize for your own needs!

## 📝 License

MIT License - Feel free to use and modify as you like.

## 🙏 Credits

-   [Ghostty](https://ghostty.org) - Terminal emulator
-   [TMUX](https://github.com/tmux/tmux) - Terminal multiplexer
-   [Oh My Zsh](https://ohmyz.sh) - Zsh framework
-   [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme

---

Made with ❤️ by vb
