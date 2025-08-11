#include "palette.hpp"

int main(int argc, char *argv[]) {
  if (argc != 4) {
    std::cout << "Usage: " << argv[0] << " <png_path> <theme> <output_file>\n";
    std::cout << "Themes: dark, light, warm\n";
    std::cout << "Example: " << argv[0]
              << " wallpaper.png dark colorscheme.txt\n";
    return 1;
  }

  std::string pngPath = argv[1];
  std::string theme = argv[2];
  std::string outputFile = argv[3];

  std::cout << "Generating colorscheme from " << pngPath << " with " << theme
            << " theme...\n\n";

  try {
    generateColorSchemeFromPNG(pngPath, theme, outputFile);
    return 0;
  } catch (const std::exception &e) {
    std::cerr << "Failed: " << e.what() << std::endl;
    return 1;
  }
}
