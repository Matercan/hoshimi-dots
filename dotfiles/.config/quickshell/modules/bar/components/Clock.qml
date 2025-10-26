import qs.functions
import qs.services

import QtQuick
import QtQuick.Layouts

Item {
    implicitWidth: layout.width
    implicitHeight: layout.height

    RowLayout {
        id: layout
        anchors.centerIn: parent

        Text {
            color: Colors.foregroundColor
            text: Time.time.split(':')[0]
        }
        Text {
            color: Colors.foregroundColor
            text: Time.time.split(':')[1]
        }
    }
}
