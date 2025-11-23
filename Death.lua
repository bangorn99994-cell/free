--[[
    ULTIMATE WAR HACK (SILENT AIM + FULL ESP)
    - Aimbot: Silent Aim (100% Lock)
    - ESP: Box, Name, Health, Tracer (มองทะลุ)
    - ใช้ Heartbeat และ pcall เพื่อความเสถียรสูงสุด
]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- --- CONFIG ---
getgenv().AIMBOT_ACTIVE = false
getgenv().ESP_ACTIVE = true -- เปิด ESP ทันที
local MAX_DISTANCE = 450 

-- 🔥 ชื่อ RemoteEvent ที่ต้องแก้ไข (ถ้าล็อคหัวไม่ทำงาน) 🔥
local FIRE_REMOTE_NAME = "FireBullet" -- เปลี่ยนเป็นชื่อที่คุณหาเจอ (เช่น "ShootEvent", "DamageRemote")

-- --- GUI SETUP ---

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateWarHack"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.01, 0, 0.65, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "Ultimate War Hack"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- --- AIMBOT TOGGLE ---
local AimbotToggle = Instance.new("TextButton", MainFrame)
AimbotToggle.Size = UDim2.new(0.9, 0, 0.2, 0)
AimbotToggle.Position = UDim2.new(0.05, 0, 0.3, 0)
AimbotToggle.Text = "AIMBOT: OFF"
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AimbotToggle.Font = Enum.Font.SourceSansBold

AimbotToggle.Activated:Connect(function()
    getgenv().AIMBOT_ACTIVE = not getgenv().AIMBOT_ACTIVE
    AimbotToggle.Text = "AIMBOT: " .. (getgenv().AIMBOT_ACTIVE and "ON" or "OFF")
    AimbotToggle.BackgroundColor3 = getgenv().AIMBOT_ACTIVE and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- --- ESP TOGGLE ---
local ESPToggle = Instance.new("TextButton", MainFrame)
ESPToggle.Size = UDim2.new(0.9, 0, 0.2, 0)
ESPToggle.Position = UDim2.new(0.05, 0, 0.6, 0)
ESPToggle.Text = "ESP: ON"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ESPToggle.Font = Enum.Font.SourceSansBold

ESPToggle.Activated:Connect(function()
    getgenv().ESP_ACTIVE = not getgenv().ESP_ACTIVE
    ESPToggle.Text = "ESP: " .. (getgenv().ESP_ACTIVE and "ON" or "OFF")
    ESPToggle.BackgroundColor3 = getgenv().ESP_ACTIVE and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)


-- --- AIMBOT CORE LOGIC (Silent Aim) ---

local OriginalFireRemote = nil
local function GetTarget()
    -- (Same Target finding logic as before, aiming for Head/HRP)
    local BestTarget = nil
    local ClosestDistance = MAX_DISTANCE
    local MyHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not MyHRP then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 and (player.Team == nil or player.Team ~= LocalPlayer.Team) then
            local TargetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if TargetPart then
                local Distance = (MyHRP.Position - TargetPart.Position).Magnitude
                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    BestTarget = TargetPart
                end
            end
        end
    end
    return BestTarget
end

local function SilentAimHook(remote, ...)
    pcall(function()
        if getgenv().AIMBOT_ACTIVE then
            local TargetPart = GetTarget()
            
            if TargetPart then
                local HeadPosition = TargetPart.Position
                local Direction = (HeadPosition - Camera.CFrame.Position).Unit -- ทิศทางใหม่
                
                local Args = {...}
                -- Anti-Kick Logic: ปลอมแปลงเฉพาะค่า Vector3
                for i, arg in ipairs(Args) do
                    if typeof(arg) == "Vector3" then
                        Args[i] = Direction
                        break 
                    end
                end
                
                return OriginalFireRemote(remote, table.unpack(Args))
            end
        end
    end)
    
    return OriginalFireRemote(remote, ...)
end

-- --- ESP CORE LOGIC (Visuals) ---

local ESPFolder = Instance.new("Folder", ScreenGui)
ESPFolder.Name = "ESPDrawings"

local function DrawESP(player, targetPart)
    local Character = player.Character
    if not Character then return end

    local HRP = Character:FindFirstChild("HumanoidRootPart")
    local Head = Character:FindFirstChild("Head")
    
    if not HRP or not Head then return end
    
    local RootPos = HRP.Position
    local HeadPos = Head.Position
    local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - RootPos).Magnitude
    
    if Distance > MAX_DISTANCE then return end

    -- 1. World to Screen Conversion
    local RootScreen, RootVisible = Camera:WorldToViewportPoint(RootPos)
    local HeadScreen, HeadVisible = Camera:WorldToViewportPoint(HeadPos + Vector3.new(0, 1.5, 0)) -- ยกระดับ Head ขึ้นเล็กน้อย
    
    if not RootVisible then return end
    
    local Color = player.Team and (player.Team ~= LocalPlayer.Team and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 255)) or Color3.fromRGB(255, 255, 0)
    
    local BoxHeight = math.abs(HeadScreen.Y - RootScreen.Y)
    local BoxWidth = BoxHeight / 2.5
    local BoxCenter = Vector2.new(RootScreen.X, RootScreen.Y)
    
    -- ลบ ESP เดิมของ Player นี้
    for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == player.Name then item:Destroy() end
    end
    
    if not getgenv().ESP_ACTIVE then return end
    
    -- 2. Box ESP
    local Box = Instance.new("Frame", ESPFolder)
    Box.Name = player.Name
    Box.Size = UDim2.new(0, BoxWidth, 0, BoxHeight)
    Box.Position = UDim2.new(0, BoxCenter.X - BoxWidth / 2, 0, BoxCenter.Y - BoxHeight)
    Box.BackgroundColor3 = Color
    Box.BackgroundTransparency = 1
    Box.BorderSizePixel = 1
    Box.BorderColor3 = Color
    
    -- 3. Name & Distance ESP
    local NameLabel = Instance.new("TextLabel", Box)
    NameLabel.Size = UDim2.new(1, 0, 0, 15)
    NameLabel.Position = UDim2.new(0, 0, 1, 0)
    NameLabel.Text = player.Name .. " [" .. math.floor(Distance) .. "m]"
    NameLabel.TextColor3 = Color
    NameLabel.TextScaled = true
    NameLabel.BackgroundTransparency = 1
    
    -- 4. Health Bar ESP
    local HealthFrame = Instance.new("Frame", Box)
    HealthFrame.Size = UDim2.new(0, 5, 1, 0)
    HealthFrame.Position = UDim2.new(1, 2, 0, 0)
    HealthFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    local HealthFill = Instance.new("Frame", HealthFrame)
    local HealthPercentage = Character.Humanoid.Health / 100
    HealthFill.Size = UDim2.new(1, 0, HealthPercentage, 0)
    HealthFill.Position = UDim2.new(0, 0, 1 - HealthPercentage, 0)
    HealthFill.BackgroundColor3 = HealthPercentage > 0.5 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)
    
    -- 5. Tracer Line (เส้นเชื่อมจากด้านล่างจอ)
    local Tracer = Instance.new("Frame", ESPFolder)
    Tracer.Name = player.Name .. "Tracer"
    Tracer.AnchorPoint = Vector2.new(0.5, 0)
    Tracer.BackgroundColor3 = Color
    Tracer.BackgroundTransparency = 0.5
    
    local LineLength = (Vector2.new(RootScreen.X, RootScreen.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)).Magnitude
    Tracer.Size = UDim2.new(0, 1, 0, LineLength)
    
    local Angle = math.atan2(RootScreen.Y - Camera.ViewportSize.Y, RootScreen.X - Camera.ViewportSize.X/2)
    Tracer.Rotation = math.deg(Angle) + 90
    
    Tracer.Position = UDim2.new(0, Camera.ViewportSize.X/2, 0, Camera.ViewportSize.Y)
end

-- --- MAIN LOOP ---

local function MainLoop()
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 then
                DrawESP(player)
            end
        end
        -- ล้าง ESP เมื่อปิด
        if not getgenv().ESP_ACTIVE then
            for _, item in pairs(ESPFolder:GetChildren()) do
                item:Destroy()
            end
        end
    end)
end

-- --- INITIALIZATION ---

-- 1. Hook Silent Aim
pcall(function()
    local Remote = game:GetService("ReplicatedStorage"):FindFirstChild(FIRE_REMOTE_NAME, true) or workspace:FindFirstChild(FIRE_REMOTE_NAME, true)
    
    if Remote and getgenv().hookfunction then
        OriginalFireRemote = getgenv().hookfunction(Remote.FireServer, SilentAimHook)
        game.StarterGui:SetCore("SendNotification", {Title = "AIMBOT READY"; Text = "Silent Aim Hooked: " .. FIRE_REMOTE_NAME, Duration = 3;})
    else
        game.StarterGui:SetCore("SendNotification", {Title = "AIMBOT WARNING"; Text = "Silent Aim Hook ล้มเหลว! ต้องแก้ชื่อ RemoteEvent.", Duration = 5;})
        AimbotToggle.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    end
end)

-- 2. Start ESP Loop
RunService.Heartbeat:Connect(MainLoop)

game.StarterGui:SetCore("SendNotification", {
    Title = "Ultimate War Hack Loaded";
    Text = "รัน ESP และ Aimbot สำเร็จแล้ว!",
    Duration = 5;
})
