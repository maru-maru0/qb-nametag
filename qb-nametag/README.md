# qb-nametag

A lightweight and simple nametag script for QBCore, allowing players to see each other's names and server IDs, with customizable visibility and debug features.

## Features

*   **Dynamic Nametags:** Displays player names and server IDs above their heads.
*   **Line of Sight (LOS) Check:** Nametags are hidden if players are behind obstacles (walls, vehicles, etc.).
*   **Toggle Visibility:** Players can toggle their own nametag visibility for others using a command.
*   **Hide in Vehicle:** Optionally hides nametags when players are inside a vehicle.
*   **Configurable:** Easily customize display distance, text scale, offsets, and notification messages.
*   **Debug Mode:** Includes an optional debug mode to spawn a fixed NPC displaying your nametag for testing purposes.

## Installation

1.  **Clone or Download:** Place the `qb-nametag` folder into your server's `resources` directory.
2.  **Add to `server.cfg`:** Add `ensure qb-nametag` to your `server.cfg` file.
3.  **Dependencies:** Ensure you have `qb-core` properly set up on your server.

## Configuration

All configuration options are available in `config.lua`.

```lua
Config = {}

-- General Settings
Config.DrawDistance = 20.0      -- Distance (in meters) to draw nametags
Config.TextScale = 0.3          -- Scale of the nametag text
Config.OffsetZ = 0.4            -- Z-axis offset from the top of the head
Config.NametagID = true         -- Whether to display the server ID next to the name
Config.HideInVehicle = false    -- Set to true to hide nametags when players are in a vehicle

-- Command Settings
Config.ToggleCommand = "name"   -- Command to toggle your own nametag visibility (e.g., /name)

-- Locale (Notification Messages)
Config.Locale = {
    hidden = "Your nametag is now hidden.",
    visible = "Your nametag is now visible."
}

-- Debug Settings
Config.Debug = true -- Set to true to enable debug mode (spawns an NPC with your nametag)
Config.DebugCoords = vector4(100.0, 100.0, 70.0, 0.0) -- Coordinates (x, y, z, heading) for the debug NPC
Config.DebugPedModel = "a_c_shepherd" -- Ped model for the debug NPC
```

## Usage

### Toggle Nametag Visibility

To toggle your own nametag visibility for other players, use the command defined in `config.lua` (default is `/name`).

*   Type `/name` in chat to hide your nametag.
*   Type `/name` again to make your nametag visible.

## Debug Mode

If `Config.Debug` is set to `true` in `config.lua`, an NPC will spawn at the specified `Config.DebugCoords` and display your nametag. This is useful for testing nametag visibility and line-of-sight checks without another player.

## Credits

Developed by Gemini (Google AI) based on user specifications.

If you redistribute this script, please ensure to include a link back to the [original GitHub repository](https://github.com/maru-maru0/qb-nametag).
