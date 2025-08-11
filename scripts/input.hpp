#pragma once
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

class InputManager {
  std::vector<std::string> totalPackages;
  std::vector<std::string> totalThemes;

public:
  InputManager(std::vector<std::string> packages,
               std::vector<std::string> themes) {
    totalPackages = packages;
    totalThemes = themes;
  }

  std::vector<std::string> packageInput() {

    std::cout << "Welcome to my dotfiles." << std::endl;
    std::cout << "List all of the packages you desire to install out of ";

    // This loop now prints the list more cleanly
    for (size_t i = 0; i < totalPackages.size(); i++) {
      std::cout << totalPackages[i];
      if (i < totalPackages.size() - 1) {
        std::cout << ", ";
      }
    }
    std::cout << "." << std::endl; // Add a period at the end

    std::cout << "They must be separated by commas: " << std::endl;
    std::string packages;
    // Use getline to read the whole line of input, not just the first word
    getline(std::cin, packages);

    std::vector<std::string> vect;
    std::stringstream ss(packages);
    std::string s;

    while (getline(ss, s, ',')) {
      vect.push_back(s);
    }

    return vect;
  }

  std::vector<std::string> themeInput() {
    std::cout << "Please pick a theme." << std::endl;

    for (size_t i = 0; i < totalThemes.size(); i++) {
      std::cout << totalThemes[i];
      if (i < totalThemes.size() - 1) {
        std::cout << ", ";
      }
    }
    std::cout << "." << std::endl;
    std::cout << "Say theme you desire to be installed";

    std::string theme;
    std::cin >> theme;

    std::cout << "Please specify the file path of your wallpaper." << std::endl;
    std::string wallpaperPathStr;
    std::cin >> wallpaperPathStr;

    std::vector<std::string> vect;

    vect.push_back(theme);
    vect.push_back(wallpaperPathStr);

    return vect;
  }
};
