#pragma once

#include "palette.hpp"
#include <filesystem>
#include <iostream>
#include <string.h>
#include <string>

using namespace std;
namespace fs = std::filesystem;

class EnvManager {
public:
  void setVariables(const std::string &wallpaperPath,
                    const std::string &assetsDir, int theme) {
    // Create the "KEY=VALUE" string using std::string concatenation
    std::string *wallpaperEnv = new std::string;
    *wallpaperEnv = "WALLPAPER=" + wallpaperPath;

    char *envString = new char[wallpaperEnv->length() + 1];
    strcpy(envString, wallpaperEnv->c_str());

    // set the environment variable
    putenv(envString);
    delete wallpaperEnv;

    std::string *assetsEnv = new std::string("ASSETS_DIR=" + assetsDir);

    char *ptr = envString;
    envString = new char[assetsEnv->length() + 1];
    delete ptr;
    strcpy(envString, assetsEnv->c_str());

    putenv(envString);
    delete assetsEnv;

    std::string *themeEnv = new std::string("HYPR_THEME=");

    if (theme == DARK) {
      *themeEnv += std::string("DARK");
    } else if (theme == LIGHT) {
      *themeEnv += std::string("LIGHT");
    } else if (theme == WARM) {
      *themeEnv += std::string("WARM");
    }

    ptr = envString;
    envString = new char[themeEnv->length() + 1];
    delete ptr;
    strcpy(envString, themeEnv->c_str());

    putenv(envString);
    delete themeEnv;
    delete[] envString;
  }
};

class FileManager {

  // Get source and destination paths
  fs::path dotfilesSource = fs::current_path().parent_path() / "config";
  fs::path configfilesDest = fs::path(getenv("HOME")) / ".config";

public:
  FileManager() {
    // Ensure the destination config directory exists
    if (!fs::exists(configfilesDest)) {
      fs::create_directories(configfilesDest);
    }
  }

  void movePackage(string trimmed_package) {
    cout << "Moving config folders for " << trimmed_package << endl;
    fs::path dotfilePath = dotfilesSource / trimmed_package;
    fs::path configPath = configfilesDest / trimmed_package;

    // Check if the source directory exists before trying to copy
    if (fs::exists(dotfilePath)) {
      // Move existing destination directory to avoid conflicts
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
