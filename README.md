# 【 Mataercan's hyprland dotfiles 】
A very tame an basic configuration for the window tiling manager hyprland.
Features include:
- A full desktop environment
- Using something me, myself, and I made - not you (make your own dotfiles)
- A really small [configuration](#showcase)
- A really small [install script](#installation)
- No fancy colorscheme generation (yet)

## Usage
```
git clone https://github.com/Matercan/hyprland-dots
cd hyprland-dots
g++ scripts/install.cpp -o install-bin
./install-bin
chmod +x pull.sh
```
If not on arch, build install.cpp with your favourite C++ compiler.
The script will try and yay -S packages you don't have, on arch this will resault in an error.

To pull back into the hyprland_dots folder, run ``./pull.sh``. This will collect all of the configurations from all of the programs within this repository and will replace all of those currently in the directory with them.

## Showcase

| Using Wallpaper 1  | Using Wallpaper 2 |
| --- | --- |
| <img width="1921" height="1080" alt="image" src="https://github.com/user-attachments/assets/64a0a824-d7c3-40b9-9153-a14f2d50b067" /> | <img width="1929" height="1080" alt="image" src="https://github.com/user-attachments/assets/e567273e-1506-4fae-9fab-8e05af3c3d45" /> |

## Inspiration

https://github.com/woioeow/hyprland-dotfiles.git
https://github.com/typecraft-dev/dotfiles.git




