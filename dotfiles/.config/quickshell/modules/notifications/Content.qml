import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.globals

PanelWindow {
    anchors {
        right: true
        top: true
    }

    Notifications {
        id: notifs
    }

    margins {
        right: 15
        top: 0
    }

    implicitWidth: rectangle.width
    implicitHeight: rectangle.height
    color: "transparent"

    Rectangle {
        id: rectangle
        implicitWidth: layout.width + 25
        implicitHeight: layout.height + 50
        color: "transparent"

        ListView {
            id: layout
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 25
            width: 360
            height: (50 + Config.spacing) * notifs.popups.length
            spacing: Config.spacing

            model: notifs.popups

            delegate: Notification {
                Layout.fillWidth: true
                Layout.alignment: {
                    console.log(notifs.popups.length);
                    Qt.AlignHCenter;
                }
            }
        }
    }
}
