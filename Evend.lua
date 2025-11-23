local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
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

-- ฟังก์ชันสำหรับบิน
local function toggleFly()
    if not isFlying then
        -- เริ่มบิน
        isFlying = true
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        flyButton.Text = "หยุดบิน"
        
        -- ลบ humanoid gravity
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        -- สร้าง BodyVelocity เพื่อควบคุมการบิน
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = humanoidRootPart
        
        -- ฟังก์ชันอัปเดตการบิน
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not isFlying or not bodyVelocity then
                connection:Disconnect()
                return
            end
            
            local speed = 50
            local moveDirection = Vector3.new(0, 0, 0)
            
            -- ควบคุมการเคลื่อนที่
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + (humanoidRootPart.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - (humanoidRootPart.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - (humanoidRootPart.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + (humanoidRootPart.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            bodyVelocity.Velocity = moveDirection.Unit * speed
        end)
    else
        -- หยุดบิน
        isFlying = false
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        flyButton.Text = "บิน"
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- เชื่อมต่อปุ่ม
flyButton.MouseButton1Click:Connect(toggleFly)

-- ล้างขณะที่ผู้เล่นตายหรือทำให้เกิดใหม่
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    isFlying = false
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    flyButton.Text = "บิน"
end)