local QBCore = exports['qb-core']:GetCoreObject()
local hiddenPlayers = {} -- Synchronized list of hidden player IDs from the server

-- 3D Text Drawing Function
function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    SetTextScale(Config.TextScale, Config.TextScale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(_x, _y)
end

-- Register command using the name from config.lua
RegisterCommand(Config.ToggleCommand, function()
    TriggerServerEvent('qb-nametag:toggleMyNametag')
end, false)

-- Event to receive the updated hidden list from the server
RegisterNetEvent('qb-nametag:updateHiddenList', function(list)
    hiddenPlayers = list
end)

-- Main rendering loop
Citizen.CreateThread(function()
    -- Request the initial hidden list from the server when the script starts
    TriggerServerEvent('qb-nametag:requestInitialList')

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local pcoords = GetEntityCoords(playerPed)

        for _, pid in ipairs(GetActivePlayers()) do
            local serverId = GetPlayerServerId(pid)
            
            -- Render if the player is NOT in the hidden list
            if not hiddenPlayers[serverId] then
                local targetPed = GetPlayerPed(pid)
                if DoesEntityExist(targetPed) then
                    -- Check if nametag should be hidden when in vehicle
                    if Config.HideInVehicle and IsPedInAnyVehicle(targetPed, false) then
                        -- Skip drawing if in vehicle and setting is enabled
                        goto continue_loop
                    end

                    local tcoords = GetEntityCoords(targetPed)
                    local dist = #(tcoords - pcoords)

                    -- Check distance and line of sight
                    if dist <= Config.DrawDistance and HasEntityClearLosToEntity(playerPed, targetPed, 17) then
                        local head = GetPedBoneCoords(targetPed, 12844, 0.0, 0.0, 0.0)
                        local pos = vector3(head.x, head.y, head.z + Config.OffsetZ)
                        
                        local name
                        -- Get player name from QBCore data for self, or GetPlayerName for others
                        if pid == PlayerId() then
                            local pd = QBCore.Functions.GetPlayerData()
                            if pd and pd.charinfo then
                                name = pd.charinfo.firstname .. " " .. pd.charinfo.lastname
                            else
                                name = GetPlayerName(pid)
                            end
                        else
                            name = GetPlayerName(pid)
                        end

                        local display = Config.NametagID and (name .. " [" .. serverId .. "]") or name
                        
                        Draw3DText(pos.x, pos.y, pos.z, display)
                    end
                end
            end
            ::continue_loop::
        end
    end
end)

-- Debug NPC logic (unaffected by the toggle command)
if Config.Debug then
    Citizen.CreateThread(function()
        local model = GetHashKey(Config.DebugPedModel)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(100)
        end

        local npc = CreatePed(4, model, Config.DebugCoords.x, Config.DebugCoords.y, Config.DebugCoords.z, Config.DebugCoords.w, false, false)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetModelAsNoLongerNeeded(model)

        while true do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local pcoords = GetEntityCoords(playerPed)
            local coords = GetEntityCoords(npc)
            local dist = #(coords - pcoords)

            if dist <= Config.DrawDistance and HasEntityClearLosToEntity(playerPed, npc, 17) then
                local head = GetPedBoneCoords(npc, 12844, 0.0, 0.0, 0.0)
                local pos = vector3(head.x, head.y, head.z + Config.OffsetZ)

                local serverId = GetPlayerServerId(PlayerId())
                local pd = QBCore.Functions.GetPlayerData()
                local name = (pd and pd.charinfo) and (pd.charinfo.firstname .. " " .. pd.charinfo.lastname) or GetPlayerName(PlayerId())
                local display = Config.NametagID and (name .. " [" .. serverId .. "]") or name
                Draw3DText(pos.x, pos.y, pos.z, display)
            end
        end
    end)
end