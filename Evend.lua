local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- ===== สร้าง Main ScreenGui =====
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "GameGui"
mainGui.ResetOnSpawn = false
mainGui.Parent = playerGui

-- ===== HUD ระหว่างเล่น =====
local hudFrame = Instance.new("Frame")
hudFrame.Name = "HUD"
hudFrame.Size = UDim2.new(1, 0, 1, 0)
hudFrame.BackgroundTransparency = 1
hudFrame.Parent = mainGui

-- สร้าง Health Bar
local healthContainer = Instance.new("Frame")
healthContainer.Name = "HealthContainer"
healthContainer.Size = UDim2.new(0, 300, 0, 50)
healthContainer.Position = UDim2.new(0, 20, 0, 20)
healthContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
healthContainer.BorderSizePixel = 0
healthContainer.Parent = hudFrame

local healthCorner = Instance.new("UICorner")
healthCorner.CornerRadius = UDim.new(0, 10)
healthCorner.Parent = healthContainer

-- HealthBar Label
local healthLabel = Instance.new("TextLabel")
healthLabel.Name = "Label"
healthLabel.Size = UDim2.new(1, 0, 0, 20)
healthLabel.BackgroundTransparency = 1
healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
healthLabel.TextSize = 14
healthLabel.Font = Enum.Font.GothamBold
healthLabel.Text = "Health"
healthLabel.Parent = healthContainer

-- HealthBar Background
local healthBarBg = Instance.new("Frame")
healthBarBg.Name = "Background"
healthBarBg.Size = UDim2.new(1, -20, 0, 20)
healthBarBg.Position = UDim2.new(0, 10, 0, 25)
healthBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
healthBarBg.BorderSizePixel = 0
healthBarBg.Parent = healthContainer

local healthBarCorner = Instance.new("UICorner")
healthBarCorner.CornerRadius = UDim.new(0, 5)
healthBarCorner.Parent = healthBarBg

-- HealthBar Fill
local healthBarFill = Instance.new("Frame")
healthBarFill.Name = "Fill"
healthBarFill.Size = UDim2.new(1, 0, 1, 0)
healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
healthBarFill.BorderSizePixel = 0
healthBarFill.Parent = healthBarBg

local healthFillCorner = Instance.new("UICorner")
healthFillCorner.CornerRadius = UDim.new(0, 5)
healthFillCorner.Parent = healthBarFill

-- Score Display
local scoreFrame = Instance.new("Frame")
scoreFrame.Name = "ScoreFrame"
scoreFrame.Size = UDim2.new(0, 200, 0, 80)
scoreFrame.Position = UDim2.new(1, -220, 0, 20)
scoreFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scoreFrame.BorderSizePixel = 0
scoreFrame.Parent = hudFrame

local scoreCorner = Instance.new("UICorner")
scoreCorner.CornerRadius = UDim.new(0, 10)
scoreCorner.Parent = scoreFrame

local scoreLabel = Instance.new("TextLabel")
scoreLabel.Name = "Label"
scoreLabel.Size = UDim2.new(1, 0, 0.5, 0)
scoreLabel.BackgroundTransparency = 1
scoreLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
scoreLabel.TextSize = 14
scoreLabel.Font = Enum.Font.GothamBold
scoreLabel.Text = "Score"
scoreLabel.Parent = scoreFrame

local scoreValue = Instance.new("TextLabel")
scoreValue.Name = "Value"
scoreValue.Size = UDim2.new(1, 0, 0.5, 0)
scoreValue.Position = UDim2.new(0, 0, 0.5, 0)
scoreValue.BackgroundTransparency = 1
scoreValue.TextColor3 = Color3.fromRGB(255, 200, 0)
scoreValue.TextSize = 24
scoreValue.Font = Enum.Font.GothamBold
scoreValue.Text = "0"
scoreValue.Parent = scoreFrame

-- ===== Menu Utama =====
local mainMenuFrame = Instance.new("Frame")
mainMenuFrame.Name = "MainMenu"
mainMenuFrame.Size = UDim2.new(1, 0, 1, 0)
mainMenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainMenuFrame.BorderSizePixel = 0
mainMenuFrame.Visible = false
mainMenuFrame.Parent = mainGui

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 100)
titleLabel.Position = UDim2.new(0, 0, 0.2, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
titleLabel.TextSize = 60
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "GAME"
titleLabel.Parent = mainMenuFrame

-- ปุ่ม Play
local playButton = Instance.new("TextButton")
playButton.Name = "PlayButton"
playButton.Size = UDim2.new(0, 200, 0, 50)
playButton.Position = UDim2.new(0.5, -100, 0.4, 0)
playButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.TextSize = 20
playButton.Font = Enum.Font.GothamBold
playButton.Text = "PLAY"
playButton.BorderSizePixel = 0
playButton.Parent = mainMenuFrame

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 10)
playCorner.Parent = playButton

-- ปุ่ม Settings
local settingsButton = Instance.new("TextButton")
settingsButton.Name = "SettingsButton"
settingsButton.Size = UDim2.new(0, 200, 0, 50)
settingsButton.Position = UDim2.new(0.5, -100, 0.5, 0)
settingsButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsButton.TextSize = 20
settingsButton.Font = Enum.Font.GothamBold
settingsButton.Text = "SETTINGS"
settingsButton.BorderSizePixel = 0
settingsButton.Parent = mainMenuFrame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 10)
settingsCorner.Parent = settingsButton

-- ปุ่ม Quit
local quitButton = Instance.new("TextButton")
quitButton.Name = "QuitButton"
quitButton.Size = UDim2.new(0, 200, 0, 50)
quitButton.Position = UDim2.new(0.5, -100, 0.6, 0)
quitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
quitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
quitButton.TextSize = 20
quitButton.Font = Enum.Font.GothamBold
quitButton.Text = "QUIT"
quitButton.BorderSizePixel = 0
quitButton.Parent = mainMenuFrame

local quitCorner = Instance.new("UICorner")
quitCorner.CornerRadius = UDim.new(0, 10)
quitCorner.Parent = quitButton

-- ===== Pause Menu =====
local pauseMenuFrame = Instance.new("Frame")
pauseMenuFrame.Name = "PauseMenu"
pauseMenuFrame.Size = UDim2.new(1, 0, 1, 0)
pauseMenuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
pauseMenuFrame.BackgroundTransparency = 0.5
pauseMenuFrame.BorderSizePixel = 0
pauseMenuFrame.Visible = false
pauseMenuFrame.Parent = mainGui

-- Pause Panel
local pausePanel = Instance.new("Frame")
pausePanel.Name = "Panel"
pausePanel.Size = UDim2.new(0, 400, 0, 300)
pausePanel.Position = UDim2.new(0.5, -200, 0.5, -150)
pausePanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
pausePanel.BorderSizePixel = 0
pausePanel.Parent = pauseMenuFrame

local pauseCorner = Instance.new("UICorner")
pauseCorner.CornerRadius = UDim.new(0, 15)
pauseCorner.Parent = pausePanel

local pauseTitle = Instance.new("TextLabel")
pauseTitle.Name = "Title"
pauseTitle.Size = UDim2.new(1, 0, 0, 60)
pauseTitle.BackgroundTransparency = 1
pauseTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
pauseTitle.TextSize = 40
pauseTitle.Font = Enum.Font.GothamBold
pauseTitle.Text = "PAUSED"
pauseTitle.Parent = pausePanel

local resumeButton = Instance.new("TextButton")
resumeButton.Name = "ResumeButton"
resumeButton.Size = UDim2.new(0, 300, 0, 50)
resumeButton.Position = UDim2.new(0.5, -150, 0, 80)
resumeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
resumeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resumeButton.TextSize = 18
resumeButton.Font = Enum.Font.GothamBold
resumeButton.Text = "RESUME"
resumeButton.BorderSizePixel = 0
resumeButton.Parent = pausePanel

local resumeCorner = Instance.new("UICorner")
resumeCorner.CornerRadius = UDim.new(0, 8)
resumeCorner.Parent = resumeButton

local pauseQuitButton = Instance.new("TextButton")
pauseQuitButton.Name = "QuitButton"
pauseQuitButton.Size = UDim2.new(0, 300, 0, 50)
pauseQuitButton.Position = UDim2.new(0.5, -150, 0, 150)
pauseQuitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
pauseQuitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
pauseQuitButton.TextSize = 18
pauseQuitButton.Font = Enum.Font.GothamBold
pauseQuitButton.Text = "QUIT TO MENU"
pauseQuitButton.BorderSizePixel = 0
pauseQuitButton.Parent = pausePanel

local pauseQuitCorner = Instance.new("UICorner")
pauseQuitCorner.CornerRadius = UDim.new(0, 8)
pauseQuitCorner.Parent = pauseQuitButton

-- ===== Variables =====
local gameRunning = false
local gamePaused = false
local score = 0

-- ===== Functions =====
local function showMainMenu()
    mainMenuFrame.Visible = true
    hudFrame.Visible = false
    pauseMenuFrame.Visible = false
    gameRunning = false
    gamePaused = false
end

local function startGame()
    mainMenuFrame.Visible = false
    hudFrame.Visible = true
    pauseMenuFrame.Visible = false
    gameRunning = true
    gamePaused = false
    score = 0
    scoreValue.Text = tostring(score)
end

local function pauseGame()
    if gameRunning then
        gamePaused = true
        pauseMenuFrame.Visible = true
        hudFrame.Visible = false
    end
end

local function resumeGame()
    if gameRunning and gamePaused then
        gamePaused = false
        pauseMenuFrame.Visible = false
        hudFrame.Visible = true
    end
end

-- ===== Update Health Bar =====
local function updateHealthBar()
    if humanoid and gameRunning then
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        healthBarFill:TweenSize(UDim2.new(healthPercent, 0, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.1, true)
    end
end

-- ===== Button Connections =====
playButton.MouseButton1Click:Connect(startGame)
settingsButton.MouseButton1Click:Connect(function()
    print("Settings clicked")
end)
quitButton.MouseButton1Click:Connect(function()
    LocalPlayer:Kick("Thanks for playing!")
end)

resumeButton.MouseButton1Click:Connect(resumeGame)
pauseQuitButton.MouseButton1Click:Connect(showMainMenu)

-- ===== Input Handling =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Escape then
        if gameRunning and not gamePaused then
            pauseGame()
        elseif gamePaused then
            resumeGame()
        end
    end
end)

-- ===== Update Loop =====
RunService.Heartbeat:Connect(function()
    if gameRunning then
        updateHealthBar()
    end
end)

-- ===== Character Respawn =====
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
end)

-- ===== Show Main Menu on Start =====
showMainMenu()
