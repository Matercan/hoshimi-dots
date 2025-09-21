pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

import qs.globals
import qs.functions
import qs.sources
import qs.generics

Item {
    id: root
    width: Config.ratios[0] * parent.width
    height: width

    property real widgetLayoutY
    required property var topLevel

    Rectangle {
        id: widget

        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: 8
        color: Colors.getPaletteColor("grey")

        Image {
            id: icon
            anchors.centerIn: parent
            width: Config.ratios[1] * parent.width
            height: width
            sourceSize.width: width
            sourceSize.height: height
            source: Quickshell.env("HOME") + "/.local/share/hoshimi/assets/m3icons/headphones_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
        }
    }
}
