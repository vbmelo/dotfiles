#!/usr/bin/env zsh
# ==========================
# Dotfiles Installation Script
# ==========================
# Author: vb
# Description: Automated setup for Ghostty, TMUX, and Zsh configuration
# ==========================

set -e  # Exit on error

echo "🚀 Starting dotfiles installation..."
echo ""

# ==========================
# 1. Check and Install Homebrew
# ==========================
if ! command -v brew &>/dev/null; then
    echo "❌ Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "✅ Homebrew installed!"
else
    echo "✅ Homebrew already installed"
fi

echo ""

# ==========================
# 2. Check and Install TMUX
# ==========================
if ! command -v tmux &>/dev/null; then
    echo "❌ TMUX not found. Installing TMUX..."
    brew install tmux
    echo "✅ TMUX installed!"
else
    echo "✅ TMUX already installed ($(tmux -V))"
fi

echo ""

# ==========================
# 3. Check and Install Ghostty
# ==========================
if [ ! -d "/Applications/Ghostty.app" ]; then
    echo "❌ Ghostty not found."
    echo "⚠️  Please install Ghostty manually from: https://ghostty.org"
    echo "    Press ENTER when done, or Ctrl+C to cancel..."
    read
else
    echo "✅ Ghostty already installed"
fi

echo ""

# ==========================
# 4. Check Oh My Zsh
# ==========================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "❌ Oh My Zsh not found. Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installed!"
else
    echo "✅ Oh My Zsh already installed"
fi

echo ""

# ==========================
# 5. Check Powerlevel10k
# ==========================
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "❌ Powerlevel10k not found. Installing..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo "✅ Powerlevel10k installed!"
else
    echo "✅ Powerlevel10k already installed"
fi

echo ""

# ==========================
# 6. Check Zsh Plugins
# ==========================
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "❌ zsh-autosuggestions not found. Installing..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "✅ zsh-autosuggestions installed!"
else
    echo "✅ zsh-autosuggestions already installed"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "❌ zsh-syntax-highlighting not found. Installing..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "✅ zsh-syntax-highlighting installed!"
else
    echo "✅ zsh-syntax-highlighting already installed"
fi

echo ""

# ==========================
# 7. Backup existing configs
# ==========================
echo "📦 Backing up existing configs..."

BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc"
[ -f "$HOME/.tmux.conf" ] && cp "$HOME/.tmux.conf" "$BACKUP_DIR/.tmux.conf"
[ -f "$HOME/.config/ghostty/config" ] && cp "$HOME/.config/ghostty/config" "$BACKUP_DIR/ghostty_config"
[ -f "$HOME/.config/ghostty/start-session.sh" ] && cp "$HOME/.config/ghostty/start-session.sh" "$BACKUP_DIR/start-session.sh"

echo "✅ Backup saved to: $BACKUP_DIR"
echo ""

# ==========================
# 8. Install configs
# ==========================
echo "📝 Installing new configs..."

# TMUX
TMUX_SRC="tmux/.tmux.conf"
TMUX_DEST="$HOME/.tmux.conf"
if [ -f "$TMUX_DEST" ]; then
    echo ""
    echo "Comparing $TMUX_DEST with $TMUX_SRC..."
    DIFF_TMP="/tmp/dotfiles_diff_tmux_$$"
    if diff -u "$TMUX_DEST" "$TMUX_SRC" > "$DIFF_TMP"; then
        echo "No differences found between $TMUX_DEST and $TMUX_SRC. Skipping copy."
    else
        echo "Differences found between $TMUX_DEST and $TMUX_SRC:"
        cat "$DIFF_TMP"
        read -k 1 "REPLY?Replace $TMUX_DEST now? (y/N): "
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp "$TMUX_SRC" "$TMUX_DEST"
            echo "✅ TMUX config installed"
        else
            echo "⏭️  Skipped TMUX config"
        fi
    fi
    rm -f "$DIFF_TMP"
else
    cp "$TMUX_SRC" "$TMUX_DEST"
    echo "✅ TMUX config installed"
fi

# Zsh (merge with existing)
echo ""
echo "⚠️  For .zshrc, you should manually merge or replace."
echo "   Your backup is at: $BACKUP_DIR/.zshrc"
echo "   New config is at: zsh/.zshrc"
echo ""
read -k 1 "REPLY?   Replace .zshrc now? (y/N): "
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cp zsh/.zshrc "$HOME/.zshrc"
    echo "✅ .zshrc replaced"
else
    echo "⏭️  Skipped .zshrc - merge manually if needed"
fi

# Ghostty
GHOSTTY_DIR="$HOME/.config/ghostty"
mkdir -p "$GHOSTTY_DIR"

for f in config start-session.sh; do
    SRC_FILE="ghostty/$f"
    DEST_FILE="$GHOSTTY_DIR/$f"
    if [ -f "$DEST_FILE" ]; then
        echo ""
        echo "Comparing $DEST_FILE with $SRC_FILE..."
        DIFF_TMP="/tmp/dotfiles_diff_ghost_${f}_$$"
        if diff -u "$DEST_FILE" "$SRC_FILE" > "$DIFF_TMP"; then
            echo "No differences found between $DEST_FILE and $SRC_FILE. Skipping copy."
        else
            echo "Differences found between $DEST_FILE and $SRC_FILE:"
            cat "$DIFF_TMP"
            read -k 1 "REPLY?Replace $DEST_FILE now? (y/N): "
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                cp "$SRC_FILE" "$DEST_FILE"
                echo "✅ Ghostty $f installed"
            else
                echo "⏭️  Skipped $f"
            fi
        fi
        rm -f "$DIFF_TMP"
    else
        cp "$SRC_FILE" "$DEST_FILE"
        echo "✅ Ghostty $f installed"
    fi
done

chmod +x "$GHOSTTY_DIR/start-session.sh"

echo ""

# ==========================
# 9. Done!
# ==========================
echo "🎉 Installation complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc"
echo "   2. Open Ghostty - TMUX session will start automatically"
echo "   3. If you want to configure Powerlevel10k, run: p10k configure"
echo ""
echo "📚 TMUX Shortcuts:"
echo "   • Ctrl+a + Tab       → Next window"
echo "   • Ctrl+a + n         → New window"
echo "   • Ctrl+a + q         → Close window"
echo "   • Ctrl+a + |         → Split vertical"
echo "   • Ctrl+a + -         → Split horizontal"
echo "   • Alt + Arrows       → Navigate panes"
echo ""
echo "✨ Happy coding!"

# Optional: offer to source ~/.zshrc now
echo ""
echo "🔁  Zsh config — source ~/.zshrc (note about interactive shells)"
echo "──────────────────────────────────────────────────────────────"
echo ""
read -k 1 "REPLY?Source ~/.zshrc now in this script process? (y/N): "
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Sourcing inside this script will only affect the script process; still offer it for completeness
    set +e
    if source "$HOME/.zshrc" 2>/dev/null; then
        echo "✅  ~/.zshrc sourced in this process."
        echo "If you ran this script as a command, run in your interactive shell to apply:"
        echo ""
        echo "   source ~/.zshrc"
        echo ""
    else
        echo "⚠️  Failed to source ~/.zshrc in the script process."
        echo "Manual command to run in your interactive shell:" 
        echo ""
        echo "   source ~/.zshrc"
        echo ""
    fi
    set -e
else
    echo "⏭️  Skipped sourcing ~/.zshrc. To apply changes in your shell, run:"
    echo ""
    echo "   source ~/.zshrc"
    echo ""
fi

# Optional: offer to apply the new tmux config now and optionally kill tmux server
echo ""
if command -v tmux &>/dev/null; then
    echo "🔁  TMUX configuration — reload or restart sessions"
    echo "──────────────────────────────────────────────"
    echo ""
    read -k 1 "REPLY?Apply new tmux config now? (y/N): "
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Temporarily disable errexit for optional commands
        set +e
        tmux source-file "$HOME/.tmux.conf" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "✅  tmux config reloaded (for sessions that accept it)."
            echo ""
            echo "If some sessions did not pick up the change, try these commands:" 
            echo ""
            echo "   Reload current session:  tmux source-file ~/.tmux.conf"
            echo "   Force restart all sessions: tmux kill-server   # will terminate all tmux sessions"
            echo ""
            read -k 1 "REPLY?Kill all tmux sessions to force a full restart? (y/N): "
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                tmux kill-server 2>/dev/null && echo "✅  All tmux sessions killed. Start tmux again to use the new config." || echo "⚠️  Failed to kill tmux server or no tmux server running."
            else
                echo "⏭️  Skipped killing tmux server."
            fi
        else
            echo "⚠️  Could not reload tmux config into the current session."
            echo ""
            echo "Try these commands manually in your shell:"
            echo ""
            echo "   tmux source-file ~/.tmux.conf"
            echo "   tmux kill-server   # (will terminate all tmux sessions)"
            echo ""
        fi
        set -e
    else
        echo "⏭️  Skipped reloading tmux config. You can run 'tmux source-file ~/.tmux.conf' later."
    fi
else
    echo "tmux not found on PATH; skipping tmux reload/kill prompts."
fi