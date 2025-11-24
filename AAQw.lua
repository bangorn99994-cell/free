-- Fly Script for Delta (Mobile Friendly GUI)
-- เขียนโดย AI Assistant

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- การตั้งค่าความเร็ว
local flySpeed = 50
local flying = false
local bv, bg

-- สร้างหน้าจอ GUI (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui_Delta"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- สร้างปุ่ม (TextButton)
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Parent = screenGui
flyButton.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
flyButton.BorderSizePixel = 0
flyButton.Position = UDim2.new(0.8, 0, 0.4, 0)
flyButton.Size = UDim2.new(0, 60, 0, 60)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.Text = "FLY: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 50, 50)
flyButton.TextSize = 14

-- ฟังก์ชันเริ่มบิน (Start Flying)
local function startFly()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart

    -- สร้าง BodyGyro และ BodyVelocity
    bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp

    -- ปิดการเคลื่อนไหวของ Humanoid
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = true
    end

    flying = true
    flyButton.Text = "FLY: ON"
    flyButton.TextColor3 = Color3.fromRGB(50, 255, 50)

    -- ลูปการทำงานขณะบิน
    task.spawn(function()
        while flying and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 do
            local moveDir = Vector3.new()

            -- การควบคุมด้วย WASD หรือ ARROW KEY
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camera.CFrame.RightVector
            end

            -- การควบคุมความสูง
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                bv.Velocity = Vector3.new(moveDir.X * flySpeed, flySpeed, moveDir.Z * flySpeed)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                bv.Velocity = Vector3.new(moveDir.X * flySpeed, -flySpeed, moveDir.Z * flySpeed)
            else
                bv.Velocity = Vector3.new(moveDir.X * flySpeed, 0, moveDir.Z * flySpeed)
            end

            bg.CFrame = camera.CFrame
            RunService.RenderStepped:Wait()
        end
        stopFly()
    end)
end

-- ฟังก์ชันหยุดบิน (Stop Flying)
local function stopFly()
    flying = false
    flyButton.Text = "FLY: OFF"
    flyButton.TextColor3 = Color3.fromRGB(255, 50, 50)

    if bg then bg:Destroy() bg = nil end
    if bv then bv:Destroy() bv = nil end

    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false -- เปิดการเคลื่อนไหวอีกครั้ง
    end
end

-- การทำงานเมื่อกดปุ่ม
flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

-- รีเซ็ตเมื่อตัวละครตาย
player.CharacterAdded:Connect(function()
    stopFly()
end)
