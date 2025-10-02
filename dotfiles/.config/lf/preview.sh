#!/bin/bash
# ~/.config/lf/preview.sh
# Preview script for lf file manager

# Get file type and extension
mimetype=$(file --dereference --brief --mime-type -- "$file")
extension="${file##*.}"
extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

BAT_THEME="Solarized (light)"

batorcat() {
    file="$1"
    shift
    if command -v bat >/dev/null 2>&1; then
        bat --color=always --theme="$BAT_THEME" --style=numbers --pager=never "$file" "$@"
    else
        cat "$file"
    fi
}

image() {
    if [ -n "$WT_SESSION" ] || [ -n "$TMUX" ]; then
      # windows terminal (no sixels yet) or tmux (not much success with passthrough to iterm here)
      chafa -f symbols -s "$2x$3" --animate off --polite on "$1"
    else
      chafa -f sixels -s "$2x$3" --animate off --polite on "$1"
    fi
}

# cpbotha's simplified version
CACHE="$HOME/.cache/lf/thumbnail.$(sha256sum "$1" | awk '{print $1}')"

case "$(file -Lb --mime-type -- "$1")" in
    image/*)
        #chafa -f sixel -s "$2x$3" --animate off --polite on "$1"
        image "$1" "$2" "$3" "$4" "$5"
        exit 1
        ;;
    application/pdf)
        [ ! -f "${CACHE}.jpg" ] && pdftoppm -jpeg -f 1 -singlefile "$1" "$CACHE"
        image "${CACHE}.jpg" "$2" "$3" "$4" "$5"
        ;;
    text/*|application/json)
        batorcat "$1"
        ;;
    *)
        #file -b "$1"
        # lesspipe can list many archives, and even do docx files
        # if it does not work (e.g. message/rfc822) then batorcat can try
        lesspipe "$1" || batorcat "$1" || echo "lesspipe not installed or could not open file"
        ;;
esac

