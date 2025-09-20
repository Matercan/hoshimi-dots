pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

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
    }
}
