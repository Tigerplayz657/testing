-- Simple ESP Script
-- Red color for players with 💢 in their name

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ESP = {}
ESP.Enabled = true
ESP.Objects = {}

function ESP:GetColor(player)
    -- Debug: Print the actual name values
    print("Player Name: '" .. player.Name .. "'")
    print("Player DisplayName: '" .. player.DisplayName .. "'")
    
    -- Check if player has 💢 in their DisplayName or Name
    local hasEmojiInName = player.Name:find("💢") ~= nil
    local hasEmojiInDisplayName = player.DisplayName:find("💢") ~= nil
    
    print("Has 💢 in Name: " .. tostring(hasEmojiInName))
    print("Has 💢 in DisplayName: " .. tostring(hasEmojiInDisplayName))
    
    if hasEmojiInDisplayName or hasEmojiInName then
        print("Setting RED color for: " .. player.DisplayName)
        return Color3.new(1, 0, 0) -- Red
    else
        print("Setting GREEN color for: " .. player.DisplayName)
        return Color3.new(0, 1, 0) -- Green (default)
    end
end

function ESP:CreateESP(player)
    local character = player.Character
    if not character then return end
    
    -- Remove existing ESP for this player
    if ESP.Objects[player] then
        for _, obj in pairs(ESP.Objects[player]) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
    end
    
    ESP.Objects[player] = {}
    local color = self:GetColor(player)
    
    -- Create boxes for body parts
    local parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg"}
    
    for _, partName in pairs(parts) do
        local part = character:FindFirstChild(partName)
        if part then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
            box.Color3 = color
            box.Transparency = 0.3
            box.ZIndex = 10
            box.AlwaysOnTop = true
            box.Adornee = part
            box.Parent = character
            table.insert(ESP.Objects[player], box)
        end
    end
    
    -- Create name tag
    local head = character:FindFirstChild("Head")
    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard
        
        table.insert(ESP.Objects[player], billboard)
    end
end

function ESP:RemoveESP(player)
    if ESP.Objects[player] then
        for _, obj in pairs(ESP.Objects[player]) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        ESP.Objects[player] = nil
    end
end

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESP.Enabled then
            ESP:CreateESP(player)
        end
    end)
    
    -- Update ESP when player respawns
    player.CharacterAdded:Connect(function()
        wait(0.1) -- Wait for character to load
        if ESP.Enabled then
            ESP:CreateESP(player)
        end
    end)
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    ESP:RemoveESP(player)
end)

-- Update ESP colors in case name changes
RunService.Heartbeat:Connect(function()
    if not ESP.Enabled then return end
    
    for player, objects in pairs(ESP.Objects) do
        if player and player.Parent == Players then
            local newColor = ESP:GetColor(player)
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    if obj:IsA("BoxHandleAdornment") then
                        obj.Color3 = newColor
                    elseif obj:IsA("BillboardGui") then
                        local label = obj:FindFirstChildWhichIsA("TextLabel")
                        if label then
                            label.TextColor3 = newColor
                        end
                    end
                end
            end
        end
    end
end)

-- Create ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        ESP:CreateESP(player)
    end
end

-- Toggle ESP with F key
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        ESP.Enabled = not ESP.Enabled
        if ESP.Enabled then
            -- Enable ESP for all players
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    ESP:CreateESP(player)
                end
            end
        else
            -- Disable ESP for all players
            for player in pairs(ESP.Objects) do
                ESP:RemoveESP(player)
            end
        end
    end
end)

print("ESP Script Loaded! Press F to toggle ESP")
print("Players with 💢 in their name will have RED ESP")
print("Other players will have GREEN ESP")
