--[[
    ULTIMATE WAR HACK (SILENT AIM + FULL ESP)
    - ปรับปรุง GUI ให้ทนทานต่อการถูกลบโดย Anti-Cheat
]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- --- CONFIG ---
getgenv().AIMBOT_ACTIVE = false
getgenv().ESP_ACTIVE = true 
local MAX_DISTANCE = 450 

-- 🔥 ชื่อ RemoteEvent ที่ต้องแก้ไข (ถ้าล็อคหัวไม่ทำงาน) 🔥
local FIRE_REMOTE_NAME = "FireBullet" 
local OriginalFireRemote = nil

-- --- GUI SETUP (ปรับปรุง) ---

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateWarHack"
ScreenGui.ResetOnSpawn = false -- สำคัญมาก: เพื่อให้ GUI ไม่ถูกล้างเมื่อตาย

-- พยายาม Parent ไปยัง CoreGui หรือ PlayerGui (วิธีที่เสถียรที่สุด)
if getgenv().gethui then 
    ScreenGui.Parent = getgenv().gethui() 
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.01, 0, 0.65, 0) -- มุมซ้ายล่าง
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
    
    if getgenv().AIMBOT_ACTIVE and not OriginalFireRemote then
         game.StarterGui:SetCore("SendNotification", {Title = "AIMBOT WARNING"; Text = "Hook ล้มเหลว! ต้องแก้ชื่อ RemoteEvent.", Duration = 4;})
         AimbotToggle.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    end
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

-- [ SILENT AIM และ ESP LOGIC ส่วนที่เหลือเหมือนเดิม ]
-- ... (โค้ด Silent Aim และ ESP ที่ผมให้ไปก่อนหน้าจะถูกรวมอยู่ด้านล่างนี้) ...

-- ----------------------------------------------------
--           CORE AIMBOT & ESP LOGIC (omitted for brevity)
-- ----------------------------------------------------

local ESPFolder = Instance.new("Folder", ScreenGui)
ESPFolder.Name = "ESPDrawings"

local function GetTarget()
    -- Target finding logic (same as before)
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
                local Direction = (HeadPosition - Camera.CFrame.Position).Unit 
                
                local Args = {...}
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


local function DrawESP(player)
    local Character = player.Character
    if not Character or not getgenv().ESP_ACTIVE then 
        -- ลบ ESP เดิมเมื่อปิด
        for _, item in pairs(ESPFolder:GetChildren()) do
            if item.Name == player.Name or item.Name == player.Name .. "Tracer" then item:Destroy() end
        end
        return 
    end
    
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    local Head = Character:FindFirstChild("Head")
    
    if not HRP or not Head then return end
    
    local RootPos = HRP.Position
    local RootScreen, RootVisible = Camera:WorldToViewportPoint(RootPos)
    local HeadScreen, HeadVisible = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 1.5, 0)) 
    
    if not RootVisible then return end
    
    local Color = player.Team and (player.Team ~= LocalPlayer.Team and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 255)) or Color3.fromRGB(255, 255, 0)
    local BoxHeight = math.abs(HeadScreen.Y - RootScreen.Y)
    local BoxWidth = BoxHeight / 2.5
    local BoxCenter = Vector2.new(RootScreen.X, RootScreen.Y)
    local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - RootPos).Magnitude
    
    -- ลบ ESP เดิมของ Player นี้ก่อนวาดใหม่
    for _, item in pairs(ESPFolder:GetChildren()) do
        if item.Name == player.Name or item.Name == player.Name .. "Tracer" then item:Destroy() end
    end
    
    -- 1. Box ESP
    local Box = Instance.new("Frame", ESPFolder)
    Box.Name = player.Name
    Box.Size = UDim2.new(0, BoxWidth, 0, BoxHeight)
    Box.Position = UDim2.new(0, BoxCenter.X - BoxWidth / 2, 0, BoxCenter.Y - BoxHeight)
    Box.BackgroundTransparency = 1
    Box.BorderSizePixel = 1
    Box.BorderColor3 = Color
    
    -- 2. Name & Distance ESP
    local NameLabel = Instance.new("TextLabel", Box)
    NameLabel.Size = UDim2.new(1, 0, 0, 15)
    NameLabel.Position = UDim2.new(0, 0, 1, 0)
    NameLabel.Text = player.Name .. " [" .. math.floor(Distance) .. "m]"
    NameLabel.TextColor3 = Color
    NameLabel.TextScaled = true
    NameLabel.BackgroundTransparency = 1
    
    -- 3. Health Bar ESP
    local HealthFrame = Instance.new("Frame", Box)
    HealthFrame.Size = UDim2.new(0, 5, 1, 0)
    HealthFrame.Position = UDim2.new(1, 2, 0, 0)
    HealthFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    local HealthFill = Instance.new("Frame", HealthFrame)
    local HealthPercentage = Character.Humanoid.Health / 100
    HealthFill.Size = UDim2.new(1, 0, HealthPercentage, 0)
    HealthFill.Position = UDim2.new(0, 0, 1 - HealthPercentage, 0)
    HealthFill.BackgroundColor3 = HealthPercentage > 0.5 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)
    
    -- 4. Tracer Line
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

local function MainLoop()
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 then
                DrawESP(player)
            end
        end
    end)
end

-- --- INITIALIZATION (เริ่มต้น) ---

-- 1. Hook Silent Aim
pcall(function()
    local Remote = game:GetService("ReplicatedStorage"):FindFirstChild(FIRE_REMOTE_NAME, true) or workspace:FindFirstChild(FIRE_REMOTE_NAME, true)
    
    if Remote and getgenv().hookfunction then
        OriginalFireRemote = getgenv().hookfunction(Remote.FireServer, SilentAimHook)
    end
end)

-- 2. Start ESP Loop
RunService.Heartbeat:Connect(MainLoop)

game.StarterGui:SetCore("SendNotification", {
    Title = "Ultimate War Hack Loaded";
    Text = "เมนูอยู่ที่มุมซ้ายล่าง! (ESP ทำงานแล้ว)",
    Duration = 5;
})
