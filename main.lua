--// Orion Library Loader (Delta Compatible)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Universal Hub | Delta Version", HidePremium = false, IntroEnabled = false})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--// MAIN TAB
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998"
})

--// AIMBOT SETTINGS
local AimbotEnabled = false
local Smoothness = 0.15
local LockPart = "Head"

local function getClosestTarget()
    local closest, dist = nil, math.huge
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local part = plr.Character:FindFirstChild(LockPart)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    
                    if distance < dist then
                        dist = distance
                        closest = part
                    end
                end
            end
        end
    end
    
    return closest
end

--// AIMBOT LOOP
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestTarget()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, target.Position),
                Smoothness
            )
        end
    end
end)

--// UI: AIMBOT TOGGLE
MainTab:AddToggle({
    Name = "Aimbot (Head Lock)",
    Default = false,
    Callback = function(v)
        AimbotEnabled = v
    end
})

--// UI: Smoothness
MainTab:AddSlider({
    Name = "Smoothness",
    Min = 0,
    Max = 1,
    Default = 0.15,
    Increment = 0.01,
    Callback = function(value)
        Smoothness = value
    end
})

--// UI: Lock Part Dropdown
MainTab:AddDropdown({
    Name = "Target Part",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    Default = "Head",
    Callback = function(text)
        LockPart = text
    end
})

OrionLib:Init()
