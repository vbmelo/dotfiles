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

	# Window 2: Neueria (left: 2 vertical panes, right: 1 full-height pane)
	$TMUX_BIN new-window -t main:2 -n "Neueria" -c ~/Projects/pareva-frontend-neueria
	$TMUX_BIN split-window -h -t main:2 -c ~/Projects/pareva-frontend-neueria   # create right pane
	$TMUX_BIN select-pane -t main:2.1
	$TMUX_BIN split-window -v -t main:2.1 -c ~/Projects/pareva-frontend-neueria # split left into top/bottom

	# Window 3: Pareva Tools (renamed from Internal Tools) - same 3-pane layout
	$TMUX_BIN new-window -t main:3 -n "Pareva Tools" -c ~/Projects/pareva-internal-tools
	$TMUX_BIN split-window -h -t main:3 -c ~/Projects/pareva-internal-tools
	$TMUX_BIN select-pane -t main:3.1
	$TMUX_BIN split-window -v -t main:3.1 -c ~/Projects/pareva-internal-tools

	# Window 4: Parcel Tool - same 3-pane layout
	$TMUX_BIN new-window -t main:4 -n "Parcel Tool" -c ~/Projects/pareva-parcel-tool
	$TMUX_BIN split-window -h -t main:4 -c ~/Projects/pareva-parcel-tool
	$TMUX_BIN select-pane -t main:4.1
	$TMUX_BIN split-window -v -t main:4.1 -c ~/Projects/pareva-parcel-tool

	# Window 5: On Premise (keep simple horizontal split)
	$TMUX_BIN new-window -t main:5 -n "On Premise" -c ~/Projects/on-premise
	$TMUX_BIN split-window -h -t main:5 -c ~/Projects/on-premise

	# Window 6: UA - CBD (no split; adjust path as needed)
	$TMUX_BIN new-window -t main:6 -n "UA - CBD" -c ~/Documents/UA/2025-2026/CBD

	# Window 7: UA - IES (no split; adjust path as needed)
	$TMUX_BIN new-window -t main:7 -n "UA - IES" -c ~/Documents/UA/2025-2026/IES

	# Window 8: ADB (no split)
	$TMUX_BIN new-window -t main:8 -n "ADB" -c ~/platform-tools

	# Window 9: Standard Terminal
	$TMUX_BIN new-window -t main:9 -n "Terminal" -c ~/

	# Select the first window
	$TMUX_BIN select-window -t main:1
fi

# Attach to the session
$TMUX_BIN attach-session -t main
