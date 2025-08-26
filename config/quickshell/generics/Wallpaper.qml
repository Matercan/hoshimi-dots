import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.functions as F
import qs.sources as S

Image {
    source: Quickshell.env("HOME") + "/.local/share/hyprland-dots/wallpaper.png"
    antialiasing: true
    asynchronous: true
    fillMode: Image.PreserveAspectCrop
    retainWhileLoading: true
    smooth: true

    ColumnLayout {
        id: content

        spacing: 2
        x: 100
        y: 900

        Text {
            text: S.Time.time || "No Time Data"
            color: F.Colors.transparentize(F.Colors.backgroundColor, 0.3) || "#ffffff"
            font.family: "MRK Maston"
            font.pointSize: 50
        }

        Text {
            text: S.Time.date || "No Date Data"
            color: F.Colors.transparentize(F.Colors.backgroundColor, 0.3) || "#ffffff"
            font.family: "MRK Maston"
            font.pointSize: 60
        }
    }
}
