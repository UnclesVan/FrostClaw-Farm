--tora script execute first
loadstring(game:HttpGet(('https://raw.githubusercontent.com/ReQiuYTPL/hub/main/ReQiuYTPLHub.lua'),true))()
wait(1)



wait(2)


local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Clone the original button
local coreGui = game:GetService("CoreGui")
local toraScript = coreGui:WaitForChild("ToraScript")
local originalButton = toraScript:WaitForChild("ImageButton")

local clonedButton = originalButton:Clone()
clonedButton.Parent = originalButton.Parent
local spacing = UDim.new(0, 10)
clonedButton.Position = UDim2.new(
    originalButton.Position.X.Scale,
    originalButton.Position.X.Offset,
    originalButton.Position.Y.Scale,
    originalButton.Position.Y.Offset + originalButton.Size.Y.Offset + spacing.Offset
)

-- Change the text on the cloned button
local function changeClonedButtonText()
    local foundTextLabel = false
    for _, child in pairs(clonedButton:GetDescendants()) do
        if child:IsA("TextLabel") then
            if string.match(child.Text:lower(), "auto minigames") then
                child.Text = "Auto Kill V2"
                foundTextLabel = true
                break
            end
        end
    end
    if not foundTextLabel then
        warn("TextLabel 'Auto Minigames' not found in cloned button!")
    end
end
changeClonedButtonText()

-- Track if the script is currently firing and clicking
local isActive = false -- Active state for the minigame actions

-- Fire the InvokeServer with the arguments
local function invokeServer()
    local args = { [1] = "frostclaws_revenge" }
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
        for _, connection in pairs(getconnections(button.MouseButton1Down)) do
            connection:Fire()
        end
        wait(0.1)
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Fire()
        end
        wait(0.1)
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

-- Checkbox behavior for the cloned button
local function handleCheckbox(button)
    local isChecked = false -- Track the toggle state of the button

    -- Create a Frame for the checkbox
    local checkboxFrame = Instance.new("Frame")
    checkboxFrame.Parent = button
    checkboxFrame.Size = UDim2.new(0.15, 0, 0.2, 0) -- Adjust size as needed
    checkboxFrame.AnchorPoint = Vector2.new(1, 0.5) -- Anchor to right edge
    checkboxFrame.Position = UDim2.new(1, -3, 0.5, 0)
    checkboxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Make the frame visible

    -- Create a checkmark inside the frame
    local checkmark = Instance.new("ImageLabel")
    checkmark.Parent = checkboxFrame
    checkmark.Size = UDim2.new(0.6, 0, 0.6, 0)
    checkmark.AnchorPoint = Vector2.new(0.5, 0.5)
    checkmark.Position = UDim2.new(0.5, 0, 0.5, 0)
    checkmark.BackgroundTransparency = 1
    checkmark.Image = "rbxassetid://3570695787"
    checkmark.Visible = false -- Initially hide the checkmark

    -- Toggle behavior on click
    button.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        checkboxFrame.BackgroundColor3 = isChecked and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        checkmark.Visible = isChecked

        -- Activate or deactivate the script based on the checkbox state
        isActive = isChecked
        if isActive then
            print("Auto Kill V2 is now ON")
        else
            print("Auto Kill V2 is now OFF. Stopping all actions.")
        end
    end)
end

-- Apply checkbox functionality to the cloned button
handleCheckbox(clonedButton)

-- Additional Action Button
local additionalActionButton = Instance.new("TextButton")
additionalActionButton.Parent = clonedButton.Parent
additionalActionButton.Size = UDim2.new(0.15, 0, 0.05, 0)
additionalActionButton.Position = UDim2.new(
    clonedButton.Position.X.Scale,
    clonedButton.Position.X.Offset,
    clonedButton.Position.Y.Scale + clonedButton.Size.Y.Scale + spacing.Scale, -- Position it below the cloned button
    clonedButton.Position.Y.Offset + clonedButton.Size.Y.Offset + spacing.Offset
)
additionalActionButton.Text = "Additional Action"
additionalActionButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Blue color (inactive)
additionalActionButton.Font = Enum.Font.SourceSans
additionalActionButton.TextSize = 20 -- Size of the text

local isAdditionalActionActive = false -- Global variable to track additional action state

-- Function to handle the additional action in a loop
local function handleAdditionalAction()
    local joyBombButton = playerGui:WaitForChild("FrostclawsRevengeHotbarApp"):WaitForChild("Hotbar"):WaitForChild("JoyBombButton"):FindFirstChild("Button")
    local swordSlashButton = playerGui:WaitForChild("FrostclawsRevengeHotbarApp"):WaitForChild("Hotbar"):WaitForChild("SwordSlashButton"):FindFirstChild("Button")

    -- Triggering the buttons
    if joyBombButton then
        print("Triggering JoyBombButton...")
        clickButton(joyBombButton)
    else
        print("JoyBombButton not found!")
    end

    if swordSlashButton then
        print("Triggering SwordSlashButton...")
        clickButton(swordSlashButton)
    else
        print("SwordSlashButton not found!")
    end
end

-- Toggle functionality for the additional action button
additionalActionButton.MouseButton1Click:Connect(function()
    isAdditionalActionActive = not isAdditionalActionActive
    if isAdditionalActionActive then
        print("Additional Action is now ON. Triggering actions...")
        -- Change button color to green when active
        additionalActionButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green color (active)
        spawn(function()
            while isAdditionalActionActive do
                handleAdditionalAction()
                wait(0.5) -- Adjust the delay as needed (interval between actions)
            end
            print("Additional Action has been turned OFF.")
            -- Change button color to blue when deactivated
            additionalActionButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Blue color (inactive)
        end)
    else
        print("Additional Action is now OFF.")
        -- Change button color to blue when deactivated
        additionalActionButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Blue color (inactive)
    end
end)

-- Main loop to continuously check the status and perform actions
while true do
    if isActive then
        if not isMinigameInGameAppEnabled() then
            -- If the MinigameInGameApp is disabled, click the StartGame button and invoke the server
            if startGameButton and startGameButton.Visible then
                print("Attempting to repeatedly click the StartGame button...")
                clickButton(startGameButton)
            end
            -- Keep calling the invokeServer function
            invokeServer()
        else
            print("MinigameInGameApp is enabled. Stopping actions.")
        end

        wait(0.5) -- Adjust the delay to control how fast it clicks
    else
        print("Script is OFF. Waiting for activation.")
    end

    wait(0.1) -- Add a small delay to prevent excessive resource usage
end
