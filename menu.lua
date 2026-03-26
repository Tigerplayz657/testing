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

local combatCategory = Instance.new("TextButton", sidebar)
combatCategory.Size = UDim2.new(1, -20, 0, 50)
combatCategory.Position = UDim2.new(0, 10, 0, 80)
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
espContent.CanvasSize = UDim2.new(0, 0, 0, 230)

local combatContent = Instance.new("ScrollingFrame", contentFrame)
combatContent.Size = UDim2.new(1, -20, 1, -20)
combatContent.Position = UDim2.new(0, 10, 0, 10)
combatContent.BackgroundColor3 = Color3.fromRGB(25, 12, 0)
combatContent.BackgroundTransparency = 0.2
combatContent.BorderSizePixel = 1
combatContent.BorderColor3 = Color3.fromRGB(255, 60, 0)
combatContent.ScrollBarThickness = 8
combatContent.Visible = false
combatContent.CanvasSize = UDim2.new(0, 0, 0, 350)

-- Combat Buttons
local function makeModernButton(text, parent, yPos)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 40)
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
local teamDetectBtn = makeModernButton("Detect Teams", espContent, 175)

-- Combat Buttons
local rangeLabel = makeModernButton("Range: 200 studs", combatContent, 10)
rangeLabel.TextColor3 = Color3.fromRGB(200,200,200)
local accuracyLabel = makeModernButton("Hit Chance: 80%", combatContent, 65)
accuracyLabel.TextColor3 = Color3.fromRGB(200,200,200)
local bloomLabel = makeModernButton("Bloom: 0.1", combatContent, 120)
bloomLabel.TextColor3 = Color3.fromRGB(200,200,200)
local targetLabel = makeModernButton("Target: Head", combatContent, 175)
targetLabel.TextColor3 = Color3.fromRGB(200,200,200)

-- States
local ESP_ENABLED = false
local XRAY = false
local SHOW_NAMES = false

-- Category switching
espCategory.MouseButton1Click:Connect(function()
    espContent.Visible = true
    combatContent.Visible = false
    espCategory.BackgroundColor3 = Color3.fromRGB(60, 30, 0)
    combatCategory.BackgroundColor3 = Color3.fromRGB(25, 12, 0)
end)

combatCategory.MouseButton1Click:Connect(function()
    espContent.Visible = false
    combatContent.Visible = true
    combatCategory.BackgroundColor3 = Color3.fromRGB(60, 30, 0)
    espCategory.BackgroundColor3 = Color3.fromRGB(25, 12, 0)
end)

-- Team color mapping for Prison Life
local TEAM_COLORS = {
    ["Inmate"] = Color3.fromRGB(255, 165, 0),    -- Orange
    ["Guard"] = Color3.fromRGB(0, 100, 255),     -- Blue  
    ["Criminal"] = Color3.fromRGB(255, 0, 0),    -- Red
    ["Neutral"] = Color3.fromRGB(128, 128, 128)  -- Gray
}

-- Get team color for a player
local function getTeamColor(plr)
    local team = plr.Team
    if team and TEAM_COLORS[team.Name] then
        return TEAM_COLORS[team.Name]
    end
    return Color3.fromRGB(255, 255, 255) -- Default white
end

-- ESP FUNCTIONS
local function applyESP(character, plr)
    if not character then return end
    if plr == player then return end

    local teamColor = getTeamColor(plr)

    -- Highlight (X-ray)
    local highlight = character:FindFirstChild("Highlight")
    if XRAY then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.FillColor = teamColor
            highlight.Parent = character
        else
            highlight.FillColor = teamColor
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
                text.TextColor3 = teamColor
                text.TextStrokeTransparency = 0
                text.TextStrokeColor3 = Color3.new(0,0,0)
                text.Font = Enum.Font.SourceSansBold
                text.TextSize = 14
                text.Text = plr.Name
            else
                -- Update existing name tag color
                local textLabel = billboard:FindFirstChildOfClass("TextLabel")
                if textLabel then
                    textLabel.TextColor3 = teamColor
                end
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

-- Team detection button
teamDetectBtn.MouseButton1Click:Connect(function()
    local teamInfo = "=== TEAMS DETECTED ===\n"
    local foundTeams = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Team and not foundTeams[plr.Team.Name] then
            foundTeams[plr.Team.Name] = true
            teamInfo = teamInfo .. plr.Team.Name .. "\n"
        end
    end
    
    -- Print to console for debugging
    print(teamInfo)
    
    -- Also show in a notification if possible
    local hint = Instance.new("Hint", workspace)
    hint.Text = "Team names printed to console (F9)"
    game:GetService("Debris"):AddItem(hint, 3)
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
