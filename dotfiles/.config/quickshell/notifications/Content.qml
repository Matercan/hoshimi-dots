import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import qs.globals
import qs.functions

PanelWindow {
    anchors {
        right: true
        top: true
    }

    Notifications {
        id: notifs
    }

    margins {
        left: 300
        top: 0
    }

    implicitWidth: notifs.popups.length > 0 ? rectangle.width : 0
    implicitHeight: notifs.popups.length > 0 ? rectangle.height : 0
    color: "transparent"

    Rectangle {
        id: rectangle
        implicitWidth: layout.width + 25
        implicitHeight: layout.height + 50
        bottomLeftRadius: 50
        color: Colors.backgroundColor

        ColumnLayout {
            id: layout
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 25

            Repeater {
                model: {
                    notifs.popups;
                }
                delegate: Notification {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
