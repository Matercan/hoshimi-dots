# eza
zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'color-scale' age
zinit snippet OMZP::eza

# Completions
autoload -Uz compinit && compinit 

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --color=always $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza --icons --color=always $realpath'
zstyle ':fzf-stab:complete:nvim:*' fzf-preview 'cat $realpath'

# Screensaver
zstyle ":morpho" screen-saver "asciiquarium"
zstyle ":morpho" arguments "-t"
zstyle ":morpho" delay "290"
zstyle ":morpho" check-interval "60"

