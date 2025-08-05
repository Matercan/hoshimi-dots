#!/bin/bash

DOTFILES_SOURCE="$(dirname "$(readlink -f "$0")")"
USER_CONFIGS_DIRECTORY="${XDG_CONFIG_HOME:-$HOME/.config}"
DOTFILES=("fastfetch" "fish" "ghostty" "hypr" "gtk-4.0" "vesktop/settings" "vesktop/themes" "wofi" "waybar" "eww")

echo "This will delete all of the dotfiles here currently, and will replace the ones soruced with your dotfiles."

read -p "Continue (y/n)? " choice
case "$choice" in
  y|Y ) echo "Proceeding with pulling";;
  n|N ) echo "Aborting pulling"; exit 0;;
  * ) echo "Invalid response, aborting"; exit 1;;
esac

for dotfile in "${DOTFILES[@]}"
do
  echo "Copying ${USER_CONFIGS_DIRECTORY}/${dotfile}"
  rm -rf "${DOTFILES_SOURCE}/${dotfile}"

  if [ "$dotfile" = "vesktop/themes" ]; then
    mkdir -p "${DOTFILES_SOURCE}/vesktop/themes"
    cp -r ~/.config/vesktop/themes/* "${DOTFILES_SOURCE}/vesktop/themes"
    continue
fi
if [ "$dotfile" = "vesktop/settings" ]; then
    mkdir -p "${DOTFILES_SOURCE}/vesktop/settings"
    cp -r ~/.config/vesktop/settings/* "${DOTFILES_SOURCE}/vesktop/settings"
    continue
fi

  cp -r "${USER_CONFIGS_DIRECTORY}/${dotfile}" "${DOTFILES_SOURCE}"
done

# Handle starship separately as it's a file, not a directory
rm -rf "${DOTFILES_SOURCE}/starship/"
mkdir "$DOTFILES_SOURCE/starship/"
cp "${USER_CONFIGS_DIRECTORY}/starship.toml" "${DOTFILES_SOURCE}/starship/"
