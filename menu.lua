local Players = game:GetService("Players")
local player = Players.LocalPlayer or game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- UI SETUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheaterMenu"
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Main frame with modern design
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BorderSizePixel = 0
frame.Visible = true

-- Add shadow effect
local shadow = Instance.new("Frame", frame)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, 5, 0, 5)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.8
shadow.BorderSizePixel = 0
shadow.ZIndex = frame.ZIndex - 1

-- Title bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(25,25,35)
titleBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎮 ESP MENU"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- Category buttons
local categoryFrame = Instance.new("Frame", frame)
categoryFrame.Size = UDim2.new(1, -20, 0, 50)
categoryFrame.Position = UDim2.new(0, 10, 0, 50)
categoryFrame.BackgroundTransparency = 1

local espCategory = Instance.new("TextButton", categoryFrame)
espCategory.Size = UDim2.new(0, 70, 1, 0)
espCategory.Position = UDim2.new(0, 0, 0, 0)
espCategory.BackgroundColor3 = Color3.fromRGB(40,40,50)
espCategory.BorderSizePixel = 0
espCategory.Text = "ESP"
espCategory.TextColor3 = Color3.new(1,1,1)
espCategory.Font = Enum.Font.Gotham

local trollCategory = Instance.new("TextButton", categoryFrame)
trollCategory.Size = UDim2.new(0, 70, 1, 0)
trollCategory.Position = UDim2.new(0, 80, 0, 0)
trollCategory.BackgroundColor3 = Color3.fromRGB(30,30,40)
trollCategory.BorderSizePixel = 0
trollCategory.Text = "TROLL"
trollCategory.TextColor3 = Color3.new(1,1,1)
trollCategory.Font = Enum.Font.Gotham

-- Content frames
local espContent = Instance.new("ScrollingFrame", frame)
espContent.Size = UDim2.new(1, -20, 1, -120)
espContent.Position = UDim2.new(0, 10, 0, 110)
espContent.BackgroundColor3 = Color3.fromRGB(20,20,25)
espContent.BorderSizePixel = 0
espContent.ScrollBarThickness = 4
espContent.Visible = true

local trollContent = Instance.new("ScrollingFrame", frame)
trollContent.Size = UDim2.new(1, -20, 1, -120)
trollContent.Position = UDim2.new(0, 10, 0, 110)
trollContent.BackgroundColor3 = Color3.fromRGB(20,20,25)
trollContent.BorderSizePixel = 0
trollContent.ScrollBarThickness = 4
trollContent.Visible = false

local function makeModernButton(text, parent, yPos)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,45)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(45,45,55)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35,35,45)
    end)
    
    return btn
end

-- ESP Buttons
local espToggle = makeModernButton("🔍 ESP: OFF", espContent, 10)
local xrayToggle = makeModernButton("💀 X-Ray: OFF", espContent, 55)
local nameToggle = makeModernButton("📝 Names: OFF", espContent, 100)

-- Trolling Buttons
local followToggle = makeModernButton("👥 Follow Player: OFF", trollContent, 10)
local targetLabel = makeModernButton("Target: None", trollContent, 55)
targetLabel.TextColor3 = Color3.fromRGB(150,150,150)

-- States
local ESP_ENABLED = false
local XRAY = false
local SHOW_NAMES = false
local FOLLOWING = false
local TARGET_PLAYER = nil

-- Category switching
espCategory.MouseButton1Click:Connect(function()
    espContent.Visible = true
    trollContent.Visible = false
    espCategory.BackgroundColor3 = Color3.fromRGB(40,40,50)
    trollCategory.BackgroundColor3 = Color3.fromRGB(30,30,40)
end)

trollCategory.MouseButton1Click:Connect(function()
    espContent.Visible = false
    trollContent.Visible = true
    trollCategory.BackgroundColor3 = Color3.fromRGB(40,40,50)
    espCategory.BackgroundColor3 = Color3.fromRGB(30,30,40)
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
    followToggle.Text = "👥 Follow Player: ON"
    
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
            followToggle.Text = "👥 Follow Player: OFF"
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
    followToggle.Text = "👥 Follow Player: OFF"
end

-- Button logic
espToggle.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    espToggle.Text = "🔍 ESP: " .. (ESP_ENABLED and "ON" or "OFF")
    updateESP()
end)

xrayToggle.MouseButton1Click:Connect(function()
    XRAY = not XRAY
    xrayToggle.Text = "💀 X-Ray: " .. (XRAY and "ON" or "OFF")
    updateESP()
end)

nameToggle.MouseButton1Click:Connect(function()
    SHOW_NAMES = not SHOW_NAMES
    nameToggle.Text = "📝 Names: " .. (SHOW_NAMES and "ON" or "OFF")
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
