import QtQuick

Rectangle {
    id: reusableBorderRect

    // Public properties
    property int topBorderWidth: 1
    property int bottomBorderWidth: 1
    property color topBorderColor: "black"
    property color bottomBorderColor: "black"
    property bool showTopBorder: true
    property bool showBottomBorder: true

    color: "transparent"

    // Top border (conditional)
    Rectangle {
        visible: parent.showTopBorder
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.topBorderWidth
        color: parent.topBorderColor
    }

    // Bottom border (conditional)
    Rectangle {
        visible: parent.showBottomBorder
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.bottomBorderWidth
        color: parent.bottomBorderColor
    }
}
