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
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(100, 100, 120)
frame.Visible = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Left sidebar for categories
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 150, 1, -40)
sidebar.Position = UDim2.new(0, 10, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
sidebar.BorderSizePixel = 1
sidebar.BorderColor3 = Color3.fromRGB(80, 80, 100)

-- Category buttons in sidebar
local espCategory = Instance.new("TextButton", sidebar)
espCategory.Size = UDim2.new(1, -20, 0, 50)
espCategory.Position = UDim2.new(0, 10, 0, 20)
espCategory.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
espCategory.BorderSizePixel = 1
espCategory.BorderColor3 = Color3.fromRGB(120, 120, 140)
espCategory.Text = "ESP"
espCategory.TextColor3 = Color3.new(1,1,1)
espCategory.Font = Enum.Font.SourceSansBold
espCategory.TextSize = 18

local trollCategory = Instance.new("TextButton", sidebar)
trollCategory.Size = UDim2.new(1, -20, 0, 50)
trollCategory.Position = UDim2.new(0, 10, 0, 80)
trollCategory.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
trollCategory.BorderSizePixel = 1
trollCategory.BorderColor3 = Color3.fromRGB(100, 100, 120)
trollCategory.Text = "TROLL"
trollCategory.TextColor3 = Color3.new(1,1,1)
trollCategory.Font = Enum.Font.SourceSansBold
trollCategory.TextSize = 18

-- Content area
local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(0, 420, 1, -40)
contentFrame.Position = UDim2.new(0, 170, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.BorderSizePixel = 1
contentFrame.BorderColor3 = Color3.fromRGB(90, 90, 110)

-- Content frames
local espContent = Instance.new("ScrollingFrame", contentFrame)
espContent.Size = UDim2.new(1, -20, 1, -20)
espContent.Position = UDim2.new(0, 10, 0, 10)
espContent.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
espContent.BorderSizePixel = 1
espContent.BorderColor3 = Color3.fromRGB(70, 70, 90)
espContent.ScrollBarThickness = 8
espContent.Visible = true

local trollContent = Instance.new("ScrollingFrame", contentFrame)
trollContent.Size = UDim2.new(1, -20, 1, -20)
trollContent.Position = UDim2.new(0, 10, 0, 10)
trollContent.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
trollContent.BorderSizePixel = 1
trollContent.BorderColor3 = Color3.fromRGB(70, 70, 90)
trollContent.ScrollBarThickness = 8
trollContent.Visible = false

-- ESP Buttons
local espToggle = makeModernButton("ESP: OFF", espContent, 10)
local xrayToggle = makeModernButton("X-Ray: OFF", espContent, 65)
local nameToggle = makeModernButton("Names: OFF", espContent, 120)

-- Trolling Buttons
local followToggle = makeModernButton("Follow Player: OFF", trollContent, 10)
local targetLabel = makeModernButton("Target: None", trollContent, 65)
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
    espCategory.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    trollCategory.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
end)

trollCategory.MouseButton1Click:Connect(function()
    espContent.Visible = false
    trollContent.Visible = true
    trollCategory.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    espCategory.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
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
