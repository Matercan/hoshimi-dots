#pragma once

#include "palette.hpp"
#include <filesystem>
#include <fstream>
#include <iostream>
#include <regex>
#include <string>
#include <vector>

using namespace std;
namespace fs = std::filesystem;

class CSSColorUpdater {
private:
  std::vector<std::string> waybarColors = {"background", "border", "hover",
                                           "active", "foreground"};

  std::vector<std::string> wofiColors = {"background", "border", "active",
                                         "foreground"};

  std::vector<std::string> ewwColors = {
      "foreground",   "background",    "hover",
      "accent-hover", "accent-purple", "accent-green",
      "accent-red",   "accent-blue",   "accent-orange"};

public:
  bool updateWaybarColorsRegex(const std::string &cssFilePath,
                               const std::vector<std::string> &colors) {
    if (colors.size() < 5) {
      std::cerr << "Error: Need at least 5 colors for waybar theme"
                << std::endl;
      return false;
    }

    // Read entire file content
    std::string content = readFileContent(cssFilePath);
    if (content.empty()) {
      std::cerr << "Error: Could not read file or file is empty" << std::endl;
      return false;
    }

    // Update each color definition using regex
    for (size_t i = 0; i < std::min(waybarColors.size(), colors.size()); ++i) {
      std::string pattern =
          "@define-color\\s+" + waybarColors[i] + "\\s+[^;]+;";
      std::string replacement =
          "@define-color " + waybarColors[i] + " " + colors[i] + ";";

      std::regex colorRegex(pattern);
      content = std::regex_replace(content, colorRegex, replacement);
    }

    // Write back to file
    return writeContentToFile(cssFilePath, content);
  }

  // Utility: Apply colorscheme to waybar
  bool applyColorSchemeToWaybar(const std::string &waybarConfigDir,
                                const std::vector<std::string> &colors) {
    std::string cssPath = waybarConfigDir + "/style.css";

    std::cout << "Updating waybar colors in: " << cssPath << std::endl;

    // Print what we're applying
    for (size_t i = 0; i < std::min(waybarColors.size(), colors.size()); ++i) {
      std::cout << "  " << waybarColors[i] << ": " << colors[i] << std::endl;
    }

    // Use regex method for robustness
    bool success = updateWaybarColorsRegex(cssPath, colors);

    if (success) {
      std::cout << "Waybar colors updated successfully!" << std::endl;
    } else {
      std::cout << "Failed to update waybar colors." << std::endl;
    }

    return success;
  }

  // Utility: Preview color scheme without applying
  void previewColorScheme(const std::vector<std::string> &colors) {
    std::cout << "Color scheme preview:" << std::endl;
    for (size_t i = 0; i < std::min(waybarColors.size(), colors.size()); ++i) {
      std::cout << "  @define-color " << waybarColors[i] << " " << colors[i]
                << ";" << std::endl;
    }
  }

  bool updateWofiColorsRegex(const std::string &cssFilePath,
                             const std::vector<std::string> &colors) {
    if (colors.size() < 4) {
      std::cerr << "Error: Need at least 4 colors for wofi theme" << std::endl;
      return false;
    }

    // read entire file content
    std::string content = readFileContent(cssFilePath);
    if (content.empty()) {
      std::cerr << "Error: Could not read this file, or file is empty"
                << std::endl;
      return false;
    }

    for (size_t i = 0; i < std::min(waybarColors.size(), colors.size()); ++i) {
      std::string pattern = "@define-color\\s+" + wofiColors[i] + "\\s+[^;]+;";
      std::string replacement =
          "@define-color " + wofiColors[i] + " " + colors[i] + ";";

      std::regex colorRegex(pattern);
      content = std::regex_replace(content, colorRegex, replacement);
    }

    return writeContentToFile(cssFilePath, content);
  }

  bool applyColorSchemeToWofi(const std::string &wofiConfigDir,
                              const std::vector<std::string> &colors) {
    std::string cssPath = wofiConfigDir + "/style.css";
    std::cout << "Updating wofi colors in: " << cssPath << std::endl;

    for (size_t i = 0; i < std::min(waybarColors.size(), colors.size()); ++i) {
      std::cout << "  " << waybarColors[i] << ": " << colors[i] << std::endl;
    }

    bool success = updateWofiColorsRegex(cssPath, colors);

    if (success) {
      std::cout << "Wofi colors updated successfully" << std::endl;
    } else {
      std::cout << "Failed to update wofi colours." << std::endl;
    }

    return success;
  }

  bool updateEwwColorsRegex(const std::string &scssFilePath,
                            const std::vector<std::string> &colors) {
    if (colors.size() < 9) {
      std::cerr << "Error: Need at least 9 colors for eww theme" << std::endl;
      return false;
    }

    // Read entire file content
    std::string content = readFileContent(scssFilePath);
    if (content.empty()) {
      std::cerr << "Error: Could not read file or file is empty" << std::endl;
      return false;
    }

    // Update each SCSS variable using regex
    for (size_t i = 0; i < std::min(ewwColors.size(), colors.size()); ++i) {
      // Pattern matches: $variable-name: #color;
      std::string pattern = "\\$" + ewwColors[i] + ":\\s*[^;]+;";
      std::string replacement = "$" + ewwColors[i] + ": " + colors[i] + ";";

      std::regex colorRegex(pattern);
      content = std::regex_replace(content, colorRegex, replacement);
    }

    // Handle the special case of $border: $foreground;
    // Replace it with the actual foreground color
    if (!colors.empty()) {
      std::regex borderRegex("\\$border:\\s*\\$foreground;");
      std::string borderReplacement = "$border: " + colors[0] + ";";
      content = std::regex_replace(content, borderRegex, borderReplacement);
    }

    // Write back to file
    return writeContentToFile(scssFilePath, content);
  }

  bool applyColorSchemeToEww(const std::string &ewwConfigDir,
                             const std::vector<std::string> &colors) {
    std::string scssPath = ewwConfigDir + "/eww.scss";

    std::cout << "Updating eww colors in: " << scssPath << std::endl;

    // Print what we're applying
    for (size_t i = 0; i < std::min(ewwColors.size(), colors.size()); ++i) {
      std::cout << "  $" << ewwColors[i] << ": " << colors[i] << std::endl;
    }

    // Use regex method for robustness
    bool success = updateEwwColorsRegex(scssPath, colors);

    if (success) {
      std::cout << "EWW colors updated successfully!" << std::endl;
    } else {
      std::cout << "Failed to update EWW colors." << std::endl;
    }

    return success;
  }

private:
  std::string readFileContent(const std::string &filepath) {
    std::ifstream file(filepath);
    if (!file.is_open())
      return "";

    std::string content((std::istreambuf_iterator<char>(file)),
                        std::istreambuf_iterator<char>());
    file.close();
    return content;
  }

  bool writeContentToFile(const std::string &filepath,
                          const std::string &content) {
    // Create backup first
    std::filesystem::copy_file(
        filepath, filepath + ".backup",
        std::filesystem::copy_options::overwrite_existing);

    std::ofstream file(filepath);
    if (!file.is_open()) {
      std::cerr << "Error: Could not write to " << filepath << std::endl;
      return false;
    }

    file << content;
    file.close();
    return true;
  }

  bool writeLinesToFile(const std::string &filepath,
                        const std::vector<std::string> &lines) {
    // Create backup first
    std::filesystem::copy_file(
        filepath, filepath + ".backup",
        std::filesystem::copy_options::overwrite_existing);

    std::ofstream file(filepath);
    if (!file.is_open()) {
      std::cerr << "Error: Could not write to " << filepath << std::endl;
      return false;
    }

    for (const auto &line : lines) {
      file << line << std::endl;
    }
    file.close();
    return true;
  }
};

class FileManager {

  // Get source and destination paths
  fs::path dotfilesSource = fs::current_path() / "config";
  fs::path configfilesDest = fs::path(getenv("HOME")) / ".config";
  fs::path assetsSource = fs::current_path() / "assets";
  fs::path localPath = fs::path(getenv("HOME")) / ".local/share/hyprland-dots";

  std::string extractHexCode(const std::string &input) {
    std::regex pattern(R"(=\s*(#[0-9a-fA-F]+)\s*$)");
    std::smatch match;

    if (std::regex_search(input, match, pattern)) {
      return match[1].str(); // Return the captured hex code
    }
    return ""; // Return empty string if no match found
  }

  vector<string> getColors(fs::path colorschemeFilePath) {
    ifstream f(colorschemeFilePath.string());
    vector<string> vec;
    vec.reserve(24);

    string line;
    while (getline(f, line)) {
      string trimmed_line = extractHexCode(line);

      if (!trimmed_line.empty()) {
        vec.push_back(trimmed_line);
      }
    }

    return vec;
  }

public:
  FileManager() {
    // Ensure the destination config directory exists
    if (!fs::exists(configfilesDest)) {
      fs::create_directories(configfilesDest);
    }
  }

  void moveWallpaper(string &wallpaper) {
    fs::path destinationPath = localPath / "wallpaper.png";

    fs::copy(fs::path(wallpaper), destinationPath,
             fs::copy_options::overwrite_existing);
  }

  void setupLocalPath(vector<string> packages) {
    if (!fs::exists(localPath)) {
      fs::create_directory(localPath);
    }

    for (int i = 0; i < packages.size(); ++i) {
      fs::path sourcePath = dotfilesSource / packages[i];
      fs::path destPath = localPath / packages[i];

      // Check if source exists
      if (!fs::exists(sourcePath)) {
        std::cerr << "Warning: Source path " << sourcePath
                  << " doesn't exist, skipping.\n";
        continue;
      }

      try {
        if (fs::is_directory(sourcePath)) {
          // Copy directory recursively
          fs::copy(sourcePath, destPath,
                   fs::copy_options::recursive |
                       fs::copy_options::overwrite_existing);
        } else {
          // It's a file, copy normally
          fs::create_directories(
              destPath.parent_path()); // Ensure parent dir exists
          fs::copy_file(sourcePath, destPath,
                        fs::copy_options::overwrite_existing);
        }
      } catch (const fs::filesystem_error &e) {
        std::cerr << "Error copying " << sourcePath << " to " << destPath
                  << ": " << e.what() << std::endl;
      }
    }

    // Copy assets directory
    try {
      if (fs::exists(assetsSource)) {
        fs::copy(assetsSource, localPath / "assets",
                 fs::copy_options::recursive |
                     fs::copy_options::overwrite_existing);
      }
    } catch (const fs::filesystem_error &e) {
      std::cerr << "Error copying assets: " << e.what() << std::endl;
    }
  }

  fs::path getAssetsDir() { return localPath / "assets"; }

  void setupPackageColors(string &package, ColorScheme scheme) {
    try {
      fs::copy(fs::current_path() / "colorscheme.txt", localPath,
               fs::copy_options::overwrite_existing);
    } catch (const fs::filesystem_error &e) {
      std::cerr << "Error copying colorscheme" << e.what() << std::endl;
      return;
    }

    fs::path colorscheme = localPath / "colorscheme.txt";
    vector<string> colors = getColors(colorscheme);

    CSSColorUpdater updater;

    if (package == "ghostty") {
      fs::copy(colorscheme, localPath / "ghostty/themes/");
      fs::rename(localPath / "ghostty/themes/colorscheme.txt",
                 localPath / "ghostty/themes/colorscheme");
    } else if (package == "waybar") {
      vector<string> waybarColors = {
          scheme.background,          scheme.foreground, scheme.palette[4],
          scheme.selectionBackground, scheme.foreground,
      };

      updater.applyColorSchemeToWaybar(localPath.string() + "/waybar",
                                       waybarColors);
    } else if (package == "wofi") {
      vector<string> wofiColors = {scheme.background, scheme.foreground,
                                   scheme.palette[4], scheme.foreground};
      updater.applyColorSchemeToWofi(localPath.string() + "/wofi", wofiColors);
    } else if (package == "eww") {
      vector<string> ewwColors = {
          scheme.foreground,          scheme.background, scheme.palette[8],
          scheme.selectionBackground, scheme.palette[5], scheme.palette[2],
          scheme.palette[1],          scheme.palette[4], scheme.palette[3]};
      updater.applyColorSchemeToEww(localPath.string() + "/eww", ewwColors);
    }

    else {
      cout << "Package " << package << " does not use colors." << endl;
    }
  }

  void movePackage(string trimmed_package) {
    cout << "Moving config folders for " << trimmed_package << endl;

    if (trimmed_package == "hyprland") {
      trimmed_package = "hypr";
    }

    // Write config files for packages.

    fs::path dotfilePath = localPath / trimmed_package;
    fs::path configPath = configfilesDest / trimmed_package;

    // Check if the source directory exists before trying to copy
    if (fs::exists(dotfilePath)) {
      // Move existing destination directory to avoid conflicts
      if (fs::exists(configPath)) {
        fs::path backupPath =
            fs::current_path() / fs::path("backup/" + trimmed_package);
        cout << "Package at " << configPath << " already exists, copying into "
             << backupPath.string() << endl;

        // Check and create the parent 'backup' directory if it doesn't exist
        fs::create_directories(backupPath.parent_path());

        // fs::rename will fail if the destination directory exists, so remove
        // it first
        if (fs::exists(backupPath)) {
          fs::remove_all(backupPath);
        }

        fs::rename(configPath, backupPath);
      }
      // Use std::filesystem::copy for a robust directory copy
      try {
        fs::copy(dotfilePath, configPath, fs::copy_options::recursive);
        cout << "Successfully copied " << trimmed_package << " config to "
             << configPath << endl;
      } catch (const fs::filesystem_error &e) {
        cerr << "Error copying " << trimmed_package << " config: " << e.what()
             << endl;
      }
    } else {
      cout << "Source directory " << dotfilePath
           << " does not exist, skipping config copy." << endl;
    }
  }
};
