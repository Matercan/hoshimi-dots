if status is-interactive
    starship init fish | source
    fastfetch
    echo ""
    set fish_greeting "おかえりなさい、マスター"
end

if test -f ~/.ssh/agent_env
    source ~/.ssh/agent_env
end

function sacman
  sudo pacman $argv
end

zoxide init --cmd cd fish | source
alias ls="eza --icons"
alias ga="git add"
alias gcm="git commit -m"
alias gp="git push"
alias cdconf="cd ~/projects/hyprland-dots/"

set -gx SUDO_EDITOR nvim
set -gx EDITOR nvim
