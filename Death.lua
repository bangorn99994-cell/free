local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- GUI Panel
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToolPanelGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0,220,0,300)
ScrollingFrame.Position = UDim2.new(0,10,0.7,0)
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,800)
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

-- ปุ่ม ESP
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

-- ปุ่ม Invisible
local InvisButton = makeButton("Toggle Invisible")
local invisRemote = ReplicatedStorage:WaitForChild("InvisibleControl")
local invisEnabled = false

InvisButton.MouseButton1Click:Connect(function()
    invisEnabled = not invisEnabled
    invisRemote:FireServer(invisEnabled)
    InvisButton.Text = invisEnabled and "Invisible ON" or "Invisible OFF"
end)

-- ปุ่ม Teleport
local TeleportButton = makeButton("Teleport (10,5,10)")
TeleportButton.MouseButton1Click:Connect(function()
    HRP.CFrame = CFrame.new(10,5,10)
end)

-- ช่องกรอกค่า Speed
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -12, 0, 40)
SpeedBox.Text = "16"
SpeedBox.Font = Enum.Font.SourceSansBold
SpeedBox.TextSize = 18
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.BackgroundColor3 = Color3.fromRGB(80,80,80)
SpeedBox.BorderSizePixel = 0
SpeedBox.Parent = ScrollingFrame

-- ปุ่ม Speed Hack
local SpeedButton = makeButton("Apply Speed")
SpeedButton.MouseButton1Click:Connect(function()
    local newSpeed = tonumber(SpeedBox.Text) or 16
    if newSpeed > 500 then newSpeed = 500 end
    Humanoid.WalkSpeed = newSpeed
    SpeedButton.Text = "Speed = "..newSpeed
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
