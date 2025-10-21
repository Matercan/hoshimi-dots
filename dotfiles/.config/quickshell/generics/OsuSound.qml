import QtMultimedia
import QtQuick

import qs.globals

Item {
    id: root
    required property string source
    property real volume: 0.7
    property bool playing: sfx.playing

    function play() {
        sfx.play();
    }

    SoundEffect {
        id: sfx
        volume: root.volume
        source: Variables.osuDirectory + "/" + root.source
    }
}
