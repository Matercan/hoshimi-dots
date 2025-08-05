if status is-interactive
    starship init fish | source
    colorscript -e random
    ~/.config/hypr/scripts/script.sh
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

fish_add_path /usr/bin/
set -gx SUDO_EDITOR nvim
set -gx EDITOR nvim
