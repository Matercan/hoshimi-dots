for item in *; do
    if [ "$item" != ".config" ]; then
        mv "$item" .config/hypr/
    fi
done
