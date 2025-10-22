pragma Singleton

import qs.generics
import Quickshell
import QtQuick

Singleton {
    property Sound drums: Sound {
        source: "drum"
    }

    property Sound softs: Sound {
        source: "soft"
    }

    property Sound normals: Sound {
        source: "normal"
    }

    component Sound: Item {
        id: sound
        property var con: "-hitnormal-"
        required property string source

        function getSound(name: string): string {
            const split = name.split("-");

            let result = sound.source + sound.con;

            for (let chara of split) {
                result += "hit" + split + "-";
            }

            return result.substring(0, result.length - 1) + ".wav";
        }

        function getComponent(sfx: string): OsuSound {
            switch (sfx) {
            case "clap":
                return clap;
            case "finishClap":
                return finishclap;
                break;
            case "finish":
                return finish;
                break;
            case "whistleclap":
                return whistleclap;
                break;
            case "whistlefinish":
                return whistlefinish;
            case "whistle":
                return whistle;
            default:
                return finish;
            }
        }

        function play(sfx: string, volume = 1) {
            const preVol = getComponent(sfx).volume === null ? 1 : getComponent(sfx).volume;
            setVolume(sfx, volume);
            if (!getComponent(sfx).playing)
                getComponent(sfx).play();
        }

        function setVolume(sfx: string, volume: real) {
            getComponent(sfx).volume = volume;
        }

        property OsuSound clap: OsuSound {
            source: sound.getSound("clap")
        }

        property OsuSound finishclap: OsuSound {
            source: sound.getSound("finish-clap")
        }

        property OsuSound finish: OsuSound {
            source: sound.getSound("finish")
        }

        property OsuSound whistleclap: OsuSound {
            source: sound.getSound("whistle-clap")
        }

        property OsuSound whistlefinish: OsuSound {
            source: sound.getSound("whistle-finish")
        }

        property OsuSound whistle: OsuSound {
            source: sound.getSound("whistle")
        }
    }
}
