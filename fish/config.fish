if status is-interactive
    starship init fish | source
    set fish_greeting
end

if test -f ~/.ssh/agent_env
    source ~/.ssh/agent_env
end
