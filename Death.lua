local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ฟังก์ชั่นยิง (ทำงานเมื่อคลิกเมาส์)
local function onShoot()
    local origin = LocalPlayer.Character.Head.Position -- จุดเริ่มจากหัว
    local targetPos = Mouse.Hit.Position -- จุดที่เมาส์ชี้
    local direction = (targetPos - origin).Unit * 100 -- ทิศทางและระยะทาง 100 หน่วย

    -- สร้าง Raycast
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character} -- ไม่ยิงโดนตัวเอง
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local raycastResult = workspace:Raycast(origin, direction, raycastParams)

    if raycastResult then
        local hitPart = raycastResult.Instance
        -- ตรวจสอบว่าสิ่งที่ยิงโดนคือหัวของคนอื่นหรือไม่
        if hitPart.Name == "Head" and hitPart.Parent:FindFirstChild("Humanoid") then
            print("ยิงโดนหัวของผู้เล่น: " .. hitPart.Parent.Name)
            -- ในเกมจริง จะมีการส่ง RemoteEvent ไปบอก Server เพื่อตัดเลือดที่นี่
        end
    end
end

-- ผูกฟังก์ชั่นกับการคลิกเมาส์
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        onShoot()
    end
end)
