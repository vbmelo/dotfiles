#!/bin/zsh
# ~/.config/ghostty/start-session.sh

# Check if we're already inside tmux
if [ -n "$TMUX" ]; then
    exit 0
fi

TMUX_BIN="$(which tmux)"

# Check if tmux exists
if ! command -v tmux &>/dev/null; then
    echo "tmux not found, please install it first"
    exit 1
fi

# Only create session if it doesn't exist
if ! $TMUX_BIN has-session -t main 2>/dev/null; then
    # Create session in detached mode
    $TMUX_BIN new-session -d -s main -n "Internal Tools" -c ~/Projects/pareva-internal-tools
    
    # Split horizontally
    $TMUX_BIN split-window -h -t main:0 -c ~/Projects/pareva-internal-tools

    # Create other windows
    $TMUX_BIN new-window -t main:1 -n "Company Tools" -c ~/Projects/pareva-company-tools
    $TMUX_BIN split-window -h -t main:1 -c ~/Projects/pareva-company-tools

    $TMUX_BIN new-window -t main:2 -n "Neueria" -c ~/Projects/pareva-frontend-neueria
    $TMUX_BIN split-window -h -t main:2 -c ~/Projects/pareva-frontend-neueria

    $TMUX_BIN new-window -t main:3 -n "Xtobox" -c ~/Projects/xtobox
    $TMUX_BIN new-window -t main:4 -n "Platform Tools" -c ~/platform-tools
    
    # Select the first window
    $TMUX_BIN select-window -t main:0
fi

# Attach to the session
$TMUX_BIN attach-session -t main
