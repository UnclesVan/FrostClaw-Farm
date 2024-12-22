--tora script execute first
loadstring(game:HttpGet("https://raw.githubusercontent.com/ToraScript/Script/main/AdoptMeWINTER", true))()
wait(1)


--dehash remotes before script
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/e4315db490a84e920190f83279c4732e.lua"))()

wait(2)


local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Fire the InvokeServer with the arguments
local function invokeServer()
    local args = { [1] = "frostclaws_revenge" }

    -- Call the InvokeServer method with the provided arguments
    local success, errorMessage = pcall(function()
        replicatedStorage.API:FindFirstChild("MinigameAPI/LobbyCreate"):InvokeServer(unpack(args))
    end)

    if success then
        print("InvokeServer called successfully!")
    else
        print("Error invoking server: " .. errorMessage)
    end
end

-- Define the location for the StartGame button
local startGameButton = playerGui:WaitForChild("MinigameLobbyApp")
    :WaitForChild("Frame")
    :WaitForChild("Body")
    :WaitForChild("LobbyContent")
    :WaitForChild("StartGame")
    :WaitForChild("Button")

-- Function to simulate click events
local function clickButton(button)
    if button then
        print("Button found! Attempting to click:", button.Name)

        -- Fire MouseButton1Down
        for _, connection in pairs(getconnections(button.MouseButton1Down)) do
            connection:Fire()
        end
        wait(0.1)

        -- Fire MouseButton1Click
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Fire()
        end
        wait(0.1)

        -- Fire MouseButton1Up
        for _, connection in pairs(getconnections(button.MouseButton1Up)) do
            connection:Fire()
        end

        print("Successfully clicked the button!")
    else
        print("Button not found!")
    end
end

-- Function to check if MinigameInGameApp is enabled
local function isMinigameInGameAppEnabled()
    local minigameInGameApp = playerGui:FindFirstChild("MinigameInGameApp")
    return minigameInGameApp and minigameInGameApp.Enabled
end

-- Track if the script is currently firing the InvokeServer and clicking the button
local isActive = true

-- Function to handle the continuous actions
local function handleActions()
    -- Check if MinigameInGameApp is disabled
    if not isMinigameInGameAppEnabled() then
        if isActive then
            -- Fire the InvokeServer
            invokeServer()

            -- Click the StartGame button if it is valid and visible
            if startGameButton and startGameButton.Visible then
                print("Clicking StartGame button...")
                clickButton(startGameButton)
            else
                print("StartGame button not found or not visible.")
            end
        end
    else
        -- If MinigameInGameApp is enabled, stop the actions
        print("MinigameInGameApp is enabled. Stopping further actions.")
        isActive = false
    end
end

-- Function to get button by name from the Hotbar
local function getButton(buttonName)
    local hotbarApp = playerGui:WaitForChild("FrostclawsRevengeHotbarApp")
    local hotbar = hotbarApp:WaitForChild("Hotbar")
    local buttonFrame = hotbar:FindFirstChild(buttonName)
    return buttonFrame and buttonFrame:FindFirstChild("Button")
end

-- Function to trigger button events
local function triggerButton(button)
    if button then
        for _, connection in pairs(getconnections(button.MouseButton1Down)) do
            connection:Fire()
        end
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Fire()
        end
        for _, connection in pairs(getconnections(button.MouseButton1Up)) do
            connection:Fire()
        end
    else
        print("Button not found!")
    end
end

-- Loop to continuously check the status and perform actions
while true do
    -- Handle the actions if MinigameInGameApp is not enabled
    handleActions()

    -- Get and trigger the JoyBombButton and SwordSlashButton
    local joyBombButton = getButton("JoyBombButton")
    local swordSlashButton = getButton("SwordSlashButton")

    -- Trigger the events for each button
    triggerButton(joyBombButton)
    triggerButton(swordSlashButton)

    wait(0.1) -- Add a short delay to prevent excessive resource usage

    -- If MinigameInGameApp is disabled again, restart the actions
    if isMinigameInGameAppEnabled() == false and not isActive then
        print("MinigameInGameApp is now disabled. Restarting actions.")
        isActive = true
    end
end
