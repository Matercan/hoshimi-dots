pragma Singleton
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root

    property int biggestWindow: workspaces[workspaces.length - 1].id

    property var activeWindow: {
        const wn = Hyprland.activeToplevel;
        if (!wn)
            return null;

        return {
            title: wn.title,
            adress: wn.address,
            activated: wn.activated,
            monitor: wn.monitor,
            workspace: wn.workspace
        };
    }
    property var activeWorkspace: {
        const ws = Hyprland.activeToplevel?.workspace;
        if (!ws)
            return null;

        return {
            id: ws.id,
            name: ws.name,
            monitor: ws.monitor,
            toplevels: ws.toplevels,
            active: ws.active
        };
    }

    property var windows: {
        const result = [];
        Hyprland.toplevels.values.forEach(client => {
            result.push({
                title: client.title,
                address: client.address,
                activated: client.activated,
                monitor: client.monitor,
                workspace: client.workspaces
            });
        });

        result.sort((a, b) => {
            if (a.workspace !== b.workspace) {
                return a.workspace - b.workspace;
            }

            return a.title.localeCompare(b.title);
        });

        return result;
    }
    property var workspaces: {
        const result = [];
        Hyprland.workspaces.values.forEach(client => {
            result.push({
                id: client.id,
                name: client.name,
                monitor: client.monitor,
                toplevels: client.toplevels,
                active: client.active
            });
        });

        result.sort((a, b) => {
            return a.id - b.id;
        });

        return result;
    }
}
