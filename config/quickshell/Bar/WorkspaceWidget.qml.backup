pragma ComponentBehavior: Bound
// WorkspaceWidget.qml
import QtQuick
import Quickshell.Io
import QtQuick.Layouts as L
import Quickshell.Hyprland as H

Rectangle {
    id: wkRect

    property int margin: 10
    property var cursorPos: []
    implicitWidth: Math.max(rowLayout.width + 2 * margin, 100)

    // Property to store all open workspaces
    property var openWorkspaces: []

    // Property to store the ID of the active workspace
    property int activeWorkspaceId: 0

    property string foregroundColor: "#654735"
    property string selectedColor: "#654735"
    property string activeColor: "#c14a4a"

    function getWorkspaceIcon(ident) {
        switch (ident) {
        case 1:
            return "󰣇 "; // Arch logo
        case 2:
            return " "; // Neovim logo
        case 3:
            return " "; // Firefox logo
        case 4:
            return " "; // File manager
        case 5:
            return " "; // Music
        default:
            return ident.toString();
        }
    }

    L.RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 4
        focus: true

        // Spawns in the icons of the workspaces
        Repeater {
            model: wkRect.openWorkspaces
            delegate: workspaceDelegate
        }
    }

    Component {
        id: workspaceDelegate
        Rectangle {
            id: rect
            required property int id
            property bool isActive: id === wkRect.activeWorkspaceId

            width: Math.max(windowContent.width + 16, 40)
            height: 24
            radius: 10

            color: {
                if (isActive) {
                    return wkRect.activeColor;
                } else if (mouseArea.containsMouse) {
                    return wkRect.selectedColor;
                } else {
                    return "transparent";
                }
            }

            L.RowLayout {
                id: windowContent
                anchors.centerIn: parent
                spacing: 4

                Text {

                    text: wkRect.getWorkspaceIcon(rect.id)

                    font.family: "CaskaydiaCove Nerd Font"
                    font.pixelSize: 16

                    color: rect.isActive ? wkRect.foregroundColor : wkRect.activeColor
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    H.Hyprland.dispatch("workspace " + rect.id);
                    getCursorPos.running = true;
                }
            }
        }
    }

    Process {
        id: getCursorPos
        command: ["hyprctl", "cursorpos"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const coords = this.text.trim().split(',');
                wkRect.cursorPos = coords;
                // Now the coordinates are clean numbers and the command will work
                H.Hyprland.dispatch("movecursor " + wkRect.cursorPos[0] + " " + wkRect.cursorPos[1]);
            }
        }
    }

    // Process to get all workspaces
    Process {
        id: allWkProcs
        command: ["hyprctl", "workspaces", "-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const hyprWorkspaces = JSON.parse(this.text.trim());
                    let newWorkspaces = [];

                    // Always include workspaces 1 through 5
                    for (let i = 1; i <= 5; i++) {
                        const wk = hyprWorkspaces.find(w => w.id === i) || {
                            id: i,
                            windows: 0,
                            hasFocus: false
                        };
                        newWorkspaces.push(wk);
                    }

                    // Add any other active workspaces
                    hyprWorkspaces.forEach(workspace => {
                        const exists = newWorkspaces.some(item => item.id === workspace.id);
                        if (!exists) {
                            newWorkspaces.push(workspace);
                        }
                    });

                    // Sort the combined list by ID
                    newWorkspaces.sort((a, b) => a.id - b.id);

                    wkRect.openWorkspaces = newWorkspaces;
                } catch (e) {
                    console.log("Failed to parse all workspaces:", e);
                }
            }
        }
    }

    // Process to get the active workspace
    Process {
        id: activeWkProc
        command: ["hyprctl", "activeworkspace", "-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const activeWorkspace = JSON.parse(this.text.trim());
                    wkRect.activeWorkspaceId = activeWorkspace.id;
                } catch (e) {
                    console.log("Failed to parse active workspace:", e);
                }
            }
        }
    }

    Timer {
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            allWkProcs.running = true;
            activeWkProc.running = true;
        }
    }
}
