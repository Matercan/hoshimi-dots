import QtQuick
import Quickshell
import Quickshell.Io

pragma Singleton


Singleton {
    function parseTime(seconds: real): var {
        var hours =  Math.floor(seconds / 3600)
        var minutes = Math.floor( ( seconds % 3600 )  / 60 )
        var lastSeconds = Math.floor((seconds % 60))
    }
}


