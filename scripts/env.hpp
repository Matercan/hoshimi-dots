#pragma once

#include "palette.hpp"
#include <cstdlib>
#include <string.h>
#include <string>

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
