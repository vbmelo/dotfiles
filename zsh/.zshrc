# Silence P10K Warning when starting TMUX
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Fix for TMUX line wrapping issues
if [[ -n "$TMUX" ]]; then
  # Tell P10K we're in TMUX for better rendering
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  
  # Shorter prompt in TMUX
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right
fi

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# "Marlin Frost" shell colors — tuned for a dark navy frosted-glass terminal.
# Matches the Ghostty palette. Set AFTER oh-my-zsh so the plugins are loaded.
# ============================================================================

# --- zsh-syntax-highlighting -------------------------------------------------
# Enable all highlighters (not just `main`) for full color-coding.
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -gA ZSH_HIGHLIGHT_STYLES
# Commands & callables
ZSH_HIGHLIGHT_STYLES[command]='fg=#61ffca,bold'           # valid command -> green
ZSH_HIGHLIGHT_STYLES[alias]='fg=#61ffca,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#61ffca'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#61ffca'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#82e2ff,bold'           # builtins -> cyan
ZSH_HIGHLIGHT_STYLES[function]='fg=#a277ff,bold'          # functions -> purple
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#f694ff,italic'      # sudo, env, ...
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#61ffca'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#61ffca'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#82e2ff,underline'
# Reserved words / control flow
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#a277ff,bold'     # if/for/while -> purple
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f694ff'
# Errors
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff6767,bold'     # unknown -> red
# Options / flags
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ffca85'   # -x  -> orange
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ffca85'   # --xx
# Paths
ZSH_HIGHLIGHT_STYLES[path]='fg=#82e2ff,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#82e2ff'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#7e7799'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#7e7799'
# Quoted strings
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#61ffca'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#61ffca'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#61ffca'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#61ffca'
# Variables, substitutions, globbing
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#82e2ff'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#82e2ff'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#82e2ff'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#f694ff'
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=#82e2ff'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#f694ff'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#6b8cc2'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f694ff,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#f694ff'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#f694ff'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#7e7799,italic'         # comments -> dim lavender-grey
ZSH_HIGHLIGHT_STYLES[default]='fg=#6b8cc2'                # everything else -> soft steel blue
# brackets highlighter
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=#ff6767,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#a277ff,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#61ffca,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#82e2ff,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#f694ff,bold'
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'

# --- zsh-autosuggestions -----------------------------------------------------
# Dim lavender-grey so suggestions are visible but clearly not yet typed.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7e7799'

# --- ls / completion colors --------------------------------------------------
export CLICOLOR=1
# BSD ls (macOS): bold cyan dirs, bold magenta symlinks -> readable on navy.
export LSCOLORS='GxFxcxdxbxegedabagacad'
# GNU ls + zsh completion menu coloring.
export LS_COLORS='di=1;36:ln=1;35:so=35:pi=33:ex=1;32:bd=33;1:cd=33;1:su=37;41:sg=30;43:tw=30;42:ow=34;42'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# GPG
export GPG_TTY=$(tty)

alias jump='jump.sh'

# Custom functions and aliases

function gpg_fix(){
    echo "test" | gpg --clearsign
    export GPG_TTY=$(tty)
    echo "test" | gpg --clearsign
}

function cors_update_preview(){
    echo "Updating Cors Branch -> merging with preview"
    git checkout preview
    git fetch
    git pull
    git checkout development/preview-allowed
}

function air_fix() {
    alias air='~/go/bin/air'
}
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
