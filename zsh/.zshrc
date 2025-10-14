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

# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# GPG
export GPG_TTY=$(tty)

# PATH
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# ===================================
# Custom Aliases & Functions
# ===================================

alias jump='jump.sh'

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
