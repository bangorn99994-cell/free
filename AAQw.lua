local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- การตั้งค่าความเร็ว
local flySpeed = 40
local ascendSpeed = 20
local flying = false
local bv, bg

-- ฟังก์ชันเริ่มบิน (Start Flying)
local function startFly()
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- สร้าง BodyGyro และ BodyVelocity
    bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp

    flying = true

    -- ลูปการทำงานขณะบิน
    task.spawn(function()
        while flying and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 do
            local moveDir = Vector3.new(0, 0, 0)

            -- การควบคุมด้วย WASD หรือ ARROW KEY
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + character.PrimaryPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - character.PrimaryPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - character.PrimaryPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + character.PrimaryPart.CFrame.RightVector
            end

            -- การควบคุมความสูง
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                bv.Velocity = Vector3.new(moveDir.X * flySpeed, ascendSpeed, moveDir.Z * flySpeed)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                bv.Velocity = Vector3.new(moveDir.X * flySpeed, -ascendSpeed, moveDir.Z * flySpeed)
            else
                bv.Velocity = Vector3.new(moveDir.X * flySpeed, 0, moveDir.Z * flySpeed)
            end

            bg.CFrame = hrp.CFrame
            RunService.RenderStepped:Wait()
        end
        stopFly()
    end)
end

-- ฟังก์ชันหยุดบิน (Stop Flying)
local function stopFly()
    flying = false
    if bg then bg:Destroy() bg = nil end
    if bv then bv:Destroy() bv = nil end
end

-- การทำงานเมื่อกดปุ่ม (เช่น ปุ่มเพื่อเริ่ม/หยุดบิน)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F then
            if flying then
                stopFly()
            else
                startFly()
            end
        end
    end
end)

-- รีเซ็ตเมื่อตัวละครตาย
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    stopFly()
end)
