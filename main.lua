-- Orion Universal UI (LocalScript)
-- Features: Player tab (speed/jump/teleport), Visuals (highlight/ESP), World (time/weather stub), Settings (UI toggle, theme)
-- Designed to be "universal": uses safe fallbacks and checks so it works in most Roblox games (client-side only).
-- Place this as a LocalScript in StarterPlayerScripts or run with an executor that supports Orion

-- == Loader: try several common Orion sources with pcall fallback ==
local Orion = nil
local sources = {
    "https://raw.githubusercontent.com/shlexware/Orion/main/source",
    "https://raw.githubusercontent.com/novaghoul/Orion/main/source",
}
for _, src in ipairs(sources) do
    local ok, res = pcall(function() return loadstring(game:HttpGet(src))() end)
    if ok and res then
        Orion = res
        break
    end
end

if not Orion then
    warn("Orion library failed to load. UI won't appear. Check internet access or Orion source URLs.")
    return
end

-- Services & locals
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players.PlayerAdded:Wait()
    LocalPlayer = Players.LocalPlayer
end

-- Utility functions
local function safeGetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid(char)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

-- Highlight manager
local highlights = {}
local function toggleHighlight(targetPlayer, enable)
    if not targetPlayer or not targetPlayer.Character then return end
    local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChildWhichIsA("BasePart")
    if not root then return end
    if enable then
        if highlights[targetPlayer] and highlights[targetPlayer].Instance then return end
        local hl = Instance.new("Highlight")
        hl.Name = "OrionHighlight"
        hl.Adornee = targetPlayer.Character
        hl.Parent = Workspace
        highlights[targetPlayer] = {Instance = hl}
    else
        if highlights[targetPlayer] and highlights[targetPlayer].Instance then
            highlights[targetPlayer].Instance:Destroy()
            highlights[targetPlayer] = nil
        end
    end
end

-- Simple ESP using BillboardGui (optional alternative to Highlight)
local espFolder = Instance.new("Folder")
espFolder.Name = "OrionESP"
espFolder.Parent = Workspace

local function createESP(p)
    if not p.Character then return end
    if espFolder:FindFirstChild(p.Name) then return end
    local bg = Instance.new("BillboardGui")
    bg.Name = p.Name
    bg.Adornee = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChildWhichIsA("BasePart")
    bg.Size = UDim2.new(0,100,0,30)
    bg.StudsOffset = Vector3.new(0,2.5,0)
    bg.AlwaysOnTop = true
    local label = Instance.new("TextLabel", bg)
    label.Size = UDim2.fromScale(1,1)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Text = p.Name
    label.Font = Enum.Font.Gotham
    label.TextStrokeTransparency = 0.6
    bg.Parent = espFolder
end

local function destroyESP(p)
    local v = espFolder:FindFirstChild(p.Name)
    if v then v:Destroy() end
end

-- Keep ESP in sync on join/leave
Players.PlayerAdded:Connect(function(p) if settings.espEnabled then createESP(p) end end)
Players.PlayerRemoving:Connect(function(p) destroyESP(p) end)

-- Default settings table
local settings = {
    uiVisible = true,
    walkSpeed = 16,
    jumpPower = 50,
    speedEnabled = false,
    jumpEnabled = false,
    espEnabled = false,
    highlightPlayers = false,
    uiToggleKey = Enum.KeyCode.RightControl,
}

-- Apply loop for speed/jump
RunService.Heartbeat:Connect(function()
    local char = safeGetCharacter()
    local humanoid = getHumanoid(char)
    if humanoid then
        if settings.speedEnabled then
            humanoid.WalkSpeed = settings.walkSpeed or 16
        else
            -- restore default if player's humanoid isn't using setting
            if humanoid.WalkSpeed ~= 16 and not settings.speedEnabled then
                -- only restore if not in a state changed by other scripts; conservative: leave it
            end
        end
        if settings.jumpEnabled then
            humanoid.JumpPower = settings.jumpPower or 50
            humanoid.UseJumpPower = true
        end
    end
end)

-- Orion UI creation
local Window = Orion:MakeWindow({Name = "Orion Universal UI", HidePremium = false, SaveConfig = true, IntroText = "Universal utility UI (client-side)"})

-- Player Tab
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998", PremiumOnly = false})
PlayerTab:AddLabel("Player utilities")

PlayerTab:AddToggle({Name = "Enable Speed", Default = false, Tooltip = "Toggle custom WalkSpeed", Flag = "SpeedToggle", Callback = function(val)
    settings.speedEnabled = val
end})

PlayerTab:AddSlider({Name = "WalkSpeed", Min = 8, Max = 300, Default = 16, Color = Color3.fromRGB(0,170,255), Increment = 1, Callback = function(val)
    settings.walkSpeed = val
end})

PlayerTab:AddToggle({Name = "Enable JumpPower", Default = false, Tooltip = "Toggle custom JumpPower", Callback = function(val)
    settings.jumpEnabled = val
end})

PlayerTab:AddSlider({Name = "JumpPower", Min = 30, Max = 300, Default = 50, Increment = 1, Callback = function(val)
    settings.jumpPower = val
end})

PlayerTab:AddButton({Name = "Reset Character", Callback = function()
    local char = safeGetCharacter()
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid.Health = 0
    end
end})

PlayerTab:AddTextbox({Name = "Teleport to Player (name)", Default = "", TextDisappear = true, Callback = function(text)
    if text == "" then return end
    local target = Players:FindFirstChild(text)
    if not target or not target.Character then
        Orion:MakeNotification({Name = "Teleport failed", Content = "Player not found or has no character.", Image = "rbxassetid://4483345998", Time = 3})
        return
    end
    local troot = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChildWhichIsA("BasePart")
    local myChar = safeGetCharacter()
    local myRoot = myChar:WaitForChild("HumanoidRootPart")
    myRoot.CFrame = troot.CFrame + Vector3.new(0,3,0)
end})

-- World Tab (limited - client-side stubs)
local WorldTab = Window:MakeTab({Name = "World", Icon = "rbxassetid://6023426915", PremiumOnly = false})
WorldTab:AddLabel("Client-only world tweaks (may not replicate for others)")
WorldTab:AddButton({Name = "Set Time (client)", Callback = function()
    local lighting = game:GetService("Lighting")
    lighting.TimeOfDay = "14:00:00"
    Orion:MakeNotification({Name = "Time changed (client)", Content = "Set TimeOfDay to 14:00 for you only.", Image = "rbxassetid://4483345998", Time = 3})
end})

-- Visuals Tab
local VisualsTab = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://4483345998", PremiumOnly = false})
VisualsTab:AddLabel("Visual helpers")
VisualsTab:AddToggle({Name = "Highlight Players", Default = false, Callback = function(val)
    settings.highlightPlayers = val
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            toggleHighlight(p, val)
        end
    end
end})

VisualsTab:AddToggle({Name = "ESP (Billboard)", Default = false, Callback = function(val)
    settings.espEnabled = val
    if val then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then createESP(p) end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            destroyESP(p)
        end
    end
end})

-- AIMBOT FUNCTION
local aimbotSettings = {enabled = false, lockPart = "Head", smoothness = 0}

local function getClosestPlayer()
    local closest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(aimbotSettings.lockPart) then
            local head = p.Character[aimbotSettings.lockPart]
            local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(head.Position)
            if onScreen then
                local mouse = LocalPlayer:GetMouse()
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < dist then
                    dist = distance
                    closest = head
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimbotSettings.enabled then
        local target = getClosestPlayer()
        if target then
            Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame:Lerp(CFrame.new(Workspace.CurrentCamera.CFrame.Position, target.Position), aimbotSettings.smoothness)
        end
    end
end)

VisualsTab:AddToggle({Name = "Aimbot (Head Lock)", Default = false, Callback = function(val)
    aimbotSettings.enabled = val
end})

VisualsTab:AddSlider({Name = "Smoothness", Min = 0, Max = 1, Default = 0, Increment = 0.01, Callback = function(val)
    aimbotSettings.smoothness = val
end})

VisualsTab:AddButton({Name = "Clear Visuals", Callback = function()
    for _, p in ipairs(Players:GetPlayers()) do
        toggleHighlight(p, false)
        destroyESP(p)
    end
end})

-- Settings Tab
local SettingsTab = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://7733964935", PremiumOnly = false})
SettingsTab:AddLabel("Interface & hotkeys")
SettingsTab:AddBind({Name = "Toggle UI (bind)", Default = settings.uiToggleKey, Hold = false, Callback = function(key)
    settings.uiToggleKey = key
end})

SettingsTab:AddDropdown({Name = "Theme", Default = "Default", Options = {"Default", "Dark", "Light"}, Callback = function(option)
    -- simplified theme handler
    if option == "Dark" then
        Window:SetTheme({Accent = Color3.fromRGB(50,50,50)})
    elseif option == "Light" then
        Window:SetTheme({Accent = Color3.fromRGB(230,230,230)})
    else
        Window:SetTheme({Accent = Color3.fromRGB(0,170,255)})
    end
end})

-- Save / Load Config (Orion has SaveConfig but provide quick buttons)
SettingsTab:AddButton({Name = "Save Config", Callback = function() Orion:SaveConfig() Orion:MakeNotification({Name = "Config", Content = "Saved.", Time = 2}) end})
SettingsTab:AddButton({Name = "Load Config", Callback = function() Orion:LoadConfig() Orion:MakeNotification({Name = "Config", Content = "Loaded.", Time = 2}) end})

-- UI toggle hotkey
-- Orion provides SetKeybind; if not, implement basic connection
if Orion.SetBind then
    Orion:SetBind({Name = "Toggle UI", Default = settings.uiToggleKey, Hold = false, Callback = function() Orion:ToggleUI() end})
else
    -- fallback: listen for key press
    local UserInput = game:GetService("UserInputService")
    UserInput.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == settings.uiToggleKey then
            Orion:ToggleUI()
        end
    end)
end

-- Clean up on close/unload
local function unload()
    -- destroy ESP/highlights
    for _, p in ipairs(Players:GetPlayers()) do
        toggleHighlight(p, false)
        destroyESP(p)
    end
    if espFolder then espFolder:Destroy() end
end

-- Make a small status notification
Orion:MakeNotification({Name = "Orion Universal UI", Content = "Loaded — Open the UI with the bind or the in-game button.", Image = "rbxassetid://4483345998", Time = 4})

-- Return unload function for advanced use
return {Unload = unload}
