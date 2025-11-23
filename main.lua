-- บริการที่จำเป็น
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- การตั้งค่าสี (สามารถแก้ได้)
local FILL_COLOR = Color3.fromRGB(255, 0, 0) -- สีภายใน (สีแดง)
local OUTLINE_COLOR = Color3.fromRGB(255, 255, 255) -- สีขอบ (สีขาว)

-- ฟังก์ชั่นสร้าง Highlight
local function createESP(character)
    -- ตรวจสอบว่ามี Highlight อยู่แล้วหรือไม่ เพื่อป้องกันการสร้างซ้ำ
    if not character:FindFirstChild("HighlightESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "HighlightESP"
        highlight.Adornee = character
        highlight.Parent = character
        
        -- ตั้งค่าความโปร่งใสและสี
        highlight.FillColor = FILL_COLOR
        highlight.OutlineColor = OUTLINE_COLOR
        highlight.FillTransparency = 0.5 -- ความจางของสีภายใน (0-1)
        highlight.OutlineTransparency = 0 -- ความจางของขอบ
        
        -- ทำให้มองทะลุสิ่งกีดขวาง (AlwaysOnTop)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

-- ฟังก์ชั่นจัดการผู้เล่นแต่ละคน
local function setupPlayer(player)
    -- ไม่ทำใส่ตัวเอง
    if player == LocalPlayer then return end

    -- ถ้าตัวละครมีอยู่แล้ว ให้ใส่ ESP เลย
    if player.Character then
        createESP(player.Character)
    end

    -- เมื่อตัวละครเกิดใหม่ (ตายแล้วเกิด) ให้ใส่ ESP ใหม่
    player.CharacterAdded:Connect(function(character)
        -- รอสักนิดให้ตัวโหลดเสร็จ
        task.wait(0.5)
        createESP(character)
    end)
end

-- 1. วนลูปผู้เล่นที่มีอยู่ในเซิฟเวอร์ตอนนี้
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

-- 2. ดักจับผู้เล่นที่เพิ่งเข้ามาใหม่
Players.PlayerAdded:Connect(function(player)
    setupPlayer(player)
end)

-- แจ้งเตือนเมื่อรันเสร็จ
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ESP Enabled";
    Text = "สคริปต์มองทะลุทำงานแล้ว!";
    Duration = 5;
})
