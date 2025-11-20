-- Simple UI Panel Example (Safe & For Study)
-- This script creates a draggable panel with working buttons

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Main Panel
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 220, 0, 150)
Panel.Position = UDim2.new(0.5, -110, 0.5, -75)
Panel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Panel.Active = true
Panel.Draggable = true
Panel.Parent = ScreenGui

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 32)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "My Panel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Parent = Panel

-- Button 1: Message
local Btn1 = Instance.new("TextButton")
Btn1.Size = UDim2.new(1, -20, 0, 30)
Btn1.Position = UDim2.new(0, 10, 0, 45)
Btn1.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn1.Text = "Show Message"
Btn1.Parent = Panel

Btn1.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Panel";
        Text = "Button Clicked!";
        Duration = 2;
    })
end)

-- Button 2: Change Color
local Btn2 = Instance.new("TextButton")
Btn2.Size = UDim2.new(1, -20, 0, 30)
Btn2.Position = UDim2.new(0, 10, 0, 80)
Btn2.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn2.Text = "Change Panel Color"
Btn2.Parent = Panel

Btn2.MouseButton1Click:Connect(function()
    Panel.BackgroundColor3 = Color3.fromRGB(
        math.random(50, 255),
        math.random(50, 255),
        math.random(50, 255)
    )
end)

-- Button 3: Hide Panel
local Btn3 = Instance.new("TextButton")
Btn3.Size = UDim2.new(1, -20, 0, 30)
Btn3.Position = UDim2.new(0, 10, 0, 115)
Btn3.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn3.Text = "Hide / Show"
Btn3.Parent = Panel

local hidden = false

Btn3.MouseButton1Click:Connect(function()
    hidden = not hidden
    for _, v in pairs(Panel:GetChildren()) do
        if v ~= Title and v:IsA("GuiObject") then
            v.Visible = not hidden
        end
    end
end)
