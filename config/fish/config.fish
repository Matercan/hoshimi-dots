if status is-interactive
    starship init fish | source
    fastfetch
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
alias cdconf="cd ~/projects/hyprland-dots"
alias ga="git add"
alias gcm="git commit -m"
alias gp="git push"
alias clear="clear && fastfetch"

set -gx SUDO_EDITOR nvim
set -gx EDITOR nvim

set -gx QT_QMl2_PATH /usr/lib/qt6/qml:/usr/lib/x86_64-linux-gnu/qt6/qml
set -gx QML2_IMPORT_PATH $QT_QML2_PATH
set -gx QT_PLUGIN_PATH /usr/lib/qt6/plugins
