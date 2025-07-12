if status is-interactive
    starship init fish | source
    colorscript -e random
    set fish_greeting
end

if test -f ~/.ssh/agent_env
    source ~/.ssh/agent_env
end
