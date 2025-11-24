-- Fly Script for Delta (Mobile Friendly GUI)
-- เขียนโดย AI Assistant

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- การตั้งค่าความเร็ว
local flySpeed = 50
local flying = false
local bv, bg

-- สร้างหน้าจอ GUI (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui_Delta"
-- พยายามใส่ใน CoreGui เพื่อความปลอดภัย หรือใส่ใน PlayerGui ถ้า Executor บล็อก
if pcall(function() screenGui.Parent = CoreGui end) then
    screenGui.Parent = CoreGui
else
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- สร้างปุ่ม (TextButton)
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Parent = screenGui
flyButton.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
flyButton.BorderSizePixel = 0
flyButton.Position = UDim2.new(0.8, 0, 0.4, 0) -- ตำแหน่งปุ่ม (ขวาเกือบกลาง)
flyButton.Size = UDim2.new(0, 60, 0, 60) -- ขนาดปุ่ม
flyButton.Font = Enum.Font.SourceSansBold
flyButton.Text = "FLY: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 50, 50)
flyButton.TextSize = 14
flyButton.LayerCollector.IgnoreGuiInset = true

-- ทำให้ปุ่มมุมโค้งมน (UICorner)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = flyButton

-- ฟังก์ชันเริ่มบิน (Start Flying)
local function startFly()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    -- สร้าง BodyGyro เพื่อพยุงตัว
    bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = hrp.CFrame
    bg.Parent = hrp
    
    -- สร้าง BodyVelocity เพื่อเคลื่อนที่
    bv = Instance.new("BodyVelocity")
    bv.velocity = Vector3.new(0, 0, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp
    
    flying = true
    flyButton.Text = "FLY: ON"
    flyButton.TextColor3 = Color3.fromRGB(50, 255, 50)
    
    -- ลูปการทำงานขณะบิน
    task.spawn(function()
        while flying and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 do
            local moveDir = Vector3.new()
            local camCFrame = camera.CFrame
            
            -- การควบคุมสำหรับมือถือ (บินไปตามทิศที่กล้องหัน + การเดินของตัวละคร)
            -- ถ้ามีการขยับ MoveDirection (จอยสติ๊ก)
            if char.Humanoid.MoveDirection.Magnitude > 0 then
                moveDir = char.Humanoid.MoveDirection * flySpeed
            else
                moveDir = Vector3.new(0, 0, 0)
            end
            
            bg.cframe = camCFrame
            bv.velocity = moveDir + (camCFrame.LookVector * (char.Humanoid.MoveDirection.Magnitude > 0 and 0 or 0)) 
            -- ปรับแต่ง: บินตามจอยสติ๊ก ถ้าไม่กดเดินจะหยุดนิ่ง
            
            RunService.RenderStepped:Wait()
        end
        stopFly()
    end)
end

-- ฟังก์ชันหยุดบิน (Stop Flying)
function stopFly()
    flying = false
    flyButton.Text = "FLY: OFF"
    flyButton.TextColor3 = Color3.fromRGB(255, 50, 50)
    
    if bg then bg:Destroy() bg = nil end
    if bv then bv:Destroy() bv = nil end
    
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
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

-- ทำให้ปุ่มลากไปมาได้ (Draggable)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    flyButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

flyButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = flyButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

flyButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
