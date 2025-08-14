#pragma once

#include <algorithm>
#include <filesystem>
#include <getopt.h>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

class ArgumentParser {
private:
  std::vector<std::string> availablePackages;
  std::vector<std::string> availableThemes;
  std::vector<std::string> availableSchemes;

  bool hasEnding(std::string const &fullString, std::string const &ending) {
    if (fullString.length() >= ending.length()) {
      return (0 == fullString.compare(fullString.length() - ending.length(),
                                      ending.length(), ending));
    } else {
      return false;
    }
  }

public:
  struct Config {
    std::vector<std::string> packages;
    std::string wallpaperPath;
    bool showHelp = false;
    bool listPackages = false;
    bool listThemes = false;
    bool listSchemes = false;
    bool interactive = false;
    bool generateColorScheme = false;
    std::string colorSchemeTheme = "dark";
    std::string predefinedScheme = "";
  };

  ArgumentParser(const std::vector<std::string> &packages,
                 const std::vector<std::string> &themes,
                 const std::vector<std::string> &schemes)
      : availablePackages(packages), availableThemes(themes),
        availableSchemes(schemes) {}

  void printHelp(const char *programName) {
    std::cout << "Usage: " << programName << " [OPTIONS]\n\n";
    std::cout << "Install and configure dotfiles with custom themes\n\n";
    std::cout << "Options:\n";
    std::cout << "  -p, --packages PKG1,PKG2  Install specific packages "
                 "(comma-separated)\n";
    std::cout << "  -w, --wallpaper PATH       Set wallpaper path\n";
    std::cout
        << "  -c, --colorscheme TYPE     Generate colorscheme from wallpaper\n";
    std::cout
        << "                             Available types: dark, light, warm\n";
    std::cout << "  -s, --scheme NAME          Use predefined color scheme\n";
    std::cout << "                             Available schemes: "
                 "catppuccin-mocha,\n";
    std::cout
        << "                             catppuccin-latte, gruvbox-dark,\n";
    std::cout << "                             gruvbox-light, dracula\n";
    std::cout << "  -i, --interactive          Run in interactive mode\n";
    std::cout << "  -l, --list-packages        List available packages\n";
    std::cout
        << "  -L, --list-themes          List available wallpaper themes\n";
    std::cout
        << "  -S, --list-schemes         List available predefined schemes\n";
    std::cout << "  -h, --help                 Show this help message\n";
    std::cout
        << "  -a, --all                  Install all available packages\n\n";
    std::cout << "Examples:\n";
    std::cout << "  " << programName << " -p hypr,waybar,wofi -s dracula\n";
    std::cout << "  " << programName << " -a -w ~/bg.jpg -c dark\n";
    std::cout << "  " << programName << " -p dunst,fish -s catppuccin-mocha\n";
    std::cout << "  " << programName << " --interactive\n";
    std::cout << "  " << programName << " --list-schemes\n";
  }

  void listPackages() {
    std::cout << "Available packages:\n";
    for (size_t i = 0; i < availablePackages.size(); ++i) {
      std::cout << "  " << availablePackages[i];
      if (i < availablePackages.size() - 1)
        std::cout << "\n";
    }
    std::cout << std::endl;
  }

  void listThemes() {
    std::cout << "Available wallpaper generation themes:\n";
    for (size_t i = 0; i < availableThemes.size(); ++i) {
      std::cout << "  " << availableThemes[i];
      if (i < availableThemes.size() - 1)
        std::cout << "\n";
    }
    std::cout << std::endl;
  }

  void listSchemes() {
    std::cout << "Available predefined color schemes:\n";
    for (size_t i = 0; i < availableSchemes.size(); ++i) {
      std::cout << "  " << availableSchemes[i];
      if (i < availableSchemes.size() - 1)
        std::cout << "\n";
    }
    std::cout << std::endl;
  }

  std::vector<std::string> parsePackageList(const std::string &packageStr) {
    std::vector<std::string> packages;
    std::stringstream ss(packageStr);
    std::string package;

    while (std::getline(ss, package, ',')) {
      // Trim whitespace
      package.erase(0, package.find_first_not_of(" \t"));
      package.erase(package.find_last_not_of(" \t") + 1);
      if (!package.empty()) {
        packages.push_back(package);
      }
    }

    return packages;
  }

  bool validatePackage(const std::string &package) {
    return std::find(availablePackages.begin(), availablePackages.end(),
                     package) != availablePackages.end();
  }

  bool validateTheme(const std::string &theme) {
    return std::find(availableThemes.begin(), availableThemes.end(), theme) !=
           availableThemes.end();
  }

  bool validateScheme(const std::string &scheme) {
    return std::find(availableSchemes.begin(), availableSchemes.end(),
                     scheme) != availableSchemes.end();
  }

  bool validateWallpaper(const std::string &path) {
    return std::filesystem::exists(path) &&
           (hasEnding(path, ".png") || hasEnding(path, ".jpeg") ||
            hasEnding(path, ".jpg"));
  }

  Config parse(int argc, char *argv[]) {
    Config config;

    static struct option long_options[] = {
        {"packages", required_argument, 0, 'p'},
        {"theme", required_argument, 0, 't'},
        {"wallpaper", required_argument, 0, 'w'},
        {"colorscheme", required_argument, 0, 'c'},
        {"scheme", required_argument, 0, 's'},
        {"interactive", no_argument, 0, 'i'},
        {"list-packages", no_argument, 0, 'l'},
        {"list-themes", no_argument, 0, 'L'},
        {"list-schemes", no_argument, 0, 'S'},
        {"help", no_argument, 0, 'h'},
        {"all", no_argument, 0, 'a'},
        {0, 0, 0, 0}};

    int option_index = 0;
    int c;

    while ((c = getopt_long(argc, argv, "p:t:w:c:s:ilLSha", long_options,
                            &option_index)) != -1) {
      switch (c) {
      case 'p':
        config.packages = parsePackageList(optarg);
        break;
      case 'w':
        config.wallpaperPath = optarg;
        break;
      case 'c':
        config.generateColorScheme = true;
        config.colorSchemeTheme = optarg;
        break;
      case 's':
        config.predefinedScheme = optarg;
        break;
      case 'i':
        config.interactive = true;
        break;
      case 'l':
        config.listPackages = true;
        return config;
      case 'L':
        config.listThemes = true;
        return config;
      case 'S':
        config.listSchemes = true;
        return config;
      case 'h':
        config.showHelp = true;
        return config;
      case 'a':
        config.packages = availablePackages;
        break;
      case '?':
        std::cerr << "Unknown option. Use -h for help.\n";
        config.showHelp = true;
        return config;
      default:
        break;
      }
    }

    return config;
  }

  bool validateConfig(const Config &config) {
    // Validate packages
    for (const auto &pkg : config.packages) {
      if (!validatePackage(pkg)) {
        std::cerr << "Error: Unknown package '" << pkg << "'\n";
        std::cerr << "Use --list-packages to see available packages.\n";
        return false;
      }
    }

    // Validate wallpaper
    if (!config.wallpaperPath.empty() &&
        !validateWallpaper(config.wallpaperPath)) {
      std::cerr << "Error: Wallpaper file '" << config.wallpaperPath
                << "' not found or invalid format.\n";
      std::cerr << "Supported formats: .png, .jpg, .jpeg\n";
      return false;
    }

    // Validate colorscheme theme (for wallpaper generation)
    if (config.generateColorScheme) {
      if (!validateTheme(config.colorSchemeTheme)) {
        std::cerr << "Error: Invalid colorscheme theme '"
                  << config.colorSchemeTheme << "'\n";
        std::cerr << "Valid wallpaper generation themes: ";
        for (size_t i = 0; i < availableThemes.size(); ++i) {
          std::cerr << availableThemes[i];
          if (i < availableThemes.size() - 1) {
            std::cerr << ", ";
          }
        }
        std::cerr << "\n";
        return false;
      }

      if (config.wallpaperPath.empty()) {
        std::cerr << "Error: Colorscheme generation requires a wallpaper "
                     "(-w/--wallpaper)\n";
        return false;
      }
    }

    // Validate predefined scheme
    if (!config.predefinedScheme.empty() &&
        !validateScheme(config.predefinedScheme)) {
      std::cerr << "Error: Invalid predefined scheme '"
                << config.predefinedScheme << "'\n";
      std::cerr << "Valid predefined schemes: ";
      for (size_t i = 0; i < availableSchemes.size(); ++i) {
        std::cerr << availableSchemes[i];
        if (i < availableSchemes.size() - 1) {
          std::cerr << ", ";
        }
      }
      std::cerr << "\n";
      return false;
    }

    // Check for conflicting options
    if (config.generateColorScheme && !config.predefinedScheme.empty()) {
      std::cerr << "Error: Cannot use both wallpaper generation (-c) and "
                   "predefined scheme (-s)\n";
      return false;
    }

    return true;
  }
};

class InteractiveInputManager {
  std::vector<std::string> totalPackages;
  std::vector<std::string> totalThemes;
  std::vector<std::string> totalSchemes;

public:
  InteractiveInputManager(const std::vector<std::string> &packages,
                          const std::vector<std::string> &themes,
                          const std::vector<std::string> &schemes)
      : totalPackages(packages), totalThemes(themes), totalSchemes(schemes) {}

  std::vector<std::string> packageInput() {
    std::cout << "\n=== Package Selection ===\n";
    std::cout << "Available packages: ";

    for (size_t i = 0; i < totalPackages.size(); i++) {
      std::cout << totalPackages[i];
      if (i < totalPackages.size() - 1) {
        std::cout << ", ";
      }
    }
    std::cout << "\n\n";

    std::cout << "Enter packages (comma-separated) or 'all' for everything: ";
    std::string packages;
    std::getline(std::cin, packages);

    if (packages == "all") {
      return totalPackages;
    }

    std::vector<std::string> vect;
    std::stringstream ss(packages);
    std::string s;

    while (std::getline(ss, s, ',')) {
      // Trim whitespace
      s.erase(0, s.find_first_not_of(" \t"));
      s.erase(s.find_last_not_of(" \t") + 1);
      if (!s.empty()) {
        vect.push_back(s);
      }
    }

    return vect;
  }

  ArgumentParser::Config themeInput() {
    ArgumentParser::Config config;

    std::cout << "\n=== Color Configuration ===\n";
    std::cout << "Choose color configuration method:\n";
    std::cout << "1. Use predefined color scheme\n";
    std::cout << "2. Generate from wallpaper\n";
    std::cout << "3. Skip (use default)\n";
    std::cout << "Enter choice (1-3) [1]: ";

    std::string choice;
    std::getline(std::cin, choice);

    if (choice.empty() || choice == "1") {
      // Predefined scheme
      std::cout << "\nAvailable predefined schemes: ";
      for (size_t i = 0; i < totalSchemes.size(); i++) {
        std::cout << totalSchemes[i];
        if (i < totalSchemes.size() - 1) {
          std::cout << ", ";
        }
      }
      std::cout << "\n\nSelect scheme [gruvbox-dark]: ";
      std::getline(std::cin, config.predefinedScheme);
      if (config.predefinedScheme.empty()) {
        config.predefinedScheme = "gruvbox-dark";
      }
      std::cout << "Using predefined " << config.predefinedScheme
                << " scheme.\n";

    } else if (choice == "2") {
      // Generate from wallpaper
      std::cout << "Wallpaper path: ";
      std::getline(std::cin, config.wallpaperPath);

      if (!config.wallpaperPath.empty()) {
        std::cout << "\nAvailable generation themes: ";
        for (size_t i = 0; i < totalThemes.size(); i++) {
          std::cout << totalThemes[i];
          if (i < totalThemes.size() - 1) {
            std::cout << ", ";
          }
        }
        std::cout << "\n\nGeneration theme [dark]: ";
        std::getline(std::cin, config.colorSchemeTheme);
        if (config.colorSchemeTheme.empty()) {
          config.colorSchemeTheme = "dark";
        }
        config.generateColorScheme = true;
        std::cout << "Will generate " << config.colorSchemeTheme
                  << " theme from wallpaper.\n";
      } else {
        std::cout << "No wallpaper provided, using default scheme.\n";
        config.predefinedScheme = "gruvbox-dark";
      }

    } else {
      // Skip - use default
      std::cout << "Using default gruvbox-dark scheme.\n";
      config.predefinedScheme = "gruvbox-dark";
    }

    return config;
  }
};
;
