#include <algorithm>
#include <cstdlib>
#include <filesystem>
#include <iostream>
#include <sstream>
#include <string>
#include <sys/stat.h>
#include <vector>

using namespace std;
namespace fs = std::filesystem;

int main(int argc, char *argv[]) {

  vector<string> totalPackages = {"dunst",  "fastfetch", "fish",
                                  "eww",    "ghostty",   "vesktop",
                                  "waybar", "wofi",      "hypr"};

  cout << "Welcome to my dotfiles." << endl;
  cout << "List all of the packages you desire to install out of ";

  // This loop now prints the list more cleanly
  for (size_t i = 0; i < totalPackages.size(); i++) {
    cout << totalPackages[i];
    if (i < totalPackages.size() - 1) {
      cout << ", ";
    }
  }
  cout << "." << endl; // Add a period at the end

  cout << "They must be separated by commas, no spaces: " << endl;
  string packages;
  // Use getline to read the whole line of input, not just the first word
  getline(cin, packages);

  vector<string> vect;
  stringstream ss(packages);
  string s;

  while (getline(ss, s, ',')) {
    // Use s.c_str() to trim whitespace, if any
    vect.push_back(s);
  }

  // Get source and destination paths
  fs::path dotfilesSource = fs::current_path();
  fs::path configfilesDest = fs::path(getenv("HOME")) / ".config";

  // Ensure the destination config directory exists
  if (!fs::exists(configfilesDest)) {
    fs::create_directories(configfilesDest);
  }

  for (const string &package_name : vect) {
    // Find package and trim any leading/trailing whitespace

    string trimmed_package = package_name;
    trimmed_package.erase(0, trimmed_package.find_first_not_of(" \t\n\r\f\v"));
    trimmed_package.erase(trimmed_package.find_last_not_of(" \t\n\r\f\v") + 1);

    if (find(totalPackages.begin(), totalPackages.end(), trimmed_package) !=
        totalPackages.end()) {

      string dir = "/usr/bin/" + trimmed_package;
      struct stat sb;

      cout << "Installing " << trimmed_package << endl;
      if (stat(dir.c_str(), &sb) == 0) {
        cout << trimmed_package << " already installed" << endl;
      } else {
        string cmd = "yay -S " + trimmed_package;
        system(cmd.c_str());
      }

      if (trimmed_package == "starhip") {
        cout << "starship not implimented yet" << endl;
        continue;
      }

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
          cout << "Package at " << configPath
               << " already exists, copying into " << backupPath.string()
               << endl;

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

    } else {
      cout << trimmed_package
           << " not found in package list, skipping installation." << endl;
    }
  }

  return 0;
}
