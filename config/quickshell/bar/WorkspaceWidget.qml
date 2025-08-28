pragma ComponentBehavior: Bound
// WorkspaceWidget.qml
import QtQuick
import Quickshell.Io
import qs.globals as G
import qs.sources

Rectangle {
    id: wkRect

    implicitHeight: 30
    property int margin: 10
    property var cursorPos: []
    implicitWidth: G.Variables.barSize
    property bool showPopUp

    // Property to store all open workspaces
    property var openWorkspaces: {
        let newWorkspaces = [];
        for (let i = 1; i <= 5; i++) {
            const wk = Desktop.workspaces.find(w => w.id === i) || {
                id: i,
                windows: 0,
                hasFocus: false
            };
            newWorkspaces.push(wk);
        }

        Desktop.workspaces.forEach(workspace => {
            const exists = newWorkspaces.some(item => item.id === workspace.id);
            if (!exists) {
                newWorkspaces.push(workspace);
            }
        });

        newWorkspaces.sort((a, b) => a.id - b.id);

        return newWorkspaces;
    }

    // Property to store the ID of the active workspace
    property int activeWorkspaceId: Desktop.activeWorkspace.id

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

    Timer {
        interval: G.Variables.timerProcInterval
        repeat: true
        running: true
        onTriggered: {
            popup.visible = wkRect.showPopUp;
        }
    }
}
