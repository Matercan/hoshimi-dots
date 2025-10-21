import QtMultimedia
import QtQuick

import qs.globals

Item {
    id: root
    required property string source
    property real volume: 0.7
    property bool playing: sfx.playing

    function play() {
        console.log(sfx.volume);
        sfx.play();
    }

    SoundEffect {
        id: sfx
        volume: 0.5
        source: Variables.osuDirectory + "/" + root.source
    }
}
