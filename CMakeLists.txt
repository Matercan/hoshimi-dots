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

# Find libjpeg
pkg_check_modules(JPEG REQUIRED libjpeg)

# Try to find Qt6 for GUI support (optional)
find_package(Qt6 QUIET COMPONENTS Core Widgets)

# Add CLI executable (original)
add_executable(hyprland-dots
    scripts/main-cli.cpp
    scripts/filey.hpp
    scripts/input.hpp
    scripts/palette.hpp
)

# Include directories for CLI
target_include_directories(hyprland-dots PRIVATE
    ${PNG_INCLUDE_DIRS}
    ${JPEG_INCLUDE_DIRS}
)

# Link libraries for CLI
target_link_libraries(hyprland-dots 
    ${PNG_LIBRARIES}
    ${JPEG_LIBRARIES}
    stdc++fs  # for std::filesystem (if using older compiler)
)

# Add compiler flags for CLI
target_compile_options(hyprland-dots PRIVATE 
    ${PNG_CFLAGS_OTHER}
    ${JPEG_CFLAGS_OTHER}
)

# Set executable output directory
set_target_properties(hyprland-dots PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# Add GUI executable if Qt6 is found
if(Qt6_FOUND)
    message(STATUS "Qt6 found - Building GUI version")
    
    add_executable(hyprland-dots-gui
        gui/main-gui.cpp
        gui/headers.hpp
        scripts/filey.hpp
        scripts/input.hpp
        scripts/palette.hpp
    )

    # Enable Qt6 MOC (Meta-Object Compiler)
    set_target_properties(hyprland-dots-gui PROPERTIES
        AUTOMOC ON
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    )

    # Include directories for GUI
    target_include_directories(hyprland-dots-gui PRIVATE
        ${PNG_INCLUDE_DIRS}
        ${JPEG_INCLUDE_DIRS}
        ${CMAKE_CURRENT_SOURCE_DIR}/gui
    )

    # Link Qt6 libraries and other dependencies for GUI
    target_link_libraries(hyprland-dots-gui
        Qt6::Core
        Qt6::Widgets
        ${PNG_LIBRARIES}
        ${JPEG_LIBRARIES}
        stdc++fs
    )

    # Add compiler flags for GUI
    target_compile_options(hyprland-dots-gui PRIVATE 
        ${PNG_CFLAGS_OTHER}
        ${JPEG_CFLAGS_OTHER}
    )

    # Install GUI target
    install(TARGETS hyprland-dots-gui
        RUNTIME DESTINATION bin
    )
    
else()
    message(STATUS "Qt6 not found - GUI version will not be built")
    message(STATUS "To build GUI: sudo apt install qt6-base-dev (Ubuntu/Debian)")
    message(STATUS "              sudo pacman -S qt6-base (Arch)")
    message(STATUS "              sudo dnf install qt6-qtbase-devel (Fedora)")
endif()

# Install CLI target
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

# Custom target for building GUI in debug mode (if Qt6 available)
if(Qt6_FOUND)
    add_custom_target(debug-gui
        COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=Debug ${CMAKE_SOURCE_DIR}
        COMMAND ${CMAKE_COMMAND} --build . --target hyprland-dots-gui
        COMMENT "Building GUI with debug information"
    )
endif()

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
message(STATUS "JPEG found: ${JPEG_FOUND}")
if(JPEG_FOUND)
    message(STATUS "JPEG libraries: ${JPEG_LIBRARIES}")
endif()
if(Qt6_FOUND)
    message(STATUS "Qt6 found: YES (GUI will be built)")
    message(STATUS "Qt6 version: ${Qt6_VERSION}")
else()
    message(STATUS "Qt6 found: NO (only CLI will be built)")
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
