#!/bin/bash
# ~/.config/lf/preview.sh
# Preview script for lf file manager

file="$1"
w="$2"
h="$3"
x="$4"
y="$5"

# Get file type and extension
mimetype=$(file --dereference --brief --mime-type -- "$file")
extension="${file##*.}"
extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

case "$mimetype" in
    # Text files - use bat
    text/*)
        bat --color=always --style=plain --pager=never "$file"
        exit 0
        ;;
    
    # Images - use chafa
    image/*)
        chafa --fill=block --symbols=block --colors=256 --size="$w"x"$h" "$file"
        exit 0
        ;;
    
    # PDFs - use pdftotext
    application/pdf)
        pdftotext "$file" - | bat --color=always --language=txt --style=plain --pager=never
        exit 0
        ;;
    
    # Archives - show contents
    application/zip|application/x-rar-compressed|application/x-7z-compressed)
        case "$extension" in
            zip)
                unzip -l "$file"
                ;;
            rar)
                unrar l "$file" 2>/dev/null
                ;;
            7z)
                7z l "$file"
                ;;
            *)
                echo "Archive: $file"
                ;;
        esac
        exit 0
        ;;
    
    # Videos - show metadata
    video/*)
        if command -v mediainfo >/dev/null 2>&1; then
            mediainfo "$file"
        elif command -v ffprobe >/dev/null 2>&1; then
            ffprobe -v quiet -print_format json -show_format -show_streams "$file" | bat --color=always --language=json --style=plain --pager=never
        else
            echo "Video file: $file"
            file -b "$file"
        fi
        exit 0
        ;;
    
    # Audio files - show metadata
    audio/*)
        if command -v mediainfo >/dev/null 2>&1; then
            mediainfo "$file"
        elif command -v ffprobe >/dev/null 2>&1; then
            ffprobe -v quiet -print_format json -show_format -show_streams "$file" | bat --color=always --language=json --style=plain --pager=never
        else
            echo "Audio file: $file"
            file -b "$file"
        fi
        exit 0
        ;;
    
    # JSON files
    application/json)
        bat --color=always --language=json --style=plain --pager=never "$file"
        exit 0
        ;;
    
    # Binary files - show file info
    application/octet-stream)
        echo "Binary file: $file"
        file -b "$file"
        echo
        ls -la "$file"
        exit 0
        ;;
esac

# Handle by file extension if mimetype detection failed
case "$extension" in
    # Programming languages
    py|python)
        bat --color=always --language=python --style=plain --pager=never "$file"
        ;;
    js|javascript)
        bat --color=always --language=javascript --style=plain --pager=never "$file"
        ;;
    html|htm)
        bat --color=always --language=html --style=plain --pager=never "$file"
        ;;
    css)
        bat --color=always --language=css --style=plain --pager=never "$file"
        ;;
    json)
        bat --color=always --language=json --style=plain --pager=never "$file"
        ;;
    xml)
        bat --color=always --language=xml --style=plain --pager=never "$file"
        ;;
    yaml|yml)
        bat --color=always --language=yaml --style=plain --pager=never "$file"
        ;;
    md|markdown)
        bat --color=always --language=markdown --style=plain --pager=never "$file"
        ;;
    sh|bash)
        bat --color=always --language=bash --style=plain --pager=never "$file"
        ;;
    
    # Configuration files
    conf|config|cfg|ini)
        bat --color=always --language=ini --style=plain --pager=never "$file"
        ;;
    
    # Default for text-like files
    *)
        if [[ -f "$file" && -r "$file" ]]; then
            # Check if file is text
            if file -b "$file" | grep -q "text"; then
                bat --color=always --style=plain --pager=never "$file"
            else
                echo "File: $file"
                file -b "$file"
                echo
                ls -la "$file"
            fi
        else
            echo "Cannot preview: $file"
        fi
        ;;
esac
