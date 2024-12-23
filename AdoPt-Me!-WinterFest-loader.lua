--tora script execute first
loadstring(game:HttpGet("https://raw.githubusercontent.com/ToraScript/Script/main/AdoptMeWINTER", true))()
wait(1)


--dehash remotes before script
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/e4315db490a84e920190f83279c4732e.lua"))()

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

-- Function to handle the continuous actions
local function handleActions()
    if isActive then -- Only execute actions if active
        if not isMinigameInGameAppEnabled() then
            invokeServer()
            if startGameButton and startGameButton.Visible then
                clickButton(startGameButton)
            else
                print("StartGame button not found or not visible.")
            end
        else
            print("MinigameInGameApp is enabled. Stopping further actions.")
            isActive = false -- Disable actions if the MinigameInGameApp is enabled
        end
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
        print(button.Name .. " was triggered!")
    else
        print("Button not found!")
    end
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

-- Create Additional Checkbox for another action
local additionalCheckbox = Instance.new("TextButton")
additionalCheckbox.Parent = clonedButton.Parent
additionalCheckbox.Size = UDim2.new(0.15, 0, 0.05, 0)
additionalCheckbox.Position = UDim2.new(
    clonedButton.Position.X.Scale,
    clonedButton.Position.X.Offset,
    clonedButton.Position.Y.Scale + clonedButton.Size.Y.Scale + spacing.Scale, -- Position it below the cloned button
    clonedButton.Position.Y.Offset + clonedButton.Size.Y.Offset + spacing.Offset
)
additionalCheckbox.Text = "Attack Action"
additionalCheckbox.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- New checkbox color
additionalCheckbox.Font = Enum.Font.SourceSans
additionalCheckbox.TextSize = 20 -- Size of the text

-- Global variable to track additional action state
local isAdditionalActionActive = false

-- Checkbox behavior for the additional checkbox
local function handleAdditionalCheckbox(button)
    local isChecked = false -- Track the toggle state for the additional checkbox

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

        -- Activate or deactivate the additional action based on the checkbox state
        isAdditionalActionActive = isChecked
        if isAdditionalActionActive then
            print("Additional action is now ON")

            -- Start a loop to trigger actions if checked
            spawn(function()
                while isAdditionalActionActive do
                    local joyBombButton = getButton("JoyBombButton")
                    local swordSlashButton = getButton("SwordSlashButton")

                    -- Trigger buttons
                    if joyBombButton then
                        triggerButton(joyBombButton)
                    else
                        print("JoyBombButton not found!")
                    end

                    if swordSlashButton then
                        triggerButton(swordSlashButton) -- Trigger SwordSlashButton
                    else
                        print("SwordSlashButton not found!")
                    end

                    wait(0.1) -- Small delay to prevent performance issues
                end
                print("Additional action has been turned OFF.")
            end)
        else
            print("Additional action is now OFF.")
        end
    end)
end

-- Apply checkbox functionality to the additional checkbox
handleAdditionalCheckbox(additionalCheckbox)

-- Main loop to continuously check the status and perform actions
while true do
    if isActive then
        handleActions()

        -- Get the JoyBombButton and SwordSlashButton
        local joyBombButton = getButton("JoyBombButton")
        local swordSlashButton = getButton("SwordSlashButton")

        print("Attempting to trigger JoyBombButton and SwordSlashButton...")

        -- Trigger buttons at intervals
        if joyBombButton then
            triggerButton(joyBombButton)
        else
            print("JoyBombButton not found!")
        end

        if swordSlashButton then
            triggerButton(swordSlashButton) -- This triggers the SwordSlashButton
        else
            print("SwordSlashButton not found!")
        end
    end

    wait(0.1) -- Add a short delay to prevent excessive resource usage
end
