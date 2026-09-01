#!/bin/zsh
# ==========================
# Claude Code — Caveman prose + ponytail lazy-code mode
# ==========================
# Author: vb
# Description: Installs the paired Caveman/ponytail setup for Claude Code:
#              the Caveman output style (terse prose), the /caveman slash
#              command, its toggle script, and the ponytail plugin.
#
# WHY THIS EXISTS
#   Caveman and ponytail govern different halves of the same taste. Caveman is
#   an output style: how the agent talks (no preamble, no recap, code and
#   identifiers never compressed). ponytail is a skill: what the agent builds
#   (YAGNI ladder, stdlib and native platform features before dependencies).
#   ponytail's own SKILL.md says to pair it with Caveman, so one switch drives
#   both instead of two settings drifting apart.
#
#   ponytail itself is not vendored here. It is a plugin with its own release
#   cadence, so it is fetched through Claude Code's plugin manager and only the
#   glue lives in this repo.
#
# USAGE
#   ./claude/install-caveman-ponytail.sh            # install, then turn both on
#   ./claude/install-caveman-ponytail.sh --no-enable # install without enabling
#
# AFTERWARDS
#   /caveman on [lite|full|ultra]   both on, at the given ponytail intensity
#   /caveman off                    both off
#   /caveman                        toggle
#   /caveman status                 report both
#
# REQUIREMENTS
#   claude (Claude Code CLI), node on the non-interactive shell's PATH (the
#   ponytail lifecycle hooks are Node scripts), python3 (the toggle script).
# ==========================
set -e

SRC_DIR="${0:A:h}"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
ENABLE=1
[[ "$1" == "--no-enable" ]] && ENABLE=0

echo "🦴 Installing Caveman + ponytail for Claude Code..."
echo ""

# --------------------------
# 1. Requirements
# --------------------------
for bin in claude python3; do
    if ! command -v "$bin" &> /dev/null; then
        echo "❌ $bin not found on PATH. Install it first, then re-run."
        exit 1
    fi
done

if ! command -v node &> /dev/null; then
    echo "⚠️  node not found on PATH. The skills still work, but ponytail's"
    echo "   always-on activation hooks stay quiet. (nvm/Nix users: node must"
    echo "   also be on the non-interactive shell's PATH.)"
    echo ""
fi

# --------------------------
# 2. Back up what we replace
# --------------------------
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
for f in "caveman-toggle.sh" "commands/caveman.md" "output-styles/caveman.md"; do
    if [ -f "$CLAUDE_DIR/$f" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname $f)"
        cp "$CLAUDE_DIR/$f" "$BACKUP_DIR/$f"
        echo "📦 Backed up $f"
    fi
done
[ -d "$BACKUP_DIR" ] && echo "   Backup: $BACKUP_DIR" && echo ""

# --------------------------
# 3. Install the glue
# --------------------------
mkdir -p "$CLAUDE_DIR/commands" "$CLAUDE_DIR/output-styles"
cp "$SRC_DIR/output-styles/caveman.md" "$CLAUDE_DIR/output-styles/caveman.md"
cp "$SRC_DIR/caveman-toggle.sh" "$CLAUDE_DIR/caveman-toggle.sh"
chmod +x "$CLAUDE_DIR/caveman-toggle.sh"

# The slash command names the toggle script by absolute path, both in its
# allowed-tools matcher and in the command it runs, so rewrite the author's
# home to whoever is installing.
sed "s|/Users/vb/.claude|$CLAUDE_DIR|g" \
    "$SRC_DIR/commands/caveman.md" > "$CLAUDE_DIR/commands/caveman.md"

echo "✅ Output style, /caveman command and toggle script installed"

# --------------------------
# 4. ponytail plugin
# --------------------------
if claude plugin list 2>/dev/null | grep -q "ponytail"; then
    echo "✅ ponytail plugin already installed"
else
    echo "⬇️  Installing the ponytail plugin..."
    claude plugin marketplace add DietrichGebert/ponytail
    claude plugin install ponytail@ponytail
fi

# --------------------------
# 5. Turn both on
# --------------------------
echo ""
if [ "$ENABLE" -eq 1 ]; then
    "$CLAUDE_DIR/caveman-toggle.sh" on
    echo ""
    echo "✅ Done. The ponytail level applies immediately; the output style"
    echo "   needs a new Claude Code session."
else
    echo "✅ Done. Run '/caveman on' in Claude Code when you want both."
fi
