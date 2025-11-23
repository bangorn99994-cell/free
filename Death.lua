-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ฟังก์ชันสร้าง Highlight
local function createHighlight(character)
    if character:FindFirstChild("Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = character
end

-- ลงทะเบียนผู้เล่น
local function registerPlayer(player)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        createHighlight(character)
    end)
    if player.Character then
        createHighlight(player.Character)
    end
end

-- ลงทะเบียนผู้เล่นทั้งหมด
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        registerPlayer(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        registerPlayer(player)
    end
end)

-- GUI Panel
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local colors = {
    {name="Red", color=Color3.fromRGB(255,0,0)},
    {name="Blue", color=Color3.fromRGB(0,0,255)},
    {name="Yellow", color=Color3.fromRGB(255,255,0)},
    {name="Rainbow", color=nil} -- Rainbow จะเปลี่ยนสีเอง
}

local selectedMode = "Red"
local rainbowHue = 0

for i, data in ipairs(colors) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,120,0,40)
    button.Position = UDim2.new(0,10,0,(i-1)*50+10)
    button.Text = data.name
    button.BackgroundColor3 = data.color or Color3.fromRGB(200,200,200)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.Parent = ScreenGui

    button.MouseButton1Click:Connect(function()
        selectedMode = data.name
    end)
end

-- อัปเดตทุกเฟรม
RunService.RenderStepped:Connect(function(delta)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            local highlight = player.Character:FindFirstChild("Highlight")

            if highlight then
                if selectedMode == "Rainbow" then
                    rainbowHue = (rainbowHue + delta*0.5) % 1
                    highlight.FillColor = Color3.fromHSV(rainbowHue,1,1)
                else
                    for _, data in ipairs(colors) do
                        if data.name == selectedMode and data.color then
                            highlight.FillColor = data.color
                        end
                    end
                end

                -- ถ้าวิ่ง → ทำให้เรืองแสงชัดขึ้น
                if humanoid.MoveDirection.Magnitude > 0 then
                    highlight.FillTransparency = 0.2
                else
                    highlight.FillTransparency = 0.5
                end
            end
        end
    end
end)
