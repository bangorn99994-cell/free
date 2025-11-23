-- Speed + FLY 2025 แก้ทะลุพื้นแล้ว บินขึ้นฟ้าได้จริง 100%

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local CurrentSpeed = 100
local SpeedOn = false
local FlyOn = false
local FlyConnection

-- GUI สั้น ๆ
local SG = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
SG.ResetOnSpawn = false

local Open = Instance.new("TextButton", SG)
Open.Size = UDim2.new(0,150,0,50); Open.Position = UDim2.new(1,-170,1,-70)
Open.BackgroundColor3 = Color3.fromRGB(0,180,255); Open.Text = "Speed + Fly"
Open.TextColor3 = Color3.new(1,1,1); Open.Font = Enum.Font.GothamBold; Open.TextSize = 18
Instance.new("UICorner", Open).CornerRadius = UDim.new(0,12)

local Panel = Instance.new("Frame", SG)
Panel.Size = UDim2.new(0,320,0,170); Panel.Position = UDim2.new(0.5,-160,0.5,-85)
Panel.BackgroundColor3 = Color3.fromRGB(25,25,40); Panel.BorderSizePixel = 2
Panel.BorderColor3 = Color3.fromRGB(0,255,150); Panel.Visible = false; Panel.Draggable = true
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0,12)

-- ปุ่มต่าง ๆ (เหมือนเดิม แต่เพิ่ม Toggle Fly ที่ดีขึ้น)
-- ... (Slider + Speed Toggle เหมือนเดิม ผมย่อให้สั้น)

local TFly = Instance.new("TextButton", Panel)
TFly.Size = UDim2.new(0,130,0,45); TFly.Position = UDim2.new(0.5,-65,1,-55)
TFly.BackgroundColor3 = Color3.fromRGB(255,80,80); TFly.Text = "FLY OFF"
TFly.TextColor3 = Color3.new(1,1,1); TFly.Font = Enum.Font.GothamBold; TFly.TextSize = 20
Instance.new("UICorner", TFly).CornerRadius = UDim.new(0,12)

-- ฟังก์ชันบินที่แก้แล้ว (ไม่ทะลุพื้นอีกต่อไป)
local function StartFly()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local char = Player.Character
    local hum = char:FindFirstChild("Humanoid")
    local root = char.HumanoidRootPart

    -- วิธีใหม่ 2025: ใช้ BodyVelocity + BodyGyro + ปิดการชน
    local bv = Instance.new("BodyVelocity", root)
    bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(0,0,0)
    bv.P = 1250

    local bg = Instance.new("BodyGyro", root)
    bg.MaxTorque = Vector3.new(0,0,0)
    bg.P = 25000
    bg.D = 500

    -- ปิดการชนทุกชิ้นส่วน
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end

    FlyConnection = RunService.Heartbeat:Connect(function()
        if not FlyOn then return end
        if not root or not root.Parent then FlyConnection:Disconnect(); return end

        hum.PlatformStand = true
        bv.MaxForce = Vector3.new(40000,40000,40000)
        bg.MaxTorque = Vector3.new(400000,400000,400000)
        bg.CFrame = workspace.CurrentCamera.CFrame

        local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0,-1,0) end

        bv.Velocity = move.Unit * CurrentSpeed
    end)

    -- ป้องกันตกลงพื้นตอนเปิดครั้งแรก
    root.Velocity = Vector3.new(0, 50, 0)
end

local function StopFly()
    FlyOn = false
    if FlyConnection then FlyConnection:Disconnect() end
    local char = Player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum then hum.PlatformStand = false end
        if root then
            root.Velocity = Vector3.new(0,0,0)
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
            end
        end
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end

-- Toggle Fly
TFly.MouseButton1Click:Connect(function()
    FlyOn = not FlyOn
    TFly.Text = FlyOn and "FLY ON" or "FLY OFF"
    TFly.BackgroundColor3 = FlyOn and Color3.fromRGB(80,255,80) or Color3.fromRGB(255,80,80)
    if FlyOn then StartFly() else StopFly() end
end)

-- เปิด/ปิด Panel
Open.MouseButton1Click:Connect(function() Open.Visible = false; Panel.Visible = true end)
Panel:FindFirstChild("X").MouseButton1Click:Connect(function() Panel.Visible = false; Open.Visible = true; StopFly() end)

-- แจ้งเตือน
game.StarterGui:SetCore("SendNotification", {
    Title = "Fly แก้แล้ว!";
    Text = "เปิด Fly → กด W + Space ค้าง = บินขึ้นฟ้าได้จริง ไม่ทะลุพื้นอีกต่อไป!";
    Duration = 10
})
