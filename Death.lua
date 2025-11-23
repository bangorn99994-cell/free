-- Delta Run ESP with Headshot Focus
-- วางใน LocalScript ภายใน StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ตั้งค่า ESP
local ESP_ENABLED = true
local HEADSHOT_MODE = true

-- สีสำหรับ ESP
local COLORS = {
    ENEMY_PLAYER = Color3.fromRGB(255, 0, 0),      -- สีแดงสำหรับศัตรู
    ENEMY_HEAD = Color3.fromRGB(255, 100, 100),    -- สีแดงอ่อนสำหรับหัว
    TEAM_PLAYER = Color3.fromRGB(0, 0, 255),       -- สีน้ำเงินสำหรับทีมเดียวกัน
    TEAM_HEAD = Color3.fromRGB(100, 100, 255),     -- สีน้ำเงินอ่อนสำหรับหัว
    NPC = Color3.fromRGB(0, 255, 0),               -- สีเขียวสำหรับ NPC
    NPC_HEAD = Color3.fromRGB(100, 255, 100)       -- สีเขียวอ่อนสำหรับหัว NPC
}

-- เก็บข้อมูล ESP
local espObjects = {}

-- ฟังก์ชันตรวจสอบทีม
local function isEnemy(player)
    if not LocalPlayer.Team then return true end
    if not player.Team then return true end
    return LocalPlayer.Team ~= player.Team
end

-- ฟังก์ชันสร้าง Head ESP (โฟกัสที่หัว)
local function createHeadESP(character, isNPC)
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not head then return end
    
    -- สร้าง ESP สำหรับหัว
    local headHighlight = Instance.new("Highlight")
    headHighlight.Name = "HeadshotESP"
    headHighlight.Adornee = head
    headHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    -- สร้าง ESP สำหรับตัว
    local bodyHighlight = Instance.new("Highlight")
    bodyHighlight.Name = "BodyESP"
    bodyHighlight.Adornee = character
    bodyHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    -- ตั้งค่าสี
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        if isEnemy(player) then
            headHighlight.FillColor = COLORS.ENEMY_HEAD
            headHighlight.OutlineColor = COLORS.ENEMY_HEAD
            bodyHighlight.FillColor = COLORS.ENEMY_PLAYER
            bodyHighlight.OutlineColor = COLORS.ENEMY_PLAYER
        else
            headHighlight.FillColor = COLORS.TEAM_HEAD
            headHighlight.OutlineColor = COLORS.TEAM_HEAD
            bodyHighlight.FillColor = COLORS.TEAM_PLAYER
            bodyHighlight.OutlineColor = COLORS.TEAM_PLAYER
        end
    else
        -- NPC
        headHighlight.FillColor = COLORS.NPC_HEAD
        headHighlight.OutlineColor = COLORS.NPC_HEAD
        bodyHighlight.FillColor = COLORS.NPC
        bodyHighlight.OutlineColor = COLORS.NPC
    end
    
    -- ตั้งค่าความโปร่งใส
    headHighlight.FillTransparency = 0.3
    headHighlight.OutlineTransparency = 0
    bodyHighlight.FillTransparency = 0.7
    bodyHighlight.OutlineTransparency = 0.2
    
    headHighlight.Parent = head
    bodyHighlight.Parent = character
    
    -- สร้าง Billboard สำหรับหัว
    local headBillboard = Instance.new("BillboardGui")
    headBillboard.Name = "HeadshotIndicator"
    headBillboard.Adornee = head
    headBillboard.Size = UDim2.new(2, 0, 2, 0)
    headBillboard.StudsOffset = Vector3.new(0, 1, 0)
    headBillboard.AlwaysOnTop = true
    headBillboard.MaxDistance = 100
    
    local headLabel = Instance.new("TextLabel")
    headLabel.Size = UDim2.new(1, 0, 1, 0)
    headLabel.BackgroundTransparency = 1
    headLabel.Text = "HEAD"
    headLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    headLabel.TextScaled = true
    headLabel.Font = Enum.Font.GothamBold
    headLabel.TextStrokeTransparency = 0
    headLabel.Parent = headBillboard
    
    headBillboard.Parent = head
    
    -- บันทึก ESP objects
    espObjects[character] = {
        HeadHighlight = headHighlight,
        BodyHighlight = bodyHighlight,
        HeadBillboard = headBillboard
    }
end

-- ฟังก์ชันสร้าง Trajectory Line สำหรับหัว
local function createHeadTrajectory(character)
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local beam = Instance.new("Beam")
    beam.Name = "HeadTrajectory"
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.FaceCamera = true
    
    local attachment0 = Instance.new("Attachment")
    attachment0.Parent = head
    
    local attachment1 = Instance.new("Attachment")
    attachment1.Parent = head
    attachment1.Position = Vector3.new(0, 0, -10)  -- ยื่นออกไปด้านหน้า
    
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.Parent = head
    
    return beam
end

-- ฟังก์ชันอัพเดท Headshot Prediction
local function updateHeadshotPrediction(character)
    if not HEADSHOT_MODE then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    -- คำนวณตำแหน่งหัวสำหรับการเล็ง
    local headPosition = head.Position
    local headVelocity = head.AssemblyLinearVelocity
    
    -- ทำนายตำแหน่งหัว (สำหรับการเล็งนำ)
    local predictedPosition = headPosition + (headVelocity * 0.2)
    
    return predictedPosition
end

-- ฟังก์ชันสร้าง ESP สำหรับผู้เล่น
local function createPlayerESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then
        player.CharacterAdded:Wait()
        character = player.Character
    end
    
    createHeadESP(character, false)
    
    -- สร้าง trajectory line
    if HEADSHOT_MODE then
        createHeadTrajectory(character)
    end
end

-- ฟังก์ชันสร้าง ESP สำหรับ NPC
local function createNPCESP(npc)
    if npc:FindFirstChild("Humanoid") then
        createHeadESP(npc, true)
        
        if HEADSHOT_MODE then
            createHeadTrajectory(npc)
        end
    end
end

-- ฟังก์ชันลบ ESP
local function removeESP(character)
    if espObjects[character] then
        for _, obj in pairs(espObjects[character]) do
            if obj then
                obj:Destroy()
            end
        end
        espObjects[character] = nil
    end
end

-- ฟังก์ชันอัพเดท ESP ตลอดเวลา
local function updateESP()
    if not ESP_ENABLED then return end
    
    for character, espData in pairs(espObjects) do
        if character and character.Parent then
            -- อัพเดทตำแหน่งหัวสำหรับ headshot prediction
            if HEADSHOT_MODE then
                local predictedPosition = updateHeadshotPrediction(character)
                -- สามารถใช้ predictedPosition นี้สำหรับการเล็งอัตโนมัติได้
            end
        else
            removeESP(character)
        end
    end
end

-- เริ่มต้นระบบ ESP
local function initializeESP()
    if not ESP_ENABLED then return end
    
    -- ESP สำหรับผู้เล่นที่มีอยู่
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createPlayerESP(player)
        end
    end
    
    -- ESP สำหรับผู้เล่นใหม่
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function(character)
                createPlayerESP(player)
            end)
        end
    end)
    
    -- ESP สำหรับ NPC
    for _, npc in ipairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
            createNPCESP(npc)
        end
    end
    
    workspace.ChildAdded:Connect(function(child)
        wait(0.5)
        if child:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(child) then
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

-- Auto Headshot Feature (Optional)
local function setupAutoHeadshot()
    if not HEADSHOT_MODE then return end
    
    local function getClosestEnemyHead()
        local closestHead = nil
        local closestDistance = math.huge
        local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
        
        if not localHead then return nil end
        
        for character, espData in pairs(espObjects) do
            if character and character.Parent then
                local head = character:FindFirstChild("Head")
                local humanoid = character:FindFirstChild("Humanoid")
                
                if head and humanoid and humanoid.Health > 0 then
                    local player = Players:GetPlayerFromCharacter(character)
                    if player and isEnemy(player) then
                        local distance = (localHead.Position - head.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestHead = head
                        end
                    end
                end
            end
        end
        
        return closestHead
    end
    
    return getClosestEnemyHead
end

-- ระบบเปิด-ปิด ESP
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- กด F เพื่อเปิด/ปิด ESP
    if input.KeyCode == Enum.KeyCode.F then
        ESP_ENABLED = not ESP_ENABLED
        
        if ESP_ENABLED then
            initializeESP()
            print("Delta Run ESP เปิดใช้งาน - Headshot Mode: " .. tostring(HEADSHOT_MODE))
        else
            for character, _ in pairs(espObjects) do
                removeESP(character)
            end
            print("Delta Run ESP ปิดใช้งาน")
        end
    end
    
    -- กด G เพื่อสลับ Headshot Mode
    if input.KeyCode == Enum.KeyCode.G then
        HEADSHOT_MODE = not HEADSHOT_MODE
        print("Headshot Mode: " .. tostring(HEADSHOT_MODE))
    end
end)

-- อัพเดท ESP ตลอดเวลา
RunService.Heartbeat:Connect(updateESP)

-- เริ่มต้นระบบ
if LocalPlayer.Character then
    initializeESP()
else
    LocalPlayer.CharacterAdded:Connect(initializeESP)
end

-- ตั้งค่า Auto Headshot
local getClosestHead = setupAutoHeadshot()

print("🎯 Delta Run Headshot ESP โหลดสำเร็จ!")
print("🔫 กด F: เปิด/ปิด ESP")
print("🎯 กด G: สลับ Headshot Mode")
print("💀 Headshot Mode: " .. tostring(HEADSHOT_MODE))

-- ฟังก์ชันสำหรับการเล็งหัวอัตโนมัติ (ใช้ร่วมกับ aimbot)
local function getHeadshotTarget()
    return getClosestHead()
end

return {
    GetHeadshotTarget = getHeadshotTarget,
    ToggleESP = function() 
        ESP_ENABLED = not ESP_ENABLED 
        if ESP_ENABLED then initializeESP() end
    end,
    ToggleHeadshotMode = function() 
        HEADSHOT_MODE = not HEADSHOT_MODE 
    end
}
