-- ############################################################
-- ServerScript (วางใน ServerScriptService)
-- ############################################################
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent สำหรับ Invisible
local invisRemote = Instance.new("RemoteEvent")
invisRemote.Name = "InvisibleControl"
invisRemote.Parent = ReplicatedStorage

-- ฟังก์ชันหายตัวจริง ๆ
local function setInvisible(character, state)
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = state and 1 or 0
            part.CanCollide = not state
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = state and 1 or 0
        end
    end
end

-- เมื่อมีการเรียกจาก RemoteEvent
invisRemote.OnServerEvent:Connect(function(player, toggle)
    if player.Character then
        setInvisible(player.Character, toggle)
    end
end)

-- ############################################################
-- LocalScript (วางใน StarterPlayerScripts)
-- ############################################################
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- GUI Panel
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToolPanelGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0,220,0,400)
ScrollingFrame.Position = UDim2.new(0,10,0.6,0)
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,1200)
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
ScrollingFrame.Parent = ScreenGui

local uiList = Instance.new("UIListLayout")
uiList.Parent = ScrollingFrame
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,8)

-- ฟังก์ชันสร้างปุ่ม
local function makeButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 40)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.BorderSizePixel = 0
    btn.Parent = ScrollingFrame
    return btn
end

-- ESP
local EspButton = makeButton("Toggle ESP")
local espEnabled = false
local function createHighlight(character)
    if character and not character:FindFirstChild("Highlight") then
        local h = Instance.new("Highlight")
        h.FillColor = Color3.fromRGB(0,255,0)
        h.OutlineColor = Color3.fromRGB(0,0,0)
        h.Parent = character
    end
end
EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspButton.Text = espEnabled and "ESP ON" or "ESP OFF"
    if not espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Highlight")
                if h then h:Destroy() end
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                createHighlight(p.Character)
            end
        end
    end
end)

-- Invisible
local InvisButton = makeButton("Toggle Invisible")
local invisRemote = ReplicatedStorage:WaitForChild("InvisibleControl")
local invisEnabled = false
InvisButton.MouseButton1Click:Connect(function()
    invisEnabled = not invisEnabled
    invisRemote:FireServer(invisEnabled)
    InvisButton.Text = invisEnabled and "Invisible ON" or "Invisible OFF"
end)

-- Teleport
local TeleportButton = makeButton("Teleport (10,5,10)")
TeleportButton.MouseButton1Click:Connect(function()
    HRP.CFrame = CFrame.new(10,5,10)
end)

-- Speed Hack
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -12, 0, 40)
SpeedBox.Text = "16"
SpeedBox.Font = Enum.Font.SourceSansBold
SpeedBox.TextSize = 18
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.BackgroundColor3 = Color3.fromRGB(80,80,80)
SpeedBox.BorderSizePixel = 0
SpeedBox.Parent = ScrollingFrame

local SpeedButton = makeButton("Apply Speed")
SpeedButton.MouseButton1Click:Connect(function()
    local newSpeed = tonumber(SpeedBox.Text) or 16
    if newSpeed > 500 then newSpeed = 500 end
    Humanoid.WalkSpeed = newSpeed
    SpeedButton.Text = "Speed = "..newSpeed
end)

-- Fly Mode
local FlyButton = makeButton("Toggle Fly")
local flying = false
local flySpeed = 50
FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    FlyButton.Text = flying and "Fly ON" or "Fly OFF"
end)

RunService.RenderStepped:Connect(function()
    if flying and HRP then
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0,0,-1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0,0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-1,0,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(1,0,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0,-1,0) end
        HRP.Velocity = moveDir * flySpeed
    end
end)

-- อัปเดต ESP ทุกเฟรม
RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                local humanoid = p.Character.Humanoid
                local h = p.Character:FindFirstChild("Highlight")
                if h then
                    h.FillTransparency = humanoid.MoveDirection.Magnitude > 0 and 0.2 or 0.5
                end
            end
        end
    end
end)
