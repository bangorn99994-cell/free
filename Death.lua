-- LocalScript ตัวอย่าง: ระบบบิน + GUI Panel
-- ต้องวางใน StarterPlayerScripts หรือ StarterGui

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- สร้าง GUI Panel
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.8, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(1, -20, 0, 40)
FlyButton.Position = UDim2.new(0, 10, 0, 30)
FlyButton.Text = "Toggle Fly"
FlyButton.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
FlyButton.TextColor3 = Color3.new(1,1,1)
FlyButton.Parent = Frame

-- ตัวแปรสถานะบิน
local flying = false
local speed = 50

-- ฟังก์ชันเริ่มบิน
local function startFlying()
    flying = true
    RunService.RenderStepped:Connect(function()
        if flying then
            local moveDirection = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + HumanoidRootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - HumanoidRootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - HumanoidRootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + HumanoidRootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0,1,0)
            end

            HumanoidRootPart.Velocity = moveDirection * speed
        end
    end)
end

-- ฟังก์ชันหยุดบิน
local function stopFlying()
    flying = false
    HumanoidRootPart.Velocity = Vector3.new(0,0,0)
end

-- ปุ่ม Toggle
FlyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFlying()
        FlyButton.Text = "Toggle Fly"
    else
        startFlying()
        FlyButton.Text = "Flying..."
    end
end)
