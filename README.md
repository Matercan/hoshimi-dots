# 【 Mataercan's hyprland dotfiles 】
A very tame an basic configuration for the window tiling manager hyprland.
Features include:
- A full desktop environment
- Colorscheme generation based on a wallpaper
- Nothing that requires sudo
- An easy installation

## Installation
```shell
git clone https://github.com/Matercan/hyprland-dots
cd hyprland-dots
mkdir -p build && cd build
cmake .. && make
```

Dependencies:
- libpng
- pkgconf

## Usage
```
Usage: ./install-bin [OPTIONS]

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

To pull back into the hyprland_dots folder, run ``./pull.sh``. This will collect all of the configurations from all of the programs within this repository and will replace all of those currently in the directory with them.

## Issues
The script will try and use yay to install packages you don't have, if you don't have yay you may install it via
```
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

The warm color theme will generate really vibrant and weirid colors, I am working to fix that soon.

 The script only compules for C++ 12.

## Showcase

| | | 
| --- | --- |
| <img width="1922" height="1080" alt="image" src="https://github.com/user-attachments/assets/42a1191e-5a67-4334-a4e4-748cd7518c63" /> | <img width="1921" height="1080" alt="image" src="https://github.com/user-attachments/assets/e41df32d-4b23-49d5-b1cd-d2a6407879b1" /> | 
| <img width="1921" height="1080" alt="image" src="https://github.com/user-attachments/assets/d0abf072-962d-42d9-84f7-ad3e9e81d198" /> | <img width="1921" height="1080" alt="image" src="https://github.com/user-attachments/assets/e049f0a9-62d9-4510-ba50-1300e9be0023" /> | 

## TO-DO:
Integrate catppucin, gruvbox, dracula, and other popular themes into the installation

## Inspiration

https://github.com/woioeow/hyprland-dotfiles.git

https://github.com/typecraft-dev/dotfiles.git







