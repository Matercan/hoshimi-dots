pragma Singleton

import Quickshell

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

    function appropriate(window: string): string {
        switch (window) {
        case "equibop":
            return "vesktop";
        case "Proton Mail":
            return "protonmail";
        case "protonvpn-app":
            return "protonvpn-gui";
        default:
            return window;
        }
    }

    function removeNotifications(window: string): string {
        return window.replace(/^\(\d+\)\s*/, '');
    }

    function getNotifications(window: string): int {
        var match = window.match(/\((\d+)\)/);
        if (match) {
            return parseInt(match[1], 10);
        }
        return 0; // No notifications found
    }
}
