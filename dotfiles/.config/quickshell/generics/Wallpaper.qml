import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.functions as F
import qs.sources as S
import qs.globals

AnimatedImage {
    source: Variables.wallpaper
    antialiasing: false
    asynchronous: true
    width: Quickshell.screens[0].width
    height: Quickshell.screens[0].height
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    mipmap: true
    retainWhileLoading: true
    cache: false
    smooth: true

    ColumnLayout {
        id: content

        spacing: 2
        x: 100
        y: 900

        Text {
            text: S.Time.time || "No Time Data"
            color: F.Colors.transparentize(F.Colors.foregroundColor, 0.3) || "#ffffff"
            font.family: "MRK Maston"
            font.pointSize: 50
        }

        Text {
            text: S.Time.date || "No Date Data"
            color: F.Colors.transparentize(F.Colors.foregroundColor, 0.3) || "#ffffff"
            font.family: "MRK Maston"
            font.pointSize: 60
        }
    }
}
