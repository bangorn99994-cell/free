local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game.Workspace

-- ตัวอย่างฟังก์ชันใช้งานจริง: โยนข้อความเสียงด้วย TTS หรือเล่นเสียง
-- คุณสามารถปรับแก้ให้เข้ากับระบบของคุณได้
local function say(text)
    -- ตัวอย่าง: เล่นเสียงผ่าน Sound ที่แนบใน StarterSound หรือ ReplicatedStorage
    local soundName = "TTS_Sample" -- ปรับชื่อไฟล์เสียงจริงที่มี
    local sound = Instance.new("Sound")
    sound.SoundId = "" -- ใส่ URL หรือ AssetId ของเสียงที่ต้องการ
    sound.Volume = 1
    sound.Parent = Workspace

    if sound.SoundId ~= "" then
        sound:Play()
        sound.Ended:Wait()
        sound:Destroy()
    else
        -- หากไม่มีเสียงจริงให้แสดงข้อความผ่าน Output
        warn("Text-to-speech เสียงยังไม่ถูกตั้งค่า: " .. tostring(text))
        sound:Destroy()
    end
end

-- ตัวอย่างการใช้งาน: บินเมื่อกดปุ่ม Space
local flying = false
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        flying = not flying
        if flying then
            say("เริ่มบิน")
            -- ใส่คำสั่งบินจริงที่คุณมีใน Run Data ที่นี่
        else
            say("หยุดบิน")
            -- ใส่คำสั่งหยุดบินจริงที่นี่
        end
    end
end)

-- ฟังก์ชันอัปเดตสถานะFlight (ตัวอย่าง)
RunService.RenderStepped:Connect(function(dt)
    if flying then
        -- ปรับตำแหน่ง/มุมกล้อง หรือสภาวะบินตาม dt
    end
end)
