pragma ComponentBehavior: Bound
// TaskbarWidget.qml
import QtQuick
import Quickshell.Io
import QtQuick.Layouts as L
import Quickshell.Hyprland as H

Rectangle {
    id: taskbarRect

    property int margin: 10
    implicitWidth: Math.max(rowLayout.width + 2 * margin, 100) // Minimum width

    // Property to store all windows
    property var windows: []

    // Property to store the active window address
    property string activeWindowAddress: ""

    property string foregroundColor: "#cdd6f4"
    property string selectedColor: "#cdd6f4"
    property string activeColor: "#f38ba8"

    function getWindowIcon(className) {
        // Map common application classes to icons
        switch (className.toLowerCase()) {
        case "firefox":
        case "firefox-esr":
            return "󰈹 "; // Firefox icon
        case "code":
        case "code - oss":
        case "vscodium":
            return "󰨞 "; // VS Code icon
        case "com.mitchellh.ghostty": // Corrected case for Ghostty
        case "kitty":
        case "alacritty":
        case "gnome-terminal":
        case "konsole":
            return " "; // Terminal icon
        case "thunar":
        case "nautilus":
        case "dolphin":
            return "󰉋 "; // File manager icon
        case "vesktop":
        case "discord":
            return " "; // Discord icon
        case "spotify":
            return " "; // Spotify icon
        case "steam":
            return " "; // Steam icon
        default:
            return "󰣆 "; // Default window icon
        }
    }

    function truncateTitle(title, maxLength = 120 / windows.length) {
        if (title.length <= maxLength) {
            return title;
        }
        return title.substring(0, maxLength - 3) + "...";
    }

    L.RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 6
        focus: true

        // Spawns window buttons
        Repeater {
            model: taskbarRect.windows
            delegate: windowDelegate
        }
    }

    Component {
        id: windowDelegate
        Rectangle {
            id: rect
            required property string address
            required property string title
            required property string className
            property bool isActive: address === taskbarRect.activeWindowAddress

            width: Math.max(windowContent.width + 16, 40)
            height: 24
            radius: 10

            color: {
                if (isActive) {
                    return taskbarRect.activeColor;  // Active window color
                } else if (mouseArea.containsMouse) {
                    return taskbarRect.selectedColor;  // Hover color
                } else {
                    return "transparent";  // Default
                }
            }

            L.RowLayout {
                id: windowContent
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: taskbarRect.getWindowIcon(rect.className)
                    font.family: "CaskaydiaCove Nerd Font"
                    font.pixelSize: 14
                    color: rect.isActive ? taskbarRect.foregroundColor : taskbarRect.activeColor
                }

                Text {
                    text: taskbarRect.truncateTitle(rect.title)
                    font.family: "CaskaydiaCove Nerd Font"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    font.italic: true
                    color: rect.isActive ? taskbarRect.foregroundColor : taskbarRect.activeColor

                    // Limit width to prevent overflow
                    L.Layout.maximumWidth: 150
                    elide: Text.ElideRight
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    H.Hyprland.dispatch("focuswindow address:" + parent.address);
                }
            }
        }
    }

    // Process to get all windows in the current workspace
    Process {
        id: windowsProc
        command: ["hyprctl", "clients", "-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const allClients = JSON.parse(this.text.trim());
                    let currentWorkspaceWindows = [];

                    // Filter windows that are in the current workspace and visible
                    allClients.forEach(client => {
                        // Only include windows that are:
                        // 1. In the current workspace (we'll get this from active workspace)
                        // 2. Not hidden or minimized
                        // 3. Not special windows (like overlays)
                        if (!client.hidden && client.mapped && !client.floating || client.floating) {
                            currentWorkspaceWindows.push({
                                address: client.address,
                                title: client.title || client.class || "Unknown",
                                className: client.class || "unknown",
                                workspace: client.workspace.id
                            });
                        }
                    });

                    taskbarRect.windows = currentWorkspaceWindows;
                } catch (e) {
                    console.log("Failed to parse windows:", e);
                }
            }
        }
    }

    // Process to get the active window
    Process {
        id: activeWindowProc
        command: ["hyprctl", "activewindow", "-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const activeWindow = JSON.parse(this.text.trim());
                    taskbarRect.activeWindowAddress = activeWindow.address || "";
                } catch (e) {
                    console.log("Failed to parse active window:", e);
                    taskbarRect.activeWindowAddress = "";
                }
            }
        }
    }

    Timer {
        interval: 100 // Update every 500ms
        repeat: true
        running: true
        onTriggered: {
            windowsProc.running = true;
            activeWindowProc.running = true;
        }
    }
}
