-- Speed + Infinite Jump GUI (สั้นมาก ลากได้ 100% Delta)
-- ปุ่มฟ้ามุมขวาล่าง → Panel: Speed Slider + ON/OFF Speed + ON/OFF Jump

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local MaxSpeed=500; local MinSpeed=16; local SpeedVal=50; local SpeedOn=false; local JumpOn=false

local SG=Instance.new("ScreenGui",Player.PlayerGui); SG.Name="HackV3"; SG.ResetOnSpawn=false

-- ปุ่มเปิด (ชัดเจนมุมขวาล่าง)
local Open=Instance.new("TextButton",SG); Open.Size=UDim2.new(0,140,0,45); Open.Position=UDim2.new(1,-155,1,-60)
Open.BG=Color3.fromRGB(0,170,255); Open.Text="🚀 Speed+Jump"; Open.TextColor3=Color3.new(1,1,1); Open.Font=Enum.Font.GothamBold; Open.TextSize=16
local OC=Instance.new("UICorner",Open); OC.CornerRadius=UDim.new(0,10)

-- Panel หลัก (ลากได้)
local Panel=Instance.new("Frame",SG); Panel.Size=UDim2.new(0,300,0,160); Panel.Position=UDim2.new(0.5,-150,0.5,-80); Panel.Visible=false; Panel.Active=true; Panel.Draggable=true
Panel.BG=Color3.fromRGB(25,25,35); Panel.BorderSizePixel=2; Panel.BorderColor3=Color3.fromRGB(0,255,200)
local PC=Instance.new("UICorner",Panel); PC.CornerRadius=UDim.new(0,12)

-- Title
local Title=Instance.new("TextLabel",Panel); Title.Size=UDim2.new(1,0,0,35); Title.BG=Color3.new(0,0,0); Title.Text="⚡ SPEED + JUMP HACK ⚡"; Title.TextColor3=Color3.fromRGB(0,255,200); Title.Font=Enum.Font.GothamBold; Title.TextSize=18

-- ปิด Panel
local Close=Instance.new("TextButton",Panel); Close.Size=UDim2.new(0,30,0,30); Close.Position=UDim2.new(1,-35,0,2.5); Close.BG=Color3.fromRGB(255,80,80); Close.Text="X"; Close.TextColor3=Color3.new(1,1,1); Close.Font=Enum.Font.GothamBold; Close.TextSize=18; local CC=Instance.new("UICorner",Close); CC.CornerRadius=UDim.new(1,0)

-- Speed Label + Slider
local SLabel=Instance.new("TextLabel",Panel); SLabel.Size=UDim2.new(1,-40,0,25); SLabel.Position=UDim2.new(0,20,0,40); SLabel.BG=0; SLabel.Text="Speed: 50"; SLabel.TextColor3=Color3.new(1,1,1); SLabel.Font=Enum.Font.Gotham; SLabel.TextSize=16
local SBG=Instance.new("Frame",Panel); SBG.Size=UDim2.new(1,-40,0,25); SBG.Position=UDim2.new(0,20,0,70); SBG.BG=Color3.fromRGB(50,50,60); local SBC=Instance.new("UICorner",SBG); SBC.CornerRadius=UDim.new(0,8)
local SFill=Instance.new("Frame",SBG); SFill.Size=UDim2.new(0.07,0,1,0); SFill.BG=Color3.fromRGB(0,255,200); local SFC=Instance.new("UICorner",SFill); SFC.CornerRadius=UDim.new(0,8)
local Knob=Instance.new("TextButton",SFill); Knob.Size=UDim2.new(0,28,0,28); Knob.Position=UDim2.new(0,-14,0,-14); Knob.BG=Color3.new(1,1,1); Knob.Text=""; local KC=Instance.new("UICorner",Knob); KC.CornerRadius=UDim.new(1,0)

-- Toggle Speed
local TSpeed=Instance.new("TextButton",Panel); TSpeed.Size=UDim2.new(0,80,0,35); TSpeed.Position=UDim2.new(0,20,1,-45); TSpeed.BG=Color3.fromRGB(255,80,80); TSpeed.Text="Speed OFF"; TSpeed.TextColor3=Color3.new(1,1,1); TSpeed.Font=Enum.Font.GothamBold; TSpeed.TextSize=14; local TSC=Instance.new("UICorner",TSpeed); TSC.CornerRadius=UDim.new(0,8)

-- Toggle Jump
local TJump=Instance.new("TextButton",Panel); TJump.Size=UDim2.new(0,80,0,35); TJump.Position=UDim2.new(0,110,1,-45); TJump.BG=Color3.fromRGB(255,80,80); TJump.Text="Jump OFF"; TJump.TextColor3=Color3.new(1,1,1); TJump.Font=Enum.Font.GothamBold; TJump.TextSize=14; local TJC=Instance.new("UICorner",TJump); TJC.CornerRadius=UDim.new(0,8)

-- ฟังก์ชัน Speed
local function setSpeed(v)
    SpeedVal=v; SLabel.Text="Speed: "..v
    local p=(v-MinSpeed)/(MaxSpeed-MinSpeed); SFill.Size=UDim2.new(p,0,1,0); Knob.Position=UDim2.new(p,-14,0,-14)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed=SpeedOn and v or 16 end
end

-- Slider Drag
local drag=false; Knob.MouseButton1Down:Connect(function() drag=true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
RunService.RenderStepped:Connect(function()
    if drag then
        local mp=UIS:GetMouseLocation(); local rx=mp.X-SBG.AbsolutePosition.X; local p=math.clamp(rx/SBG.AbsoluteSize.X,0,1)
        setSpeed(math.floor(MinSpeed + p*(MaxSpeed-MinSpeed)))
    end
    if SpeedOn and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.WalkSpeed~=SpeedVal then
        Player.Character.Humanoid.WalkSpeed=SpeedVal
    end
end)

-- Toggle Speed
TSpeed.MouseButton1Click:Connect(function()
    SpeedOn=not SpeedOn; if SpeedOn then TSpeed.BG=Color3.fromRGB(80,255,80); TSpeed.Text="Speed ON" else TSpeed.BG=Color3.fromRGB(255,80,80); TSpeed.Text="Speed OFF" end
    setSpeed(SpeedVal)
end)

-- Toggle Jump + Infinite Jump
TJump.MouseButton1Click:Connect(function()
    JumpOn=not JumpOn; if JumpOn then TJump.BG=Color3.fromRGB(80,255,80); TJump.Text="Jump ON" else TJump.BG=Color3.fromRGB(255,80,80); TJump.Text="Jump OFF" end
end)
UIS.InputBegan:Connect(function(i,gp) if gp or not JumpOn then return end; if i.KeyCode==Enum.KeyCode.Space and Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.Jump=true end end)

-- Respawn
Player.CharacterAdded:Connect(function(c) task.wait(0.5); if SpeedOn then c:WaitForChild("Humanoid").WalkSpeed=SpeedVal end end)

-- Open/Close
Open.MouseButton1Click:Connect(function() Open.Visible=false; Panel.Visible=true end)
Close.MouseButton1Click:Connect(function() Panel.Visible=false; Open.Visible=true end)

setSpeed(50)
game.StarterGui:SetCore("SendNotification",{Title="🚀 Speed+Jump",Text="กดปุ่มฟ้ามุมขวาล่าง!",Duration=6})
