cmake_minimum_required(VERSION 3.16)
project(hyprland-dots VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set build type to Release if not specified
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Compiler flags
set(CMAKE_CXX_FLAGS_DEBUG "-g -Wall -Wextra -pedantic")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")

# Find required packages
find_package(PkgConfig REQUIRED)

# Find libpng
pkg_check_modules(PNG REQUIRED libpng)

# Include directories
include_directories(${PNG_INCLUDE_DIRS})

# Add executable
add_executable(hyprland-dots
    scripts/main.cpp
    scripts/filey.hpp
    scripts/input.hpp
    scripts/palette.hpp
)

# Link libraries
target_link_libraries(hyprland-dots 
    ${PNG_LIBRARIES}
    stdc++fs  # for std::filesystem (if using older compiler)
)

# Add compiler flags for PNG
target_compile_options(hyprland-dots PRIVATE ${PNG_CFLAGS_OTHER})

# Set executable output directory
set_target_properties(hyprland-dots PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# Install target
install(TARGETS hyprland-dots
    RUNTIME DESTINATION bin
)

# Install assets and config directories
install(DIRECTORY assets/
    DESTINATION share/hyprland-dots/assets
    FILES_MATCHING 
    PATTERN "*"
)

install(DIRECTORY config/
    DESTINATION share/hyprland-dots/config
    FILES_MATCHING 
    PATTERN "*"
)

# Create a script to copy configs to user's home directory (only if template exists)
if(EXISTS "${CMAKE_SOURCE_DIR}/install.sh.in")
    configure_file(
        "${CMAKE_SOURCE_DIR}/install.sh.in"
        "${CMAKE_BINARY_DIR}/install.sh"
        @ONLY
    )
endif()

# Custom target for development build with debug info
add_custom_target(debug
    COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=Debug ${CMAKE_SOURCE_DIR}
    COMMAND ${CMAKE_COMMAND} --build . --target hyprland-dots
    COMMENT "Building with debug information"
)

# Custom target for installing dotfiles to user home
add_custom_target(install-dotfiles
    COMMAND ./install.sh
    DEPENDS hyprland-dots
    COMMENT "Installing dotfiles to user home directory"
)

# Print configuration summary
message(STATUS "=== Configuration Summary ===")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "C++ standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "PNG found: ${PNG_FOUND}")
if(PNG_FOUND)
    message(STATUS "PNG version: ${PNG_VERSION}")
    message(STATUS "PNG libraries: ${PNG_LIBRARIES}")
endif()
message(STATUS "Install prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "=============================")

# Optional: Add testing if you have tests
# enable_testing()
# add_subdirectory(tests)

# Optional: Generate package config (only if template exists)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in")
    include(CMakePackageConfigHelpers)
    configure_package_config_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/hyprland-dotsConfig.cmake"
        INSTALL_DESTINATION lib/cmake/hyprland-dots
    )
endif()

# Optional: Add uninstall target (only if template exists)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in" AND NOT TARGET uninstall)
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY
    )
    
    add_custom_target(uninstall
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake
    )
endif()
