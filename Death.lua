-- Delta Run Real Headlock ESP for Flick Map
-- วางใน LocalScript ภายใน StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ตั้งค่าหลัก
local ESP_ENABLED = false
local HEADLOCK_ENABLED = false
local AIMBOT_ENABLED = false
local CURRENT_TARGET = nil

-- สี
local COLORS = {
    RED = Color3.fromRGB(255, 0, 0),
    GREEN = Color3.fromRGB(0, 255, 0),
    BLUE = Color3.fromRGB(0, 100, 255),
    YELLOW = Color3.fromRGB(255, 255, 0),
    PURPLE = Color3.fromRGB(180, 0, 255),
    WHITE = Color3.fromRGB(255, 255, 255)
}

-- เก็บข้อมูล
local espObjects = {}
local headlockConnection = nil
local circleGUI = nil

-- 🎯 ฟังก์ชันล็อกหัวจริง
local function realHeadlock(targetHead)
    if not targetHead then return end
    
    local camera = workspace.CurrentCamera
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    
    if not camera or not localHead then return end
    
    -- คำนวณตำแหน่งสำหรับเล็งหัว
    local headPosition = targetHead.Position
    local headVelocity = targetHead.AssemblyLinearVelocity
    
    -- ทำนายตำแหน่ง (prediction)
    local distance = (localHead.Position - headPosition).Magnitude
    local travelTime = distance / 1000 -- ความเร็วกระสุนประมาณ
    local predictedPosition = headPosition + (headVelocity * travelTime)
    
    -- เล็งไปที่หัว
    camera.CFrame = CFrame.lookAt(camera.CFrame.Position, predictedPosition)
    
    return predictedPosition
end

-- 🎯 ค้นหาศัตรูที่ใกล้ที่สุด
local function findClosestEnemy()
    local closestPlayer = nil
    local closestDistance = math.huge
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    
    if not localHead then return nil end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and head then
                local distance = (localHead.Position - head.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- 🎯 Aimbot System
local function aimAtHead(targetHead)
    if not targetHead then return end
    
    -- สำหรับเกม Flick Map ที่ต้องคลิกเมาส์เร็ว
    local camera = workspace.CurrentCamera
    local screenPoint = camera:WorldToScreenPoint(targetHead.Position)
    
    -- ส่งเมาส์ไปที่ตำแหน่งหัว (จำลองการเล็ง)
    mousemoverel(screenPoint.X - Mouse.X, screenPoint.Y - Mouse.Y)
end

-- 🔘 สร้าง Circle GUI ไม่บังหน้าจอ
local function createCircleGUI()
    if circleGUI then circleGUI:Destroy() end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "HeadlockCircle"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    
    -- Circle Toggle Button
    local circleButton = Instance.new("TextButton")
    circleButton.Size = UDim2.new(0, 60, 0, 60)
    circleButton.Position = UDim2.new(1, -70, 0.5, -30)
    circleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    circleButton.Text = "⚙️"
    circleButton.TextColor3 = COLORS.WHITE
    circleButton.TextSize = 20
    circleButton.Font = Enum.Font.GothamBold
    
    -- Make it circular
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circleButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = COLORS.PURPLE
    stroke.Thickness = 2
    stroke.Parent = circleButton
    
    -- Menu Frame (จะแสดงเมื่อคลิก)
    local menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 150, 0, 120)
    menuFrame.Position = UDim2.new(1, -160, 0.5, -60)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    menuFrame.Visible = false
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 8)
    menuCorner.Parent = menuFrame
    
    local menuStroke = Instance.new("UIStroke")
    menuStroke.Color = COLORS.PURPLE
    menuStroke.Thickness = 1
    menuStroke.Parent = menuFrame
    
    -- ESP Toggle
    local espToggle = Instance.new("TextButton")
    espToggle.Size = UDim2.new(1, -10, 0, 30)
    espToggle.Position = UDim2.new(0, 5, 0, 10)
    espToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    espToggle.Text = "ESP: OFF"
    espToggle.TextColor3 = COLORS.RED
    espToggle.TextSize = 12
    espToggle.Font = Enum.Font.GothamBold
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 4)
    espCorner.Parent = espToggle
    
    -- Headlock Toggle
    local headlockToggle = Instance.new("TextButton")
    headlockToggle.Size = UDim2.new(1, -10, 0, 30)
    headlockToggle.Position = UDim2.new(0, 5, 0, 45)
    headlockToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    headlockToggle.Text = "HEADLOCK: OFF"
    headlockToggle.TextColor3 = COLORS.RED
    headlockToggle.TextSize = 12
    headlockToggle.Font = Enum.Font.GothamBold
    
    local headlockCorner = Instance.new("UICorner")
    headlockCorner.CornerRadius = UDim.new(0, 4)
    headlockCorner.Parent = headlockToggle
    
    -- Aimbot Toggle
    local aimbotToggle = Instance.new("TextButton")
    aimbotToggle.Size = UDim2.new(1, -10, 0, 30)
    aimbotToggle.Position = UDim2.new(0, 5, 0, 80)
    aimbotToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    aimbotToggle.Text = "AIMBOT: OFF"
    aimbotToggle.TextColor3 = COLORS.RED
    aimbotToggle.TextSize = 12
    aimbotToggle.Font = Enum.Font.GothamBold
    
    local aimbotCorner = Instance.new("UICorner")
    aimbotCorner.CornerRadius = UDim.new(0, 4)
    aimbotCorner.Parent = aimbotToggle
    
    -- Add to parents
    espToggle.Parent = menuFrame
    headlockToggle.Parent = menuFrame
    aimbotToggle.Parent = menuFrame
    menuFrame.Parent = gui
    circleButton.Parent = gui
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Toggle menu visibility
    circleButton.MouseButton1Click:Connect(function()
        menuFrame.Visible = not menuFrame.Visible
    end)
    
    -- Close menu when clicking outside
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and menuFrame.Visible then
            local mousePos = input.Position
            local menuAbsPos = menuFrame.AbsolutePosition
            local menuSize = menuFrame.AbsoluteSize
            
            if mousePos.X < menuAbsPos.X or mousePos.X > menuAbsPos.X + menuSize.X or
               mousePos.Y < menuAbsPos.Y or mousePos.Y > menuAbsPos.Y + menuSize.Y then
                menuFrame.Visible = false
            end
        end
    end)
    
    -- Button events
    espToggle.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        if ESP_ENABLED then
            espToggle.Text = "ESP: ON"
            espToggle.TextColor3 = COLORS.GREEN
            initializeESP()
        else
            espToggle.Text = "ESP: OFF"
            espToggle.TextColor3 = COLORS.RED
            clearESP()
        end
    end)
    
    headlockToggle.MouseButton1Click:Connect(function()
        HEADLOCK_ENABLED = not HEADLOCK_ENABLED
        if HEADLOCK_ENABLED then
            headlockToggle.Text = "HEADLOCK: ON"
            headlockToggle.TextColor3 = COLORS.GREEN
            startHeadlock()
        else
            headlockToggle.Text = "HEADLOCK: OFF"
            headlockToggle.TextColor3 = COLORS.RED
            stopHeadlock()
        end
    end)
    
    aimbotToggle.MouseButton1Click:Connect(function()
        AIMBOT_ENABLED = not AIMBOT_ENABLED
        if AIMBOT_ENABLED then
            aimbotToggle.Text = "AIMBOT: ON"
            aimbotToggle.TextColor3 = COLORS.GREEN
        else
            aimbotToggle.Text = "AIMBOT: OFF"
            aimbotToggle.TextColor3 = COLORS.RED
        end
    end)
    
    circleGUI = gui
    return gui
end

-- 🎯 ระบบ Headlock จริง
local function startHeadlock()
    if headlockConnection then
        headlockConnection:Disconnect()
    end
    
    headlockConnection = RunService.Heartbeat:Connect(function()
        if not HEADLOCK_ENABLED then return end
        
        local target = findClosestEnemy()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                CURRENT_TARGET = target
                
                -- ล็อกหัวจริง
                if AIMBOT_ENABLED then
                    aimAtHead(head)
                else
                    realHeadlock(head)
                end
                
                -- เอฟเฟกต์แสดงการล็อก
                if not head:FindFirstChild("HeadlockEffect") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "HeadlockEffect"
                    highlight.FillColor = COLORS.RED
                    highlight.OutlineColor = COLORS.RED
                    highlight.FillTransparency = 0.2
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = head
                end
            end
        else
            CURRENT_TARGET = nil
        end
    end)
end

local function stopHeadlock()
    if headlockConnection then
        headlockConnection:Disconnect()
        headlockConnection = nil
    end
    
    CURRENT_TARGET = nil
    
    -- ลบเอฟเฟกต์
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head and head:FindFirstChild("HeadlockEffect") then
                head.HeadlockEffect:Destroy()
            end
        end
    end
end

-- 👁️ ESP System
local function createESP(character, isNPC)
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not head then return end
    
    -- ESP สำหรับตัว
    local bodyHighlight = Instance.new("Highlight")
    bodyHighlight.Name = "BodyESP"
    bodyHighlight.Adornee = character
    bodyHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    -- ESP สำหรับหัว
    local headHighlight = Instance.new("Highlight")
    headHighlight.Name = "HeadESP"
    headHighlight.Adornee = head
    headHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        bodyHighlight.FillColor = COLORS.RED
        bodyHighlight.OutlineColor = COLORS.RED
        headHighlight.FillColor = COLORS.YELLOW
        headHighlight.OutlineColor = COLORS.YELLOW
    else
        bodyHighlight.FillColor = COLORS.GREEN
        bodyHighlight.OutlineColor = COLORS.GREEN
        headHighlight.FillColor = COLORS.BLUE
        headHighlight.OutlineColor = COLORS.BLUE
    end
    
    bodyHighlight.FillTransparency = 0.7
    bodyHighlight.OutlineTransparency = 0.3
    headHighlight.FillTransparency = 0.4
    headHighlight.OutlineTransparency = 0.1
    
    bodyHighlight.Parent = character
    headHighlight.Parent = head
    
    espObjects[character] = {
        Body = bodyHighlight,
        Head = headHighlight
    }
end

local function initializeESP()
    if not ESP_ENABLED then return end
    
    -- ESP ผู้เล่น
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createESP(player.Character, false)
        end
    end
    
    -- ESP NPC
    for _, npc in ipairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
            createESP(npc, true)
        end
    end
    
    -- ติดตามผู้เล่นใหม่
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            wait(1)
            if ESP_ENABLED then
                createESP(character, false)
            end
        end)
    end)
    
    -- ติดตาม NPC ใหม่
    workspace.ChildAdded:Connect(function(child)
        wait(1)
        if child:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(child) then
            if ESP_ENABLED then
                createESP(child, true)
            end
        end
    end)
end

local function clearESP()
    for character, espData in pairs(espObjects) do
        if espData.Body then espData.Body:Destroy() end
        if espData.Head then espData.Head:Destroy() end
    end
    espObjects = {}
end

-- 🚀 เริ่มต้นระบบ
local function initializeSystem()
    -- สร้าง Circle GUI
    createCircleGUI()
    
    -- พิมพ์ข้อความยืนยัน
    print("🎯 Delta Run Real Headlock Loaded!")
    print("🔘 Circle GUI created at right side")
    print("🎮 Controls:")
    print("  - Click gear icon to open menu")
    print("  - ESP: Visual tracking")
    print("  - HEADLOCK: Real head targeting")
    print("  - AIMBOT: Auto aim for Flick Map")
end

-- ⚡ Auto Headshot สำหรับ Flick Map
local function setupFlickMapAimbot()
    if not AIMBOT_ENABLED then return end
    
    -- สำหรับเกม Flick Map ที่ต้องคลิกเร็ว
    Mouse.Button1Down:Connect(function()
        if AIMBOT_ENABLED and CURRENT_TARGET and CURRENT_TARGET.Character then
            local head = CURRENT_TARGET.Character:FindFirstChild("Head")
            if head then
                -- ยิงไปที่หัวโดยอัตโนมัติ
                aimAtHead(head)
            end
        end
    end)
end

-- 🎮 คีย์ลัด
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- กด T สำหรับ Headlock เร็ว
    if input.KeyCode == Enum.KeyCode.T then
        HEADLOCK_ENABLED = not HEADLOCK_ENABLED
        if HEADLOCK_ENABLED then
            startHeadlock()
        else
            stopHeadlock()
        end
    end
    
    -- กด Y สำหรับ ESP เร็ว
    if input.KeyCode == Enum.KeyCode.Y then
        ESP_ENABLED = not ESP_ENABLED
        if ESP_ENABLED then
            initializeESP()
        else
            clearESP()
        end
    end
end)

-- เริ่มต้นระบบ
if LocalPlayer.Character then
    initializeSystem()
    setupFlickMapAimbot()
else
    LocalPlayer.CharacterAdded:Connect(function()
        initializeSystem()
        setupFlickMapAimbot()
    end)
end

-- ฟังก์ชันสำหรับ Flick Map โดยเฉพาะ
local FlickMapUtils = {
    -- สำหรับ Map ที่ต้องเล็งเร็ว
    QuickFlick = function()
        if CURRENT_TARGET and CURRENT_TARGET.Character then
            local head = CURRENT_TARGET.Character:FindFirstChild("Head")
            if head then
                aimAtHead(head)
                return true
            end
        end
        return false
    end,
    
    -- โหมดสแนปเร็วสำหรับ Flick Shot
    SnapFlick = function()
        local target = findClosestEnemy()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                CURRENT_TARGET = target
                aimAtHead(head)
                return true
            end
        end
        return false
    end
}

-- ส่งออกฟังก์ชันสำหรับ Flick Map
return FlickMapUtils
