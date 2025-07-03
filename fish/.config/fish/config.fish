if status is-interactive
    starship init fish | source
    set fish_greeting
    fish_add_path /mnt/toshiba/my-games/Economy/.venv/bin
    fish_add_path /usr/bin
end

if test -f ~/.ssh/agent_env
    source ~/.ssh/agent_env
end
