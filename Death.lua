-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ฟังก์ชันวาร์ปไปยังตำแหน่งที่กำหนด
local function teleportTo(position)
    HRP.CFrame = CFrame.new(position)
end

-- ฟังก์ชันหายตัว (โปร่งใส)
local function setInvisible(state)
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = state and 1 or 0
        end
    end
end

-- ฟังก์ชันสร้าง Highlight (มองทะลุ)
local function createHighlight(targetCharacter, color)
    if targetCharacter:FindFirstChild("Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = color or Color3.fromRGB(0,255,0)
    highlight.OutlineColor = Color3.fromRGB(0,0,0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = targetCharacter
end

-- ลงทะเบียนผู้เล่นอื่น
local function registerPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createHighlight(player.Character, Color3.fromRGB(255,0,0)) -- สีแดง
        end
    end
end

-- เรียกใช้งานฟังก์ชันต่าง ๆ
-- วาร์ปไปยังตำแหน่ง (10,5,10)
teleportTo(Vector3.new(10,5,10))

-- เปิดหายตัว
setInvisible(true)

-- สร้าง Highlight ให้ผู้เล่นอื่น
registerPlayers()

-- อัปเดตทุกเฟรม (Run Delta)
RunService.RenderStepped:Connect(function(delta)
    -- ตัวอย่าง: ทำให้ Highlight เรืองแสงเมื่อผู้เล่นอื่นวิ่ง
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            local highlight = player.Character:FindFirstChild("Highlight")
            if highlight then
                if humanoid.MoveDirection.Magnitude > 0 then
                    highlight.FillTransparency = 0.2
                else
                    highlight.FillTransparency = 0.5
                end
            end
        end
    end
end)
