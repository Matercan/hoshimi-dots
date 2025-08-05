 DOTFILES_SOURCE="$(dirname "$(readlink -f "$0")")"
USER_CONFIGS_DIRECTORY="${XDG_CONFIG_HOME:-$HOME/.config}"
DOTFILES=("fastfetch" "fish" "ghostty" "hypr" "gtk-4.0" "vesktop/themes" "vesktop/settings" "wofi" "waybar" "eww")

echo "This will delete all of the dotfiles here currently, and will replace the ones soruced with your dotfiles."

read -p "Continue (y/n)? " choice
case "$choice" in
  y|Y ) echo "Proceeding with pulling";;
  n|N ) echo "Aborting pulling"; exit 0;;
  * ) echo "Invalid response, aborting"; exit 1;;
esac

for dotfile in ${DOTFILES}
do
  echo "Copying ${USER_CONFIGS_DIRECTORY}/${dotfile}"
  rm "${DOTFILES_SOURCE}/${dotfile}"
  cp "${USER_CONFIGS_DIRECTORY}/${dotfile}" ${DOTFILES_SOURCE}
done
rm "${DOTFILES_SOURCE}/starship/*"
cp "${USER_CONFIGS_DIRECTORY}/starship.toml" "${DOTFILES_SOURCE}/starship/"
