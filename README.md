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
