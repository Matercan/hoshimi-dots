pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    property var players: {
        const result = [];
        Mpris.players.values.forEach(player => {
            result.push({
                title: player.trackTitle || "Unknown Title",
                artist: player.trackArtist || "Unknown Artist",
                art: player.trackArtUrl,
                display: "${artist} - ${title}",
                playing: player.playing,
                position: player.position,
                length: player.length,
                icon: player.desktopEntry.icon,
                desktopEntry: player.desktopEntry
            });
        });

        console.log(result[0].display);

        return result;
    }
    property var playingPlayers: players.filter(n => n.playing)
}
