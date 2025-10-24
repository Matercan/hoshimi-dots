# Base functiosn

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

# lf
lfcd () {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")"
}
alias lf='lfcd'

# qucikshell 
qsr () {
  prime-run qs > ~/Documents/qs.log \
    2>&1 &
  tail -f ~/Documents/qs.log; rm -f ~/Documents/qs.log
}

# Aliases

alias ga="git add"
alias gcm="git commit -m"
alias gp="git push"
alias clear="clear && fastfetch"
alias svim="sudo -e"

# environemnt variables
export SUDO_EDITOR=nvim
export EDITOR=nvim
export HOSHIMI_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/hoshimi"



