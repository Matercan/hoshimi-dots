if status is-interactive
    starship init fish | source
    colorscript -e random
    zoxide init --cmd cd fish | source
    set fish_greeting "おかえりなさい、マスター"
end

if test -f ~/.ssh/agent_env
    source ~/.ssh/agent_env
end

function sacman
  sudo pacman $argv
end

alias ls="eza --icons"

fish_add_path /usr/bin/
set -gx SUDO_EDITOR nvim
set -gx EDITOR nvim
