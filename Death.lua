local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- GUI Panel เลื่อนได้
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0,220,0,200)
ScrollingFrame.Position = UDim2.new(0,10,0.7,0)
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,400)
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
ScrollingFrame.Parent = ScreenGui

-- ปุ่ม ESP
local EspButton = Instance.new("TextButton")
EspButton.Size = UDim2.new(0,200,0,40)
EspButton.Position = UDim2.new(0,10,0,10)
EspButton.Text = "Toggle ESP"
EspButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
EspButton.TextColor3 = Color3.new(1,1,1)
EspButton.Font = Enum.Font.SourceSansBold
EspButton.TextSize = 20
EspButton.Parent = ScrollingFrame

-- ปุ่ม Invisible
local InvisButton = Instance.new("TextButton")
InvisButton.Size = UDim2.new(0,200,0,40)
InvisButton.Position = UDim2.new(0,10,0,60)
InvisButton.Text = "Toggle Invisible"
InvisButton.BackgroundColor3 = Color3.fromRGB(255,100,100)
InvisButton.TextColor3 = Color3.new(1,1,1)
InvisButton.Font = Enum.Font.SourceSansBold
InvisButton.TextSize = 20
InvisButton.Parent = ScrollingFrame

-- ปุ่ม Teleport
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0,200,0,40)
TeleportButton.Position = UDim2.new(0,10,0,110)
TeleportButton.Text = "Teleport (10,5,10)"
TeleportButton.BackgroundColor3 = Color3.fromRGB(100,255,100)
TeleportButton.TextColor3 = Color3.new(0,0,0)
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.TextSize = 20
TeleportButton.Parent = ScrollingFrame

-- ตัวแปรสถานะ
local espEnabled = false
local invisEnabled = false

-- ฟังก์ชันสร้าง Highlight
local function createHighlight(character)
    if character:FindFirstChild("Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0,255,0)
    highlight.OutlineColor = Color3.fromRGB(0,0,0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = character
end

-- ESP Toggle
EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        EspButton.Text = "ESP ON"
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= LocalPlayer and other.Character then
                createHighlight(other.Character)
            end
        end
    else
        EspButton.Text = "ESP OFF"
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= LocalPlayer and other.Character then
                local h = other.Character:FindFirstChild("Highlight")
                if h then h:Destroy() end
            end
        end
    end
end)

-- Invisible Toggle (ส่งไป Server)
local invisRemote = ReplicatedStorage:WaitForChild("InvisibleControl")
InvisButton.MouseButton1Click:Connect(function()
    invisEnabled = not invisEnabled
    invisRemote:FireServer(invisEnabled)
    InvisButton.Text = invisEnabled and "Invisible ON" or "Invisible OFF"
end)

-- Teleport Button
TeleportButton.MouseButton1Click:Connect(function()
    HRP.CFrame = CFrame.new(Vector3.new(10,5,10))
end)

-- อัปเดตทุกเฟรม (ESP)
RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("Humanoid") then
                local humanoid = other.Character.Humanoid
                local highlight = other.Character:FindFirstChild("Highlight")
                if highlight then
                    if humanoid.MoveDirection.Magnitude > 0 then
                        highlight.FillTransparency = 0.2
                    else
                        highlight.FillTransparency = 0.5
                    end
                end
            end
        end
    end
end)
