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
	# Window 1: Xtobox (no split)
	$TMUX_BIN new-session -d -s main -n "Xtobox" -c ~/Projects/xtobox

	# Window 2: Neueria
	$TMUX_BIN new-window -t main:2 -n "Neueria" -c ~/Projects/pareva-frontend-neueria
	$TMUX_BIN split-window -h -t main:2 -c ~/Projects/pareva-frontend-neueria

	# Window 3: Parcel Tool
	$TMUX_BIN new-window -t main:3 -n "Parcel Tool" -c ~/Projects/pareva-parcel-tool
	$TMUX_BIN split-window -h -t main:3 -c ~/Projects/pareva-parcel-tool

	# Window 4: Internal Tools
	$TMUX_BIN new-window -t main:4 -n "Internal Tools" -c ~/Projects/pareva-internal-tools
	$TMUX_BIN split-window -h -t main:4 -c ~/Projects/pareva-internal-tools

	# Window 5: Company Tools
	$TMUX_BIN new-window -t main:5 -n "Company Tools" -c ~/Projects/pareva-company-tools
	$TMUX_BIN split-window -h -t main:5 -c ~/Projects/pareva-company-tools

	# Window 6: On Premise
	$TMUX_BIN new-window -t main:6 -n "On Premise" -c ~/Projects/on-premise
	$TMUX_BIN split-window -h -t main:6 -c ~/Projects/on-premise

	# Window 7: Platform Tools (no split)
	$TMUX_BIN new-window -t main:7 -n "ADB" -c ~/platform-tools

	# Window 8: Standard Terminal
	$TMUX_BIN new-window -t main:8 -n "Terminal" -c ~/

	# Select the first window
	$TMUX_BIN select-window -t main:1
fi

# Attach to the session
$TMUX_BIN attach-session -t main
