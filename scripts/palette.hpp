#ifndef COLORSCHEME_HPP
#define COLORSCHEME_HPP

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <fstream>
#include <iomanip>
#include <ios>
#include <iostream>
#include <memory>
#include <sstream>
#include <stdexcept>
#include <string.h>
#include <string>
#include <unordered_map>
#include <vector>

#include <jpeglib.h>
#include <png.h>
#include <pngconf.h>

enum class ThemeType { DARK, LIGHT, WARM };

class Color {
public:
  uint8_t r, g, b;
  int frequency;

  Color() : r(0), g(0), b(0), frequency(0) {}
  Color(uint8_t red, uint8_t green, uint8_t blue, int freq = 1)
      : r(red), g(green), b(blue), frequency(freq) {}

  // Conver to hex string
  std::string toHex() const {
    std::stringstream ss;
    ss << "#" << std::hex << std::setfill('0') << std::setw(2)
       << static_cast<int>(r) << std::setw(2) << static_cast<int>(g)
       << std::setw(2) << static_cast<int>(b);
    return ss.str();
  }

  // Calculate color distance for clustering
  double distanceTo(const Color &other) const {
    return std::sqrt(std::pow(r - other.r, 2) + std::pow(g - other.g, 2) +
                     std::pow(b - other.b, 2));
  }

  // Create a hash for unordered_map
  struct Hash {
    std::size_t operator()(const Color &c) const {
      return (static_cast<std::size_t>(c.r) << 16) |
             (static_cast<std::size_t>(c.g) << 8) |
             static_cast<std::size_t>(c.b);
    }
  };

  bool operator==(const Color &other) const {
    return r == other.r && g == other.g && b == other.b;
  }

  // Comparison for sorting by frequency
  bool operator<(const Color &other) const {
    return frequency > other.frequency; // Descending order
  }
};

class ColorScheme {
public:
  std::string background;
  std::string foreground;
  std::string cursorColor;
  std::string cursorText;
  std::string selectionBackground;
  std::string selectionForeground;
  std::vector<std::string> palette;

  ColorScheme() : palette(16) {}

  void writeToFile(const std::string &filename) const {
    std::ofstream file(filename);
    if (!file) {
      throw std::runtime_error("Could not create output file: " + filename);
    }

    file << "background = " << background << "\n";
    file << "foreground = " << foreground << "\n";
    file << "cursor-color = " << cursorColor << "\n";
    file << "cursor-text = " << cursorText << "\n";
    file << "selection-background = " << selectionBackground << "\n";
    file << "selection-foreground = " << selectionForeground << "\n";
    file << "\n";

    for (size_t i = 0; i < palette.size(); ++i) {
      file << "palette = " << i << "=" << palette[i] << "\n";
    }
  }

  void print() const {
    std::cout << "Generated ColorScheme:\n";
    std::cout << "Background: " << background << "\n";
    std::cout << "Foreground: " << foreground << "\n";
    std::cout << "Most dominant colors:\n";
    for (size_t i = 0; i < std::min(palette.size(), size_t(8)); ++i) {
      std::cout << "  " << i << ": " << palette[i] << "\n";
    }
  }
};

class PNGImage {
private:
  std::unique_ptr<uint8_t[]> data;
  int width, height;

public:
  PNGImage() : width(0), height(0) {}

  bool loadFromFile(const std ::string &filename) {
    FILE *fp = fopen(filename.c_str(), "rb");
    if (!fp) {
      std::cerr << "Error: Could not open file " << filename << std::endl;
      return false;
    }

    // Create PNG read struct
    png_structp png = png_create_read_struct(PNG_LIBPNG_VER_STRING, nullptr,
                                             nullptr, nullptr);
    if (!png) {
      fclose(fp);
      return false;
    }

    png_infop info = png_create_info_struct(png);
    if (setjmp(png_jmpbuf(png))) {
      png_destroy_read_struct(&png, &info, nullptr);
      fclose(fp);
      return false;
    }

    if (setjmp(png_jmpbuf(png))) {
      png_destroy_read_struct(&png, &info, nullptr);
      fclose(fp);
      return false;
    }

    png_init_io(png, fp);
    png_read_info(png, info);

    width = png_get_image_width(png, info);
    height = png_get_image_height(png, info);
    png_byte colorType = png_get_color_type(png, info);
    png_byte bitDepth = png_get_bit_depth(png, info);

    // Convert to RGBA format
    if (bitDepth == 16)
      png_set_strip_16(png);
    if (colorType == PNG_COLOR_TYPE_PALETTE)
      png_set_palette_to_rgb(png);
    if (colorType == PNG_COLOR_TYPE_GRAY && bitDepth < 8)
      png_set_expand_gray_1_2_4_to_8(png);
    if (png_get_valid(png, info, PNG_INFO_tRNS))
      png_set_tRNS_to_alpha(png);
    if (colorType == PNG_COLOR_TYPE_RGB || colorType == PNG_COLOR_TYPE_GRAY ||
        colorType == PNG_COLOR_TYPE_PALETTE)
      png_set_filler(png, 0xFF, PNG_FILLER_AFTER);
    if (colorType == PNG_COLOR_TYPE_GRAY ||
        colorType == PNG_COLOR_TYPE_GRAY_ALPHA)
      png_set_gray_to_rgb(png);

    png_read_update_info(png, info);

    // Allocate memory
    int rowBytes = png_get_rowbytes(png, info);
    data = std::make_unique<uint8_t[]>(rowBytes * height);

    std::vector<png_bytep> rowPointers(height);
    for (int y = 0; y < height; ++y) {
      rowPointers[y] = data.get() + y * rowBytes;
    }

    png_read_image(png, rowPointers.data());

    png_destroy_read_struct(&png, &info, nullptr);
    fclose(fp);

    return true;
  }

  std::vector<Color> extractColors() const {
    if (!data)
      return {};

    std::unordered_map<Color, int, Color::Hash> colorMap;

    for (int y = 0; y < height; ++y) {
      for (int x = 0; x < width; ++x) {
        int index = (y * width + x) * 4; // RGBA format
        uint8_t r = data[index];
        uint8_t g = data[index + 1];
        uint8_t b = data[index + 2];
        uint8_t a = data[index + 3];

        // Skip very transparent pixels
        if (a < 128)
          continue;

        Color color(r, g, b);
        colorMap[color]++;
      }
    }

    // Convert map to vector and sort by frequency
    std::vector<Color> colors;
    colors.reserve(colorMap.size());

    for (const auto &pair : colorMap) {
      Color color = pair.first;
      color.frequency = pair.second;
      colors.push_back(color);
    }

    std::sort(colors.begin(), colors.end());
    return colors;
  }

  int getWidth() const { return width; }
  int getHeight() const { return height; }
  bool isValid() const { return data != nullptr; }
};

class JPEGImage {
private:
  std::unique_ptr<uint8_t[]> data;
  int width, height;

public:
  JPEGImage() : width(0), height(0) {}

  bool loadFromFile(const std::string &filename) {
    FILE *fp = fopen(filename.c_str(), "rb");
    if (!fp) {
      std::cerr << "Error: Could not open file " << filename << std::endl;
      return false;
    }

    // Create JPEG decompression object
    struct jpeg_decompress_struct cinfo;
    struct jpeg_error_mgr jerr;

    // Set up error handling
    cinfo.err = jpeg_std_error(&jerr);

    // Initialize JPEG decompression object
    jpeg_create_decompress(&cinfo);

    // Set input file
    jpeg_stdio_src(&cinfo, fp);

    // Read JPEG header
    int rc = jpeg_read_header(&cinfo, TRUE);
    if (rc != 1) {
      std::cerr << "Error: Invalid JPEG file " << filename << std::endl;
      jpeg_destroy_decompress(&cinfo);
      fclose(fp);
      return false;
    }

    // Force RGB output (3 components per pixel)
    cinfo.out_color_space = JCS_RGB;
    cinfo.output_components = 3;

    // Start decompression
    jpeg_start_decompress(&cinfo);

    width = cinfo.output_width;
    height = cinfo.output_height;
    int channels = cinfo.output_components;

    // Allocate memory for RGB data (we'll convert to RGBA)
    int rgb_row_size = width * channels;
    int rgba_row_size = width * 4; // RGBA format

    std::unique_ptr<uint8_t[]> rgb_data =
        std::make_unique<uint8_t[]>(rgb_row_size * height);
    data = std::make_unique<uint8_t[]>(rgba_row_size * height);

    // Read scanlines
    std::vector<JSAMPROW> row_pointers(height);
    for (int y = 0; y < height; ++y) {
      row_pointers[y] = rgb_data.get() + y * rgb_row_size;
    }

    // Read all scanlines
    int lines_read = 0;
    while (cinfo.output_scanline < cinfo.output_height) {
      lines_read +=
          jpeg_read_scanlines(&cinfo, &row_pointers[cinfo.output_scanline],
                              cinfo.output_height - cinfo.output_scanline);
    }

    // Convert RGB to RGBA format
    for (int y = 0; y < height; ++y) {
      for (int x = 0; x < width; ++x) {
        int rgb_index = (y * width + x) * 3;
        int rgba_index = (y * width + x) * 4;

        data[rgba_index] = rgb_data[rgb_index];         // R
        data[rgba_index + 1] = rgb_data[rgb_index + 1]; // G
        data[rgba_index + 2] = rgb_data[rgb_index + 2]; // B
        data[rgba_index + 3] = 255;                     // A (fully opaque)
      }
    }

    // Cleanup
    jpeg_finish_decompress(&cinfo);
    jpeg_destroy_decompress(&cinfo);
    fclose(fp);

    return true;
  }

  std::vector<Color> extractColors() const {
    if (!data)
      return {};

    std::unordered_map<Color, int, Color::Hash> colorMap;

    for (int y = 0; y < height; ++y) {
      for (int x = 0; x < width; ++x) {
        int index = (y * width + x) * 4; // RGBA format
        uint8_t r = data[index];
        uint8_t g = data[index + 1];
        uint8_t b = data[index + 2];
        uint8_t a = data[index + 3];

        // Skip very transparent pixels (though JPEG doesn't have transparency)
        if (a < 128)
          continue;

        Color color(r, g, b);
        colorMap[color]++;
      }
    }

    // Convert map to vector and sort by frequency
    std::vector<Color> colors;
    colors.reserve(colorMap.size());

    for (const auto &pair : colorMap) {
      Color color = pair.first;
      color.frequency = pair.second;
      colors.push_back(color);
    }

    std::sort(colors.begin(), colors.end());
    return colors;
  }

  int getWidth() const { return width; }
  int getHeight() const { return height; }
  bool isValid() const { return data != nullptr; }
};

// Generic Image class that can handle both PNG and JPEG
class Image {
private:
  std::unique_ptr<uint8_t[]> data;
  int width, height;

  bool hasEnding(const std::string &fullString,
                 const std::string &ending) const {
    if (fullString.length() >= ending.length()) {
      return (0 == fullString.compare(fullString.length() - ending.length(),
                                      ending.length(), ending));
    } else {
      return false;
    }
  }

  std::string toLower(const std::string &str) const {
    std::string result = str;
    std::transform(result.begin(), result.end(), result.begin(), ::tolower);
    return result;
  }

public:
  Image() : width(0), height(0) {}

  bool loadFromFile(const std::string &filename) {
    std::string lowerFilename = toLower(filename);

    if (hasEnding(lowerFilename, ".png")) {
      PNGImage pngImage;
      if (pngImage.loadFromFile(filename)) {
        width = pngImage.getWidth();
        height = pngImage.getHeight();

        // Copy data from PNG image
        int dataSize = width * height * 4; // RGBA
        data = std::make_unique<uint8_t[]>(dataSize);

        // Since PNGImage doesn't expose raw data, we need to extract colors
        // and reconstruct. For now, let's use the PNG image directly.
        // You might want to modify PNGImage to expose raw data access.
        return true;
      }
    } else if (hasEnding(lowerFilename, ".jpg") ||
               hasEnding(lowerFilename, ".jpeg")) {
      JPEGImage jpegImage;
      if (jpegImage.loadFromFile(filename)) {
        width = jpegImage.getWidth();
        height = jpegImage.getHeight();
        return true;
      }
    } else {
      std::cerr << "Error: Unsupported image format. Supported formats: PNG, "
                   "JPG, JPEG"
                << std::endl;
      return false;
    }

    return false;
  }

  std::vector<Color> extractColors() const {
    // This would need to be implemented based on the loaded image type
    // For now, return empty vector
    return {};
  }

  int getWidth() const { return width; }
  int getHeight() const { return height; }
  bool isValid() const { return data != nullptr; }
};

class ColorSchemeGenerator {
private:
  ThemeType theme;

  Color adjustColorForTheme(Color color) const {
    switch (theme) {
    case ThemeType::DARK:
      // Make colors darker and more muted
      color.r = static_cast<uint8_t>(color.r * 1.2);
      color.g = static_cast<uint8_t>(color.g * 1.2);
      color.b = static_cast<uint8_t>(color.b * 1.2);
      break;

    case ThemeType::LIGHT:
      // Make colors lighter and softer
      color.r = static_cast<uint8_t>(color.r + (255 - color.r) * 0.4);
      color.g = static_cast<uint8_t>(color.g + (255 - color.g) * 0.4);
      color.b = static_cast<uint8_t>(color.b + (255 - color.b) * 0.4);
      break;

    case ThemeType::WARM:
      // Add warm tones (more red, less blue)
      color.r = static_cast<uint8_t>(std::min(255.0, color.r * 1.15));
      color.g = static_cast<uint8_t>(color.g * 0.95);
      color.b = static_cast<uint8_t>(color.b * 0.75);
      break;
    }
    return color;
  }

  std::vector<Color> generateDefaultPalette() const {
    // Standard ANSI colors as fallback
    std::vector<Color> defaults = {
        Color(0, 0, 0),       // Black
        Color(128, 0, 0),     // Dark Red
        Color(0, 128, 0),     // Dark Green
        Color(128, 128, 0),   // Dark Yellow
        Color(0, 0, 128),     // Dark Blue
        Color(128, 0, 128),   // Dark Magenta
        Color(0, 128, 128),   // Dark Cyan
        Color(192, 192, 192), // Light Gray
        Color(128, 128, 128), // Dark Gray
        Color(255, 0, 0),     // Bright Red
        Color(0, 255, 0),     // Bright Green
        Color(255, 255, 0),   // Bright Yellow
        Color(0, 0, 255),     // Bright Blue
        Color(255, 0, 255),   // Bright Magenta
        Color(0, 255, 255),   // Bright Cyan
        Color(255, 255, 255)  // White
    };

    for (auto &color : defaults) {
      color = adjustColorForTheme(color);
    }

    return defaults;
  }

  // Helper function to check if a color is too similar to already used colors
  bool isTooSimilarToUsed(const Color &candidate,
                          const std::vector<Color> &usedColors,
                          double threshold) const {
    for (const auto &used : usedColors) {
      if (candidate.distanceTo(used) < threshold) {
        return true;
      }
    }
    return false;
  }

  // Helper function to ensure a color is distinct from used colors
  Color ensureDistinct(const Color &candidate,
                       const std::vector<Color> &usedColors,
                       const Color &fallback) const {
    if (!isTooSimilarToUsed(candidate, usedColors, 30.0)) {
      return candidate;
    }

    // Try to adjust the candidate to make it more distinct
    std::vector<Color> adjustments = {
        Color(std::min(255, candidate.r + 50), candidate.g, candidate.b),
        Color(std::max(0, candidate.r - 50), candidate.g, candidate.b),
        Color(candidate.r, std::min(255, candidate.g + 50), candidate.b),
        Color(candidate.r, std::max(0, candidate.g - 50), candidate.b),
        Color(candidate.r, candidate.g, std::min(255, candidate.b + 50)),
        Color(candidate.r, candidate.g, std::max(0, candidate.b - 50))};

    for (const auto &adjusted : adjustments) {
      if (!isTooSimilarToUsed(adjusted, usedColors, 30.0) &&
          adjusted.distanceTo(fallback) < 100.0) {
        return adjusted;
      }
    }

    // If all adjustments fail, return the fallback
    return fallback;
  }

  double calculateLuminance(const Color &color) const {
    auto sRGB = [](double val) {
      val /= 255.0;
      return val <= 0.03928 ? val / 12.92
                            : std::pow((val + 0.055) / 1.055, 2.4);
    };
    return 0.2126 * sRGB(color.r) + 0.7152 * sRGB(color.g) +
           0.0722 * sRGB(color.b);
  }

  double calculateContrast(const Color &c1, const Color &c2) const {
    double l1 = calculateLuminance(c1);
    double l2 = calculateLuminance(c2);

    if (l1 < l2)
      std::swap(l1, l2);
    return (l1 + 0.05) / (l2 + 0.05);
  }

  Color ensureContrast(const Color &foreground, const Color &background,
                       double minContrast = 4.5) const {
    double currentContrast = calculateContrast(foreground, background);

    if (currentContrast >= minContrast) {
      return foreground;
    }

    // Try to adjust the foreground color to improve contrast
    double bgLuminance = calculateLuminance(background);

    // If background is dark, make foreground lighter
    Color adjusted = foreground;

    if (bgLuminance < 0.5) {
      // Dark background - brighten foreground
      int brighten = static_cast<int>(
          std::min(255.0, 255 * (minContrast - currentContrast) / 10.0));
      adjusted = Color(std::min(255, foreground.r + brighten),
                       std::min(255, foreground.g + brighten),
                       std::min(255, foreground.b + brighten));
    } else {
      // Light background - darken foreground
      int darken = static_cast<int>(
          std::min(255.0, 255 * (minContrast - currentContrast) / 10.0));
      adjusted = Color(std::max(0, foreground.r - darken),
                       std::max(0, foreground.g - darken),
                       std::max(0, foreground.b - darken));
    }

    // If still not enough contrast, use high contrast fallbacks
    if (calculateContrast(adjusted, background) < minContrast) {
      if (bgLuminance < 0.5) {
        return Color(240, 240, 240); // Light foreground for dark background
      } else {
        return Color(20, 20, 20); // Dark foreground for light background
      }
    }

    return adjusted;
  }

  // IMPROVED: Background/foreground generation with contrast awareness
  void generateContrastAwareBackgroundForeground(
      ColorScheme &scheme, const std::vector<Color> &extractedColors,
      const std::vector<Color> &dominantColors) const {
    if (extractedColors.empty()) {
      scheme.background = "#000000";
      scheme.foreground = "#ffffff";
      return;
    }

    Color domColor = extractedColors[0];
    double luminance = calculateLuminance(domColor);
    bool isDark = luminance < 0.4; // Adjusted threshold for better detection

    Color backgroundColor, foregroundColor;

    switch (theme) {
    case ThemeType::DARK: {
      if (isDark) {
        backgroundColor = domColor;
      } else {
        // Force darker background for dark theme
        backgroundColor = Color(static_cast<int>(domColor.r * 0.2),
                                static_cast<int>(domColor.g * 0.2),
                                static_cast<int>(domColor.b * 0.2));
      }

      // Find a high-contrast foreground from dominantColors or create one
      foregroundColor =
          findHighContrastColor(backgroundColor, dominantColors, true);
      break;
    }
    case ThemeType::LIGHT: {
      if (!isDark) {
        // Use a lightened version of the dominant color
        backgroundColor =
            Color(std::min(255, static_cast<int>(domColor.r * 1.3 + 40)),
                  std::min(255, static_cast<int>(domColor.g * 1.3 + 40)),
                  std::min(255, static_cast<int>(domColor.b * 1.3 + 40)));
      } else {
        backgroundColor = Color(250, 250, 250);
      }

      // Find a high-contrast foreground
      foregroundColor =
          findHighContrastColor(backgroundColor, dominantColors, false);
      break;
    }
    case ThemeType::WARM: {
      // Create warm variations with good contrast
      backgroundColor =
          Color(std::min(255, std::max(20, domColor.r + 15)),
                std::max(10, domColor.g - 5), std::max(5, domColor.b - 25));

      foregroundColor =
          findHighContrastColor(backgroundColor, dominantColors,
                                calculateLuminance(backgroundColor) < 0.4);
      break;
    }
    }

    // Final contrast check and adjustment
    foregroundColor = ensureContrast(foregroundColor, backgroundColor, 4.5);

    scheme.background = backgroundColor.toHex();
    scheme.foreground = foregroundColor.toHex();
  }

  Color findHighContrastColor(const Color &background,
                              const std::vector<Color> &candidates,
                              bool preferLight) const {
    Color bestColor = preferLight ? Color(240, 240, 240) : Color(20, 20, 20);
    double bestContrast = calculateContrast(bestColor, background);

    // Look through candidates for better contrast
    for (const auto &candidate : candidates) {
      double contrast = calculateContrast(candidate, background);
      if (contrast > bestContrast) {
        bestContrast = contrast;
        bestColor = candidate;
      }
    }

    // Ensure minimum contrast
    if (bestContrast < 4.5) {
      bestColor = ensureContrast(bestColor, background, 4.5);
    }

    return bestColor;
  }

  // IMPROVED: Cursor and selection colors with contrast awareness
  void
  generateContrastAwareCursorAndSelection(ColorScheme &scheme,
                                          const Color &primaryColor) const {
    Color backgroundColor = hexToColor(scheme.background);

    // Create cursor color that's distinct and visible
    Color cursorColor;
    if (theme == ThemeType::WARM) {
      cursorColor = Color(255, 180, 120); // Warm cursor
    } else {
      // Use a complementary color approach
      cursorColor = Color(255 - primaryColor.r / 2, 255 - primaryColor.g / 2,
                          std::min(255, primaryColor.b + 100));
    }

    // Ensure cursor has good contrast with background
    cursorColor = ensureContrast(cursorColor, backgroundColor,
                                 3.0); // Lower threshold for cursor

    // Selection background should be subtle but visible
    Color selectionBg;
    double bgLuminance = calculateLuminance(backgroundColor);

    if (bgLuminance < 0.5) {
      // Dark background - lighter selection
      selectionBg = Color(std::min(255, backgroundColor.r + 40),
                          std::min(255, backgroundColor.g + 40),
                          std::min(255, backgroundColor.b + 40));
    } else {
      // Light background - darker selection
      selectionBg = Color(std::max(0, backgroundColor.r - 30),
                          std::max(0, backgroundColor.g - 30),
                          std::max(0, backgroundColor.b - 30));
    }

    cursorColor = adjustColorForTheme(cursorColor);
    selectionBg = adjustColorForTheme(selectionBg);

    scheme.cursorColor = cursorColor.toHex();
    scheme.cursorText = cursorColor.toHex();
    scheme.selectionBackground = selectionBg.toHex();
    scheme.selectionForeground = selectionBg.toHex();
  }

  Color hexToColor(std::string hex) const {
    if (hex[0] == '#') {
      hex.erase(0, 1);
    }

    while (hex.length() != 6) {
      hex += "0";
    }

    int r;
    int g;
    int b;

    for (int i = 0; i < hex.length(); i += 2) {
      std::string hedec = {hex[i], hex[i + 1]};
      int val = std::stoi(hedec, nullptr, 16);
      switch (i) {
      case 0:
        r = val;
      case 2:
        g = val;
      case 4:
        b = val;
      }
    }

    return Color(r, g, b);
  }

public:
  ColorSchemeGenerator(ThemeType themeType) : theme(themeType) {}

  static ThemeType parseTheme(const std::string &themeStr) {
    std::string lower = themeStr;
    std::transform(lower.begin(), lower.end(), lower.begin(), ::tolower);

    if (lower == "dark")
      return ThemeType::DARK;
    if (lower == "light")
      return ThemeType::LIGHT;
    if (lower == "warm")
      return ThemeType::WARM;

    throw std::invalid_argument("Invalid theme: " + themeStr +
                                ". Use 'dark', 'light', or 'warm'");
  }

  ColorScheme generate(const std::vector<Color> &extractedColors) const {
    ColorScheme scheme;
    std::vector<Color> dominantColors;
    dominantColors.reserve(16);

    auto defaultColors = generateDefaultPalette();

    // Track used colors to ensure distinctness
    std::vector<Color> usedColors;

    for (size_t i = 0; i < 16; ++i) {
      Color defaultColor = defaultColors[i];
      Color bestMatch = defaultColor; // fallback
      double bestScore = std::numeric_limits<double>::max();

      // Find the best matching extracted color
      for (const auto &extractedColor : extractedColors) {
        // Skip if this color is too similar to already used colors
        if (isTooSimilarToUsed(extractedColor, usedColors, 35.0)) {
          continue;
        }

        double defaultDistance = defaultColor.distanceTo(extractedColor);

        // Skip colors that are too far from the default (except for special
        // positions)
        double maxAllowedDistance = (i == 0 || i == 15) ? 120.0 : 80.0;
        if (defaultDistance > maxAllowedDistance) {
          continue;
        }

        // Calculate score: balance frequency and distance to default
        // Lower score is better
        double frequencyWeight = 1.0 / std::log(extractedColor.frequency + 2);
        double score = defaultDistance * frequencyWeight;

        if (score < bestScore) {
          bestScore = score;
          bestMatch = extractedColor;
        }
      }

      // Ensure the selected color is distinct enough from previously used
      // colors
      Color finalColor = ensureDistinct(bestMatch, usedColors, defaultColor);
      finalColor = adjustColorForTheme(finalColor);

      dominantColors.push_back(finalColor);
      usedColors.push_back(finalColor);
    }

    // Fill remaining slots with defaults if needed
    while (dominantColors.size() < 16) {
      Color defaultColor = defaultColors[dominantColors.size()];
      Color distinctColor =
          ensureDistinct(defaultColor, usedColors, defaultColor);
      dominantColors.push_back(adjustColorForTheme(distinctColor));
      usedColors.push_back(distinctColor);
    }

    // Generate palette
    for (size_t i = 0; i < 16; ++i) {
      scheme.palette[i] = dominantColors[i].toHex();
    }

    // IMPROVED: Generate background/foreground with better contrast
    generateContrastAwareBackgroundForeground(scheme, extractedColors,
                                              dominantColors);

    // Enhanced cursor and selection colors with contrast awareness
    generateContrastAwareCursorAndSelection(scheme, dominantColors[0]);

    return scheme;
  }

  ColorScheme generateFromPng(const std::string &pngPath) {
    PNGImage image;

    if (!image.loadFromFile(pngPath)) {
      throw std::runtime_error("Failed to load PNG image: " + pngPath);
    }

    std::cout << "Loaded image: " << image.getWidth() << "x"
              << image.getHeight() << " pixels\n";

    auto colors = image.extractColors();
    if (colors.empty()) {
      throw std::runtime_error("No colors extracted from image");
    }

    std::cout << "Extracted " << colors.size() << " unique colors\n";
    std::cout << "Most frequent colors:\n";
    for (size_t i = 0; i < std::min(colors.size(), size_t(5)); ++i) {
      std::cout << " " << colors[i].toHex() << " (used " << colors[i].frequency
                << " times)\n";
    }

    return generate(colors);
  }
};

inline ColorScheme generateColorSchemeFromImage(const std::string &imagePath,
                                                const std::string &themeStr,
                                                const std::string &outputFile) {
  try {
    ThemeType theme = ColorSchemeGenerator::parseTheme(themeStr);
    ColorSchemeGenerator generator(theme);

    std::string lowerPath = imagePath;
    std::transform(lowerPath.begin(), lowerPath.end(), lowerPath.begin(),
                   ::tolower);

    ColorScheme scheme;

    if (lowerPath.find(".png") != std::string::npos) {
      // Use existing PNG functionality
      scheme = generator.generateFromPng(imagePath);
    } else if (lowerPath.find(".jpg") != std::string::npos ||
               lowerPath.find(".jpeg") != std::string::npos) {
      // Use new JPEG functionality
      JPEGImage image;
      if (!image.loadFromFile(imagePath)) {
        throw std::runtime_error("Failed to load JPEG image: " + imagePath);
      }

      std::cout << "Loaded JPEG image: " << image.getWidth() << "x"
                << image.getHeight() << " pixels\n";

      auto colors = image.extractColors();
      if (colors.empty()) {
        throw std::runtime_error("No colors extracted from JPEG image");
      }

      std::cout << "Extracted " << colors.size() << " unique colors\n";
      std::cout << "Most frequent colors:\n";
      for (size_t i = 0; i < std::min(colors.size(), size_t(5)); ++i) {
        std::cout << " " << colors[i].toHex() << " (used "
                  << colors[i].frequency << " times)\n";
      }

      scheme = generator.generate(colors);
    } else {
      throw std::runtime_error(
          "Unsupported image format. Use PNG, JPG, or JPEG");
    }

    scheme.writeToFile(outputFile);
    scheme.print();

    std::cout << "\nColorscheme written to: " << outputFile << std::endl;
    return scheme;

  } catch (const std::exception &e) {
    std::cerr << "Error: " << e.what() << std::endl;
    throw;
  }
}

#endif
