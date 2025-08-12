#pragma once

#include <filesystem>
#include <iostream>
#include <string>
#include <vector>

using namespace std;
namespace fs = std::filesystem;

class FileManager {

  // Get source and destination paths
  fs::path dotfilesSource = fs::current_path() / "config";
  fs::path configfilesDest = fs::path(getenv("HOME")) / ".config";
  fs::path assetsSource = fs::current_path() / "assets";
  fs::path localPath = fs::path(getenv("HOME")) / ".local/share/hyprland-dots";

public:
  FileManager() {
    // Ensure the destination config directory exists
    if (!fs::exists(configfilesDest)) {
      fs::create_directories(configfilesDest);
    }
  }

  void moveWallpaper(string &wallpaper) {
    fs::copy_file(fs::path(wallpaper), localPath);
    fs::rename(localPath / wallpaper, "wallpaper");
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

  void movePackage(string trimmed_package) {
    cout << "Moving config folders for " << trimmed_package << endl;

    if (trimmed_package == "hyprland") {
      trimmed_package = "hypr";
    }

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
