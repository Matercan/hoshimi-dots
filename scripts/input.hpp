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
    bool interactive = false;
    bool generateColorScheme = false;
    std::string colorSchemeTheme = "dark";
  };

  ArgumentParser(const std::vector<std::string> &packages,
                 const std::vector<std::string> &themes)
      : availablePackages(packages), availableThemes(themes) {}

  void printHelp(const char *programName) {
    std::cout << "Usage: " << programName << " [OPTIONS]\n\n";
    std::cout << "Install and configure dotfiles with custom themes\n\n";
    std::cout << "Options:\n";
    std::cout << "  -p, --packages PKG1,PKG2  Install specific packages "
                 "(comma-separated)\n";
    std::cout << "  -w, --wallpaper PATH       Set wallpaper path\n";
    std::cout << "  -c, --colorscheme TYPE     Generate colorscheme from "
                 "wallpaper (dark/light/warm)\n";
    std::cout << "  -i, --interactive          Run in interactive mode\n";
    std::cout << "  -l, --list-packages        List available packages\n";
    std::cout << "  -L, --list-themes          List available themes\n";
    std::cout << "  -h, --help                 Show this help message\n";
    std::cout
        << "  -a, --all                  Install all available packages\n\n";
    std::cout << "Examples:\n";
    std::cout << "  " << programName
              << " -p hypr,waybar,wofi -w ~/wallpaper.png\n";
    std::cout << "  " << programName << " -a -w ~/bg.jpg -c dark\n";
    std::cout << "  " << programName << " --interactive\n";
    std::cout << "  " << programName << " --list-packages\n";
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
    std::cout << "Available themes:\n";
    for (size_t i = 0; i < availableThemes.size(); ++i) {
      std::cout << "  " << availableThemes[i];
      if (i < availableThemes.size() - 1)
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

  bool validateWallpaper(const std::string &path) {
    return std::filesystem::exists(path) && hasEnding(path, ".png");
  }

  Config parse(int argc, char *argv[]) {
    Config config;

    static struct option long_options[] = {
        {"packages", required_argument, 0, 'p'},
        {"theme", required_argument, 0, 't'},
        {"wallpaper", required_argument, 0, 'w'},
        {"colorscheme", required_argument, 0, 'c'},
        {"interactive", no_argument, 0, 'i'},
        {"list-packages", no_argument, 0, 'l'},
        {"list-themes", no_argument, 0, 'L'},
        {"help", no_argument, 0, 'h'},
        {"all", no_argument, 0, 'a'},
        {0, 0, 0, 0}};

    int option_index = 0;
    int c;

    while ((c = getopt_long(argc, argv, "p:t:w:c:ilLha", long_options,
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
      case 'i':
        config.interactive = true;
        break;
      case 'l':
        config.listPackages = true;
        return config;
      case 'L':
        config.listThemes = true;
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

    // Validate colorscheme theme
    if (config.generateColorScheme) {
      if (config.colorSchemeTheme != "dark" &&
          config.colorSchemeTheme != "light" &&
          config.colorSchemeTheme != "warm") {
        std::cerr << "Error: Invalid colorscheme theme '"
                  << config.colorSchemeTheme << "'\n";
        std::cerr << "Valid options: dark, light, warm\n";
        return false;
      }

      if (config.wallpaperPath.empty()) {
        std::cerr << "Error: Colorscheme generation requires a wallpaper "
                     "(-w/--wallpaper)\n";
        return false;
      }
    }

    return true;
  }
};

class InteractiveInputManager {
  std::vector<std::string> totalPackages;
  std::vector<std::string> totalThemes;

public:
  InteractiveInputManager(const std::vector<std::string> &packages,
                          const std::vector<std::string> &themes)
      : totalPackages(packages), totalThemes(themes) {}

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

    std::cout << "\n=== Theme Selection ===\n";
    std::cout << "Available themes: ";

    for (size_t i = 0; i < totalThemes.size(); i++) {
      std::cout << totalThemes[i];
      if (i < totalThemes.size() - 1) {
        std::cout << ", ";
      }
    }
    std::cout << "\n\n";

    std::cout << "Wallpaper path (or press enter to skip): ";
    std::getline(std::cin, config.wallpaperPath);

    if (!config.wallpaperPath.empty()) {
      std::cout << "Generate colorscheme from wallpaper? (y/n): ";
      char choice;
      std::cin >> choice;
      std::cin.ignore();

      if (choice == 'y' || choice == 'Y') {
        config.generateColorScheme = true;
        std::cout << "Colorscheme type (dark/light/warm) [dark]: ";
        std::string csTheme;
        std::getline(std::cin, csTheme);
        config.colorSchemeTheme = csTheme.empty() ? "dark" : csTheme;
      }
    }

    return config;
  }
};
