import QtQuick.Layouts
import QtQuick

import qs.functions
import qs.services
import qs.globals

ColumnLayout {
    id: content

    Text {
        text: Time.time || "No Time Data"
        color: Colors.transparentize(Colors.foregroundColor, 0.3) || "#ffffff"
        font.family: Config.background.clock.font
        font.pointSize: 50
    }

    Text {
        text: Time.date || "No Date Data"
        color: Colors.transparentize(Colors.foregroundColor, 0.3) || "#ffffff"
        font.family: Config.background.clock.font
        font.pointSize: 60
    }
}
