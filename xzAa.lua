-- Delta Run Auto Jump/Fly Script
-- วางใน LocalScript ภายใน StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ตั้งค่าหลัก
local AUTO_JUMP_ENABLED = false
local FLY_MODE = false
local JUMP_POWER = 50
local currentConnection = nil

-- สี
local COLORS = {
    GREEN = Color3.fromRGB(0, 255, 0),
    RED = Color3.fromRGB(255, 0, 0),
    BLUE = Color3.fromRGB(0, 100, 255),
    WHITE = Color3.fromRGB(255, 255, 255)
}

-- เก็บข้อมูล
local circleGUI = nil
local menuOpen = false

-- 🚀 ฟังก์ชันกระโดดอัตโนมัติ
local function autoJump()
    local character = LocalPlayer.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    if humanoid:GetState() == Enum.HumanoidStateType.Freefall or 
       humanoid:GetState() == Enum.HumanoidStateType.Jumping then
        -- อยู่ในอากาศแล้ว - เพิ่มแรงกระโดดต่อเนื่อง
        rootPart.Velocity = Vector3.new(
            rootPart.Velocity.X,
            JUMP_POWER,
            rootPart.Velocity.Z
        )
    else
        -- กระโดดปกติ
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    
    return true
end

-- 🚀 โหมดบินด้วยการกระโดดซ้ำ
local function flyMode()
    local character = LocalPlayer.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    -- บินโดยการกระโดดซ้ำๆ + ควบคุมทิศทาง
    local camera = workspace.CurrentCamera
    local lookVector = camera.CFrame.LookVector
    
    -- ความเร็วบิน
    local flySpeed = 30
    
    -- ตั้งค่าความเร็ว
    rootPart.Velocity = Vector3.new(
        lookVector.X * flySpeed,
        JUMP_POWER * 0.8, -- ลดแรงกระโดดลงเล็กน้อยสำหรับการบิน
        lookVector.Z * flySpeed
    )
    
    return true
end

-- 🔘 สร้าง Circle GUI
local function createCircleGUI()
    if circleGUI then 
        circleGUI:Destroy()
        circleGUI = nil
    end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "JumpFlyGUI"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    gui.Enabled = true
    
    -- Circle Toggle Button
    local circleButton = Instance.new("TextButton")
    circleButton.Name = "CircleToggle"
    circleButton.Size = UDim2.new(0, 60, 0, 60)
    circleButton.Position = UDim2.new(1, -70, 0.5, -30)
    circleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    circleButton.Text = "🚀"
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
    stroke.Color = COLORS.BLUE
    stroke.Thickness = 2
    stroke.Parent = circleButton
    
    -- Menu Frame
    local menuFrame = Instance.new("Frame")
    menuFrame.Name = "MenuFrame"
    menuFrame.Size = UDim2.new(0, 200, 0, 200)
    menuFrame.Position = UDim2.new(1, -210, 0.5, -100)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    menuFrame.Visible = false
    menuFrame.Active = true
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 8)
    menuCorner.Parent = menuFrame
    
    local menuStroke = Instance.new("UIStroke")
    menuStroke.Color = COLORS.BLUE
    menuStroke.Thickness = 1
    menuStroke.Parent = menuFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    title.Text = "JUMP/FLY SYSTEM"
    title.TextColor3 = COLORS.WHITE
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.Parent = menuFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    -- Auto Jump Toggle
    local jumpToggle = Instance.new("TextButton")
    jumpToggle.Name = "JumpToggle"
    jumpToggle.Size = UDim2.new(1, -20, 0, 35)
    jumpToggle.Position = UDim2.new(0, 10, 0, 40)
    jumpToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    jumpToggle.Text = "AUTO JUMP: OFF"
    jumpToggle.TextColor3 = COLORS.RED
    jumpToggle.TextSize = 12
    jumpToggle.Font = Enum.Font.GothamBold
    jumpToggle.AutoButtonColor = true
    jumpToggle.Active = true
    
    local jumpCorner = Instance.new("UICorner")
    jumpCorner.CornerRadius = UDim.new(0, 6)
    jumpCorner.Parent = jumpToggle
    
    -- Fly Mode Toggle
    local flyToggle = Instance.new("TextButton")
    flyToggle.Name = "FlyToggle"
    flyToggle.Size = UDim2.new(1, -20, 0, 35)
    flyToggle.Position = UDim2.new(0, 10, 0, 85)
    flyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    flyToggle.Text = "FLY MODE: OFF"
    flyToggle.TextColor3 = COLORS.RED
    flyToggle.TextSize = 12
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.AutoButtonColor = true
    flyToggle.Active = true
    
    local flyCorner = Instance.new("UICorner")
    flyCorner.CornerRadius = UDim.new(0, 6)
    flyCorner.Parent = flyToggle
    
    -- Jump Power Slider
    local powerFrame = Instance.new("Frame")
    powerFrame.Size = UDim2.new(1, -20, 0, 50)
    powerFrame.Position = UDim2.new(0, 10, 0, 130)
    powerFrame.BackgroundTransparency = 1
    powerFrame.Parent = menuFrame
    
    local powerLabel = Instance.new("TextLabel")
    powerLabel.Size = UDim2.new(1, 0, 0, 20)
    powerLabel.BackgroundTransparency = 1
    powerLabel.Text = "JUMP POWER: " .. JUMP_POWER
    powerLabel.TextColor3 = COLORS.WHITE
    powerLabel.TextSize = 11
    powerLabel.Font = Enum.Font.Gotham
    powerLabel.Parent = powerFrame
    
    local powerSlider = Instance.new("TextButton")
    powerSlider.Size = UDim2.new(1, 0, 0, 25)
    powerSlider.Position = UDim2.new(0, 0, 0, 25)
    powerSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    powerSlider.Text = ""
    powerSlider.AutoButtonColor = false
    powerSlider.Parent = powerFrame
    
    local powerSliderCorner = Instance.new("UICorner")
    powerSliderCorner.CornerRadius = UDim.new(0, 4)
    powerSliderCorner.Parent = powerSlider
    
    local powerFill = Instance.new("Frame")
    powerFill.Size = UDim2.new((JUMP_POWER - 20) / 80, 0, 1, 0)
    powerFill.BackgroundColor3 = COLORS.BLUE
    powerFill.BorderSizePixel = 0
    powerFill.Parent = powerSlider
    
    local powerFillCorner = Instance.new("UICorner")
    powerFillCorner.CornerRadius = UDim.new(0, 4)
    powerFillCorner.Parent = powerFill
    
    -- Add to parents
    jumpToggle.Parent = menuFrame
    flyToggle.Parent = menuFrame
    powerFrame.Parent = menuFrame
    menuFrame.Parent = gui
    circleButton.Parent = gui
    
    -- Parent GUI
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- ✅ ฟังก์ชันเปิด-ปิดเมนู
    local function toggleMenu()
        menuOpen = not menuOpen
        menuFrame.Visible = menuOpen
        
        if menuOpen then
            circleButton.Text = "❌"
            circleButton.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        else
            circleButton.Text = "🚀"
            circleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        end
    end
    
    -- ✅ Event สำหรับปุ่มวงกลม
    circleButton.MouseButton1Click:Connect(function()
        toggleMenu()
    end)
    
    -- ✅ Event สำหรับปุ่ม Auto Jump
    jumpToggle.MouseButton1Click:Connect(function()
        AUTO_JUMP_ENABLED = not AUTO_JUMP_ENABLED
        
        if AUTO_JUMP_ENABLED then
            -- ปิด Fly Mode ถ้าเปิดอยู่
            if FLY_MODE then
                FLY_MODE = false
                flyToggle.Text = "FLY MODE: OFF"
                flyToggle.TextColor3 = COLORS.RED
                flyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            end
            
            jumpToggle.Text = "AUTO JUMP: ON"
            jumpToggle.TextColor3 = COLORS.GREEN
            jumpToggle.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
            startAutoJump()
        else
            jumpToggle.Text = "AUTO JUMP: OFF"
            jumpToggle.TextColor3 = COLORS.RED
            jumpToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            stopAutoJump()
        end
    end)
    
    -- ✅ Event สำหรับปุ่ม Fly Mode
    flyToggle.MouseButton1Click:Connect(function()
        FLY_MODE = not FLY_MODE
        
        if FLY_MODE then
            -- ปิด Auto Jump ถ้าเปิดอยู่
            if AUTO_JUMP_ENABLED then
                AUTO_JUMP_ENABLED = false
                jumpToggle.Text = "AUTO JUMP: OFF"
                jumpToggle.TextColor3 = COLORS.RED
                jumpToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            end
            
            flyToggle.Text = "FLY MODE: ON"
            flyToggle.TextColor3 = COLORS.GREEN
            flyToggle.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
            startFlyMode()
        else
            flyToggle.Text = "FLY MODE: OFF"
            flyToggle.TextColor3 = COLORS.RED
            flyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            stopFlyMode()
        end
    end)
    
    -- ✅ Event สำหรับ Slider
    powerSlider.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local mouse = UserInputService:GetMouseLocation()
            local sliderAbsolutePosition = powerSlider.AbsolutePosition
            local sliderAbsoluteSize = powerSlider.AbsoluteSize
            
            local relativeX = math.clamp(
                (mouse.X - sliderAbsolutePosition.X) / sliderAbsoluteSize.X,
                0, 1
            )
            
            JUMP_POWER = 20 + math.floor(relativeX * 80) -- 20 ถึง 100
            powerLabel.Text = "JUMP POWER: " .. JUMP_POWER
            powerFill.Size = UDim2.new(relativeX, 0, 1, 0)
        end)
        
        local function disconnect()
            connection:Disconnect()
        end
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                disconnect()
            end
        end)
    end)
    
    -- ✅ ปิดเมนูเมื่อคลิกนอก
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

-- 🚀 เริ่มระบบกระโดดอัตโนมัติ
local function startAutoJump()
    if currentConnection then
        currentConnection:Disconnect()
    end
    
    print("🚀 Auto Jump เริ่มทำงาน!")
    
    currentConnection = RunService.Heartbeat:Connect(function()
        if not AUTO_JUMP_ENABLED then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        autoJump()
    end)
end

-- 🚀 เริ่มโหมดบิน
local function startFlyMode()
    if currentConnection then
        currentConnection:Disconnect()
    end
    
    print("🕊️ Fly Mode เริ่มทำงาน!")
    
    currentConnection = RunService.Heartbeat:Connect(function()
        if not FLY_MODE then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        flyMode()
    end)
end

-- 🚀 หยุดระบบทั้งหมด
local function stopAutoJump()
    if currentConnection then
        currentConnection:Disconnect()
        currentConnection = nil
    end
    print("🚫 Auto Jump หยุดทำงาน")
end

local function stopFlyMode()
    if currentConnection then
        currentConnection:Disconnect()
        currentConnection = nil
    end
    print("🚫 Fly Mode หยุดทำงาน")
end

-- 🚀 เริ่มต้นระบบ
local function initializeSystem()
    -- รอให้เกมโหลดเสร็จ
    wait(2)
    
    -- สร้าง Circle GUI
    createCircleGUI()
    
    -- พิมพ์ข้อความยืนยัน
    print("✅ Delta Run Jump/Fly System โหลดสำเร็จ!")
    print("🚀 กดปุ่มวงกลมที่ขวาล่างเพื่อเปิดเมนู")
    print("🔵 Auto Jump: กระโดดซ้ำๆ อัตโนมัติ")
    print("🕊️ Fly Mode: บินด้วยการกระโดดต่อเนื่อง")
end

-- 🎮 คีย์ลัดเพิ่มเติม
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- กด J สำหรับ Auto Jump เร็ว
    if input.KeyCode == Enum.KeyCode.J then
        AUTO_JUMP_ENABLED = not AUTO_JUMP_ENABLED
        FLY_MODE = false
        
        if AUTO_JUMP_ENABLED then
            startAutoJump()
        else
            stopAutoJump()
        end
    end
    
    -- กด F สำหรับ Fly Mode เร็ว
    if input.KeyCode == Enum.KeyCode.F then
        FLY_MODE = not FLY_MODE
        AUTO_JUMP_ENABLED = false
        
        if FLY_MODE then
            startFlyMode()
        else
            stopFlyMode()
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
    
    -- กด R สำหรับรีเซ็ตความเร็ว (กรณีติด)
    if input.KeyCode == Enum.KeyCode.R then
        local character = LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Velocity = Vector3.new(0, 0, 0)
                print("🔄 รีเซ็ตความเร็วแล้ว")
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
print("=== Delta Run Jump/Fly Controls ===")
print("🚀 Circle Button: เปิด/ปิดเมนู")
print("🔵 J Key: เปิด/ปิด Auto Jump เร็ว")
print("🕊️ F Key: เปิด/ปิด Fly Mode เร็ว") 
print("📱 U Key: เปิด/ปิดเมนูเร็ว")
print("🔄 R Key: รีเซ็ตความเร็ว (กรณีติด)")
print("===================================")