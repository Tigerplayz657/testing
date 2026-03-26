-- TriggerBot Script for Roblox
-- Automatically fires when an enemy is in crosshairs with customizable delay

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Configuration
local config = {
    enabled = true,
    delay = 50, -- Delay in milliseconds (default: 50ms)
    maxDistance = 200, -- Maximum distance to target (studs)
    crosshairRadius = 30, -- Crosshair detection radius in pixels
    teamCheck = true, -- Only target enemy players
    ignoreFriends = true, -- Don't target friends
    keybind = Enum.KeyCode.LeftControl -- Hold to enable
}

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TriggerBotGUI"
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Main UI Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(255, 100, 0)
mainFrame.Active = true
mainFrame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "TriggerBot v1.0"
title.TextColor3 = Color3.fromRGB(255, 200, 100)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = mainFrame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: " .. (config.enabled and "ENABLED" or "DISABLED")
statusLabel.TextColor3 = config.enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Delay Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(1, -20, 0, 20)
delayLabel.Position = UDim2.new(0, 10, 0, 65)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay: " .. config.delay .. "ms"
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.Font = Enum.Font.SourceSans
delayLabel.TextSize = 14
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = mainFrame

-- Keybind Label
local keybindLabel = Instance.new("TextLabel")
keybindLabel.Size = UDim2.new(1, -20, 0, 20)
keybindLabel.Position = UDim2.new(0, 10, 0, 90)
keybindLabel.BackgroundTransparency = 1
keybindLabel.Text = "Keybind: " .. config.keybind.Name
keybindLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
keybindLabel.Font = Enum.Font.SourceSans
keybindLabel.TextSize = 14
keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
keybindLabel.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 80, 0, 25)
toggleButton.Position = UDim2.new(1, -90, 1, -30)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.BorderSizePixel = 1
toggleButton.BorderColor3 = Color3.fromRGB(255, 100, 0)
toggleButton.Text = "Toggle"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 12
toggleButton.Parent = mainFrame

-- Delay Input
local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0, 60, 0, 20)
delayInput.Position = UDim2.new(1, -70, 0, 65)
delayInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
delayInput.BorderSizePixel = 1
delayInput.BorderColor3 = Color3.fromRGB(255, 100, 0)
delayInput.Text = tostring(config.delay)
delayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
delayInput.Font = Enum.Font.SourceSans
delayInput.TextSize = 12
delayInput.Parent = mainFrame

-- Variables
local localPlayer = Players.LocalPlayer
local triggerConnection = nil
local isHoldingKey = false
currentTarget = nil
lastFireTime = 0

-- Functions
local function isValidTarget(plr)
    if not plr or not plr.Character then return false end
    if plr == localPlayer then return false end
    
    local humanoid = plr.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    -- Team check
    if config.teamCheck and plr.Team == localPlayer.Team then return false end
    
    -- Friend check
    if config.ignoreFriends and localPlayer:IsFriendsWith(plr.UserId) then return false end
    
    return true
end

local function getClosestPlayerToCrosshair()
    local camera = Workspace.CurrentCamera
    local mousePos = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, plr in pairs(Players:GetPlayers()) do
        if not isValidTarget(plr) then continue end
        
        local character = plr.Character
        local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
        if not head then continue end
        
        local screenPos = camera:WorldToScreenPoint(head.Position)
        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        
        -- Check if player is in crosshair area
        if distance < config.crosshairRadius then
            local charDistance = (camera.CFrame.Position - character.HumanoidRootPart.Position).Magnitude
            if charDistance < config.maxDistance and charDistance < closestDistance then
                closestDistance = charDistance
                closestPlayer = plr
            end
        end
    end
    
    return closestPlayer
end

local function fireWeapon()
    local character = localPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local currentTime = tick()
    if currentTime - lastFireTime < (config.delay / 1000) then return end
    
    -- Try different methods to fire
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        -- Method 1: Activate tool
        if tool:FindFirstChild("Activate") then
            tool:Activate()
        end
        
        -- Method 2: Use humanoid
        humanoid:Activate()
        
        -- Method 3: Simulate mouse click
        local mouse = localPlayer:GetMouse()
        mouse1press()
        wait(0.01)
        mouse1release()
    else
        -- Just use humanoid activation
        humanoid:Activate()
    end
    
    lastFireTime = currentTime
end

local function onHeartbeat()
    if not config.enabled or not isHoldingKey then return end
    
    local target = getClosestPlayerToCrosshair()
    if target then
        currentTarget = target
        fireWeapon()
    else
        currentTarget = nil
    end
end

local function startTriggerbot()
    if triggerConnection then return end
    
    triggerConnection = RunService.Heartbeat:Connect(onHeartbeat)
    statusLabel.Text = "Status: ENABLED"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
end

local function stopTriggerbot()
    if triggerConnection then
        triggerConnection:Disconnect()
        triggerConnection = nil
    end
    currentTarget = nil
    statusLabel.Text = "Status: DISABLED"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
end

-- UI Events
toggleButton.MouseButton1Click:Connect(function()
    config.enabled = not config.enabled
    if config.enabled then
        startTriggerbot()
    else
        stopTriggerbot()
    end
end)

delayInput.FocusLost:Connect(function(enterPressed)
    local newDelay = tonumber(delayInput.Text)
    if newDelay and newDelay >= 0 and newDelay <= 1000 then
        config.delay = newDelay
        delayLabel.Text = "Delay: " .. newDelay .. "ms"
    else
        delayInput.Text = tostring(config.delay)
    end
end)

-- Keybind handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == config.keybind then
        isHoldingKey = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == config.keybind then
        isHoldingKey = false
        currentTarget = nil
    end
end)

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 5)
corner.Parent = mainFrame

-- Start the triggerbot if enabled
if config.enabled then
    startTriggerbot()
end

-- Notification
local function notify(message)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 200, 0, 30)
    notification.Position = UDim2.new(0.5, -100, 0, 50)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notification.BackgroundTransparency = 0.2
    notification.BorderSizePixel = 1
    notification.BorderColor3 = Color3.fromRGB(255, 100, 0)
    notification.Text = message
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.Font = Enum.Font.SourceSans
    notification.TextSize = 14
    notification.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = notification
    
    game:GetService("TweenService"):Create(notification, TweenInfo.new(3), {Position = UDim2.new(0.5, -100, 0, 100), TextTransparency = 1}):Play()
    game.Debris:AddItem(notification, 3)
end

notify("TriggerBot loaded! Hold " .. config.keybind.Name .. " to activate")
print("TriggerBot Script Loaded Successfully")
