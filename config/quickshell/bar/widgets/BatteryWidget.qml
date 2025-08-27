import qs.sources
import qs.globals
import qs.functions

import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: batteryWidget
    implicitHeight: layout.height
    implicitWidth: layout.width
    color: "transparent"
    visible: UPower.displayDevice.isLaptopBattery

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        spacing: -2

        Text {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 20
            font.weight: 2
            font.family: Variables.fontFamily
            text: {
                if (Battery.batteryAmount == 100) {
                    return "";
                } else if (Battery.batteryAmount >= 70) {
                    return "";
                } else if (Battery.batteryAmount >= 40) {
                    return "";
                } else if (Battery.batteryAmount >= 30) {
                    return "";
                } else {
                    return "";
                }
            }

            color: Colors.interpolate(Colors.getPaletteColor("red"), Colors.getPaletteColor("green"), Battery.batteryAmount / 100)
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Battery.batteryText
            font.pixelSize: 12

            color: Colors.interpolate(Colors.getPaletteColor("red"), Colors.getPaletteColor("green"), Battery.batteryAmount / 100)
        }
    }
}
