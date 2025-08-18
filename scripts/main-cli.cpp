#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <string>
#include <sys/stat.h>
#include <vector>

#include "filey.hpp"
#include "input.hpp"
#include "palette.hpp"

using namespace std;

const vector<string> TOTALPACKAGES = {"dunst",   "fastfetch", "fish",   "eww",
                                      "ghostty", "vesktop",   "waybar", "wofi",
                                      "hypr",    "catalyst",  "cava"};

const vector<string> TOTALTHEMES = {"dark", "warm", "light"};

const vector<string> TOTALSCHEMES = {"catppuccin-mocha", "catppuccin-latte",
                                     "gruvbox-dark", "gruvbox-light",
                                     "dracula"};

const ColorScheme CATPPUCCIN_MOCHA({"#45475a", "#f38ba8", "#a6e3a1", "#f9e2af",
                                    "#89b4fa", "#f5c2e7", "#94e2d5", "#a6adc8",
                                    "#585b70", "#f38ba8", "#a6e3a1", "#f9e2af",
                                    "#89b4fa", "#f5c2e7", "#94e2d5", "#bac2de"},
                                   {"#1e1e2e", "#cdd6f4", "#f5e0dc", "#1e1e2e",
                                    "#353749", "#cdd6f4"});

const ColorScheme CATPPUCCIN_LATTE({"#5c5f77", "#d20f39", "#40a02b", "#df8e1d",
                                    "#1e66f5", "#ea76cb", "#179299", "#acb0be",
                                    "#6c6f85", "#d20f39", "#40a02b", "#df8e1d",
                                    "#1e66f5", "#ea76cb", "#179299", "#bcc0cc"},
                                   {"#eff1f5", "#4c4f69", "#dc8a78", "#eff1f5",
                                    "#d8dae1", "#4c4f69"});

const ColorScheme GRUVBOX_DARK({"#1b1b1b", "#ea6962", "#a9b665", "#d8a657",
                                "#7daea3", "#d3869b", "#89b482", "#d4be98",
                                "#32302f", "#ea6962", "#a9b665", "#d8a657",
                                "#7daea3", "#d3869b", "#89b482", "#d4be98"},
                               {"#282828", "#d4be98", "#d4be98", "#282828",
                                "#3c3836", "#d4be98"});

const ColorScheme GRUVBOX_LIGHT({"#f2e5bc", "#c14a4a", "#6c782e", "#b47109",
                                 "#45707a", "#945e80", "#4c7a5d", "#654735",
                                 "#f3eac7", "#c14a4a", "#6c782e", "#b47109",
                                 "#45707a", "#945e80", "#4c7a5d", "#654735"},
                                {"#fbf1c7", "#654735", "#654735", "#fbf1c7",
                                 "#f2e5bc", "#654735"});

const ColorScheme DRACULA_DARK({"#21222c", "#ff5555", "#50fa7b", "#f1fa8c",
                                "#bd93f9", "#ff79c6", "#8be9fd", "#f8f8f2",
                                "#6272a4", "#ff6e6e", "#69ff94", "#ffffa5",
                                "#d6acff", "#ff92df", "#a4ffff", "#ffffff"},
                               {"#282a36", "#f8f8f2", "#f8f8f2", "#282a36",
                                "#44475a", "#f8f8f2"});

ColorScheme getColorSchemeByName(const string &schemeName) {
  if (schemeName == "catppuccin-mocha") {
    return CATPPUCCIN_MOCHA;
  } else if (schemeName == "catppuccin-latte") {
    return CATPPUCCIN_LATTE;
  } else if (schemeName == "gruvbox-dark") {
    return GRUVBOX_DARK;
  } else if (schemeName == "gruvbox-light") {
    return GRUVBOX_LIGHT;
  } else if (schemeName == "dracula") {
    return DRACULA_DARK;
  }

  // Fallback to dark theme
  return GRUVBOX_DARK;
}

string setupPackage(const string &package_name,
                    const vector<string> totalPackages) {
  string trimmed_package = package_name;
  trimmed_package.erase(0, trimmed_package.find_first_not_of(" \t\n\r\f\v"));
  trimmed_package.erase(trimmed_package.find_last_not_of(" \t\n\r\f\v") + 1);

  if (find(totalPackages.begin(), totalPackages.end(), trimmed_package) !=
      totalPackages.end()) {

    if (trimmed_package == "hypr") {
      trimmed_package = "hyprland";
    }

    string dir = "/usr/bin/" + trimmed_package;
    struct stat sb;

    if (stat(dir.c_str(), &sb) == 0) {
      cout << trimmed_package << " already on system" << endl;
    } else if (trimmed_package == "catalyst") {
      string cmd = "git clone https://github.com/Matercan/catalyst.git"
                   " && makepkg -si";
      system(cmd.c_str());
    } else {
      string cmd;
      if (trimmed_package != "hyprland") {
        cmd = "yay -S " + trimmed_package;
      } else {
        cmd = "yay -S hyprland hyprlock hypridle";
      }

      system(cmd.c_str());
    }

    if (trimmed_package == "starship") {
      cout << "starship not implemented yet" << endl;
      return "Starship.";
    }

    return trimmed_package;
  } else {
    return "Not found.";
  }
}

int main(int argc, char *argv[]) {

  ArgumentParser parser(TOTALPACKAGES, TOTALTHEMES, TOTALSCHEMES);

  // Handle no arguments - show help
  if (argc == 1) {
    std::cout << "No arguments provided. Use -h for help or -i for interactive "
                 "mode.\n";
    return 1;
  }

  auto config = parser.parse(argc, argv);

  // Handle special flags first
  if (config.showHelp) {
    parser.printHelp(argv[0]);
    return 0;
  }

  if (config.listPackages) {
    parser.listPackages();
    return 0;
  }

  if (config.listThemes) {
    parser.listThemes();
    return 0;
  }

  if (config.listSchemes) {
    parser.listSchemes();
    return 0;
  }

  // Interactive mode
  if (config.interactive) {
    InteractiveInputManager input(TOTALPACKAGES, TOTALTHEMES, TOTALSCHEMES);
    config.packages = input.packageInput();
    auto themeConfig = input.themeInput();
    config.wallpaperPath = themeConfig.wallpaperPath;
    config.generateColorScheme = themeConfig.generateColorScheme;
    config.colorSchemeTheme = themeConfig.colorSchemeTheme;
    config.predefinedScheme = themeConfig.predefinedScheme;
  }

  // Validate configuration
  if (!parser.validateConfig(config)) {
    return 1;
  }

  // Check if we have anything to do
  if (config.packages.empty()) {
    std::cerr << "Error: No packages specified. Use -p, -a, or -i.\n";
    return 1;
  }

  // Print what we're going to do
  std::cout << "\n=== Installation Plan ===\n";
  std::cout << "Packages: ";
  for (size_t i = 0; i < config.packages.size(); ++i) {
    std::cout << config.packages[i];
    if (i < config.packages.size() - 1)
      std::cout << ", ";
  }
  std::cout << "\n";

  if (!config.wallpaperPath.empty()) {
    std::cout << "Wallpaper: " << config.wallpaperPath << "\n";
  }

  ColorScheme scheme;
  if (config.generateColorScheme) {
    std::cout << "Colorscheme: Generate " << config.colorSchemeTheme
              << " theme from wallpaper\n";

    try {
      scheme = generateColorSchemeFromImage(
          config.wallpaperPath, config.colorSchemeTheme, "colorscheme.txt");
      std::cout << "Colorscheme generated successfully!\n";
    } catch (const std::exception &e) {
      std::cerr << "Failed to generate colorscheme: " << e.what() << "\n";
      return 1;
    }
  } else if (!config.predefinedScheme.empty()) {
    std::cout << "Using predefined " << config.predefinedScheme
              << " colorscheme\n";
    scheme = getColorSchemeByName(config.predefinedScheme);
    scheme.print();
  } else if (!config.generateColorScheme) {
    std::cout << "No colorscheme specified, using default gruvbox-dark\n";
    scheme = GRUVBOX_DARK;
  }

  std::cout << "\n=== Installing ===\n";

  // Set up ~/.local/share/hyprland-dots
  FileManager fm;
  ThemeType theme;

  if (config.colorSchemeTheme == "dark") {
    theme = ThemeType::DARK;
  } else if (config.colorSchemeTheme == "light") {
    theme = ThemeType::LIGHT;
  } else if (config.colorSchemeTheme == "warm") {
    theme = ThemeType::WARM;
  } else {
    theme = ThemeType::DARK; // Default
  }

  if (!config.wallpaperPath.empty()) {
    fm.moveWallpaper(config.wallpaperPath);
  }
  fm.setupLocalPath(config.packages);

  for (const std::string &package_name : config.packages) {
    std::string trimmed_package = setupPackage(package_name, TOTALPACKAGES);

    if (trimmed_package == "Not found.") {
      std::cout << "Package " << package_name << " not found; skipping.\n";
      continue;
    }

    std::cout << "Installing " << trimmed_package << "...\n";
    fm.setupPackageColors(trimmed_package, scheme);
    fm.movePackage(trimmed_package);
    cout << "\n";
  }

  system("hyprctl reload > /dev/null &");
  if (!config.wallpaperPath.empty()) {
    system("swww img ~/.local/share/hyprland-dots/wallpaper.png -t wave "
           "--transition-angle 30");
  }
  std::cout << "\n=== Installation Complete ===\n";
  return 0;
}
