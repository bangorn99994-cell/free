-- Variables
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- Function to highlight a button
local function highlightButton(button)
    local highlight = Instance.new("Highlight")
    highlight.Parent = button
    highlight.FillColor = Color3.new(1, 1, 0) -- Yellow color
    highlight.OutlineColor = Color3.new(1, 0, 0) -- Red outline
end

-- Function for aimbot
local function aimbot()
    local target = nil

    -- Function to find the closest enemy
    local function getClosestEnemy()
        local closestDistance = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    target = v
                end
            end
        end
        return target
    end

    -- Aim towards the closest enemy
    RS.RenderStepped:Connect(function()
        target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(target.Character.HumanoidRootPart.Position + Vector3.new(0, 0, -5))
        end
    end)
end

-- Function for flying
local flying = false
local bodyVelocity

local function fly()
    if not flying then
        flying = true
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 50, 0) -- Ascend speed
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Parent = humanoidRootPart
        
        -- Control flying with WASD
        RS.RenderStepped:Connect(function()
            if flying then
                local direction = Vector3.new(0, 0, 0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + workspace.CurrentCamera.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - workspace.CurrentCamera.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - workspace.CurrentCamera.CFrame.RightVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + workspace.CurrentCamera.CFrame.RightVector
                end
                bodyVelocity.Velocity = direction * 50 -- Adjust flying speed here
            end
        end)
    else
        flying = false
        bodyVelocity:Destroy()
    end
end

-- Example usage
local button = script.Parent -- Assuming this script is a child of a GUI button
highlightButton(button)

button.MouseButton1Click:Connect(function()
    aimbot() -- Activate aimbot
    fly() -- Allow flying
end)
