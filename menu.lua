local Players = game:GetService("Players")
local player = Players.LocalPlayer or game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- UI SETUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XenuMenu"
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Main frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 600, 0, 350)
frame.Position = UDim2.new(0.5, -300, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(255, 140, 0)
frame.Visible = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Active = true

-- Close button
local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.BackgroundTransparency = 0.1
closeButton.BorderSizePixel = 2
closeButton.BorderColor3 = Color3.fromRGB(255, 100, 0)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.ZIndex = 10

local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(0, 8)

-- Reopen button (hidden initially)
local reopenButton = Instance.new("TextButton", screenGui)
reopenButton.Size = UDim2.new(0, 100, 0, 30)
reopenButton.Position = UDim2.new(1, -110, 0, 10)
reopenButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
reopenButton.BackgroundTransparency = 0.2
reopenButton.BorderSizePixel = 1
reopenButton.BorderColor3 = Color3.fromRGB(255, 100, 0)
reopenButton.Text = "Open Menu"
reopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenButton.Font = Enum.Font.SourceSansBold
reopenButton.TextSize = 14
reopenButton.Visible = false
reopenButton.ZIndex = 10

-- Dragging variables
local dragging = false
local dragStart = nil
local startPos = nil

-- Drag functionality
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    reopenButton.Visible = true
end)

-- Reopen button functionality
reopenButton.MouseButton1Click:Connect(function()
    frame.Visible = true
    reopenButton.Visible = false
end)

-- Left sidebar for categories
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 150, 1, -40)
sidebar.Position = UDim2.new(0, 10, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 10, 0)
sidebar.BackgroundTransparency = 0.2
sidebar.BorderSizePixel = 1
sidebar.BorderColor3 = Color3.fromRGB(255, 120, 0)

-- Category buttons in sidebar
local espCategory = Instance.new("TextButton", sidebar)
espCategory.Size = UDim2.new(1, -20, 0, 50)
espCategory.Position = UDim2.new(0, 10, 0, 20)
espCategory.BackgroundColor3 = Color3.fromRGB(40, 20, 0)
espCategory.BackgroundTransparency = 0.2
espCategory.BorderSizePixel = 1
espCategory.BorderColor3 = Color3.fromRGB(255, 100, 0)
espCategory.Text = "ESP"
espCategory.TextColor3 = Color3.fromRGB(255, 200, 100)
espCategory.Font = Enum.Font.SourceSansBold
espCategory.TextSize = 18

local trollCategory = Instance.new("TextButton", sidebar)
trollCategory.Size = UDim2.new(1, -20, 0, 50)
trollCategory.Position = UDim2.new(0, 10, 0, 80)
trollCategory.BackgroundColor3 = Color3.fromRGB(30, 15, 0)
trollCategory.BackgroundTransparency = 0.2
trollCategory.BorderSizePixel = 1
trollCategory.BorderColor3 = Color3.fromRGB(255, 100, 0)
trollCategory.Text = "TROLL"
trollCategory.TextColor3 = Color3.fromRGB(255, 200, 100)
trollCategory.Font = Enum.Font.SourceSansBold
trollCategory.TextSize = 18

local combatCategory = Instance.new("TextButton", sidebar)
combatCategory.Size = UDim2.new(1, -20, 0, 50)
combatCategory.Position = UDim2.new(0, 10, 0, 140)
combatCategory.BackgroundColor3 = Color3.fromRGB(25, 12, 0)
combatCategory.BackgroundTransparency = 0.2
combatCategory.BorderSizePixel = 1
combatCategory.BorderColor3 = Color3.fromRGB(255, 100, 0)
combatCategory.Text = "COMBAT"
combatCategory.TextColor3 = Color3.fromRGB(255, 200, 100)
combatCategory.Font = Enum.Font.SourceSansBold
combatCategory.TextSize = 18

-- Content area
local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(0, 420, 1, -40)
contentFrame.Position = UDim2.new(0, 170, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 0)
contentFrame.BackgroundTransparency = 0.2
contentFrame.BorderSizePixel = 1
contentFrame.BorderColor3 = Color3.fromRGB(255, 80, 0)

-- Content frames
local espContent = Instance.new("ScrollingFrame", contentFrame)
espContent.Size = UDim2.new(1, -20, 1, -20)
espContent.Position = UDim2.new(0, 10, 0, 10)
espContent.BackgroundColor3 = Color3.fromRGB(25, 12, 0)
espContent.BackgroundTransparency = 0.2
espContent.BorderSizePixel = 1
espContent.BorderColor3 = Color3.fromRGB(255, 60, 0)
espContent.ScrollBarThickness = 8
espContent.Visible = true
espContent.CanvasSize = UDim2.new(0, 0, 0, 200)

local trollContent = Instance.new("ScrollingFrame", contentFrame)
trollContent.Size = UDim2.new(1, -20, 1, -20)
trollContent.Position = UDim2.new(0, 10, 0, 10)
trollContent.BackgroundColor3 = Color3.fromRGB(25, 12, 0)
trollContent.BackgroundTransparency = 0.2
trollContent.BorderSizePixel = 1
trollContent.BorderColor3 = Color3.fromRGB(255, 60, 0)
trollContent.ScrollBarThickness = 8
trollContent.Visible = false
trollContent.CanvasSize = UDim2.new(0, 0, 0, 150)

local combatContent = Instance.new("ScrollingFrame", contentFrame)
combatContent.Size = UDim2.new(1, -20, 1, -20)
combatContent.Position = UDim2.new(0, 10, 0, 10)
combatContent.BackgroundColor3 = Color3.fromRGB(25, 12, 0)
combatContent.BackgroundTransparency = 0.2
combatContent.BorderSizePixel = 1
combatContent.BorderColor3 = Color3.fromRGB(255, 60, 0)
combatContent.ScrollBarThickness = 8
combatContent.Visible = false
combatContent.CanvasSize = UDim2.new(0, 0, 0, 200)

local function makeModernButton(text, parent, yPos)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 18, 0)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 40, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 180, 80)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 30, 0)
        btn.BackgroundTransparency = 0.1
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 18, 0)
        btn.BackgroundTransparency = 0.2
    end)
    
    return btn
end

-- ESP Buttons
local espToggle = makeModernButton("ESP: OFF", espContent, 10)
local xrayToggle = makeModernButton("X-Ray: OFF", espContent, 65)
local nameToggle = makeModernButton("Names: OFF", espContent, 120)

-- Trolling Buttons
local followToggle = makeModernButton("Follow Player: OFF", trollContent, 10)
local targetLabel = makeModernButton("Target: None", trollContent, 65)
targetLabel.TextColor3 = Color3.fromRGB(150,150,150)

-- Combat Buttons
local triggerbotToggle = makeModernButton("TriggerBot: OFF", combatContent, 10)
local delayLabel = makeModernButton("Delay: 50ms", combatContent, 65)
delayLabel.TextColor3 = Color3.fromRGB(200,200,200)

-- Delay input
local delayInput = Instance.new("TextBox", combatContent)
delayInput.Size = UDim2.new(0, 80, 0, 30)
delayInput.Position = UDim2.new(0, 10, 0, 120)
delayInput.BackgroundColor3 = Color3.fromRGB(30, 15, 0)
delayInput.BackgroundTransparency = 0.2
delayInput.BorderSizePixel = 1
delayInput.BorderColor3 = Color3.fromRGB(255, 80, 0)
delayInput.Text = "50"
delayInput.TextColor3 = Color3.fromRGB(255, 200, 100)
delayInput.Font = Enum.Font.SourceSans
delayInput.TextSize = 14
delayInput.PlaceholderText = "Delay (ms)"

-- Update delay when input changes
delayInput.FocusLost:Connect(function()
    local newDelay = tonumber(delayInput.Text)
    if newDelay and newDelay >= 0 and newDelay <= 1000 then
        TRIGGER_DELAY = newDelay
        delayLabel.Text = "Delay: " .. newDelay .. "ms"
    end
end)

-- Triggerbot functionality
local triggerbotConnection
local function startTriggerbot()
    if TRIGGERBOT_ENABLED and triggerbotConnection then
        triggerbotConnection:Disconnect()
        triggerbotConnection = nil
    end
    
    TRIGGERBOT_ENABLED = true
    triggerbotToggle.Text = "TriggerBot: ON"
    
    triggerbotConnection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character:FindFirstChild("Humanoid"):Activate()
                task.wait(TRIGGER_DELAY / 1000)
            end
        end
    end)
end

local function stopTriggerbot()
    if triggerbotConnection then
        triggerbotConnection:Disconnect()
        triggerbotConnection = nil
    end
    TRIGGERBOT_ENABLED = false
    triggerbotToggle.Text = "TriggerBot: OFF"
end

-- States
local ESP_ENABLED = false
local XRAY = false
local SHOW_NAMES = false
local FOLLOWING = false
local TARGET_PLAYER = nil
local TRIGGERBOT_ENABLED = false
local TRIGGER_DELAY = 50

-- Category switching
espCategory.MouseButton1Click:Connect(function()
    espContent.Visible = true
    trollContent.Visible = false
    combatContent.Visible = false
    espCategory.BackgroundColor3 = Color3.fromRGB(60, 30, 0)
    trollCategory.BackgroundColor3 = Color3.fromRGB(30, 15, 0)
    combatCategory.BackgroundColor3 = Color3.fromRGB(25, 12, 0)
end)

trollCategory.MouseButton1Click:Connect(function()
    espContent.Visible = false
    trollContent.Visible = true
    combatContent.Visible = false
    trollCategory.BackgroundColor3 = Color3.fromRGB(60, 30, 0)
    espCategory.BackgroundColor3 = Color3.fromRGB(30, 15, 0)
    combatCategory.BackgroundColor3 = Color3.fromRGB(25, 12, 0)
end)

combatCategory.MouseButton1Click:Connect(function()
    espContent.Visible = false
    trollContent.Visible = false
    combatContent.Visible = true
    combatCategory.BackgroundColor3 = Color3.fromRGB(60, 30, 0)
    espCategory.BackgroundColor3 = Color3.fromRGB(30, 15, 0)
    trollCategory.BackgroundColor3 = Color3.fromRGB(25, 12, 0)
end)

-- ESP FUNCTIONS
local function applyESP(character, plr)
    if not character then return end
    if plr == player then return end

    -- Highlight (X-ray)
    local highlight = character:FindFirstChild("Highlight")
    if XRAY then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.Parent = character
        end
        highlight.Enabled = ESP_ENABLED
    else
        if highlight then highlight:Destroy() end
    end

    -- Name
    local head = character:FindFirstChild("Head")
    if head then
        local billboard = head:FindFirstChild("NameTag")
        if SHOW_NAMES and ESP_ENABLED then
            if not billboard then
                billboard = Instance.new("BillboardGui", head)
                billboard.Name = "NameTag"
                billboard.Size = UDim2.new(0,100,0,25)
                billboard.StudsOffset = Vector3.new(0,2.5,0)
                billboard.AlwaysOnTop = true

                local text = Instance.new("TextLabel", billboard)
                text.Size = UDim2.new(1,0,1,0)
                text.BackgroundTransparency = 1
                text.TextColor3 = Color3.new(1,1,1)
                text.TextStrokeTransparency = 0
                text.TextStrokeColor3 = Color3.new(0,0,0)
                text.Font = Enum.Font.SourceSansBold
                text.TextSize = 14
                text.Text = plr.Name
            end
        else
            if billboard then billboard:Destroy() end
        end
    end
end

-- Loop through players
local function updateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            applyESP(plr.Character, plr)
        end
    end
end

-- Follow player function
local followConnection
local function startFollowing(target)
    if FOLLOWING and followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    
    FOLLOWING = true
    TARGET_PLAYER = target
    targetLabel.Text = "Target: " .. target.Name
    followToggle.Text = "Follow Player: ON"
    
    followConnection = RunService.Heartbeat:Connect(function()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 3)
                player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            end
        else
            -- Target left/disconnected
            FOLLOWING = false
            TARGET_PLAYER = nil
            targetLabel.Text = "Target: None"
            followToggle.Text = "Follow Player: OFF"
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
        end
    end)
end

local function stopFollowing()
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    FOLLOWING = false
    TARGET_PLAYER = nil
    targetLabel.Text = "Target: None"
    followToggle.Text = "Follow Player: OFF"
end

-- Button logic
espToggle.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    espToggle.Text = "ESP: " .. (ESP_ENABLED and "ON" or "OFF")
    updateESP()
end)

xrayToggle.MouseButton1Click:Connect(function()
    XRAY = not XRAY
    xrayToggle.Text = "X-Ray: " .. (XRAY and "ON" or "OFF")
    updateESP()
end)

nameToggle.MouseButton1Click:Connect(function()
    SHOW_NAMES = not SHOW_NAMES
    nameToggle.Text = "Names: " .. (SHOW_NAMES and "ON" or "OFF")
    updateESP()
end)

followToggle.MouseButton1Click:Connect(function()
    if FOLLOWING then
        stopFollowing()
    else
        -- Find closest player to follow
        local closestPlayer = nil
        local closestDistance = math.huge
        
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = plr
                end
            end
        end
        
        if closestPlayer then
            startFollowing(closestPlayer)
        end
    end
end)

triggerbotToggle.MouseButton1Click:Connect(function()
    if TRIGGERBOT_ENABLED then
        stopTriggerbot()
    else
        startTriggerbot()
    end
end)

-- Auto apply when players spawn
Players.PlayerAdded:Connect(function(plr)
    if plr and plr.Character then
        applyESP(plr.Character, plr)
    end
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if char then
            applyESP(char, plr)
        end
    end)
end)

-- Initial update
updateESP()
