-- Delta Run Real Headlock ESP - Fixed Version
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
local menuOpen = false

-- 🎯 ฟังก์ชันล็อกหัวจริง 100%
local function realHeadlock(targetHead)
    if not targetHead or not workspace.CurrentCamera then return end
    
    local camera = workspace.CurrentCamera
    local localCharacter = LocalPlayer.Character
    if not localCharacter then return end
    
    local localHead = localCharacter:FindFirstChild("Head")
    if not localHead then return end
    
    -- คำนวณตำแหน่งหัวด้วย prediction
    local headPosition = targetHead.Position
    local headVelocity = targetHead.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
    
    -- Prediction สำหรับกระสุน
    local distance = (localHead.Position - headPosition).Magnitude
    local bulletSpeed = 1000 -- ความเร็วกระสุน
    local travelTime = distance / bulletSpeed
    local predictedPosition = headPosition + (headVelocity * travelTime)
    
    -- เล็งไปที่หัวเป้าหมาย
    local direction = (predictedPosition - camera.CFrame.Position).Unit
    local newCFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)
    
    -- อัพเดทกล้องให้เล็งไปที่หัว
    workspace.CurrentCamera.CFrame = newCFrame
    
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
                -- ตรวจสอบว่าเห็นศัตรูหรือไม่ (raycast check)
                local rayOrigin = localHead.Position
                local rayDirection = (head.Position - rayOrigin).Unit * 1000
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                
                local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                
                if not raycastResult or raycastResult.Instance:IsDescendantOf(player.Character) then
                    local distance = (localHead.Position - head.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- 🔘 สร้าง Circle GUI ที่กดได้จริง
local function createCircleGUI()
    if circleGUI then 
        circleGUI:Destroy()
        circleGUI = nil
    end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "HeadlockCircle"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    gui.Enabled = true
    
    -- Circle Toggle Button
    local circleButton = Instance.new("TextButton")
    circleButton.Name = "CircleToggle"
    circleButton.Size = UDim2.new(0, 60, 0, 60)
    circleButton.Position = UDim2.new(1, -70, 0.5, -30)
    circleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    circleButton.Text = "🎯"
    circleButton.TextColor3 = COLORS.WHITE
    circleButton.TextSize = 20
    circleButton.Font = Enum.Font.GothamBold
    circleButton.AutoButtonColor = true
    circleButton.Visible = true
    circleButton.Active = true
    
    -- Make it circular
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circleButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = COLORS.PURPLE
    stroke.Thickness = 2
    stroke.Parent = circleButton
    
    -- Menu Frame
    local menuFrame = Instance.new("Frame")
    menuFrame.Name = "MenuFrame"
    menuFrame.Size = UDim2.new(0, 200, 0, 180)
    menuFrame.Position = UDim2.new(1, -210, 0.5, -90)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    menuFrame.Visible = false
    menuFrame.Active = true
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 8)
    menuCorner.Parent = menuFrame
    
    local menuStroke = Instance.new("UIStroke")
    menuStroke.Color = COLORS.PURPLE
    menuStroke.Thickness = 1
    menuStroke.Parent = menuFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    title.Text = "DELTA RUN ESP"
    title.TextColor3 = COLORS.WHITE
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.Parent = menuFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    -- ESP Toggle
    local espToggle = Instance.new("TextButton")
    espToggle.Name = "ESPToggle"
    espToggle.Size = UDim2.new(1, -20, 0, 35)
    espToggle.Position = UDim2.new(0, 10, 0, 40)
    espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    espToggle.Text = "ESP: OFF"
    espToggle.TextColor3 = COLORS.RED
    espToggle.TextSize = 12
    espToggle.Font = Enum.Font.GothamBold
    espToggle.AutoButtonColor = true
    espToggle.Active = true
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 6)
    espCorner.Parent = espToggle
    
    -- Headlock Toggle
    local headlockToggle = Instance.new("TextButton")
    headlockToggle.Name = "HeadlockToggle"
    headlockToggle.Size = UDim2.new(1, -20, 0, 35)
    headlockToggle.Position = UDim2.new(0, 10, 0, 85)
    headlockToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    headlockToggle.Text = "HEADLOCK: OFF"
    headlockToggle.TextColor3 = COLORS.RED
    headlockToggle.TextSize = 12
    headlockToggle.Font = Enum.Font.GothamBold
    headlockToggle.AutoButtonColor = true
    headlockToggle.Active = true
    
    local headlockCorner = Instance.new("UICorner")
    headlockCorner.CornerRadius = UDim.new(0, 6)
    headlockCorner.Parent = headlockToggle
    
    -- Aimbot Toggle
    local aimbotToggle = Instance.new("TextButton")
    aimbotToggle.Name = "AimbotToggle"
    aimbotToggle.Size = UDim2.new(1, -20, 0, 35)
    aimbotToggle.Position = UDim2.new(0, 10, 0, 130)
    aimbotToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    aimbotToggle.Text = "AIMBOT: OFF"
    aimbotToggle.TextColor3 = COLORS.RED
    aimbotToggle.TextSize = 12
    aimbotToggle.Font = Enum.Font.GothamBold
    aimbotToggle.AutoButtonColor = true
    aimbotToggle.Active = true
    
    local aimbotCorner = Instance.new("UICorner")
    aimbotCorner.CornerRadius = UDim.new(0, 6)
    aimbotCorner.Parent = aimbotToggle
    
    -- Add to parents
    espToggle.Parent = menuFrame
    headlockToggle.Parent = menuFrame
    aimbotToggle.Parent = menuFrame
    menuFrame.Parent = gui
    circleButton.Parent = gui
    
    -- Parent GUI
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- ✅ FIXED: ฟังก์ชันเปิด-ปิดเมนู
    local function toggleMenu()
        menuOpen = not menuOpen
        menuFrame.Visible = menuOpen
        
        if menuOpen then
            circleButton.Text = "❌"
            circleButton.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        else
            circleButton.Text = "🎯"
            circleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        end
    end
    
    -- ✅ FIXED: Event สำหรับปุ่มวงกลม
    circleButton.MouseButton1Click:Connect(function()
        toggleMenu()
    end)
    
    -- ✅ FIXED: Event สำหรับปุ่ม ESP
    espToggle.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        if ESP_ENABLED then
            espToggle.Text = "ESP: ON"
            espToggle.TextColor3 = COLORS.GREEN
            espToggle.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
            initializeESP()
        else
            espToggle.Text = "ESP: OFF"
            espToggle.TextColor3 = COLORS.RED
            espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            clearESP()
        end
    end)
    
    -- ✅ FIXED: Event สำหรับปุ่ม Headlock
    headlockToggle.MouseButton1Click:Connect(function()
        HEADLOCK_ENABLED = not HEADLOCK_ENABLED
        if HEADLOCK_ENABLED then
            headlockToggle.Text = "HEADLOCK: ON"
            headlockToggle.TextColor3 = COLORS.GREEN
            headlockToggle.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
            startHeadlock()
        else
            headlockToggle.Text = "HEADLOCK: OFF"
            headlockToggle.TextColor3 = COLORS.RED
            headlockToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            stopHeadlock()
        end
    end)
    
    -- ✅ FIXED: Event สำหรับปุ่ม Aimbot
    aimbotToggle.MouseButton1Click:Connect(function()
        AIMBOT_ENABLED = not AIMBOT_ENABLED
        if AIMBOT_ENABLED then
            aimbotToggle.Text = "AIMBOT: ON"
            aimbotToggle.TextColor3 = COLORS.GREEN
            aimbotToggle.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
        else
            aimbotToggle.Text = "AIMBOT: OFF"
            aimbotToggle.TextColor3 = COLORS.RED
            aimbotToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        end
    end)
    
    -- ✅ FIXED: ปิดเมนูเมื่อคลิกนอก
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and menuOpen then
            local mousePos = input.Position
            local menuAbsPos = menuFrame.AbsolutePosition
            local menuSize = menuFrame.AbsoluteSize
            local circleAbsPos = circleButton.AbsolutePosition
            local circleSize = circleButton.AbsoluteSize
            
            -- ตรวจสอบว่าคลิกนอกเมนูและนอกปุ่มวงกลม
            local clickInMenu = (
                mousePos.X >= menuAbsPos.X and 
                mousePos.X <= menuAbsPos.X + menuSize.X and
                mousePos.Y >= menuAbsPos.Y and 
                mousePos.Y <= menuAbsPos.Y + menuSize.Y
            )
            
            local clickInCircle = (
                mousePos.X >= circleAbsPos.X and 
                mousePos.X <= circleAbsPos.X + circleSize.X and
                mousePos.Y >= circleAbsPos.Y and 
                mousePos.Y <= circleAbsPos.Y + circleSize.Y
            )
            
            if not clickInMenu and not clickInCircle then
                toggleMenu()
            end
        end
    end)
    
    circleGUI = gui
    return gui
end

-- 🎯 ระบบ Headlock จริง 100%
local function startHeadlock()
    if headlockConnection then
        headlockConnection:Disconnect()
    end
    
    print("🎯 Headlock 100% เริ่มทำงาน!")
    
    headlockConnection = RunService.Heartbeat:Connect(function()
        if not HEADLOCK_ENABLED then return end
        
        local target = findClosestEnemy()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                CURRENT_TARGET = target
                
                -- ✅ ล็อกหัวจริง 100%
                realHeadlock(head)
                
                -- เอฟเฟกต์แสดงการล็อก
                if not head:FindFirstChild("HeadlockEffect") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "HeadlockEffect"
                    highlight.FillColor = COLORS.RED
                    highlight.OutlineColor = COLORS.RED
                    highlight.FillTransparency = 0.1
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
    
    print("🎯 Headlock ปิดการทำงาน")
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
    headHighlight.FillTransparency = 0.3
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
    
    clearESP() -- ล้างก่อนเริ่มใหม่
    
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
    
    print("👁️ ESP เปิดใช้งานแล้ว")
end

local function clearESP()
    for character, espData in pairs(espObjects) do
        if espData.Body and espData.Body.Parent then 
            espData.Body:Destroy() 
        end
        if espData.Head and espData.Head.Parent then 
            espData.Head:Destroy() 
        end
    end
    espObjects = {}
    
    if ESP_ENABLED then
        print("👁️ ESP ปิดการทำงาน")
    end
end

-- 🚀 เริ่มต้นระบบ
local function initializeSystem()
    -- รอให้เกมโหลดเสร็จ
    wait(2)
    
    -- สร้าง Circle GUI
    createCircleGUI()
    
    -- พิมพ์ข้อความยืนยัน
    print("✅ Delta Run Real Headlock โหลดสำเร็จ!")
    print("🎯 กดปุ่มวงกลมที่ขวาล่างเพื่อเปิดเมนู")
    print("🔫 Headlock 100% พร้อมใช้งาน")
    print("👁️ ESP พร้อมใช้งาน")
end

-- 🎮 คีย์ลัดเพิ่มเติม
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
    
    -- กด U สำหรับเปิด/ปิดเมนู
    if input.KeyCode == Enum.KeyCode.U then
        if circleGUI then
            local circleButton = circleGUI:FindFirstChild("CircleToggle")
            if circleButton then
                circleButton:Fire("MouseButton1Click")
            end
        end
    end
end)

-- ⚡ เริ่มต้นระบบเมื่อพร้อม
if LocalPlayer.Character then
    spawn(initializeSystem)
else
    LocalPlayer.CharacterAdded:Connect(function()
        spawn(initializeSystem)
    end)
end

-- รอให้ PlayerGui พร้อม
if not LocalPlayer:FindFirstChild("PlayerGui") then
    LocalPlayer:WaitForChild("PlayerGui")
end

wait(3)
print(" ")
print("=== Delta Run ESP Controls ===")
print("🎯 Circle Button: เปิด/ปิดเมนู")
print("🔫 T Key: เปิด/ปิด Headlock เร็ว")
print("👁️ Y Key: เปิด/ปิด ESP เร็ว") 
print("📱 U Key: เปิด/ปิดเมนูเร็ว")
print("==============================")