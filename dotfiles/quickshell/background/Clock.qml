import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "../sources" as S
import "../functions" as F

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: w

            property var modelData
            screen: modelData

            implicitWidth: content.implicitWidth || 300
            implicitHeight: content.implicitHeight || 200

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            margins {
                bottom: 580
            }

            color: "transparent"
            mask: Region {}
            WlrLayershell.layer: WlrLayer.Bottom

            ColumnLayout {
                id: content
                anchors.centerIn: parent

                // Add some spacing and margins for better visibility
                spacing: 2
                anchors.margins: 10
                rotation: 12

                FontLoader {
                    id: mastonRegular
                    source: "file:///home/matercan/.fonts/mrk_maston/MRKMaston-Regular.ttf"
                }

                FontLoader {
                    id: mastonBold
                    source: "file:///home/matercan/.fonts/mrk_maston/MRKMaston-Bold.ttf"
                }

                Text {
                    text: S.Time.time || "No Time Data"
                    color: F.Colors.transparentize(F.Colors.backgroundColor, 0.3) || "#ffffff"
                    font.family: mastonRegular.name
                    font.pointSize: 50
                }

                Text {
                    text: S.Time.date || "No Date Data"
                    color: F.Colors.transparentize(F.Colors.backgroundColor, 0.3) || "#ffffff"
                    font.family: mastonBold.name
                    font.pointSize: 60
                }
            }
        }
    }
}
