pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.globals

Item {
    id: root

    required property var screen

    readonly property real nonAnimWidth: x > 0 || hasCurrent ? children.find(c => c.shouldBeActive)?.implicitWidth ?? content.implicitWidth : 0
    readonly property real nonAnimHeight: children.find(c => c.shouldBeActive)?.implicitHeight ?? content.implicitHeight
    readonly property Item current: Content.item?.current ?? null

    property string currentName
    property real currentCenter
    property bool hasCurrent

    property string detatchedMode
    property string queuedMode
    readonly property bool isDetatched: detatchedMode.length > 0

    property int animLength: MaterialEasing.standardTime
    property list<real> animCurve: MaterialEasing.emphasized

    function detach(mode: string): void {
        root.animLength = MaterialEasing.emphasizedTime;
        if (mode == "winfo") {
            detatchedMode = mode;
        } else {
            detatchedMode = "any";
            queuedMode = mode;
        }
        focus = true;
    }

    function close(): void {
        hasCurrent = false;
        animCurve = MaterialEasing.standardAccel;
        animLength = MaterialEasing.standardAccelTime;
        detatchedMode = "";
    }

    visible: width > 0 && height > 0
    clip: true

    implicitWidth: nonAnimWidth
    implicitHeight: nonAnimHeight

    Keys.onEscapePressed: close()

    HyprlandFocusGrab {
        active: root.isDetatched
        windows: [QsWindow.window]
        onCleared: root.close()
    }

    Binding {
        when: root.isDetatched

        target: QsWindow.window
        property: "WlrLayerShell.keyboardFocus"
        value: WlrKeyboardFocus.OnDemand
    }

    Comp {
        id: content

        shouldBeActive: root.hasCurrent && !root.detatchedMode
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        sourceComponent: Content {
            wrapper: root
        }
    }

    Behavior on x {
        Anim {}
    }
    Behavior on y {
        enabled: root.implicitHeight > 0
        Anim {}
    }
    Behavior on implicitWidth {
        Anim {}
    }
    Behavior on implicitHeight {
        enabled: root.implicitWidth > 0
        Anim {}
    }

    component Anim: NumberAnimation {
        duration: root.animLength
        easing.bezierCurve: root.animCurve
    }

    component Comp: Loader {
        id: comp

        property bool shouldBeActive

        asynchronous: true
        active: false
        opacity: 0

        states: State {
            name: "active"
            when: comp.shouldBeActive

            PropertyChanges {
                comp.opacity: 1
                comp.active: true
            }
        }

        transitions: [
            Transition {
                from: ""
                to: "active"

                SequentialAnimation {
                    PropertyAction {
                        property: "active"
                    }
                    Anim {
                        property: "opacity"
                    }
                }
            },
            Transition {
                from: "active"
                to: ""

                SequentialAnimation {
                    Anim {
                        property: "opacity"
                    }
                    PropertyAction {
                        property: "active"
                    }
                }
            }
        ]
    }
}
