local QBCore = exports['qb-core']:GetCoreObject()

-- This table stores the server IDs of players who have chosen to hide their nametags.
-- If a player's ID is not in this list, their nametag is considered "visible".
local hiddenPlayers = {}

-- Function to broadcast the current list of hidden players to all clients
local function broadcastHiddenList()
    TriggerClientEvent('qb-nametag:updateHiddenList', -1, hiddenPlayers)
end

-- Event triggered by the /name command from a client to toggle their nametag visibility
RegisterNetEvent('qb-nametag:toggleMyNametag', function()
    local src = source

    -- Toggle the player's visibility state
    if hiddenPlayers[src] then
        hiddenPlayers[src] = nil -- Remove from hidden list (make visible)
        TriggerClientEvent('QBCore:Notify', src, Config.Locale.visible, "success", 3500)
    else
        hiddenPlayers[src] = true -- Add to hidden list (make hidden)
        TriggerClientEvent('QBCore:Notify', src, Config.Locale.hidden, "error", 3500)
    end

    broadcastHiddenList()
end)

-- Event triggered by a client on script start to request the initial hidden list
RegisterNetEvent('qb-nametag:requestInitialList', function()
    local src = source
    TriggerClientEvent('qb-nametag:updateHiddenList', src, hiddenPlayers)
end)

-- When a player disconnects, remove them from the hidden list if they were in it
AddEventHandler('playerDropped', function(reason)
    local src = source
    if hiddenPlayers[src] then
        hiddenPlayers[src] = nil
        broadcastHiddenList()
    end
end)
