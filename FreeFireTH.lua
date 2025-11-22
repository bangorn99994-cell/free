-- สร้าง panel
local Panel = Instance.new("ScreenGui")
Panel.Name = "TransparentPanel"
Panel.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- สร้าง Frame ที่จะทำหน้าที่เป็น Panel
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, 0, 1, 0)  -- ขนาดเต็มหน้าจอ
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- สีขาว
Frame.BackgroundTransparency = 0.5  -- ความโปร่งใส 50%
Frame.Parent = Panel

-- ใช้เพื่อทำให้ panel สามารถมองทะลุถึงผู้เล่น
Frame.Active = true
Frame.Selectable = true
Frame.BackgroundTransparency = 0.5  -- ปรับความโปร่งใส

-- ฟังก์ชันสำหรับอัพเดทการมองทะลุ
local function UpdateTransparency()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = (character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                Frame.BackgroundTransparency = math.clamp(distance / 100, 0.1, 0.9) -- ปรับความโปร่งใสตามระยะห่าง
            end
        end
    end
end

-- เรียกใช้งานฟังก์ชันทุก ๆ เฟรม
game:GetService("RunService").RenderStepped:Connect(UpdateTransparency)
 
