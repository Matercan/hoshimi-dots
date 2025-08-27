pragma Singleton

import Quickshell
import qs.sources

Singleton {
    function getWorkspaceIcon(ident) {
        switch (ident) {
        case 1:
            return "󰣇"; // Arch logo
        case 2:
            return ""; // Neovim logo
        case 3:
            return ""; // Firefox logo
        case 4:
            return ""; // File manager
        case 5:
            return ""; // Music
        default:
            return ident.toString();
        }
    }

    function getWindowIcon(className) {
        // Map common application classes to icons
        switch (className.toLowerCase()) {
        case "firefox":
        case "firefox-esr":
            return "󰈹"; // Firefox icon
        case "code":
        case "code - oss":
        case "vscodium":
            return "󰨞"; // VS Code icon
        case "com.mitchellh.ghostty": // Corrected case for Ghostty
        case "kitty":
        case "alacritty":
        case "gnome-terminal":
        case "konsole":
            return ""; // Terminal icon
        case "thunar":
        case "nautilus":
        case "org.kde.dolphin":
            return "󰉋"; // File manager icon
        case "equibop":
        case "vesktop":
        case "discord":
            return ""; // Discord icon
        case "spotify":
            return ""; // Spotify icon
        case "steam":
            return ""; // Steam icon
        case "anki":
            return "";
        default:
            return "󰣆"; // Default window icon
        }
    }
}
