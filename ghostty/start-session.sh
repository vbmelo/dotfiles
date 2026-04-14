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
	# Window 1: Xtobox (left: 2 vertical panes, right: 1 full-height pane)
	$TMUX_BIN new-session -d -s main -n "Xtobox" -c ~/Projects/xtobox
	$TMUX_BIN split-window -h -t main:1 -c ~/Projects/xtobox
	$TMUX_BIN select-pane -t main:1.0
	$TMUX_BIN split-window -v -t main:1.0 -c ~/Projects/xtobox

	# Window 2: Neueria (left: 2 vertical panes, right: 1 full-height pane)
	$TMUX_BIN new-window -t main:2 -n "Neueria" -c ~/Projects/pareva-frontend-neueria
	$TMUX_BIN split-window -h -t main:2 -c ~/Projects/pareva-frontend-neueria
	$TMUX_BIN select-pane -t main:2.0
	$TMUX_BIN split-window -v -t main:2.0 -c ~/Projects/pareva-frontend-neueria

	# Window 3: Pareva Tools (left: 2 vertical panes, right: 1 full-height pane)
	$TMUX_BIN new-window -t main:3 -n "Pareva Tools" -c ~/Projects/pareva-internal-tools
	$TMUX_BIN split-window -h -t main:3 -c ~/Projects/pareva-internal-tools
	$TMUX_BIN select-pane -t main:3.0
	$TMUX_BIN split-window -v -t main:3.0 -c ~/Projects/pareva-internal-tools

	# Window 4: On Premise (horizontal split)
	$TMUX_BIN new-window -t main:4 -n "On Premise" -c ~/Projects/on-premise
	$TMUX_BIN split-window -h -t main:4 -c ~/Projects/on-premise

	# Window 5: UA - CBD (horizontal split)
	$TMUX_BIN new-window -t main:5 -n "UA - CBD" -c ~/Documents/UA/2025-2026/CBD
	$TMUX_BIN split-window -h -t main:5 -c ~/Documents/UA/2025-2026/CBD

	# Window 6: UA - IES (horizontal split)
	$TMUX_BIN new-window -t main:6 -n "UA - IES" -c ~/Documents/UA/2025-2026/IES
	$TMUX_BIN split-window -h -t main:6 -c ~/Documents/UA/2025-2026/IES

	# Window 7: ADB (horizontal split)
	$TMUX_BIN new-window -t main:7 -n "ADB" -c ~/platform-tools
	$TMUX_BIN split-window -h -t main:7 -c ~/platform-tools

	# Window 8: Terminal (horizontal split)
	$TMUX_BIN new-window -t main:8 -n "Terminal" -c ~/
	$TMUX_BIN split-window -h -t main:8 -c ~/

	# Select the first window
	$TMUX_BIN select-window -t main:1
fi

# Attach to the session
$TMUX_BIN attach-session -t main
