-- Delta Run ESP with Fake Headlock GUI
-- วางใน LocalScript ภายใน StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ตั้งค่าหลัก
local ESP_ENABLED = false
local HEADLOCK_ENABLED = false
local FAKE_LOADING = true

-- สี
local COLORS = {
    RED = Color3.fromRGB(255, 0, 0),
    GREEN = Color3.fromRGB(0, 255, 0),
    BLUE = Color3.fromRGB(0, 100, 255),
    PURPLE = Color3.fromRGB(180, 0, 255),
    YELLOW = Color3.fromRGB(255, 255, 0),
    WHITE = Color3.fromRGB(255, 255, 255)
}

-- เก็บข้อมูล
local espObjects = {}
local fakeTarget = nil
local connectionLoop = nil

-- ⚡ สร้าง GUI ที่ดูเหมือนของจริง
local function createFakeGUI()
    -- สร้าง Main GUI
    local mainGUI = Instance.new("ScreenGui")
    mainGUI.Name = "DeltaRunESP"
    mainGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGUI.ResetOnSpawn = false

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = mainGUI

    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = COLORS.PURPLE
    stroke.Thickness = 2
    stroke.Parent = mainFrame

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar

    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "DELTA RUN ESP v2.0"
    titleText.TextColor3 = COLORS.WHITE
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = COLORS.WHITE
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton

    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Loading Animation (เหมือนของจริง)
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    loadingFrame.Visible = FAKE_LOADING
    loadingFrame.Parent = contentFrame

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0, 30)
    loadingText.Position = UDim2.new(0, 0, 0.5, -15)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "Loading ESP System..."
    loadingText.TextColor3 = COLORS.PURPLE
    loadingText.TextSize = 18
    loadingText.Font = Enum.Font.GothamBold
    loadingText.Parent = loadingFrame

    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0, 0, 0, 4)
    loadingBar.Position = UDim2.new(0, 0, 0.5, 20)
    loadingBar.BackgroundColor3 = COLORS.PURPLE
    loadingBar.BorderSizePixel = 0
    loadingBar.Parent = loadingFrame

    local loadingBarCorner = Instance.new("UICorner")
    loadingBarCorner.CornerRadius = UDim.new(0, 2)
    loadingBarCorner.Parent = loadingBar

    -- Control Buttons
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, 0, 0, 200)
    buttonContainer.Position = UDim2.new(0, 0, 0, 0)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Visible = not FAKE_LOADING
    buttonContainer.Parent = contentFrame

    -- ESP Toggle Button
    local espButton = Instance.new("TextButton")
    espButton.Size = UDim2.new(1, 0, 0, 45)
    espButton.Position = UDim2.new(0, 0, 0, 10)
    espButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    espButton.Text = "ESP: OFF"
    espButton.TextColor3 = COLORS.RED
    espButton.TextSize = 16
    espButton.Font = Enum.Font.GothamBold
    espButton.Parent = buttonContainer

    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 6)
    espCorner.Parent = espButton

    local espStroke = Instance.new("UIStroke")
    espStroke.Color = COLORS.RED
    espStroke.Thickness = 2
    espStroke.Parent = espButton

    -- Headlock Toggle Button
    local headlockButton = Instance.new("TextButton")
    headlockButton.Size = UDim2.new(1, 0, 0, 45)
    headlockButton.Position = UDim2.new(0, 0, 0, 65)
    headlockButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    headlockButton.Text = "HEADLOCK: OFF"
    headlockButton.TextColor3 = COLORS.RED
    headlockButton.TextSize = 16
    headlockButton.Font = Enum.Font.GothamBold
    headlockButton.Parent = buttonContainer

    local headlockCorner = Instance.new("UICorner")
    headlockCorner.CornerRadius = UDim.new(0, 6)
    headlockCorner.Parent = headlockButton

    local headlockStroke = Instance.new("UIStroke")
    headlockStroke.Color = COLORS.RED
    headlockStroke.Thickness = 2
    headlockStroke.Parent = headlockButton

    -- Status Display
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 80)
    statusFrame.Position = UDim2.new(0, 0, 1, -90)
    statusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    statusFrame.Parent = contentFrame

    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame

    local statusTitle = Instance.new("TextLabel")
    statusTitle.Size = UDim2.new(1, 0, 0, 25)
    statusTitle.BackgroundTransparency = 1
    statusTitle.Text = "SYSTEM STATUS"
    statusTitle.TextColor3 = COLORS.WHITE
    statusTitle.TextSize = 14
    statusTitle.Font = Enum.Font.GothamBold
    statusTitle.Parent = statusFrame

    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -10, 1, -25)
    statusText.Position = UDim2.new(0, 5, 0, 25)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Waiting for activation..."
    statusText.TextColor3 = COLORS.YELLOW
    statusText.TextSize = 12
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextYAlignment = Enum.TextYAlignment.Top
    statusText.Parent = statusFrame

    -- Fake Console Output
    local consoleFrame = Instance.new("ScrollingFrame")
    consoleFrame.Size = UDim2.new(1, 0, 0, 100)
    consoleFrame.Position = UDim2.new(0, 0, 1, -200)
    consoleFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    consoleFrame.BorderSizePixel = 0
    consoleFrame.ScrollBarThickness = 4
    consoleFrame.Visible = not FAKE_LOADING
    consoleFrame.Parent = contentFrame

    local consoleCorner = Instance.new("UICorner")
    consoleCorner.CornerRadius = UDim.new(0, 6)
    consoleCorner.Parent = consoleFrame

    -- Animation Loading Bar
    if FAKE_LOADING then
        spawn(function()
            for i = 1, 100 do
                loadingBar.Size = UDim2.new(0, i * 3.2, 0, 4)
                loadingText.Text = "Loading ESP System... " .. i .. "%"
                wait(0.02)
            end
            wait(0.5)
            FAKE_LOADING = false
            loadingFrame.Visible = false
            buttonContainer.Visible = true
            consoleFrame.Visible = true
            statusText.Text = "System Ready - Select features to activate"
        end)
    end

    -- Button Events
    espButton.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        if ESP_ENABLED then
            espButton.Text = "ESP: ON"
            espButton.TextColor3 = COLORS.GREEN
            espStroke.Color = COLORS.GREEN
            statusText.Text = "ESP Activated - Visual tracking enabled"
            initializeESP()
        else
            espButton.Text = "ESP: OFF"
            espButton.TextColor3 = COLORS.RED
            espStroke.Color = COLORS.RED
            statusText.Text = "ESP Deactivated"
            clearESP()
        end
    end)

    headlockButton.MouseButton1Click:Connect(function()
        HEADLOCK_ENABLED = not HEADLOCK_ENABLED
        if HEADLOCK_ENABLED then
            headlockButton.Text = "HEADLOCK: ON"
            headlockButton.TextColor3 = COLORS.GREEN
            headlockStroke.Color = COLORS.GREEN
            statusText.Text = "Headlock Activated - Fake targeting system running"
            startFakeHeadlock()
        else
            headlockButton.Text = "HEADLOCK: OFF"
            headlockButton.TextColor3 = COLORS.RED
            headlockStroke.Color = COLORS.RED
            statusText.Text = "Headlock Deactivated"
            stopFakeHeadlock()
        end
    end)

    closeButton.MouseButton1Click:Connect(function()
        mainGUI:Destroy()
    end)

    -- Make draggable
    local dragging = false
    local dragInput, dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    mainGUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
    return mainGUI
end

-- 🎯 Fake Headlock System (หลอกเหมือนทำงานจริง)
local function startFakeHeadlock()
    if connectionLoop then
        connectionLoop:Disconnect()
    end
    
    connectionLoop = RunService.Heartbeat:Connect(function()
        if not HEADLOCK_ENABLED then return end
        
        -- สุ่มเลือก target หลอกๆ
        local players = Players:GetPlayers()
        local enemyPlayers = {}
        
        for _, player in ipairs(players) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    table.insert(enemyPlayers, player)
                end
            end
        end
        
        if #enemyPlayers > 0 then
            -- สุ่มเปลี่ยน target บ้างเพื่อให้ดูเหมือนทำงาน
            if math.random(1, 30) == 1 then
                fakeTarget = enemyPlayers[math.random(1, #enemyPlayers)]
            end
            
            if fakeTarget and fakeTarget.Character then
                local head = fakeTarget.Character:FindFirstChild("Head")
                if head then
                    -- สร้างเอฟเฟกต์หลอกๆ
                    if not head:FindFirstChild("FakeLockEffect") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "FakeLockEffect"
                        highlight.FillColor = Color3.fromRGB(255, 0, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 0, 255)
                        highlight.FillTransparency = 0.3
                        highlight.OutlineTransparency = 0
                        highlight.Parent = head
                    end
                end
            end
        end
    end)
end

local function stopFakeHeadlock()
    if connectionLoop then
        connectionLoop:Disconnect()
        connectionLoop = nil
    end
    
    -- ลบเอฟเฟกต์ทั้งหมด
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head and head:FindFirstChild("FakeLockEffect") then
                head.FakeLockEffect:Destroy()
            end
        end
    end
end

-- 🎯 ESP System จริง
local function createESP(character, isNPC)
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not head then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "RealESP"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        highlight.FillColor = COLORS.RED
        highlight.OutlineColor = COLORS.RED
    else
        highlight.FillColor = COLORS.GREEN
        highlight.OutlineColor = COLORS.GREEN
    end
    
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0.2
    highlight.Parent = character
    
    espObjects[character] = highlight
end

local function initializeESP()
    if not ESP_ENABLED then return end
    
    -- ESP ผู้เล่น
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createESP(player.Character, false)
        end
    end
    
    -- ESP NPC
    for _, npc in ipairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(npc) then
            createESP(npc, true)
        end
    end
    
    -- ติดตามผู้เล่นใหม่
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            wait(1)
            if ESP_ENABLED then
                createESP(character, false)
            end
        end)
    end)
    
    -- ติดตาม NPC ใหม่
    workspace.ChildAdded:Connect(function(child)
        wait(1)
        if child:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(child) then
            if ESP_ENABLED then
                createESP(child, true)
            end
        end
    end)
end

local function clearESP()
    for character, highlight in pairs(espObjects) do
        if highlight then
            highlight:Destroy()
        end
    end
    espObjects = {}
end

-- 🚀 เริ่มต้นระบบ
local function initializeSystem()
    -- สร้าง GUI
    createFakeGUI()
    
    -- พิมพ์ข้อความหลอกๆ ใน Output
    print("Delta Run ESP System Initialized")
    print("Loading security bypass...")
    wait(1)
    print("Anti-cheat bypass: SUCCESS")
    print("Memory injection: COMPLETE")
    print("ESP System: READY")
    print("Headlock System: STANDBY")
end

-- ⚡ เริ่มระบบเมื่อพร้อม
if LocalPlayer.Character then
    initializeSystem()
else
    LocalPlayer.CharacterAdded:Connect(initializeSystem)
end

-- 🎮 คีย์บอร์ดลัด
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- กด F5 เพื่อเปิด GUI ใหม่
    if input.KeyCode == Enum.KeyCode.F5 then
        initializeSystem()
    end
    
    -- กด F6 เพื่อเปิด/ปิด ESP
    if input.KeyCode == Enum.KeyCode.F6 then
        ESP_ENABLED = not ESP_ENABLED
        if ESP_ENABLED then
            initializeESP()
        else
            clearESP()
        end
    end
end)

print("🎯 Delta Run Fake Headlock ESP Loaded!")
print("📟 Press F5 to open GUI")
print("🔮 System appears to be loading...")
