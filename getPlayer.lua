-- Initialize the Peripherals
local monitor = peripheral.find("monitor")
local playerSensor = peripheral.find("playerDetector")

if not monitor then
    print("No monitor found")
    return
end

if not playerSensor then
    print("No player detector found")
    return
end

-- Function to get player data
local function getPlayerData()
    return playerSensor.getOnlinePlayers()
end

-- Function to get detailed player position data
local function getPlayerPosition(username)
    return playerSensor.getPlayerPos(username)
end

-- Function to display player positions
local function displayPlayerPositions(players)
    monitor.clear()
    monitor.setTextScale(0.5)  -- Adjust text scale for readability

    -- Draw a border
    local width, height = monitor.getSize()
    monitor.setCursorPos(1, 1)
    monitor.write(string.rep("-", width))
    monitor.setCursorPos(1, height)
    monitor.write(string.rep("-", width))
    for y = 2, height - 1 do
        monitor.setCursorPos(1, y)
        monitor.write("|")
        monitor.setCursorPos(width, y)
        monitor.write("|")
    end

    monitor.setCursorPos(3, 2)
    monitor.write("Player Positions")
    monitor.setCursorPos(3, 3)
    monitor.write(string.rep("-", width - 4))

    local line = 4
    for i, player in ipairs(players) do
        local name = player
        local playerPos = getPlayerPosition(name)

        if playerPos then
            local x = tonumber(playerPos.x) or "N/A"
            local y = tonumber(playerPos.y) or "N/A"
            local z = tonumber(playerPos.z) or "N/A"
            local dimension = playerPos.dimension or "N/A"
            local health = tonumber(playerPos.health) or "N/A"
            local maxHealth = tonumber(playerPos.maxHealth) or 20

            -- Debug: Print player data to console
            print(string.format("Player: %s, x: %s, y: %s, z: %s, dimension: %s, health: %s/%s", name, x, y, z, dimension, health, maxHealth))

            monitor.setCursorPos(3, line)
            monitor.write(string.format("%s:", name))
            line = line + 1
            monitor.setCursorPos(5, line)
            monitor.write(string.format("Pos: (%.2f, %.2f, %.2f)", x, y, z))
            line = line + 1
            monitor.setCursorPos(5, line)
            monitor.write(string.format("Dim: %s", dimension))
            line = line + 1
            monitor.setCursorPos(5, line)
            monitor.write(string.format("Health: %s/%s", health, maxHealth))
            line = line + 2  -- Add extra line for spacing
        else
            monitor.setCursorPos(3, line)
            monitor.write(string.format("%s: Position not available", name))
            line = line + 1
        end
    end
end

-- Main Loop
while true do
    local players = getPlayerData()
    if players then
        displayPlayerPositions(players)
    else
        monitor.clear()
        monitor.setTextScale(0.5)  -- Adjust text scale for readability
        -- Draw a border
        local width, height = monitor.getSize()
        monitor.setCursorPos(1, 1)
        monitor.write(string.rep("-", width))
        monitor.setCursorPos(1, height)
        monitor.write(string.rep("-", width))
        for y = 2, height - 1 do
            monitor.setCursorPos(1, y)
            monitor.write("|")
            monitor.setCursorPos(width, y)
            monitor.write("|")
        end
        monitor.setCursorPos(3, 2)
        monitor.write("No players online.")
    end
    sleep(5)  -- Update every 5 seconds
end
