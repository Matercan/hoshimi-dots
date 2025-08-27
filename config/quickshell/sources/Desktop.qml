pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

import qs.globals

Singleton {
    id: root
    property var activeWindow
    property var activeWorkspace
    property var windows
    property var workspaces

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
                        // 1. Not hidden or minimized
                        // 1. Not special windows (like overlays)
                        if (!client.hidden && client.mapped && !client.floating || client.floating) {
                            currentWorkspaceWindows.push({
                                address: client.address,
                                title: client.title || client.class || "Unknown",
                                className: client.class || "unknown",
                                workspace: client.workspace.id
                            });
                        }
                    });

                    root.windows = currentWorkspaceWindows;
                } catch (e) {
                    console.log("Failed to parse windows:", e);
                }
            }
        }
    }

    Process {
        id: workspacesProc
        command: ["hyprctl", "workspaces", "-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const allWorkspaces = JSON.parse(this.text.trim());
                    root.workspaces = allWorkspaces;
                } catch (e) {
                    console.log("failed to parse workspaces:", e);
                }
            }
        }
    }

    Process {
        id: windowProc
        command: ["hyprctl", "activewindow", "-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const thisWindow = JSON.parse(this.text.trim());
                    root.activeWindow = thisWindow;
                } catch (e) {
                    console.log("Failed to parse window:", e);
                }
            }
        }
    }

    Process {
        id: workspaceProc
        command: ["hyprctl", "activeworkspace", "-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const thisWorkspace = JSON.parse(this.text.trim());
                    root.activeWorkspace = thisWorkspace;
                } catch (e) {
                    console.log("failed to parse workspace: ", e);
                }
            }
        }
    }

    Timer {
        interval: Variables.timerProcInterval
        running: true
        repeat: true

        onTriggered: {
            workspaceProc.running = true, windowProc.running = true;
            workspacesProc.running = true, windowsProc.running = true;
        }
    }
}
