--[[
    REMOTE EVENT SPY - โค้ดสแกนหาชื่อ RemoteEvent
    - ใช้เพื่อหาชื่อ RemoteEvent ที่ถูกต้องสำหรับ Aimbot
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local FoundEvents = {}

-- ฟังก์ชันที่ใช้ดักจับ FireServer
local function HookRemote(remote)
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        local remoteName = remote.Name
        if not FoundEvents[remoteName] then
            FoundEvents[remoteName] = true
            
            -- พยายาม Hook FireServer (ถ้า Executor รองรับ)
            if getgenv().hookfunction then
                 getgenv().hookfunction(remote.FireServer, function(self, ...)
                    print("🔥 REMOTE FIRE DETECTED (ชื่อ): " .. remoteName)
                    -- ส่งคำสั่งเดิมกลับไปเพื่อให้เกมทำงานต่อ
                    return remote.FireServer(self, ...)
                end)
            end
        end
    end
end

-- สแกนหา RemoteEvents ทั้งใน ReplicatedStorage และ Workspace (หรือที่อื่น ๆ)
local function ScanForRemotes(parent)
    for _, child in pairs(parent:GetDescendants()) do
        HookRemote(child)
    end
end

-- รันการสแกนทันทีและสแกนซ้ำเมื่อมี Object ใหม่เข้ามา
ScanForRemotes(ReplicatedStorage)
ScanForRemotes(Workspace)

-- สแกนเมื่อมีวัตถุใหม่เข้ามา
ReplicatedStorage.DescendantAdded:Connect(HookRemote)
Workspace.DescendantAdded:Connect(HookRemote)

print("✅ REMOTE SPY ACTIVE! ยิงปืนในเกมเพื่อดูชื่อในคอนโซล.")
