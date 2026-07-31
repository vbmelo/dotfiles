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

# Layout for project windows: screen split horizontally into two,
# left portion split into three vertical (stacked) panes.
#   Pane 1: top-left | Pane 2: middle-left | Pane 3: bottom-left | Pane 4: right
create_project_window() {
	local index="$1"
	local name="$2"
	local dir="$3"
	local middle_dir="${4:-$3}"

	if [ "$index" -eq 1 ]; then
		$TMUX_BIN new-session -d -s main -n "$name" -c "$dir"
	else
		$TMUX_BIN new-window -t main:"$index" -n "$name" -c "$dir"
	fi
	$TMUX_BIN split-window -h -t main:"$index".1 -c "$dir"
	$TMUX_BIN split-window -v -t main:"$index".1 -l '66%' -c "$middle_dir"
	$TMUX_BIN split-window -v -t main:"$index".2 -l '50%' -c "$dir"
	$TMUX_BIN select-pane -t main:"$index".1
}

# Only create session if it doesn't exist
if ! $TMUX_BIN has-session -t main 2>/dev/null; then
	# Window 1: Xtobox
	create_project_window 1 "Xtobox" ~/Projects/xtobox

	# Window 2: Neueria (middle-left pane starts in ~/Projects/xtobox)
	create_project_window 2 "Neueria" ~/Projects/pareva-frontend-neueria ~/Projects/xtobox

	# Window 3: Pareva Tools (middle-left pane starts in ~/Projects/xtobox)
	create_project_window 3 "Pareva Tools" ~/Projects/pareva-tools ~/Projects/xtobox

	# Window 4: Rossmann (middle-left pane starts in ~/Projects/xtobox)
	create_project_window 4 "Rossmann" ~/Projects/pareva-frontend-rossmann ~/Projects/xtobox

	# Window 5: On Premise
	create_project_window 5 "On Premise" ~/Projects/on-premise

	# Window 6: ADB (horizontal split)
	$TMUX_BIN new-window -t main:6 -n "ADB" -c ~/platform-tools
	$TMUX_BIN split-window -h -t main:6 -c ~/platform-tools

	# Window 7: Terminal (horizontal split)
	$TMUX_BIN new-window -t main:7 -n "Terminal" -c ~/
	$TMUX_BIN split-window -h -t main:7 -c ~/

	# Window 8: Dotfiles (left: 2 vertical panes, right: 1 full-height pane)
	$TMUX_BIN new-window -t main:8 -n "Dotfiles" -c ~/dotfiles
	$TMUX_BIN split-window -h -t main:8 -c ~/dotfiles
	$TMUX_BIN select-pane -t main:8.1
	$TMUX_BIN split-window -v -t main:8.1 -c ~/dotfiles

	# Select the first window
	$TMUX_BIN select-window -t main:1
fi

# Attach to the session
$TMUX_BIN attach-session -t main
