pragma ComponentBehavior: Bound
// WorkspaceWidget.qml
import QtQuick
import Quickshell.Io
import qs.globals as G

Rectangle {
    id: wkRect

    implicitHeight: 30
    property int margin: 10
    property var cursorPos: []
    implicitWidth: G.Variables.barSize
    property bool showPopUp

    // Property to store all open workspaces
    property var openWorkspaces: []

    // Property to store the ID of the active workspace
    property int activeWorkspaceId: 0

    WorkspaceItem {
        id: mainItem
        activeWorkspaceId: wkRect.activeWorkspaceId
        idNum: wkRect.activeWorkspaceId

        anchors.centerIn: parent

        onEntered: {
            popupTimer.restart();
            wkRect.showPopUp = true;
            popup.varShow = true;
            console.log(wkRect.showPopUp);
            console.log(popup.varShow);
        }

        WorkspacePopup {
            id: popup

            openWorkspaces: wkRect.openWorkspaces
            activeWorkspaceId: wkRect.activeWorkspaceId
        }
    }

    Timer {
        id: popupTimer
        interval: G.Variables.popupMenuOpenTime
        repeat: false

        onTriggered: {
            running = false;
            closeTimer.restart();
            popup.varShow = false;
        }
    }

    Timer {
        id: closeTimer
        interval: G.MaterialEasing.emphasizedTime
        repeat: false

        onTriggered: {
            running = false;
            wkRect.showPopUp = false;
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

    Timer {
        interval: 1
        repeat: true
        running: true
        onTriggered: {
            popup.visible = wkRect.showPopUp;
        }
    }
}
