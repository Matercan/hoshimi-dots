pragma Singleton

import Quickshell
import qs.sources as S

Singleton {
    function getWorkspaceIcon(ident) {
        /* Uncomment or change logos as you see fit
         * If on neovim, use the nerdy to find nerdfont icons
         * I do have them commented out to be traditional however */
        switch (ident) {
        case 1:
        //    return ""; // Nix logo
        case 2:
        //    return ""; // Neovim logo
        case 3:
        //    return ""; // Firefox logo
        case 4:
        //  return ""; // File manager
        case 5:
        //    return ""; // Music
        default:
            return ident.toString();
        }
    }

    /*
     * Here you can define the rules by which you get your icon based on the title and class of a client
     * You can see the clients from typing hyprctl clients -j into a terminal
     * It is best to use a full icon theme like candy icons to source your icons from.
     */
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

    function getWindowsInWorkspace(workspace: int): var {
        var windowsInWorkwpace = [];
        var openWindows = S.Desktop.windows;
        for (let window of openWindows) {
            if (window.workspace == workspace) {
                windowsInWorkwpace.push(window);
            } else if (window.workspace > workspace) {
                return windowsInWorkwpace;
            }
        }
        return windowsInWorkwpace;
    }

    function removeNotifications(window: string): string {
        return window.replace(/^\(\d+\)\s*/, '');
    }

    function getNotifications(window: string): int {
        var match = window.match(/\((\d+)\)/);
        if (match) {
            var str = parseInt(match[1], 10);
            if (str >= 9)
                return 9;
            else
                return str;
        }
        return 0; // No notifications found
    }
}
