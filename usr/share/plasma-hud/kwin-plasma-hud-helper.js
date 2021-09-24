workspace.clientAdded.connect(onClientAdded)
workspace.clientActivated.connect(onClientActivated)
workspace.clientRemoved.connect(onClientRemoved)

print("Plasma HUD helper is loaded")

function isPlasmaHUDClient(client) {
    if (client && client.resourceName.toString() === "rofi"
            && client.resourceClass.toString() === "rofi") {
        return true
    }

    return false
}

function runDelayed(milliseconds, callbackFunc) {
    var timer = new QTimer()
    timer.timeout.connect(function () {
        timer.stop()
        callbackFunc()
    })
    timer.start(milliseconds)
    return timer
}

var lastActivatedClient = workspace.activeClient
var hudClient = null

function requestCloseWindow(client) {
    // Schedule close event
    runDelayed(1, function () {
        if (client) {
            client.closeWindow()
        }
    })
}

function onHudActiveChanged() {
    if (!hudClient || hudClient.active) {
        return
    }

    // Don't run closeWindow from a activeChanged event. it will crash kwin
    requestCloseWindow(hudClient)
}

function onClientAdded(client) {
    if (isPlasmaHUDClient(client) && lastActivatedClient) {
        var hudGeometry = client.frameGeometry
        var windowGeometry = lastActivatedClient.frameGeometry
        var titlebarHeight = windowGeometry.height - lastActivatedClient.clientSize.height
        hudGeometry.x = windowGeometry.x
        hudGeometry.y = windowGeometry.y + titlebarHeight
        hudGeometry.width = windowGeometry.width
        client.geometry = hudGeometry
        client.activeChanged.connect(onHudActiveChanged)
    }
}

function onClientActivated(client) {
    if (client && client.active) {
        if (isPlasmaHUDClient(client)) {
            hudClient = client
            // These two cannot be set in onClientAdded, their value would be
            // overwritten.
            client.skipTaskbar = true
            client.keepAbove = true
        } else {
            lastActivatedClient = client
        }
    }
}

function onClientRemoved(client) {
    if (!client)
        return

    if (client === hudClient) {
        hudClient = null
    } else if (hudClient && client === lastActivatedClient) {
        requestCloseWindow(hudClient)
    }
}
