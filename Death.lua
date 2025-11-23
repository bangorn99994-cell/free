-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ตัวแปรควบคุม
local flying = false
local speed = 50
local direction = Vector3.new(0,0,0)

-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0,150,0,50)
FlyButton.Position = UDim2.new(0.5,-75,0.8,0)
FlyButton.Text = "Toggle Fly"
FlyButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
FlyButton.TextColor3 = Color3.new(1,1,1)
FlyButton.Font = Enum.Font.SourceSansBold
FlyButton.TextSize = 24
FlyButton.Parent = ScreenGui

-- ฟังก์ชันเปิด/ปิดบิน
local function startFlying()
    flying = true
    Humanoid.PlatformStand = true
    FlyButton.Text = "Stop Fly"
    FlyButton.BackgroundColor3 = Color3.fromRGB(255,100,100)
end

local function stopFlying()
    flying = false
    Humanoid.PlatformStand = false
    HRP.Velocity = Vector3.new(0,0,0)
    FlyButton.Text = "Toggle Fly"
    FlyButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
end

-- กดปุ่มบนมือถือ
FlyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFlying()
    else
        startFlying()
    end
end)

-- อัปเดตการบินทุกเฟรม
RunService.RenderStepped:Connect(function()
    if flying then
        direction = Vector3.new(0,0,0)

        -- ควบคุมด้วยปุ่ม WASD (ถ้าเล่นบน PC)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction + Vector3.new(0,-1,0)
        end

        -- บังคับความเร็ว
        if direction.Magnitude > 0 then
            HRP.Velocity = direction.Unit * speed
        else
            HRP.Velocity = Vector3.new(0,0,0)
        end
    end
end)
