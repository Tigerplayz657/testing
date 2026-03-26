local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Function to scan all values on a player
local function scanPlayerValues(plr)
    print("=== Scanning", plr.Name, "===")
    
    -- Scan player object
    for _, child in pairs(plr:GetChildren()) do
        if child:IsA("ValueBase") then
            print("Player." .. child.Name .. ": " .. tostring(child.Value) .. " (" .. child.ClassName .. ")")
        end
    end
    
    -- Scan character if exists
    if plr.Character then
        for _, child in pairs(plr.Character:GetChildren()) do
            if child:IsA("ValueBase") then
                print("Char." .. child.Name .. ": " .. tostring(child.Value) .. " (" .. child.ClassName .. ")")
            end
        end
        
        -- Also scan all descendants (might be nested)
        for _, child in pairs(plr.Character:GetDescendants()) do
            if child:IsA("ValueBase") and not child:IsDescendantOf(plr.Character) then
                print("Descendant." .. child:GetFullName() .. ": " .. tostring(child.Value) .. " (" .. child.ClassName .. ")")
            end
        end
    end
    
    -- Scan backpack for weapon-related values
    local backpack = plr:FindFirstChild("Backpack")
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("ValueBase") then
                print("Backpack." .. child.Name .. ": " .. tostring(child.Value) .. " (" .. child.ClassName .. ")")
            end
        end
    end
    
    -- Check for common arrestable properties directly
    print("--- Common Properties ---")
    print("Team:", plr.Team and plr.Team.Name or "No Team")
    print("Neutral:", plr.Neutral)
    print("CharacterExists:", plr.Character ~= nil)
    
    -- Check for leaderstats
    local leaderstats = plr:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in pairs(leaderstats:GetChildren()) do
            if stat:IsA("ValueBase") then
                print("Stat." .. stat.Name .. ": " .. tostring(stat.Value) .. " (" .. stat.ClassName .. ")")
            end
        end
    end
    
    print("---")
end

-- Function to scan for arrest-related remotes
local function scanRemotes()
    print("=== Scanning for Arrest Remotes ===")
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = string.lower(obj.Name)
            if string.find(name, "arrest") or string.find(name, "crime") or string.find(name, "wanted") or string.find(name, "criminal") then
                print("Found remote:", obj:GetFullName(), "- Type:", obj.ClassName)
            end
        end
    end
    print("---")
end

-- Store initial values to detect changes
local playerValues = {}

-- Function to store current values
local function storePlayerValues(plr)
    playerValues[plr.Name] = {}
    
    -- Store player values
    for _, child in pairs(plr:GetChildren()) do
        if child:IsA("ValueBase") then
            playerValues[plr.Name]["Player_" .. child.Name] = child.Value
        end
    end
    
    -- Store character values
    if plr.Character then
        for _, child in pairs(plr.Character:GetChildren()) do
            if child:IsA("ValueBase") then
                playerValues[plr.Name]["Char_" .. child.Name] = child.Value
            end
        end
    end
end

-- Function to check for hostile/arrestable indicators
local function checkHostileIndicators(plr)
    print("=== Checking hostile indicators for", plr.Name, "===")
    
    -- Check for emoji in name display
    if plr.Character and plr.Character:FindFirstChild("Head") then
        local head = plr.Character.Head
        for _, child in pairs(head:GetChildren()) do
            if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
                for _, textChild in pairs(child:GetChildren()) do
                    if textChild:IsA("TextLabel") then
                        local text = textChild.Text
                        if string.find(text, "💢") then
                            print("FOUND HOSTILE EMOJI in:", child.Name, "Text:", text)
                        end
                        print("TextLabel content:", text)
                    end
                end
            end
        end
    end
    
    -- Check player display name changes
    if plr.DisplayName then
        print("DisplayName:", plr.DisplayName)
        if string.find(plr.DisplayName, "💢") then
            print("FOUND HOSTILE EMOJI in DisplayName!")
        end
    end
    
    -- Check for any UI elements with emoji
    for _, child in pairs(plr:GetChildren()) do
        if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
            for _, textChild in pairs(child:GetChildren()) do
                if textChild:IsA("TextLabel") then
                    local text = textChild.Text
                    if string.find(text, "💢") then
                        print("FOUND HOSTILE EMOJI in player UI:", child.Name, "Text:", text)
                    end
                end
            end
        end
    end
    
    print("---")
end

-- Initial scan and store values
print("=== STORING INITIAL VALUES ===")
for _, plr in pairs(Players:GetPlayers()) do
    scanPlayerValues(plr)
    storePlayerValues(plr)
end

-- Scan for remotes
scanRemotes()

-- Watch for hostile indicators continuously
spawn(function()
    while true do
        for _, plr in pairs(Players:GetPlayers()) do
            checkHostileIndicators(plr)
        end
        task.wait(1) -- Check every second
    end
end)

-- Watch for new players
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        scanPlayerValues(plr)
        storePlayerValues(plr)
    end)
end)

-- Instructions
print("=== AUTO-DETECTION ACTIVE ===")
print("Now watching for value changes...")
print("Make an inmate commit a crime and watch for CHANGED messages!")
print("=== READY ===")
