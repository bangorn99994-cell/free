-- ESP Script สำหรับ Delta Run
-- วางใน LocalScript ภายใน StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ตั้งค่าสำหรับ Delta Run
local ESP_ENABLED = true
local ESP_COLOR = Color3.fromRGB(255, 0, 0)  -- สีแดง
local ESP_TRANSPARENCY = 0.7

-- ฟังก์ชันสร้าง ESP สำหรับผู้เล่น
local function createPlayerESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then
        player.CharacterAdded:Wait()
        character = player.Character
    end
    
    -- สร้าง Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "DeltaRunESP"
    highlight.Adornee = character
    highlight.OutlineColor = ESP_COLOR
    highlight.FillColor = ESP_COLOR
    highlight.FillTransparency = ESP_TRANSPARENCY
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    -- สร้าง BillboardGui สำหรับแสดงชื่อ
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DeltaRunESPInfo"
    billboard.Adornee = character:WaitForChild("Head")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = ESP_COLOR
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = ESP_COLOR
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = billboard
    
    billboard.Parent = character
    
    -- อัพเดทระยะทาง
    local function updateDistance()
        if character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            local localHead = LocalPlayer.Character.Head
            local targetHead = character:FindFirstChild("Head")
            if targetHead then
                local distance = (localHead.Position - targetHead.Position).Magnitude
                distanceLabel.Text = string.format("%.1m", distance)
            end
        end
    end
    
    -- Connection สำหรับอัพเดทระยะทาง
    local distanceConnection
    distanceConnection = RunService.Heartbeat:Connect(function()
        if character and character.Parent then
            updateDistance()
        else
            distanceConnection:Disconnect()
        end
    end)
end

-- ฟังก์ชันสร้าง ESP สำหรับ NPC/ศัตรูใน Delta Run
local function createNPCESP(npc)
    if npc:FindFirstChild("Humanoid") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "DeltaRunNPCESP"
        highlight.Adornee = npc
        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)  -- สีเขียวสำหรับ NPC
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.FillTransparency = 0.8
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = npc
    end
end

-- ฟังก์ชันลบ ESP
local function removeESP(character)
    local esp = character:FindFirstChild("DeltaRunESP")
    local espInfo = character:FindFirstChild("DeltaRunESPInfo")
    
    if esp then esp:Destroy() end
    if espInfo then espInfo:Destroy() end
end

-- เริ่มต้นระบบ ESP
local function initializeESP()
    if not ESP_ENABLED then return end
    
    -- สร้าง ESP สำหรับผู้เล่นที่มีอยู่แล้ว
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            coroutine.wrap(createPlayerESP)(player)
        end
    end
    
    -- สร้าง ESP สำหรับผู้เล่นใหม่
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function(character)
                createPlayerESP(player)
            end)
        end
    end)
    
    -- สร้าง ESP สำหรับ NPC ที่มีอยู่แล้ว
    for _, npc in ipairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
            createNPCESP(npc)
        end
    end
    
    -- สร้าง ESP สำหรับ NPC ใหม่
    workspace.ChildAdded:Connect(function(child)
        if child:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(child) then
            wait(1) -- รอให้โหลดเสร็จ
            createNPCESP(child)
        end
    end)
    
    -- ลบ ESP เมื่อผู้เล่นออก
    Players.PlayerRemoving:Connect(function(player)
        local character = player.Character
        if character then
            removeESP(character)
        end
    end)
end

-- เริ่มต้นระบบ
if LocalPlayer.Character then
    initializeESP()
else
    LocalPlayer.CharacterAdded:Connect(initializeESP)
end

-- ปุ่มเปิด-ปิด ESP (กด F)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        ESP_ENABLED = not ESP_ENABLED
        
        if ESP_ENABLED then
            initializeESP()
        else
            -- ลบ ESP ทั้งหมด
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    removeESP(player.Character)
                end
            end
            for _, npc in ipairs(workspace:GetChildren()) do
                if npc:FindFirstChild("Humanoid") then
                    removeESP(npc)
                end
            end
        end
    end
end)

print("Delta Run ESP โหลดสำเร็จ! กด F เพื่อเปิด/ปิด ESP")
