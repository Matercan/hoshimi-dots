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

    function appropriate(window: string, title: string): string {
        if (title.includes("nvim")) {
            return "nvim";
        }
        if (window.toLowerCase().includes("minecraft")) {
            return "minecraft";
        }
        if (window.toLowerCase().includes("qt")) {
            return "qt";
        }

        switch (window) {
        case "equibop":
            return "vesktop";
        case "Proton Mail":
            return "protonmail";
        case "protonvpn-app":
            return "protonvpn-gui";
        case "Aseprite":
            return window.toLowerCase();
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
