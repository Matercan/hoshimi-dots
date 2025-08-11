#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <string>
#include <sys/stat.h>
#include <vector>

#include "filey.hpp"
#include "input.hpp"

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

    string dir = "/usr/bin/" + trimmed_package;
    struct stat sb;

    cout << "Installing " << trimmed_package << endl;
    if (stat(dir.c_str(), &sb) == 0) {
      cout << trimmed_package << " already installed" << endl;
    } else if (trimmed_package == "catalyst") {
      string cmd = "git clone https://github.com/Matercan/catalyst.git"
                   " && makepkg -si";
      system(cmd.c_str());
    } else {
      string cmd = "yay -S " + trimmed_package;
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

  InputManager input(TOTALPACKAGES, TOTALTHEMES);

  const vector<string> packageVect = input.packageInput();

  const vector<string> themesVect = input.themeInput();

  for (const string &package_name : packageVect) {
    // Find package and trim any leading/trailing whitespace
    string trimmed_package = setupPackage(package_name, TOTALPACKAGES);

    if (trimmed_package == "Starship.") {
      continue;
    } else if (trimmed_package == "Not Found.") {
      cout << "Package" << package_name << "Not found; skipping." << endl;
    }

    FileManager().movePackage(trimmed_package);
  }

  return 0;
}
