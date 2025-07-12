Config = {}

-- General Settings
Config.DrawDistance = 5.0      -- Distance (in meters) to draw nametags
Config.TextScale = 0.3          -- Scale of the nametag text
Config.OffsetZ = 0.4            -- Z-axis offset from the top of the head
Config.NametagID = true         -- Whether to display the server ID next to the name
Config.HideInVehicle = true    -- Set to true to hide nametags when players are in a vehicle

-- Command Settings
Config.ToggleCommand = "name"   -- Command to toggle your own nametag visibility (e.g., /name)

-- Locale (Notification Messages)
Config.Locale = {
    hidden = "Your nametag is now hidden.",
    visible = "Your nametag is now visible."
}

-- Debug Settings
Config.Debug = true -- Set to true to enable debug mode (spawns an NPC with your nametag)
Config.DebugCoords = vector4(-21.6, -605.48, 105.3, 251.29) -- Coordinates (x, y, z, heading) for the debug NPC
Config.DebugPedModel = "s_m_m_movspace_01" -- Ped model for the debug NPC
