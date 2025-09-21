import QtQuick
import Quickshell
import qs.functions as F
import qs.globals as G

Rectangle {
    id: rect
    radius: G.Variables.wrapSize
    required property PanelWindow root
    required property bool fullyOpen
    required property bool varShow

    property bool closedAnimRunning: closeAnimation.running
    property bool openAnimRunning: openAnimation.running

    color: F.Colors.backgroundColor

    SequentialAnimation {
        id: openAnimation
        running: rect.varShow && !rect.fullyOpen

        NumberAnimation {
            target: rect.root
            property: "implicitWidth"
            to: rect.width
            duration: G.MaterialEasing.standardTime * 0.3
            easing.type: Easing.Bezier
            easing.bezierCurve: G.MaterialEasing.standard
        }

        PropertyAction {
            target: rect.root
            property: "fullyOpen"
            value: true
        }
    }

    SequentialAnimation {
        id: closeAnimation
        running: !rect.varShow && rect.fullyOpen

        PropertyAction {
            target: rect.root
            property: "fullyOpen"
            value: false
        }

        NumberAnimation {
            target: rect.root
            property: "implicitWidth"
            to: 0
            duration: G.MaterialEasing.emphasizedTime * 0.3
            easing.type: Easing.Bezier
            easing.bezierCurve: G.MaterialEasing.standard
        }
    }
    Connections {
        target: rect.root

        function onVarShowChanged() {
            console.log("VAR SHOW CHANGEGD: " + rect.varShow);
            console.log("PLAYING ANIMATIOn");
            if (rect.varShow)
                openAnimation.start();
            else
                closeAnimation.start();
        }
    }
}
