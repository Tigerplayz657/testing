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

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Visible = true

local function makeButton(text, posY)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    return btn
end

-- Buttons
local espToggle = makeButton("ESP: OFF", 10)
local xrayToggle = makeButton("X-Ray: OFF", 50)
local nameToggle = makeButton("Names: OFF", 90)
local healthToggle = makeButton("Healthbars: OFF", 130)

-- States
local ESP_ENABLED = false
local XRAY = false
local SHOW_NAMES = false
local SHOW_HEALTH = false

-- Menu is always visible

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

    -- Health bar
    if SHOW_HEALTH and ESP_ENABLED then
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")

        if humanoid and head then
            local bar = head:FindFirstChild("HealthBar")
            if not bar then
                bar = Instance.new("BillboardGui", head)
                bar.Name = "HealthBar"
                bar.Size = UDim2.new(0,6,0,60)
                bar.StudsOffset = Vector3.new(0,3.5,0)
                bar.AlwaysOnTop = true

                -- Background track
                local bg = Instance.new("Frame", bar)
                bg.Name = "Background"
                bg.Size = UDim2.new(1,0,1,0)
                bg.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
                bg.BorderSizePixel = 0
                bg.Position = UDim2.new(0,0,0,0)
                
                -- Health bar with rounded corners effect
                local hp = Instance.new("Frame", bg)
                hp.Name = "HP"
                hp.Size = UDim2.new(1,0,1,0)
                hp.BackgroundColor3 = Color3.new(0,1,0)
                hp.BorderSizePixel = 0
                hp.Position = UDim2.new(0,0,1,0)
                hp.AnchorPoint = Vector2.new(0,1)

                -- Glow effect (outer frame)
                local glow = Instance.new("Frame", bg)
                glow.Name = "Glow"
                glow.Size = UDim2.new(1.2,0,1,0)
                glow.BackgroundColor3 = Color3.new(0,0,0)
                glow.BackgroundTransparency = 0.8
                glow.BorderSizePixel = 0
                glow.Position = UDim2.new(-0.1,0,0,0)
                glow.ZIndex = hp.ZIndex - 1

                -- Health text
                local text = Instance.new("TextLabel", bg)
                text.Name = "HealthText"
                text.Size = UDim2.new(1,0,0,12)
                text.Position = UDim2.new(0,0,-0.2,0)
                text.BackgroundTransparency = 1
                text.TextColor3 = Color3.new(1,1,1)
                text.TextStrokeTransparency = 0.3
                text.TextStrokeColor3 = Color3.new(0,0,0)
                text.Font = Enum.Font.SourceSansBold
                text.TextSize = 10
                text.Text = "100/100"
                text.ZIndex = hp.ZIndex + 1

                -- Smooth animation
                local tweenService = game:GetService("TweenService")
                local lastHealth = humanoid.Health

                RunService.RenderStepped:Connect(function()
                    if humanoid and humanoid.Parent and hp and hp.Parent then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        local currentHealth = math.floor(humanoid.Health)
                        local maxHealth = math.floor(humanoid.MaxHealth)
                        
                        -- Update health text
                        if text then
                            text.Text = currentHealth .. "/" .. maxHealth
                        end
                        
                        -- Gradient colors based on health
                        local healthColor
                        if healthPercent > 0.6 then
                            healthColor = Color3.new(0,1,0) -- Green
                        elseif healthPercent > 0.3 then
                            healthColor = Color3.new(1,1,0) -- Yellow
                        else
                            healthColor = Color3.new(1,0,0) -- Red
                        end
                        
                        -- Smooth color transition
                        local colorTween = tweenService:Create(hp, TweenInfo.new(0.3), {BackgroundColor3 = healthColor})
                        colorTween:Play()
                        
                        -- Smooth size animation
                        local targetSize = math.clamp(healthPercent, 0, 1)
                        local sizeTween = tweenService:Create(hp, TweenInfo.new(0.2), {Size = UDim2.new(1,0, targetSize, 0)})
                        sizeTween:Play()
                        
                        -- Update glow color to match health
                        if glow then
                            glow.BackgroundColor3 = healthColor
                            glow.BackgroundTransparency = 0.9 - (healthPercent * 0.3) -- More visible when low health
                        end
                    end
                end)
            end
        end
    else
        local head = character:FindFirstChild("Head")
        if head then
            local bar = head:FindFirstChild("HealthBar")
            if bar then bar:Destroy() end
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

healthToggle.MouseButton1Click:Connect(function()
    SHOW_HEALTH = not SHOW_HEALTH
    healthToggle.Text = "Healthbars: " .. (SHOW_HEALTH and "ON" or "OFF")
    updateESP()
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
