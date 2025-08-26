pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import QtQuick.Effects

import qs.functions as F
import qs.generics as Gen
import qs.globals as Glo

Rectangle {
    id: root
    required property LockContext context
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    readonly property var phrases: [["仏", "陀", "の", "勇", "猛", "果", "敢", "武", "士"], ["黒", "鴉", "の", "翼"], ["月", "下", "美", "人", "剣"], ["桜", "散", "る", "戦", "場"], ["龍", "神", "の", "怒", "り"], ["夜", "叉", "の", "如", "く"], ["一", "期", "一", "会"], ["七", "転", "び", "八", "起", "き"], ["風", "林", "火", "山", "陰", "雷"], ["血", "染", "め", "の", "月", "光"], ["千", "本", "桜", "散", "華"], ["闇", "夜", "の", "刺", "客"], ["不", "死", "身", "の", "武", "士"], ["鋼", "の", "意", "志"]]
    readonly property list<string> translations: ["The Bhudda's most courageous samurai", "Wings of the black crow", "The sword of beauty under the moonlight", "The battlefield where the cherry blossoms fall", "The wrath of the Dragon God", "Like a demon", "Treasure each encounter", "Fall seven times, rise eight", "wind, forest, fire, mountain, shadow, thunder", "The bloodstained moonlight", "Thousand cherry blossom falling", "Assassin of the dark night", "Warrior of Immortality", "A will of steel"]

    readonly property int phraseIndex: Math.floor(Math.random() * 12)
    readonly property list<string> samuraiText: phrases[phraseIndex]
    readonly property string englishText: translations[phraseIndex]
    readonly property list<string> samurai: ["s", "a", "m", "u", "r", "a", "i"]

    property string inputBuffer: ""
    property string maskedBuffer: ""

    Gen.Wallpaper {
        layer.enabled: true
        layer.effect: MultiEffect {
            id: walBlur
            blurEnabled: true

            // Fix: Animate blur in when screen locks
            NumberAnimation on blur {
                id: blurInAnimation
                duration: Glo.MaterialEasing.emphasizedTime
                easing.type: Easing.Linear
                from: 0
                to: 0.69
                running: true
            }

            // Fix: Animate blur out when unlocking
            NumberAnimation {
                id: blurOutAnimation
                duration: Glo.MaterialEasing.emphasizedTime * 1.5
                easing.type: Easing.Linear
                property: "blur"
                running: root.context.timerInProgress
                target: walBlur
                to: 0
            }
        }
    }

    ColumnLayout {
        id: decodedText
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }

        Text {
            text: root.samuraiText.join("")
            font.family: "Mutsuki"
            font.pointSize: 30
            color: F.Colors.iconColor
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: root.englishText
            font.pointSize: 30
            font.family: "Shadow Whisper"
            color: F.Colors.iconColor
            Layout.alignment: Qt.AlignHCenter
        }
    }

    ColumnLayout {

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
        }

        TextField {
            id: passwordBox

            focus: true
            visible: false
            enabled: !root.context.unlockInProgress

            onTextChanged: root.context.currentText = this.text

            onAccepted: root.context.tryUnlock()

            Connections {
                id: connection
                target: root.context
                property string toBuffer: ""

                function onCurrentTextChanged() {
                    passwordBox.text = root.context.currentText;
                    connection.toBuffer = "";

                    for (const ch of passwordBox.text) {
                        connection.toBuffer += root.samurai[Math.floor(Math.random() * root.samurai.length)];
                    }
                    connection.toBuffer = connection.toBuffer.slice(0, -1);
                    root.maskedBuffer = connection.toBuffer;
                    // Set the new character (last character typed)
                    if (root.context.currentText.length > 0) {
                        root.inputBuffer = root.samurai[Math.floor(Math.random() * root.samurai.length)];
                        root.inputBufferChanged = !root.inputBufferChanged; // Toggle to trigger animation
                    } else {
                        root.inputBuffer = "";
                    }
                }
            }
        }
    }

    ColumnLayout {
        visible: root.context.showFailure

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }

        Label {
            text: "失敗行いました"
            font.pointSize: 30
            color: F.Colors.errorColor
            font.family: "Mutsuki"
            horizontalAlignment: Qt.AlignCenter
            verticalAlignment: Qt.AlignCenter
        }

        Label {
            font.pointSize: 30
            text: "Incorrect password"
            color: F.Colors.errorColor
            font.family: "Shadow Whisper"
            horizontalAlignment: Qt.AlignCenter
        }
    }

    RowLayout {
        id: displayText
        anchors.centerIn: parent
        opacity: 1

        Label {
            id: mainText
            text: root.maskedBuffer
            font.family: "Libre Barcode 128"
            color: F.Colors.passwordColor
            property int size: 400
            font.letterSpacing: text.length * 14
            font.pixelSize: size

            NumberAnimation on font.letterSpacing {
                duration: Glo.MaterialEasing.standardTime
                easing.type: Easing.OutCubic
            }
        }

        Label {
            id: newChar
            font.family: "Libre Barcode 128"
            text: root.inputBuffer
            color: F.Colors.transparentize(F.Colors.passwordColor, 0.3)
            property int size: 0
            font.pixelSize: size

            NumberAnimation {
                id: textAnimation
                target: newChar
                properties: "size"
                duration: Glo.MaterialEasing.standardTime
                from: 0
                to: 300
                easing.type: Easing.OutCubic
            }
        }

        OpacityAnimator {
            running: root.context.timerInProgress
            target: displayText
            to: 0
            from: 1
            duration: Glo.MaterialEasing.emphasizedTime * 1.5
            easing.type: Easing.Linear
        }

        Connections {
            target: root

            function onInputBufferChanged() {
                textAnimation.start();
            }
        }
    }
}
