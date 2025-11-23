local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlightGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- สร้าง Panel (Frame)
local panel = Instance.new("Frame")
panel.Name = "FlightPanel"
panel.Size = UDim2.new(0, 200, 0, 100)
panel.Position = UDim2.new(0.5, -100, 0.1, 0)
panel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
panel.BorderSizePixel = 0
panel.Parent = screenGui

-- ปรับขอบของ Panel
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = panel

-- สร้างปุ่มบิน
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0, 180, 0, 50)
flyButton.Position = UDim2.new(0, 10, 0, 20)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 18
flyButton.Font = Enum.Font.GothamBold
flyButton.Text = "บิน"
flyButton.BorderSizePixel = 0
flyButton.Parent = panel

-- ปรับขอบของปุ่ม
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = flyButton

local isFlying = false
local bodyVelocity
local bodyGyro
local flyConnection

-- ฟังก์ชันสำหรับบิน
local function startFlying()
    isFlying = true
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    flyButton.Text = "หยุดบิน"
    
    humanoid.PlatformStand = true
    
    -- ลบ BodyVelocity/BodyGyro เก่า
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    if bodyGyro then
        bodyGyro:Destroy()
    end
    
    -- สร้าง BodyVelocity
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Drag = 0
    bodyVelocity.Parent = humanoidRootPart
    
    -- สร้าง BodyGyro เพื่อควบคุมการหมุน
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.Parent = humanoidRootPart
    
    -- ฟังก์ชันอัปเดตการบิน
    if flyConnection then
        flyConnection:Disconnect()
    end
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not bodyVelocity or not bodyGyro then
            return
        end
        
        local speed = 50
        local moveDirection = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        
        -- ควบคุมการเคลื่อนที่
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (camera.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (camera.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (camera.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (camera.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            bodyVelocity.Velocity = moveDirection.Unit * speed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        bodyGyro.CFrame = camera.CFrame
    end)
end

-- ฟังก์ชันหยุดบิน
local function stopFlying()
    isFlying = false
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    flyButton.Text = "บิน"
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    humanoid.PlatformStand = false
end

-- เชื่อมต่อปุ่ม
flyButton.MouseButton1Click:Connect(function()
    if isFlying then
        stopFlying()
    else
        startFlying()
    end
end)

-- ล้างขณะที่ผู้เล่นตายหรือทำให้เกิดใหม่
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    stopFlying()
    
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    flyButton.Text = "บิน"
end)
