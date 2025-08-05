#!/bin/bash

# Get the script's directory
DOTFILES_SOURCE="$(dirname "$(readlink -f "$0")")"
# Use the correct XDG variable, defaulting to ~/.config
USER_CONFIGS_DIRECTORY="${XDG_CONFIG_HOME:-$HOME/.config}"
# Correct the array syntax by removing the commas and fixing vesktop
DOTFILES=("fastfetch" "fish" "ghostty" "hypr" "gtk-4.0" "vesktop/themes" "vesktop/settings" "wofi" "waybar" "eww")

echo "This script will install all of the files into their respective config folders."
echo "If you have any configurations you would like to keep, it is advised to back them up."

read -p "Continue (y/n)? " choice
case "$choice" in
  y|Y ) echo "Proceeding with installation";;
  n|N ) echo "Aborting installation"; exit 0;;
  * ) echo "Invalid response, aborting"; exit 1;;
esac

# Check for GNU Stow
if ! command -v stow >/dev/null 2>&1
then
  echo "GNU Stow could not be found. Please install it first."
  exit 2
fi

# Create a backup of existing files
read -p "Do you wish to create a backup of existing configs? (y/n) " choice
case "$choice" in
  y|Y )
    BACKUPDIR="$DOTFILES_SOURCE/backup/"
    mkdir -p "$BACKUPDIR"
    
    for dotfile in "${DOTFILES[@]}"
    do
      if [ -e "${USER_CONFIGS_DIRECTORY}/${dotfile}" ]; then
        echo "Copying ${USER_CONFIGS_DIRECTORY}/${dotfile} to $BACKUPDIR"
        cp -r "${USER_CONFIGS_DIRECTORY}/${dotfile}" "$BACKUPDIR"
      fi
    done
    mv "$USER_CONFIGS_DIRECTORY/starship.toml" $BACKUPDIR
    ;;
  n|N ) echo "Proceeding without backup";;
  * ) echo "Invalid response, aborting"; exit 1;;
esac

# Change into the dotfiles directory to run stow correctly
cd "$DOTFILES_SOURCE" || exit 1

# Remove existing configurations to prevent conflicts
for dotfile in "${DOTFILES[@]}"
do
  if [ -e "${USER_CONFIGS_DIRECTORY}/${dotfile}" ]; then
    echo "Removing existing ${USER_CONFIGS_DIRECTORY}/${dotfile}"
    rm -rf "${USER_CONFIGS_DIRECTORY}/${dotfile}"
  fi
done

# Create the target directories before moving
for dotfile in "${DOTFILES[@]}"
do
  mkdir -p "${USER_CONFIGS_DIRECTORY}/${dotfile}"
done

# Move each dotfile
for dotfile in "${DOTFILES[@]}"
do
  echo "Moving ${dotfile}"
  cp -r ${dotfile}/* "${USER_CONFIGS_DIRECTORY}/${dotfile}" 
done

cp starship/starship.toml ~/.config/

read -p "Remove special login? (y/n) " choice
case "$choice" in 
  y|Y) rm ~/.config/hypr/hyprland/start.sh; echo "Removed. ";;
  n|N) echo "Ok weeb"; echo "Password: 大好きなのよ";;
  * ) ;;
esac

hyprctl reload
