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
                                      "hypr",    "catalyst"};

const vector<string> TOTALTHEMES = {"dark", "warm", "light"};

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

    if (trimmed_package == "starhip") {
      cout << "starship not implimented yet" << endl;
      return "Starship.";
    }

    return trimmed_package;
  } else {
    return "Not found.";
  }
}

int main(int argc, char *argv[]) {
  // Your available packages and themes
  std::vector<std::string> TOTALPACKAGES = {
      "ghostty", "hypr",    "fish",  "eww",      "waybar",
      "wofi",    "vesktop", "dunst", "catalyst", "fastfetch"};

  std::vector<std::string> TOTALTHEMES = {"dark", "light", "warm"};

  ArgumentParser parser(TOTALPACKAGES, TOTALTHEMES);

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

  // Interactive mode
  if (config.interactive) {
    InteractiveInputManager input(TOTALPACKAGES, TOTALTHEMES);
    config.packages = input.packageInput();
    auto themeConfig = input.themeInput();
    config.wallpaperPath = themeConfig.wallpaperPath;
    config.generateColorScheme = themeConfig.generateColorScheme;
    config.colorSchemeTheme = themeConfig.colorSchemeTheme;
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
      scheme = generateColorSchemeFromPNG(
          config.wallpaperPath, config.colorSchemeTheme, "colorscheme.txt");
      std::cout << "Colorscheme generated successfully!\n";
    } catch (const std::exception &e) {
      std::cerr << "Failed to generate colorscheme: " << e.what() << "\n";
    }
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
  }

  fm.moveWallpaper(config.wallpaperPath);
  fm.setupLocalPath(config.packages);

  for (const std::string &package_name : config.packages) {
    std::string trimmed_package = setupPackage(package_name, TOTALPACKAGES);

    if (trimmed_package == "Not Found.") {
      std::cout << "Package " << package_name << " not found; skipping.\n";
      continue;
    }

    std::cout << "Installing " << trimmed_package << "...\n";
    fm.setupPackageColors(trimmed_package, scheme);
    fm.movePackage(trimmed_package);
    cout << "\n";
  }

  system("hyprctl reload > /dev/null &");
  system("swww img ~/.local/share/hyprland-dots/wallpaper.png");
  std::cout << "\n=== Installation Complete ===\n";
  return 0;
}
