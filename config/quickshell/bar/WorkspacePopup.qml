pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts as L

import qs.functions as F
import qs.globals as G

PanelWindow {
    id: root
    required property var openWorkspaces
    required property var activeWorkspaceId

    anchors {
        top: true
        left: true
    }

    implicitWidth: rect.width
    implicitHeight: 0  // Start with 0 height
    color: "transparent"

    property bool varShow: visible

    Rectangle {
        id: rect
        implicitWidth: layout.width + 2
        implicitHeight: layout.height + 2
        radius: 10

        border.color: F.Colors.borderColor
        border.width: 2
        color: F.Colors.transparentize(F.Colors.backgroundColor, 0.3)

        Rectangle {
            L.ColumnLayout {
                id: layout

                Repeater {
                    model: root.openWorkspaces
                    delegate: WorkspaceItem {
                        required property var modelData
                        activeWorkspaceId: root.activeWorkspaceId
                        idNum: modelData.id
                    }
                }
            }
        }
    }

    // Single animation that handles both open and close
    NumberAnimation {
        id: heightAnimation
        target: root
        property: "implicitHeight"
        duration: root.varShow ? G.MaterialEasing.standardTime : G.MaterialEasing.emphasizedTime
        easing.type: root.varShow ? Easing.OutCubic : Easing.InCubic

        to: root.varShow ? rect.height : 0

        running: false
    }

    Connections {
        target: root

        function onVarShowChanged() {
            console.log("VAR SHOW CHANGEGD: " + root.varShow);
            console.log("PLAYING ANIMATIOn");
            heightAnimation.start();
        }
    }
}
