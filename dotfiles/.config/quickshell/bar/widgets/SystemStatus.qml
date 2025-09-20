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
    width: 0.9 * parent.width
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

        ProgressRing {
            anchors.centerIn: parent

            width: 0.6 * parent.width
            height: width

            fillColor: Colors.interpolate(Colors.getPaletteColor("navy"), Colors.getPaletteColor("red"), System.percentMemory)
            underlyingColor: Colors.transparentize(Colors.getPaletteColor("silver"), 0.7)
            percent: System.percentMemory

            Behavior on percent {
                NumberAnimation {
                    duration: MaterialEasing.standardTime
                    easing.type: Easing.OutCubic
                }
            }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowColor: Colors.getPaletteColor("teal")
            shadowEnabled: true
            blurMax: 10
            shadowScale: area.containsMouse ? 1 : 0

            Behavior on shadowScale {
                NumberAnimation {
                    duration: MaterialEasing.standardTime
                    easing.type: Easing.OutCurve
                }
            }
        }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
        }
    }

    PopupWindow {
        anchor.window: root.topLevel
        anchor.rect.x: Variables.barSize - 8
        anchor.rect.y: root.y + root.widgetLayoutY
        implicitWidth: rect.width + 8
        implicitHeight: rect.height + 8
        visible: true
        color: "transparent"

        Rectangle {
            id: rect
            height: systemInfoCard.height
            width: popupArea.containsMouse || area.containsMouse ? systemInfoCard.width : 0

            Behavior on width {
                NumberAnimation {
                    duration: MaterialEasing.standardTime
                    easing.type: Easing.OutCurve
                }
            }

            anchors.top: parent.top
            anchors.leftMargin: 8
            anchors.left: parent.left

            color: Colors.backgroundColor
            radius: 8

            Rectangle {
                id: systemInfoCard
                width: systemInfoContent.width + margins * 2
                height: systemInfoContent.height + header.height + 3 * margins
                color: Colors.backgroundColor  // Surface container
                radius: 16
                property real margins: 12

                // Subtle elevation shadow
                layer.enabled: true

                // Header section with accent
                Rectangle {
                    id: header
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: 24
                    color: Colors.getPaletteColor("teal")
                    radius: 16
                    opacity: 0.12

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: parent.height / 2
                        color: parent.color
                        opacity: parent.opacity
                    }
                }

                Text {
                    text: "System Information"
                    color: Colors.foregroundColor
                    anchors.centerIn: header
                    font.pixelSize: 10
                }

                // Content container
                GridLayout {
                    id: systemInfoContent
                    y: systemInfoCard.height - height - systemInfoCard.margins
                    anchors.horizontalCenter: parent.horizontalCenter

                    columns: 2
                    rows: 2

                    ProgressRing {
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100

                        fillColor: Colors.interpolate(Colors.getPaletteColor("navy"), Colors.getPaletteColor("red"), System.percentMemory)
                        underlyingColor: Colors.transparentize(Colors.getPaletteColor("silver"), 0.7)
                        percent: System.percentMemory
                        showText: true
                        text: "RAM:"

                        Behavior on percent {
                            NumberAnimation {
                                duration: MaterialEasing.standardTime
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    ProgressRing {
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100

                        fillColor: Colors.interpolate(Colors.getPaletteColor("navy"), Colors.getPaletteColor("red"), System.load)
                        underlyingColor: Colors.transparentize(Colors.getPaletteColor("silver"), 0.7)
                        percent: System.load
                        showText: true
                        text: "CPU:"

                        Behavior on percent {
                            NumberAnimation {
                                duration: MaterialEasing.standardTime
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    ProgressRing {
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100

                        fillColor: Colors.interpolate(Colors.getPaletteColor("navy"), Colors.getPaletteColor("red"), System.percentSwap)
                        underlyingColor: Colors.transparentize(Colors.getPaletteColor("silver"), 0.7)
                        percent: System.percentSwap
                        showText: true
                        text: "Swap:"

                        Behavior on percent {
                            NumberAnimation {
                                duration: MaterialEasing.standardTime
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    ProgressRing {
                        id: tempRing
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100

                        fillColor: Colors.interpolate(Colors.getPaletteColor("navy"), Colors.getPaletteColor("red"), System.temperature / 100)
                        underlyingColor: Colors.transparentize(Colors.getPaletteColor("silver"), 0.7)
                        percent: System.temperature / 100
                        showText: false
                        text: "Temp:"

                        ColumnLayout {

                            anchors.centerIn: parent
                            implicitWidth: iconText.width
                            implicitHeight: iconText.height + percentText.height + spacing
                            spacing: 2

                            Text {
                                id: iconText
                                Layout.alignment: Qt.AlignCenter

                                text: "temp"
                                font.pixelSize: Math.min(tempRing.width, tempRing.height) * 0.15
                                font.weight: Font.Medium
                                color: tempRing.fillColor
                            }

                            Text {
                                id: percentText
                                Layout.alignment: Qt.AlignCenter

                                text: Math.round(tempRing.percent * 100) + "°C"
                                font.pixelSize: Math.min(tempRing.width, tempRing.height) * 0.15
                                font.weight: Font.Medium
                                color: tempRing.fillColor
                            }
                        }

                        Behavior on percent {
                            NumberAnimation {
                                duration: MaterialEasing.standardTime
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }

        MouseArea {
            id: popupArea
            hoverEnabled: true
            anchors.fill: parent

            onEntered: parent.showContent = true
        }
    }
}
