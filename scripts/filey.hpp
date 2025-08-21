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

class DotfileColorUpdater {
private:
  std::vector<std::string> waybarColors = {"background", "border", "hover",
                                           "active", "foreground"};

  std::vector<std::string> wofiColors = {"background", "border", "active",
                                         "foreground"};

  std::vector<std::string> ewwColors = {
      "foreground",   "background",    "hover",
      "accent-hover", "accent-purple", "accent-green",
      "accent-red",   "accent-blue",   "accent-orange"};

  // Cava uses 7 gradient colors
  std::vector<std::string> cavaGradientColors = {"gradient_color_1",
                                                 "gradient_color_2"};

  std::vector<std::string> quickshellColors = {"backgroundColor",
                                               "foregroundColor", "borderColor",
                                               "activeColor", "selectedColor"};

  // Dunst color mappings - background, foreground, frame
  struct DunstColors {
    std::string background;
    std::string foreground;
    std::string frame;
    std::string critical_frame;
  };

public:
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

    for (size_t i = 0; i < std::min(wofiColors.size(), colors.size()); ++i) {
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

    for (size_t i = 0; i < std::min(wofiColors.size(), colors.size()); ++i) {
      std::cout << "  " << wofiColors[i] << ": " << colors[i] << std::endl;
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

  bool updateCavaColorsRegex(const std::string &configFilePath,
                             const std::vector<std::string> &colors) {
    if (colors.size() < 2) {
      std::cerr << "Error: Need at least 7 colors for cava gradient theme"
                << std::endl;
      return false;
    }

    // Read entire file content
    std::string content = readFileContent(configFilePath);
    if (content.empty()) {
      std::cerr << "Error: Could not read file or file is empty" << std::endl;
      return false;
    }

    // Update each gradient color using regex
    for (size_t i = 0; i < std::min(cavaGradientColors.size(), colors.size());
         ++i) {
      // Pattern matches: gradient_color_N = '#color'
      std::string pattern = cavaGradientColors[i] + "\\s*=\\s*'[^']*'";
      std::string replacement =
          cavaGradientColors[i] + " = '" + colors[i] + "'";

      std::regex colorRegex(pattern);
      content = std::regex_replace(content, colorRegex, replacement);
    }

    // Write back to file
    return writeContentToFile(configFilePath, content);
  }

  bool applyColorSchemeToCava(const std::string &cavaConfigPath,
                              const std::vector<std::string> &colors) {
    std::cout << "Updating cava colors in: " << cavaConfigPath << std::endl;

    // Print what we're applying
    for (size_t i = 0; i < std::min(cavaGradientColors.size(), colors.size());
         ++i) {
      std::cout << "  " << cavaGradientColors[i] << " = '" << colors[i] << "'"
                << std::endl;
    }

    // Use regex method for robustness
    bool success = updateCavaColorsRegex(cavaConfigPath + "config", colors);

    if (success) {
      std::cout << "Cava colors updated successfully!" << std::endl;
    } else {
      std::cout << "Failed to update cava colors." << std::endl;
    }

    return success;
  }

  // Function to update QML colors using regex
  bool updateQuickshellColorsRegex(const std::string &qmlFilePath,
                                   const std::vector<std::string> &colors) {
    if (colors.size() < 5) {
      std::cerr << "Error: Need at least 5 colors for quickshell theme"
                << std::endl;
      return false;
    }

    // Read entire file content
    std::string content = readFileContent(qmlFilePath);
    if (content.empty()) {
      std::cerr << "Error: Could not read file or file is empty" << std::endl;
      return false;
    }

    // Update backgroundColor
    std::regex bgRegex(
        "(property\\s+string\\s+backgroundColor:\\s*)\"[^\"]*\"");
    std::string bgReplacement = "$1\"" + colors[0] + "\"";
    content = std::regex_replace(content, bgRegex, bgReplacement);

    // Update foregroundColor
    std::regex fgRegex(
        "(property\\s+string\\s+foregroundColor:\\s*)\"[^\"]*\"");
    std::string fgReplacement = "$1\"" + colors[1] + "\"";
    content = std::regex_replace(content, fgRegex, fgReplacement);

    // Update borderColor (note: it references foregroundColor by default, so we
    // set it explicitly)
    std::regex borderRegex(
        "(property\\s+string\\s+borderColor:\\s*)(foregroundColor|\"[^\"]*\")");
    std::string borderReplacement = "$1\"" + colors[2] + "\"";
    content = std::regex_replace(content, borderRegex, borderReplacement);

    // Update activeColor
    std::regex activeRegex(
        "(property\\s+string\\s+activeColor:\\s*)\"[^\"]*\"");
    std::string activeReplacement = "$1\"" + colors[3] + "\"";
    content = std::regex_replace(content, activeRegex, activeReplacement);

    // Update selectedColor
    std::regex selectedRegex(
        "(property\\s+string\\s+selectedColor:\\s*)\"[^\"]*\"");
    std::string selectedReplacement = "$1\"" + colors[4] + "\"";
    content = std::regex_replace(content, selectedRegex, selectedReplacement);

    // Write back to file
    return writeContentToFile(qmlFilePath, content);
  }
  bool applyColorSchemeToQuickshell(const std::string &quickshellConfigPath,
                                    const std::vector<std::string> &colors) {
    std::cout << "Updating quickshell colors in: " << quickshellConfigPath
              << std::endl;

    // Print what we're applying
    for (size_t i = 0; i < std::min(quickshellColors.size(), colors.size());
         ++i) {
      std::cout << "  " << quickshellColors[i] << " = '" << colors[i] << "'"
                << std::endl;
    }

    // Use regex method for robustness
    bool success = updateQuickshellColorsRegex(
        quickshellConfigPath + "functions/Colors.qml", colors);

    if (success) {
      std::cout << "Cava colors quickshell successfully!" << std::endl;
    } else {
      std::cout << "Failed to update quickshell colors." << std::endl;
    }

    return success;
  }

  bool updateDunstColorsRegex(const std::string &configFilePath,
                              const DunstColors &colors) {
    // Read entire file content
    std::string content = readFileContent(configFilePath);
    if (content.empty()) {
      std::cerr << "Error: Could not read file or file is empty" << std::endl;
      return false;
    }

    // Update global frame color
    std::regex frameRegex("frame_color\\s*=\\s*\"[^\"]*\"");
    std::string frameReplacement = "frame_color = \"" + colors.frame + "\"";
    content = std::regex_replace(content, frameRegex, frameReplacement);

    // Update urgency_low colors
    std::regex lowBgRegex(
        "(\\[urgency_low\\][^\\[]*background\\s*=\\s*)\"[^\"]*\"");
    std::string lowBgReplacement = "$1\"" + colors.background + "\"";
    content = std::regex_replace(content, lowBgRegex, lowBgReplacement);

    std::regex lowFgRegex(
        "(\\[urgency_low\\][^\\[]*foreground\\s*=\\s*)\"[^\"]*\"");
    std::string lowFgReplacement = "$1\"" + colors.foreground + "\"";
    content = std::regex_replace(content, lowFgRegex, lowFgReplacement);

    // Update urgency_normal colors
    std::regex normalBgRegex(
        "(\\[urgency_normal\\][^\\[]*background\\s*=\\s*)\"[^\"]*\"");
    std::string normalBgReplacement = "$1\"" + colors.background + "\"";
    content = std::regex_replace(content, normalBgRegex, normalBgReplacement);

    std::regex normalFgRegex(
        "(\\[urgency_normal\\][^\\[]*foreground\\s*=\\s*)\"[^\"]*\"");
    std::string normalFgReplacement = "$1\"" + colors.foreground + "\"";
    content = std::regex_replace(content, normalFgRegex, normalFgReplacement);

    // Update urgency_critical colors
    std::regex criticalBgRegex(
        "(\\[urgency_critical\\][^\\[]*background\\s*=\\s*)\"[^\"]*\"");
    std::string criticalBgReplacement = "$1\"" + colors.background + "\"";
    content =
        std::regex_replace(content, criticalBgRegex, criticalBgReplacement);

    std::regex criticalFgRegex(
        "(\\[urgency_critical\\][^\\[]*foreground\\s*=\\s*)\"[^\"]*\"");
    std::string criticalFgReplacement = "$1\"" + colors.foreground + "\"";
    content =
        std::regex_replace(content, criticalFgRegex, criticalFgReplacement);

    std::regex criticalFrameRegex(
        "(\\[urgency_critical\\][^\\[]*frame_color\\s*=\\s*)\"[^\"]*\"");
    std::string criticalFrameReplacement =
        "$1\"" + colors.critical_frame + "\"";
    content = std::regex_replace(content, criticalFrameRegex,
                                 criticalFrameReplacement);

    // Write back to file
    return writeContentToFile(configFilePath, content);
  }

  bool applyColorSchemeToDunst(const std::string &dunstConfigPath,
                               const std::vector<std::string> &colors) {
    if (colors.size() < 3) {
      std::cerr << "Error: Need at least 3 colors for dunst theme (background, "
                   "foreground, frame)"
                << std::endl;
      return false;
    }

    std::cout << "Updating dunst colors in: " << dunstConfigPath << std::endl;

    // Create dunst color structure from provided colors
    DunstColors dunstColors;
    dunstColors.background = colors[0]; // Use first color as background
    dunstColors.foreground = colors[1]; // Use second color as foreground
    dunstColors.frame = colors[2];      // Use third color as frame

    // Use a more vibrant color for critical notifications (red-ish)
    if (colors.size() >= 4) {
      dunstColors.critical_frame = colors[3]; // Use fourth color if available
    } else {
      dunstColors.critical_frame = "#ff0000"; // Fallback to red
    }

    // Print what we're applying
    std::cout << "  Background: " << dunstColors.background << std::endl;
    std::cout << "  Foreground: " << dunstColors.foreground << std::endl;
    std::cout << "  Frame: " << dunstColors.frame << std::endl;
    std::cout << "  Critical Frame: " << dunstColors.critical_frame
              << std::endl;

    // Use regex method for robustness
    bool success = updateDunstColorsRegex(dunstConfigPath, dunstColors);

    if (success) {
      std::cout << "Dunst colors updated successfully!" << std::endl;
    } else {
      std::cout << "Failed to update dunst colors." << std::endl;
    }

    return success;
  }

  std::vector<std::string>
  generateGradientColors(const std::vector<std::string> &baseColors,
                         size_t count = 7) {
    if (baseColors.empty()) {
      return std::vector<std::string>(count, "#ffffff");
    }

    std::vector<std::string> gradient;
    gradient.reserve(count);

    // If we have enough colors, use them directly
    if (baseColors.size() >= count) {
      for (size_t i = 0; i < count; ++i) {
        gradient.push_back(baseColors[i]);
      }
      return gradient;
    }

    // Generate gradient by interpolating between available colors
    for (size_t i = 0; i < count; ++i) {
      double ratio = static_cast<double>(i) / (count - 1);
      size_t baseIndex = static_cast<size_t>(ratio * (baseColors.size() - 1));
      gradient.push_back(baseColors[baseIndex]);
    }

    return gradient;
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
    try {
      std::filesystem::copy_file(
          filepath, filepath + ".backup",
          std::filesystem::copy_options::overwrite_existing);
    } catch (const std::exception &e) {
      std::cerr << "Warning: Could not create backup for " << filepath << ": "
                << e.what() << std::endl;
    }

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
    try {
      std::filesystem::copy_file(
          filepath, filepath + ".backup",
          std::filesystem::copy_options::overwrite_existing);
    } catch (const std::exception &e) {
      std::cerr << "Warning: Could not create backup for " << filepath << ": "
                << e.what() << std::endl;
    }

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
    scheme.writeToFile("colorscheme.txt");
    try {
      fs::copy(fs::current_path() / "colorscheme.txt", localPath,
               fs::copy_options::overwrite_existing);
    } catch (const fs::filesystem_error &e) {
      std::cerr << "Error copying colorscheme" << e.what() << std::endl;
      return;
    }

    fs::path colorscheme = localPath / "colorscheme.txt";
    vector<string> colors = getColors(colorscheme);

    DotfileColorUpdater updater;

    if (package == "ghostty") {
      fs::copy(colorscheme, localPath / "ghostty/themes/");
      fs::rename(localPath / "ghostty/themes/colorscheme.txt",
                 localPath / "ghostty/themes/colorscheme");
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
      system("eww reload > /dev/null &");
    } else if (package == "cava") {
      vector<string> cavaColors = {scheme.palette[4], scheme.palette[7]};
      // Fixed: Pass directory path, the method handles adding "/config"
      updater.applyColorSchemeToCava(localPath.string() + "/cava/", cavaColors);
    } else if (package == "dunst") {
      vector<string> dunstColors = {scheme.background, scheme.foreground,
                                    scheme.foreground, scheme.palette[1]};
      updater.applyColorSchemeToDunst(localPath.string() + "/dunst/dunstrc",
                                      dunstColors);
      // Restart dunst to apply changes
      system("killall dunst && dunst > /dev/null 2>&1 &");
    } else if (package == "quickshell") {
      vector<string> barColors = {scheme.background, scheme.foreground,
                                  scheme.foreground, scheme.palette[1],
                                  scheme.selectionForeground};
      updater.applyColorSchemeToQuickshell(localPath.string() + "/quickshell/",
                                           barColors);
      system("killall quickshell && quickshell > /dev/null 2&>1 &");
    } else {
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
