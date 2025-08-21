#include "palette.hpp"
#include <iostream>
#include <string.h>
#include <vector>

bool hasEnding(const std::string &fullString, const std::string &ending) {
  if (fullString.length() >= ending.length()) {
    return (0 == fullString.compare(fullString.length() - ending.length(),
                                    ending.length(), ending));
  } else {
    return false;
  }
}

int main(int argc, char *argv[]) {
  std::string pngPath = argv[1];

  if (hasEnding(argv[1], ".png")) {
    PNGImage pngTitle;
    pngTitle.loadFromFile(pngPath);
    std::cout << "Loaded" << std::endl;

    EdgeResult result = pngTitle.getLongestEdge();

    std::cout << "The two highest contrast points are: ("
              << result.edgePoints[0][0] << ", " << result.edgePoints[0][1]
              << ") and (" << result.edgePoints[1][0] << ", "
              << result.edgePoints[1][1] << ")" << std::endl;

    std::cout << "The angle of the edge is: " << result.angle << " degrees."
              << std::endl;
  } else {
    JPEGImage jpegTitle;
    jpegTitle.loadFromFile(pngPath);

    EdgeResult result = jpegTitle.getLongestEdge();
    std::cout << "The two highest contrast points are: ("
              << result.edgePoints[0][0] << ", " << result.edgePoints[0][1]
              << ") and (" << result.edgePoints[1][0] << ", "
              << result.edgePoints[1][1] << ")" << std::endl;

    std::cout << "The angle of the edge is: " << result.angle << " degrees."
              << std::endl;
  }

  return 0;
}
