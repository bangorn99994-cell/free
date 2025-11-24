local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DraggablePanelGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- สร้าง Frame สำหรับ Panel
local panel = Instance.new("Frame")
panel.Name = "DragPanel"
panel.Size = UDim2.new(0, 300, 0, 200)
panel.Position = UDim2.new(0.5, -150, 0.5, -100) -- กึ่งกลางจอ
panel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
panel.BorderSizePixel = 0
panel.Parent = screenGui

-- ทำให้มุมโค้งมน (UICorner)
local uiCorner = Instance.new("UICorner")
uiCorner.Parent = panel

-- สร้างปุ่มล็อคหัว
local lockHeadButton = Instance.new("TextButton")
lockHeadButton.Size = UDim2.new(0, 100, 0, 50)
lockHeadButton.Position = UDim2.new(0.5, -50, 0.5, -25)
lockHeadButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
lockHeadButton.Text = "Lock Head"
lockHeadButton.Parent = panel

-- ฟังก์ชันล็อคหัว
local function lockHead(targetPosition)
    local hrp = character:WaitForChild("HumanoidRootPart")
    local head = character:WaitForChild("Head")

    -- สร้าง BodyGyro
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 10000
    bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    -- ลูปการหมุนหัว
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if character and character:FindFirstChild("Head") then
            -- คำนวณทิศทางที่หัวควรหันไป
            local direction = (targetPosition - head.Position).unit
            local lookAtCFrame = CFrame.new(head.Position, head.Position + direction)

            bodyGyro.CFrame = lookAtCFrame
        else
            connection:Disconnect() -- หยุดการหมุนถ้าตัวละครหายไป
            bodyGyro:Destroy() -- ทำลาย BodyGyro
        end
    end)
end

-- ฟังก์ชันเพื่อเริ่มล็อคหัว
lockHeadButton.MouseButton1Click:Connect(function()
    local targetPosition = Vector3.new(0, 10, 0) -- เปลี่ยนเป็นตำแหน่งที่ต้องการ
    lockHead(targetPosition)
end)

-- ฟังก์ชันให้เลื่อน Panel
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

panel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
