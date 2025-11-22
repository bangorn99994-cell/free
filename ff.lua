--[[
  UNIVERSAL ESP SCRIPT (Lua/Luau) - Designed for direct execution in Delta/Fluxus
  * โค้ดนี้ไม่ใช้ loadstring/HttpGet จึงไม่ต้องพึ่งพา GitHub และทำงานได้เสถียรกว่า *
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP_TOGGLE = true -- สถานะเริ่มต้น: เปิด ESP ทันทีที่รัน
local ESP_COLOR = Color3.fromRGB(255, 165, 0) -- สีส้ม (มองเห็นง่าย)
local ESP_DEPTH = Enum.DepthMode.AlwaysOnTop -- มองเห็นทะลุกำแพง

-- ## 1. ฟังก์ชันสร้าง Highlight (กลไกหลักของ ESP)

local function createHighlight(instance, esp_id)
    -- ตรวจสอบและสร้าง Highlight (ถ้ายังไม่มี)
    local highlight = instance:FindFirstChild(esp_id)
    if highlight then
        return highlight
    end

    highlight = Instance.new("Highlight")
    highlight.Name = esp_id -- ใช้ ID เพื่อค้นหา
    highlight.FillColor = ESP_COLOR
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Adornee = instance -- ผูกติดกับ Object
    highlight.FillTransparency = 0.6
    highlight.DepthMode = ESP_DEPTH
    highlight.Parent = instance
    return highlight
end

-- ## 2. ฟังก์ชันหลักในการค้นหาและอัปเดตผู้เล่น

local function updateESP()
    if not ESP_TOGGLE or not LocalPlayer then
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        -- ข้ามตัวผู้เล่นเองและตรวจสอบว่าผู้เล่นยังมีตัวละครหรือไม่
        if player == LocalPlayer or not player.Character then
            continue
        end

        local Character = player.Character

        local humanoid = Character:FindFirstChildOfClass("Humanoid")

        if humanoid and humanoid.Health > 0 then
            -- พยายามหา HumanoidRootPart เป็นจุดหลักในการ Adorn
            local PartToAdorn = Character:FindFirstChild("HumanoidRootPart")

            if PartToAdorn then
                createHighlight(PartToAdorn, "DeltaESPHighlight")
            else
                -- หากไม่มี HumanoidRootPart (เช่น โมเดลแปลกๆ) ให้ Adorn ที่ Model หลัก
                createHighlight(Character, "DeltaESPHighlight")
            end
        else
            -- ลบ Highlight ถ้าตัวละครตาย
            pcall(function()
                Character:FindFirstChild("DeltaESPHighlight"):Destroy()
            end)
        end
    end
end

-- เชื่อมต่อกับ RenderStepped เพื่ออัปเดตอย่างต่อเนื่อง (FPS สูง)
RunService:BindToRenderStep("DeltaESPUpdate", Enum.RenderPriority.Camera.Value + 1, updateESP)


-- ## 3. ระบบควบคุม (Toggle Function)

-- ฟังก์ชันสำหรับเปิด/ปิด ESP
function ToggleDeltaESP()
    ESP_TOGGLE = not ESP_TOGGLE
    print("[Delta ESP Toggle]: ESP ตอนนี้สถานะ: " .. tostring(ESP_TOGGLE))
    
    -- ถ้าปิด ให้ลบ Highlight ทันที
    if not ESP_TOGGLE then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                pcall(function()
                    player.Character:FindFirstChild("DeltaESPHighlight"):Destroy()
                end)
            end
        end
    end
end

print("✅ Delta ESP Script Loaded Successfully!")
print("💡 พิมพ์ 'ToggleDeltaESP()' ใน Console/ช่อง Executor เพื่อเปิด/ปิด")
