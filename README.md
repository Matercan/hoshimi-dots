# 【 Mataercan's hyprland dotfiles 】
A very tame an basic configuration for the window tiling manager hyprland.
Features include:
- A complete environment (except notifications)
- Most popular apps' configurations
- Colorscheme generation based on a wallpaper
- Famous colorschemes like catppuccin

![image)](https://github.com/user-attachments/assets/08925f45-ac6a-47b9-a3b0-b1dc36cc1290)

WARNING: the screenshots are outdated!


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

For best user experience:
- playerctl
- candy-icons
- cava
- pipewire-pulse
- sweet gtk/kvantum themes
- shadow whisper font
- MRK Maston font
- Mutsuki font
- Any japanese font

## Usage
```
Usage: build/bin/hyprland-dots [OPTIONS]

Install and configure dotfiles with custom themes

Options:
  -p, --packages PKG1,PKG2  Install specific packages (comma-separated)
  -w, --wallpaper PATH       Set wallpaper path
  -c, --colorscheme TYPE     Generate colorscheme from wallpaper
                             Available types: dark, light, warm
  -s, --scheme NAME          Use predefined color scheme
                             Available schemes: catppuccin-mocha,
                             catppuccin-latte, gruvbox-dark,
                             gruvbox-light, dracula
  -i, --interactive          Run in interactive mode
  -l, --list-packages        List available packages
  -L, --list-themes          List available wallpaper themes
  -S, --list-schemes         List available predefined schemes
  -h, --help                 Show this help message
  -a, --all                  Install all available packages

Examples:
  build/bin/hyprland-dots -p hypr,wofi -s dracula
  build/bin/hyprland-dots -a -w ~/bg.jpg -c dark
  build/bin/hyprland-dots -p dunst,fish -s catppuccin-mocha
  build/bin/hyprland-dots --interactive
  build/bin/hyprland-dots --list-schemes
```

You can also use `` build/bin/hyprland-dots-gui `` to launch a GUI menu if that is more your style (though it is not fully updated yet)


To pull back into the hyprland_dots folder, run ``./pull.sh``. This will collect all of the configurations from all of the programs within this repository and will replace all of those currently in the directory with them.

## Issues
- The script will try and use yay to install packages you don't have, if you don't have yay you may install it via
```
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

A lot of issues with file management

## Showcase (LEGACY)

| Wallpaper | Warm | Dark | Light |
| --- | --- | --- | --- |
| Wallpaper One | <img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/6ec3640b-f2bc-4573-b3bf-cea670512d58" /> | <img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/966a7a90-cfee-4c13-948a-d917e56a960c" /> |  <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/fc2b17c2-b79b-4cc6-b887-7fc428574589" /> |
| Wallpaper Two |<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/af0f2fd0-162e-4628-b9b4-a5538afbefbc" /> |  <img width="1917" height="1080" alt="image" src="https://github.com/user-attachments/assets/edf0c419-9031-4f0f-840f-8ad5a534d21d" /> | <img width="1921" height="1080" alt="image" src="https://github.com/user-attachments/assets/64d4dd04-75e0-4dd0-88fb-7543ecf1ba76" />  |
| Wallpaper Three | <img width="1920" height="1079" alt="image" src="https://github.com/user-attachments/assets/314db5d3-4607-4f09-a8ba-1e5e692c7944" /> | <img width="1919" height="1080" alt="image" src="https://github.com/user-attachments/assets/c4bf4f93-4b04-4516-b792-c20e153a84a9" /> | <img width="1916" height="1080" alt="image" src="https://github.com/user-attachments/assets/f02b3c92-1bb8-441f-8fd2-64b0aa232247" /> 

| Colorscheme | Light | Dark
| --- | --- | --- |
Catppuccin | <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/e812dfe8-d932-4cc9-bb8e-f1986c76a279" /> | <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/edfbdbfe-4eca-413d-809c-18b029e6be83" /> |
| gruvbox| <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/26e9e425-2c5b-4ecc-bb40-3a7884546653" />  | <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/92455d2e-43da-4dd9-bfa9-0b3b7e2ee9bf" /> |



## Thanks to
- Soraname (celestia shell)
- end-4 (end-4's dotfiles)
- The rest of the hyprland discord server

for helping me make thia rice and introducing me to my lord and saviour quickshell

## Inspiration

[woieow's dotfiles](https://github.com/woioeow/hyprland-dotfiles.git)

[typecraft's dotfiles](https://github.com/typecraft-dev/dotfiles.git)

[ml4w dotfiles](https://github.com/mylinuxforwork/dotfiles)

[end-4's dotfiles](https://github.com/end-4/dots-hyprland)

[celaestia shell](https://github.com/caelestia-dots/shell/tree/main)
















