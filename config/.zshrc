# Created by newuser for 5.9

fastfetch
echo "おかえりなさ～いマスター"
echo "\n"


ZINIT_HOME="{XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Downloads Zinit if  it's not there
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit snippet OMZP::cp 

# eza
zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'color-scale' age
zinit snippet OMZP::eza

# Completions
autoload -Uz compinit && compinit 
zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --color=always $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza --icons --color=always $realpath'

# Keybinds
bindkey -e # Emacs keybinds
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Cursor
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        # Normal/block cursor for command mode
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} == '' ]] || [[ $1 = 'beam' ]]; then
        # Beam cursor for insert mode
        echo -ne '\e[5 q'
    fi
}

function zle-line-init {
    # Start with beam cursor when entering command input
    echo -ne '\e[5 q'
}

function zle-line-finish {
    # Return to normal cursor when command finishes
    echo -ne '\e[1 q'
}

# Register the functions as ZLE widgets
zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

# Set initial cursor to beam
echo -ne '\e[5 q'

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases

alias ga="git add"
alias gcm="git commit -m"
alias gp="git push"
alias clear="clear && fastfetch"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init  --cmd cd zsh)"
