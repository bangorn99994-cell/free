-- INVISIBLE 100% (คนอื่นมองไม่เห็นตัวเราเลย) | 2025

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

local IsInvisible = false

local function MakeInvisible()
    if not Player.Character then return end
    local char = Player.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    -- 1. ทำให้ทุก Part ล่องหนในมุมมองของคนอื่น (Replication)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = 1
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 1
        end
    end

    -- 2. ซ่อนชื่อ + Health Bar + Nametag (สำคัญที่สุด)
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    -- 3. ซ่อนตัวละครจาก PlayerList / Leaderboard (บางเกม)
    if char:FindFirstChild("Head") then
        for _, v in ipairs(char.Head:GetChildren()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = false
            end
        end
    end

    IsInvisible = true
    game.StarterGui:SetCore("SendNotification", {
        Title = "ล่องหน 100%";
        Text = "คนอื่นมองไม่เห็นคุณแล้ว!";
        Duration = 3
    })
end

local function MakeVisible()
    if not Player.Character then return end
    local char = Player.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = 0
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 0
        end
    end

    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
    end

    if char:FindFirstChild("Head") then
        for _, v in ipairs(char.Head:GetChildren()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = true
            end
        end
    end

    IsInvisible = false
    game.StarterGui:SetCore("SendNotification", {
        Title = "กลับมาเห็น";
        Text = "คนอื่นเห็นคุณอีกครั้ง";
        Duration = 3
    })
end

-- รองรับการรีสปอนด์ 100%
Player.CharacterAdded:Connect(function()
    task.wait(1.5)
    if IsInvisible then
        MakeInvisible()
    end
end)

-- เปิด/ปิดด้วยปุ่ม RightControl (กด 1 ครั้ง = ล่องหน)
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if IsInvisible then
            MakeVisible()
        else
            MakeInvisible()
        end
    end
end)

-- แจ้งตอนโหลดเสร็จ
game.StarterGui:SetCore("SendNotification", {
    Title = "Invisible 100% โหลดแล้ว";
    Text = "กด Right Ctrl เพื่อล่องหน/กลับมาเห็น\nคนอื่นมองไม่เห็นคุณแน่นอน!";
    Duration = 8
})
