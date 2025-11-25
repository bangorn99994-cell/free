-- สคริปต์ Roblox: Loading Screen ที่รันพร้อม RunDelta-like loop
-- หมายเหตุ: ปรับให้เข้ากับ RunDelta platform หรือแพลตฟอร์มจริงที่คุณใช้งาน
-- ที่นี่เป็นตัวอย่าง LocalScript ที่วางใน StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- สร้าง ScreenGui สำหรับ loading
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingGui"
loadingGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 60)
frame.Position = UDim2.new(0.5, -200, 0.5, -30)
frame.BackgroundTransparency = 0.2
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.Parent = loadingGui

local progressBarBack = Instance.new("Frame")
progressBarBack.Size = UDim2.new(1, 0, 1, 0)
progressBarBack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
progressBarBack.BorderSizePixel = 0
progressBarBack.Parent = frame

local progressBarFill = Instance.new("Frame")
progressBarFill.Size = UDim2.new(0, 0, 1, 0)
progressBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
progressBarFill.BorderSizePixel = 0
progressBarFill.Parent = progressBarBack

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(1, 0, 1, 0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingLabel.TextScaled = true
loadingLabel.Text = "Loading assets..."
loadingLabel.Parent = frame

-- ฟังก์ชันจำลองการโหลดทรัพยากร (แทนจริงด้วย Asset หรือ Remote fetch)
local assetsToLoad = {
    "rbxassetid://12345678",
    "rbxassetid://23456789",
    "rbxassetid://34567890",
    "rbxassetid://45678901",
}
local total = #assetsToLoad
local loaded = 0

local function simulateLoad(assetId)
    -- จำลองการโหลดด้วยเวลารอ
    return delay(0.5, function()
        -- ในจริงอาจเรียกโค้ดโหลดทรัพยากร เช่น:
        -- local asset = game:GetObjects(assetId)[1]
        -- -- เก็บหรือใช้งาน asset ตามต้องการ
        return true
    end)
end

local function updateProgress()
    local ratio = loaded / total
    progressBarFill.Size = UDim2.new(ratio, 0, 1, 0)
end

local function startLoading()
    loadingGui.Enabled = true
    loaded = 0
    updateProgress()

    for i, id in ipairs(assetsToLoad) do
        -- คุณสามารถเรียก simulateLoad หรือโหลดจริงตาม API ที่มี
        simulateLoad(id)
        loaded = i
        updateProgress()
        -- เพื่อให้เห็นความตอบสนอง สามารถรอเล็กน้อย
        RunService.Heartbeat:Wait()
    end

    -- โหลดเสร็จแล้วดำเนินการต่อ
    loadingLabel.Text = "Loading complete. Starting game..."
    -- ปิด GUI หลังโหลดเสร็จ
    local t = TweenService:Create(frame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -200, 0.55, -30)})
    t:Play()
    t.Completed:Wait()
    loadingGui:Destroy()

    -- เรียกใช้งานฟังก์ชันเริ่มเกมจริง
    if typeof(_G) == "table" and _G.OnLoadingComplete then
        _G.OnLoadingComplete()
    end
end

-- เริ่มโหลดเมื่อสคริปต์ทำงาน
startLoading()
