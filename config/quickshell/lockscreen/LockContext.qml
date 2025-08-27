import QtQuick
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Hyprland as H
import Quickshell.Io

import qs.globals as G

Scope {
    id: root
    signal unlocked
    signal failed

    // These properties are in the context and not individual lock surfaces
    // so all surfaces can share the same state.
    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false
    property bool timerInProgress: false

    // Clear the failure text once the user starts typing.
    onCurrentTextChanged: showFailure = false

    function tryUnlock() {
        if (currentText === "")
            return;

        root.unlockInProgress = true;
        pam.start();
    }

    PamContext {
        id: pam

        // Its best to have a custom pam config for quickshell, as the system one
        // might not be what your interface expects, and break in some way.
        // This particular example only supports passwords.
        configDirectory: "pam"
        config: "password.conf"

        // pam_unix will ask for a response for the password prompt
        onPamMessage: {
            if (this.responseRequired) {
                pam.respond(root.currentText);
            }
        }

        // pam_unix won't send any important messages so all we need is the completion status.
        onCompleted: result => {
            if (result == PamResult.Success) {
                root.timerInProgress = true;
                timer.running = true;
            } else {
                root.currentText = "";
                root.showFailure = true;
            }

            root.unlockInProgress = false;
        }
    }
    Timer {
        id: timer
        running: false
        repeat: false
        interval: G.MaterialEasing.emphasizedTime * 1.5
        onTriggered: {
            G.Variables.locked = false;
            root.unlocked();
            root.timerInProgress = false;
        }
    }

    IpcHandler {
        target: "lock"

        function toggle(): void {
            G.Variables.locked = !G.Variables.locked;
        }
        function lock(): void {
            G.Variables.locked = true;
            console.log("Screen locked");
        }
        function getLocked(): bool {
            return G.Variables.locked;
        }
    }
}
