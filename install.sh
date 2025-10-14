#!/bin/zsh
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
cp tmux/.tmux.conf "$HOME/.tmux.conf"
echo "✅ TMUX config installed"

# Zsh (merge with existing)
echo ""
echo "⚠️  For .zshrc, you should manually merge or replace."
echo "   Your backup is at: $BACKUP_DIR/.zshrc"
echo "   New config is at: zsh/.zshrc"
echo ""
read -p "   Replace .zshrc now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cp zsh/.zshrc "$HOME/.zshrc"
    echo "✅ .zshrc replaced"
else
    echo "⏭️  Skipped .zshrc - merge manually if needed"
fi

# Ghostty
mkdir -p "$HOME/.config/ghostty"
cp ghostty/config "$HOME/.config/ghostty/config"
cp ghostty/start-session.sh "$HOME/.config/ghostty/start-session.sh"
chmod +x "$HOME/.config/ghostty/start-session.sh"
echo "✅ Ghostty config installed"

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
