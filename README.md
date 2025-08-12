# 【 Mataercan's hyprland dotfiles 】
A very tame an basic configuration for the window tiling manager hyprland.
Features include:
- A full desktop environment
- Colorscheme generation based on a wallpaper
- Nothing that requires sudo
- An easy installation with a GUI, if you choise

## Installation
```shell
git clone https://github.com/Matercan/hyprland-dots
cd hyprland-dots
mkdir -p build && cd build
cmake .. && make && cd ..
```

Dependencies:
- libpng
- libjpg
- qt6-base
- qt6-tools
- pkgconf

## Usage
```
Usage: build/bin/hyprland-dots

Install and configure dotfiles with custom themes

Options:
  -p, --packages PKG1,PKG2  Install specific packages (comma-separated)
  -w, --wallpaper PATH       Set wallpaper path
  -c, --colorscheme TYPE     Generate colorscheme from wallpaper (dark/light/warm)
  -i, --interactive          Run in interactive mode
  -l, --list-packages        List available packages
  -L, --list-themes          List available themes
  -h, --help                 Show this help message
  -a, --all                  Install all available packages

Examples:
  ./install-bin -p hypr,waybar,wofi -w ~/wallpaper.png
  ./install-bin -a -w ~/bg.jpg -c dark
  ./install-bin --interactive
  ./install-bin --list-packages
```

You can also use `` build/bin/hyprland-dots-gui `` to launch a GUI menu if that is more your style



To pull back into the hyprland_dots folder, run ``./pull.sh``. This will collect all of the configurations from all of the programs within this repository and will replace all of those currently in the directory with them.

## Issues
The script will try and use yay to install packages you don't have, if you don't have yay you may install it via
```
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

## Showcase

| Wallpaper | Warm | Dark | Light |
| --- | --- | --- | --- |
| Wallpaper One | <img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/6ec3640b-f2bc-4573-b3bf-cea670512d58" /> | <img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/966a7a90-cfee-4c13-948a-d917e56a960c" /> |  <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/fc2b17c2-b79b-4cc6-b887-7fc428574589" /> |
| Wallpaper Two |<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/af0f2fd0-162e-4628-b9b4-a5538afbefbc" /> |  <img width="1911" height="1080" alt="image" src="https://github.com/user-attachments/assets/54c7219c-8bfb-4471-a71b-2cfd965ef984" /> | <img width="1921" height="1080" alt="image" src="https://github.com/user-attachments/assets/64d4dd04-75e0-4dd0-88fb-7543ecf1ba76" />  |
| Wallpaper Three | <img width="1920" height="1079" alt="image" src="https://github.com/user-attachments/assets/314db5d3-4607-4f09-a8ba-1e5e692c7944" /> | <img width="1919" height="1080" alt="image" src="https://github.com/user-attachments/assets/c4bf4f93-4b04-4516-b792-c20e153a84a9" /> | <img width="1916" height="1080" alt="image" src="https://github.com/user-attachments/assets/f02b3c92-1bb8-441f-8fd2-64b0aa232247" /> 







## TO-DO:
- Integrate catppucin, gruvbox, dracula, and other popular themes into the installation
- A lot more widgets for eww
- Dunst theming

## Inspiration

[woieow's dotfiles](https://github.com/woioeow/hyprland-dotfiles.git)

[typecraft's dotfiles](https://github.com/typecraft-dev/dotfiles.git)

[ml4 dotfiles](https://github.com/mylinuxforwork/dotfiles)











