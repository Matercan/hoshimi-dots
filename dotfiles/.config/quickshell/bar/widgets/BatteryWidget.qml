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
        spacing: 2

        Image {
            Layout.alignment: Qt.AlignHCenter
            source: {
                function getBattery() {
                    var iconDirectory = Variables.iconDirectory + "../../status/scalable/";
                    var toThreeDigits;
                    if (Battery.batteryAmount == 0) {
                        toThreeDigits = "000";
                    } else if (Battery.batteryAmount >= 90) {
                        toThreeDigits = "100";
                    } else {
                        toThreeDigits = "0" + (Math.round(Battery.batteryAmount / 10) * 10).toString();
                    }

                    if (UPower.displayDevice.changeRate >= 0) {
                        return iconDirectory + "battery-" + toThreeDigits + "-charging-symbolic.svg";
                    } else {
                        return iconDirectory + "battery-" + toThreeDigits + "-symbolic.svg";
                    }
                }

                return getBattery() || "usr/share/icons/Adwaita/symbolic/status/battery-level-100-symbolic.svg";
            }
            Layout.preferredWidth: 14
            Layout.preferredHeight: 20
            rotation: 90
            mipmap: true
            smooth: true
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Battery.batteryText
            font.pixelSize: 12
            font.family: Variables.fontFamily

            color: Colors.interpolate(Colors.getPaletteColor("red"), Colors.getPaletteColor("green"), Battery.batteryAmount / 100)
        }
    }
}
