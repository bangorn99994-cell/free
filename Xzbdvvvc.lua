-- Gui to Lua
-- Version: 3.2

-- Instances:

local UESP1 = Instance.new("ScreenGui")
local ESPFRAME = Instance.new("Frame")
local Frame = Instance.new("Frame")
local DropShadowHolder = Instance.new("Frame")
local DropShadow = Instance.new("ImageLabel")
local ESPSTUFF = Instance.new("Folder")
local EXAMPLEGLOW = Instance.new("ImageLabel")
local Tracer = Instance.new("Frame")
local BOXESP = Instance.new("Frame")
local BOXESP_2 = Instance.new("Frame")
local BOXESP_3 = Instance.new("Frame")
local BOXESP_4 = Instance.new("Frame")
local Two = Instance.new("TextLabel")
local One = Instance.new("TextLabel")
local Three = Instance.new("TextLabel")
local Dup = Instance.new("TextLabel")
local TextLabel = Instance.new("ImageLabel")
local ESPS = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local NAMESP = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Description = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local HEALTHESP = Instance.new("Frame")
local Title_2 = Instance.new("TextLabel")
local Description_2 = Instance.new("TextLabel")
local TextButton_2 = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local DistanceESP = Instance.new("Frame")
local Title_3 = Instance.new("TextLabel")
local Description_3 = Instance.new("TextLabel")
local TextButton_3 = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local BOXESP_5 = Instance.new("Frame")
local Title_4 = Instance.new("TextLabel")
local Description_4 = Instance.new("TextLabel")
local TextButton_4 = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local Outlineglow = Instance.new("Frame")
local Title_5 = Instance.new("TextLabel")
local Description_5 = Instance.new("TextLabel")
local TextButton_5 = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local TracerESP = Instance.new("Frame")
local Title_6 = Instance.new("TextLabel")
local Description_6 = Instance.new("TextLabel")
local TextButton_6 = Instance.new("TextButton")
local UICorner_6 = Instance.new("UICorner")
local TeamColor = Instance.new("Frame")
local Title_7 = Instance.new("TextLabel")
local Description_7 = Instance.new("TextLabel")
local TextButton_7 = Instance.new("TextButton")
local UICorner_7 = Instance.new("UICorner")
local AllyESP = Instance.new("Frame")
local Title_8 = Instance.new("TextLabel")
local Description_8 = Instance.new("TextLabel")
local TextButton_8 = Instance.new("TextButton")
local UICorner_8 = Instance.new("UICorner")

-- === START OF NEW AIMBOT INSTANCES ===
local AimbotESP = Instance.new("Frame")
local Title_Aimbot = Instance.new("TextLabel")
local Description_Aimbot = Instance.new("TextLabel")
local TextButton_Aimbot = Instance.new("TextButton")
local UICorner_Aimbot = Instance.new("UICorner")
-- === END OF NEW AIMBOT INSTANCES ===

local Settingsbuttopn = Instance.new("TextButton")
local SettingFrame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local ESPColor = Instance.new("TextLabel")
local ESPCOLOR = Instance.new("TextButton")
local UICorner_9 = Instance.new("UICorner")
local Framae = Instance.new("Frame")
local colorpi = Instance.new("Frame")
local RGB = Instance.new("ImageLabel")
local Marker = Instance.new("Frame")
local UICorner_10 = Instance.new("UICorner")
local UICorner_11 = Instance.new("UICorner")
local Preview = Instance.new("ImageLabel")
local OpenClose = Instance.new("Frame")
local BUTTONDESIGN = Instance.new("TextButton")
local UICorner_12 = Instance.new("UICorner")
local Title_9 = Instance.new("TextLabel")
local TextButton_9 = Instance.new("TextButton")
local UICorner_13 = Instance.new("UICorner")
local OpenCloseMob = Instance.new("Frame")
local BUTTONDESIGN_2 = Instance.new("TextButton")
local UICorner_14 = Instance.new("UICorner")
local Title_10 = Instance.new("TextLabel")
local TextButton_10 = Instance.new("ImageLabel")
local o = Instance.new("Folder")
local ColorSwitch = Instance.new("ImageLabel")
local LTXOPEN = Instance.new("ImageButton")

--Properties:

UESP1.Name = "UESP1"
UESP1.Parent = game.CoreGui
UESP1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ESPFRAME.Name = "ESPFRAME"
ESPFRAME.Parent = UESP1
ESPFRAME.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
ESPFRAME.BorderColor3 = Color3.fromRGB(0, 0, 0)
ESPFRAME.BorderSizePixel = 0
ESPFRAME.Position = UDim2.new(0.314642459, 0, 0.335503459, 0)
ESPFRAME.Size = UDim2.new(0, 436, 0, 266)

Frame.Parent = ESPFRAME
Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.497706413, 0, 0, 0)
Frame.Size = UDim2.new(0, 2, 0, 266)

DropShadowHolder.Name = "DropShadowHolder"
DropShadowHolder.Parent = ESPFRAME
DropShadowHolder.BackgroundTransparency = 1.000
DropShadowHolder.BorderSizePixel = 0
DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder.ZIndex = 0

DropShadow.Name = "DropShadow"
DropShadow.Parent = DropShadowHolder
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.BackgroundTransparency = 1.000
DropShadow.BorderSizePixel = 0
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow.Size = UDim2.new(1, 47, 1, 47)
DropShadow.ZIndex = 0
DropShadow.Image = "rbxassetid://6014261993"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 0.500
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

ESPSTUFF.Name = "ESPSTUFF"
ESPSTUFF.Parent = ESPFRAME

EXAMPLEGLOW.Name = "EXAMPLE/GLOW"
EXAMPLEGLOW.Parent = ESPSTUFF
EXAMPLEGLOW.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
EXAMPLEGLOW.BackgroundTransparency = 1.000
EXAMPLEGLOW.BorderColor3 = Color3.fromRGB(0, 0, 0)
EXAMPLEGLOW.BorderSizePixel = 0
EXAMPLEGLOW.Position = UDim2.new(0.293578118, 0, -0.0488721803, 0)
EXAMPLEGLOW.Size = UDim2.new(0, 387, 0, 292)
EXAMPLEGLOW.Image = "http://www.roblox.com/asset/?id=15586629590"

Tracer.Name = "Tracer"
Tracer.Parent = ESPSTUFF
Tracer.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
Tracer.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tracer.BorderSizePixel = 0
Tracer.Position = UDim2.new(0.733944952, 0, 0.590225577, 0)
Tracer.Size = UDim2.new(0, 2, 0, 98)
Tracer.Visible = false

BOXESP.Name = "BOXESP"
BOXESP.Parent = ESPSTUFF
BOXESP.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
BOXESP.BorderColor3 = Color3.fromRGB(0, 0, 0)
BOXESP.BorderSizePixel = 0
BOXESP.Position = UDim2.new(0.905963302, 0, 0.150375932, 0)
BOXESP.Size = UDim2.new(0, 2, 0, 186)
BOXESP.Visible = false

BOXESP_2.Name = "BOXESP"
BOXESP_2.Parent = ESPSTUFF
BOXESP_2.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
BOXESP_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
BOXESP_2.BorderSizePixel = 0
BOXESP_2.Position = UDim2.new(0.568807364, 0, 0.842105269, 0)
BOXESP_2.Size = UDim2.new(0, 147, 0, 2)
BOXESP_2.Visible = false

BOXESP_3.Name = "BOXESP"
BOXESP_3.Parent = ESPSTUFF
BOXESP_3.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
BOXESP_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
BOXESP_3.BorderSizePixel = 0
BOXESP_3.Position = UDim2.new(0.56422019, 0, 0.150375932, 0)
BOXESP_3.Size = UDim2.new(0, 2, 0, 186)
BOXESP_3.Visible = false

BOXESP_4.Name = "BOXESP"
BOXESP_4.Parent = ESPSTUFF
BOXESP_4.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
BOXESP_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
BOXESP_4.BorderSizePixel = 0
BOXESP_4.Position = UDim2.new(0.568807364, 0, 0.150375932, 0)
BOXESP_4.Size = UDim2.new(0, 147, 0, 2)
BOXESP_4.Visible = false

Two.Name = "Two"
Two.Parent = ESPSTUFF
Two.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Two.BackgroundTransparency = 1.000
Two.BorderColor3 = Color3.fromRGB(0, 0, 0)
Two.BorderSizePixel = 0
Two.Position = UDim2.new(0.678899109, 0, 0.176717654, 0)
Two.Size = UDim2.new(0, 51, 0, 14)
Two.Visible = false
Two.Font = Enum.Font.SourceSansSemibold
Two.Text = "Health"
Two.TextColor3 = Color3.fromRGB(255, 255, 255)
Two.TextSize = 14.000

One.Name = "One"
One.Parent = ESPSTUFF
One.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
One.BackgroundTransparency = 1.000
One.BorderColor3 = Color3.fromRGB(0, 0, 0)
One.BorderSizePixel = 0
One.Position = UDim2.new(0.568807364, 0, 0.176717654, 0)
One.Size = UDim2.new(0, 51, 0, 14)
One.Visible = false
One.Font = Enum.Font.SourceSansSemibold
One.Text = "Name"
One.TextColor3 = Color3.fromRGB(255, 255, 255)
One.TextSize = 14.000

Three.Name = "Three"
Three.Parent = ESPSTUFF
Three.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Three.BackgroundTransparency = 1.000
Three.BorderColor3 = Color3.fromRGB(0, 0, 0)
Three.BorderSizePixel = 0
Three.Position = UDim2.new(0.788990855, 0, 0.176717654, 0)
Three.Size = UDim2.new(0, 51, 0, 14)
Three.Visible = false
Three.Font = Enum.Font.SourceSansSemibold
Three.Text = "Distance"
Three.TextColor3 = Color3.fromRGB(255, 255, 255)
Three.TextSize = 14.000

Dup.Name = "Dup"
Dup.Parent = ESPSTUFF
Dup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Dup.BackgroundTransparency = 1.000
Dup.BorderColor3 = Color3.fromRGB(0, 0, 0)
Dup.BorderSizePixel = 0
Dup.Position = UDim2.new(0.678899109, 0, 0.176717654, 0)
Dup.Size = UDim2.new(0, 51, 0, 14)
Dup.Font = Enum.Font.SourceSansSemibold
Dup.Text = ""
Dup.TextColor3 = Color3.fromRGB(255, 255, 255)
Dup.TextSize = 14.000

TextLabel.Name = "TextLabel"
TextLabel.Parent = ESPFRAME
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.112385318, 0, 0.0263157897, 0)
TextLabel.Size = UDim2.new(0, 119, 0, 33)
TextLabel.Image = "http://www.roblox.com/asset/?id=12705497553"

ESPS.Name = "ESPS"
ESPS.Parent = ESPFRAME
ESPS.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ESPS.BackgroundTransparency = 1.000
ESPS.BorderColor3 = Color3.fromRGB(0, 0, 0)
ESPS.BorderSizePixel = 0
ESPS.Position = UDim2.new(0.00158271438, 0, 0.180477053, 0)
ESPS.Selectable = false
ESPS.Size = UDim2.new(0, 216, 0, 217)
ESPS.CanvasSize = UDim2.new(0, 0, 1.25, 0) -- Adjusted CanvasSize to fit new Aimbot feature
ESPS.ScrollBarThickness = 2

UIListLayout.Parent = ESPS
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

NAMESP.Name = "NAMESP"
NAMESP.Parent = ESPS
NAMESP.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
NAMESP.BorderColor3 = Color3.fromRGB(0, 0, 0)
NAMESP.BorderSizePixel = 0
NAMESP.Position = UDim2.new(0.00255471678, 0, 0, 0)
NAMESP.Size = UDim2.new(0, 217, 0, 54)

Title.Name = "Title"
Title.Parent = NAMESP
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0.0441988967, 0, 0.130989924, 0)
Title.Size = UDim2.new(0, 146, 0, 12)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Name ESP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14.000
Title.TextXAlignment = Enum.TextXAlignment.Left

Description.Name = "Description"
Description.Parent = NAMESP
Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description.BackgroundTransparency = 1.000
Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
Description.BorderSizePixel = 0
Description.Position = UDim2.new(0.0441990159, 0, 0.449419945, 0)
Description.Size = UDim2.new(0, 165, 0, 25)
Description.Font = Enum.Font.SourceSans
Description.Text = "Shows players name above their head"
Description.TextColor3 = Color3.fromRGB(255, 255, 255)
Description.TextSize = 12.000
Description.TextWrapped = true
Description.TextXAlignment = Enum.TextXAlignment.Left
Description.TextYAlignment = Enum.TextYAlignment.Top

TextButton.Parent = NAMESP
TextButton.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.851000011, 0, 0.314814806, 0)
TextButton.Size = UDim2.new(0, 20, 0, 20)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = ""
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 14.000

UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = TextButton

HEALTHESP.Name = "HEALTHESP"
HEALTHESP.Parent = ESPS
HEALTHESP.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
HEALTHESP.BorderColor3 = Color3.fromRGB(0, 0, 0)
HEALTHESP.BorderSizePixel = 0
HEALTHESP.Position = UDim2.new(0.00255471678, 0, 0, 0)
HEALTHESP.Size = UDim2.new(0, 217, 0, 54)

Title_2.Name = "Title"
Title_2.Parent = HEALTHESP
Title_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_2.BackgroundTransparency = 1.000
Title_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_2.BorderSizePixel = 0
Title_2.Position = UDim2.new(0.0441988967, 0, 0.130989924, 0)
Title_2.Size = UDim2.new(0, 146, 0, 12)
Title_2.Font = Enum.Font.SourceSansBold
Title_2.Text = "Health ESP"
Title_2.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_2.TextSize = 14.000
Title_2.TextXAlignment = Enum.TextXAlignment.Left

Description_2.Name = "Description"
Description_2.Parent = HEALTHESP
Description_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description_2.BackgroundTransparency = 1.000
Description_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Description_2.BorderSizePixel = 0
Description_2.Position = UDim2.new(0.0441990159, 0, 0.449419945, 0)
Description_2.Size = UDim2.new(0, 165, 0, 25)
Description_2.Font = Enum.Font.SourceSans
Description_2.Text = "Shows players healths above their head"
Description_2.TextColor3 = Color3.fromRGB(255, 255, 255)
Description_2.TextSize = 12.000
Description_2.TextWrapped = true
Description_2.TextXAlignment = Enum.TextXAlignment.Left
Description_2.TextYAlignment = Enum.TextYAlignment.Top

TextButton_2.Parent = HEALTHESP
TextButton_2.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_2.BorderSizePixel = 0
TextButton_2.Position = UDim2.new(0.851000011, 0, 0.314814806, 0)
TextButton_2.Size = UDim2.new(0, 20, 0, 20)
TextButton_2.Font = Enum.Font.SourceSans
TextButton_2.Text = ""
TextButton_2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_2.TextSize = 14.000

UICorner_2.CornerRadius = UDim.new(0, 5)
UICorner_2.Parent = TextButton_2

DistanceESP.Name = "DistanceESP"
DistanceESP.Parent = ESPS
DistanceESP.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
DistanceESP.BorderColor3 = Color3.fromRGB(0, 0, 0)
DistanceESP.BorderSizePixel = 0
DistanceESP.Position = UDim2.new(0.00255471678, 0, 0, 0)
DistanceESP.Size = UDim2.new(0, 217, 0, 54)

Title_3.Name = "Title"
Title_3.Parent = DistanceESP
Title_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_3.BackgroundTransparency = 1.000
Title_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_3.BorderSizePixel = 0
Title_3.Position = UDim2.new(0.0441988967, 0, 0.130989924, 0)
Title_3.Size = UDim2.new(0, 146, 0, 12)
Title_3.Font = Enum.Font.SourceSansBold
Title_3.Text = "Distance ESP"
Title_3.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_3.TextSize = 14.000
Title_3.TextXAlignment = Enum.TextXAlignment.Left

Description_3.Name = "Description"
Description_3.Parent = DistanceESP
Description_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description_3.BackgroundTransparency = 1.000
Description_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Description_3.BorderSizePixel = 0
Description_3.Position = UDim2.new(0.0441990159, 0, 0.449419945, 0)
Description_3.Size = UDim2.new(0, 165, 0, 25)
Description_3.Font = Enum.Font.SourceSans
Description_3.Text = "Shows how far each players are from you above their head"
Description_3.TextColor3 = Color3.fromRGB(255, 255, 255)
Description_3.TextSize = 12.000
Description_3.TextWrapped = true
Description_3.TextXAlignment = Enum.TextXAlignment.Left
Description_3.TextYAlignment = Enum.TextYAlignment.Top

TextButton_3.Parent = DistanceESP
TextButton_3.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_3.BorderSizePixel = 0
TextButton_3.Position = UDim2.new(0.851000011, 0, 0.314814806, 0)
TextButton_3.Size = UDim2.new(0, 20, 0, 20)
TextButton_3.Font = Enum.Font.SourceSans
TextButton_3.Text = ""
TextButton_3.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_3.TextSize = 14.000

UICorner_3.CornerRadius = UDim.new(0, 5)
UICorner_3.Parent = TextButton_3

BOXESP_5.Name = "BOXESP"
BOXESP_5.Parent = ESPS
BOXESP_5.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
BOXESP_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
BOXESP_5.BorderSizePixel = 0
BOXESP_5.Position = UDim2.new(0.00255471678, 0, 0, 0)
BOXESP_5.Size = UDim2.new(0, 217, 0, 54)

Title_4.Name = "Title"
Title_4.Parent = BOXESP_5
Title_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_4.BackgroundTransparency = 1.000
Title_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_4.BorderSizePixel = 0
Title_4.Position = UDim2.new(0.0441988967, 0, 0.130989924, 0)
Title_4.Size = UDim2.new(0, 146, 0, 12)
Title_4.Font = Enum.Font.SourceSansBold
Title_4.Text = "Box ESP"
Title_4.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_4.TextSize = 14.000
Title_4.TextXAlignment = Enum.TextXAlignment.Left

Description_4.Name = "Description"
Description_4.Parent = BOXESP_5
Description_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description_4.BackgroundTransparency = 1.000
Description_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
Description_4.BorderSizePixel = 0
Description_4.Position = UDim2.new(0.0441990159, 0, 0.449419945, 0)
Description_4.Size = UDim2.new(0, 165, 0, 25)
Description_4.Font = Enum.Font.SourceSans
Description_4.Text = "Puts a box around the character "
Description_4.TextColor3 = Color3.fromRGB(255, 255, 255)
Description_4.TextSize = 12.000
Description_4.TextWrapped = true
Description_4.TextXAlignment = Enum.TextXAlignment.Left
Description_4.TextYAlignment = Enum.TextYAlignment.Top

TextButton_4.Parent = BOXESP_5
TextButton_4.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_4.BorderSizePixel = 0
TextButton_4.Position = UDim2.new(0.851000011, 0, 0.314814806, 0)
TextButton_4.Size = UDim2.new(0, 20, 0, 20)
TextButton_4.Font = Enum.Font.SourceSans
TextButton_4.Text = ""
TextButton_4.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_4.TextSize = 14.000

UICorner_4.CornerRadius = UDim.new(0, 5)
UICorner_4.Parent = TextButton_4

Outlineglow.Name = "Outline / glow"
Outlineglow.Parent = ESPS
Outlineglow.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
Outlineglow.BorderColor3 = Color3.fromRGB(0, 0, 0)
Outlineglow.BorderSizePixel = 0
Outlineglow.Position = UDim2.new(0.00255471678, 0, 0, 0)
Outlineglow.Size = UDim2.new(0, 217, 0, 54)

Title_5.Name = "Title"
Title_5.Parent = Outlineglow
Title_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_5.BackgroundTransparency = 1.000
Title_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_5.BorderSizePixel = 0
Title_5.Position = UDim2.new(0.0441988967, 0, 0.130989924, 0)
Title_5.Size = UDim2.new(0, 146, 0, 12)
Title_5.Font = Enum.Font.SourceSansBold
Title_5.Text = "Outline/Glow ESP"
Title_5.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_5.TextSize = 14.000
Title_5.TextXAlignment = Enum.TextXAlignment.Left

Description_5.Name = "Description"
Description_5.Parent = Outlineglow
Description_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description_5.BackgroundTransparency = 1.000
Description_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
Description_5.BorderSizePixel = 0
Description_5.Position = UDim2.new(0.0441990159, 0, 0.449419945, 0)
Description_5.Size = UDim2.new(0, 165, 0, 25)
Description_5.Font = Enum.Font.SourceSans
Description_5.Text = "Puts a glow and outline each player to see them clearly"
Description_5.TextColor3 = Color3.fromRGB(255, 255, 255)
Description_5.TextSize = 12.000
Description_5.TextWrapped = true
Description_5.TextXAlignment = Enum.TextXAlignment.Left
Description_5.TextYAlignment = Enum.TextYAlignment.Top

TextButton_5.Parent = Outlineglow
TextButton_5.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_5.BorderSizePixel = 0
TextButton_5.Position = UDim2.new(0.851000011, 0, 0.314814806, 0)
TextButton_5.Size = UDim2.new(0, 20, 0, 20)
TextButton_5.Font = Enum.Font.SourceSans
TextButton_5.Text = ""
TextButton_5.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_5.TextSize = 14.000

UICorner_5.CornerRadius = UDim.new(0, 5)
UICorner_5.Parent = TextButton_5

TracerESP.Name = "TracerESP"
TracerESP.Parent = ESPS
TracerESP.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
TracerESP.BorderColor3 = Color3.fromRGB(0, 0, 0)
TracerESP.BorderSizePixel = 0
TracerESP.Position = UDim2.new(0.00255471678, 0, 0, 0)
TracerESP.Size = UDim2.new(0, 217, 0, 54)

Title_6.Name = "Title"
Title_6.Parent = TracerESP
Title_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_6.BackgroundTransparency = 1.000
Title_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_6.BorderSizePixel = 0
Title_6.Position = UDim2.new(0.0441988967, 0, 0.130989924, 0)
Title_6.Size = UDim2.new(0, 146, 0, 12)
Title_6.Font = Enum.Font.SourceSansBold
Title_6.Text = "Tracer ESP"
Title_6.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_6.TextSize = 14.000
Title_6.TextXAlignment = Enum.TextXAlignment.Left

Description_6.Name = "Description"
Description_6.Parent = TracerESP
Description_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description_6.BackgroundTransparency = 1.000
Description_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
Description_6.BorderSizePixel = 0
Description_6.Position = UDim2.new(0.0441990159, 0, 0.449419945, 0)
Description_6.Size = UDim2.new(0, 165, 0, 25)
Description_6.Font = Enum.Font.SourceSans
Description_6.Text = "A line from your character to theres to see where they are"
Description_6.TextColor3 = Color3.fromRGB(255, 255, 255)
Description_6.TextSize = 12.000
Description_6.TextWrapped = true
Description_6.TextXAlignment = Enum.TextXAlignment.Left
Description_6.TextYAlignment = Enum.TextYAlignment.Top

TextButton_6.Parent = TracerESP
TextButton_6.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_6.BorderSizePixel = 0
TextButton_6.Position = UDim2.new(0.851000011, 0, 0.314814806, 0)
TextButton_6.Size = UDim2.new(0, 20, 0, 20)
TextButton_6.Font = Enum.Font.SourceSans
TextButton_6.Text = ""
TextButton_6.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_6.TextSize = 14.000

UICorner_6.CornerRadius = UDim.new(0, 5)
UICorner_6.Parent = TextButton_6

TeamColor.Name = "TeamColor"
TeamColor.Parent = ESPS
TeamColor.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
TeamColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
TeamColor.BorderSizePixel = 0
TeamColor.Position = UDim2.new(0.00255471678, 0, 0, 0)
TeamColor.Size = UDim2.new(0, 217, 0, 54)

Title_7.Name = "Title"
Title_7.Parent = TeamColor
Title_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_7.BackgroundTransparency = 1.000
Title_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_7.BorderSizePixel = 0
Title_7.Position = UDim2.new(0.0441988967, 0, 0.130989924, 0)
Title_7.Size = UDim2.new(0, 146, 0, 12)
Title_7.Font = Enum.Font.SourceSansBold
Title_7.Text = "Team Color ESP"
Title_7.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_7.TextSize = 14.000
Title_7.TextXAlignment = Enum.TextXAlignment.Left

Description_7.Name = "Description"
Description_7.Parent = TeamColor
Description_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description_7.BackgroundTransparency = 1.000
Description_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
Description_7.BorderSizePixel = 0
Description_7.Position = UDim2.new(0.0441990159, 0, 0.449419945, 0)
Description_7.Size = UDim2.new(0, 165, 0, 25)
Description_7.Font = Enum.Font.SourceSans
Description_7.Text = "Change the colors of the ESP based on team"
Description_7.TextColor3 = Color3.fromRGB(255, 255, 255)
Description_7.TextSize = 12.000
Description_7.TextWrapped = true
Description_7.TextXAlignment = Enum.TextXAlignment.Left
Description_7.TextYAlignment = Enum.TextYAlignment.Top

TextButton_7.Parent = TeamColor
TextButton_7.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_7.BorderSizePixel = 0
TextButton_7.Position = UDim2.new(0.851000011, 0, 0.314814806, 0)
TextButton_7.Size = UDim2.new(0, 20, 0, 20)
TextButton_7.Font = Enum.Font.SourceSans
TextButton_7.Text = ""
TextButton_7.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_7.TextSize = 14.000

UICorner_7.CornerRadius = UDim.new(0, 5)
UICorner_7.Parent = TextButton_7

AllyESP.Name = "AllyESP"
AllyESP.Parent = ESPS
AllyESP.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
AllyESP.BorderColor3 = Color3.fromRGB(0, 0, 0)
AllyESP.BorderSizePixel = 0
AllyESP.Position = UDim2.new(0.00255471678, 0, 0, 0)
AllyESP.Size = UDim2.new(0, 217, 0, 54)

Title_8.Name = "Title"
Title_8.Parent = AllyESP
Title_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_8.BackgroundTransparency = 1.000
Title_8.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_8.BorderSizePixel = 0
Title_8.Position = UDim2.new(0.0441988967, 0, 0.130989924, 0)
Title_8.Size = UDim2.new(0, 146, 0, 12)
Title_8.Font = Enum.Font.SourceSansBold
Title_8.Text = "Ally Check"
Title_8.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_8.TextSize = 14.000
Title_8.TextXAlignment = Enum.TextXAlignment.Left

Description_8.Name = "Description"
Description_8.Parent = AllyESP
Description_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description_8.BackgroundTransparency = 1.000
Description_8.BorderColor3 = Color3.fromRGB(0, 0, 0)
Description_8.BorderSizePixel = 0
Description_8.Position = UDim2.new(0.0441990159, 0, 0.449419945, 0)
Description_8.Size = UDim2.new(0, 165, 0, 25)
Description_8.Font = Enum.Font.SourceSans
Description_8.Text = "Turns off ESP features for your teammates."
Description_8.TextColor3 = Color3.fromRGB(255, 255, 255)
Description_8.TextSize = 12.000
Description_8.TextWrapped = true
Description_8.TextXAlignment = Enum.TextXAlignment.Left
Description_8.TextYAlignment = Enum.TextYAlignment.Top

TextButton_8.Parent = AllyESP
TextButton_8.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton_8.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_8.BorderSizePixel = 0
TextButton_8.Position = UDim2.new(0.851000011, 0, 0.314814806, 0)
TextButton_8.Size = UDim2.new(0, 20, 0, 20)
TextButton_8.Font = Enum.Font.SourceSans
TextButton_8.Text = ""
TextButton_8.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_8.TextSize = 14.000

UICorner_8.CornerRadius = UDim.new(0, 5)
UICorner_8.Parent = TextButton_8

-- === START OF NEW AIMBOT PROPERTIES ===
AimbotESP.Name = "AimbotESP"
AimbotESP.Parent = ESPS
AimbotESP.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
AimbotESP.BorderColor3 = Color3.fromRGB(0, 0, 0)
AimbotESP.BorderSizePixel = 0
AimbotESP.Position = UDim2.new(0.00255471678, 0, 0, 0)
AimbotESP.Size = UDim2.new(0, 217, 0, 54)

Title_Aimbot.Name = "Title"
Title_Aimbot.Parent = AimbotESP
Title_Aimbot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_Aimbot.BackgroundTransparency = 1.000
Title_Aimbot.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_Aimbot.BorderSizePixel = 0
Title_Aimbot.Position = UDim2.new(0.0441988967, 0, 0.130989924, 0)
Title_Aimbot.Size = UDim2.new(0, 146, 0, 12)
Title_Aimbot.Font = Enum.Font.SourceSansBold
Title_Aimbot.Text = "Head Lock (Aimbot)"
Title_Aimbot.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_Aimbot.TextSize = 14.000
Title_Aimbot.TextXAlignment = Enum.TextXAlignment.Left

Description_Aimbot.Name = "Description"
Description_Aimbot.Parent = AimbotESP
Description_Aimbot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Description_Aimbot.BackgroundTransparency = 1.000
Description_Aimbot.BorderColor3 = Color3.fromRGB(0, 0, 0)
Description_Aimbot.BorderSizePixel = 0
Description_Aimbot.Position = UDim2.new(0.0441990159, 0, 0.449419945, 0)
Description_Aimbot.Size = UDim2.new(0, 165, 0, 25)
Description_Aimbot.Font = Enum.Font.SourceSans
Description_Aimbot.Text = "Automatically aims at the enemy's head (Head Lock)."
Description_Aimbot.TextColor3 = Color3.fromRGB(255, 255, 255)
Description_Aimbot.TextSize = 12.000
Description_Aimbot.TextWrapped = true
Description_Aimbot.TextXAlignment = Enum.TextXAlignment.Left
Description_Aimbot.TextYAlignment = Enum.TextYAlignment.Top

TextButton_Aimbot.Parent = AimbotESP
TextButton_Aimbot.Name = "AimbotToggle"
TextButton_Aimbot.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton_Aimbot.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_Aimbot.BorderSizePixel = 0
TextButton_Aimbot.Position = UDim2.new(0.851000011, 0, 0.314814806, 0)
TextButton_Aimbot.Size = UDim2.new(0, 20, 0, 20)
TextButton_Aimbot.Font = Enum.Font.SourceSans
TextButton_Aimbot.Text = ""
TextButton_Aimbot.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_Aimbot.TextSize = 14.000

UICorner_Aimbot.CornerRadius = UDim.new(0, 5)
UICorner_Aimbot.Parent = TextButton_Aimbot
-- === END OF NEW AIMBOT PROPERTIES ===

Settingsbuttopn.Name = "Settingsbuttopn"
Settingsbuttopn.Parent = ESPFRAME
Settingsbuttopn.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
Settingsbuttopn.BorderColor3 = Color3.fromRGB(0, 0, 0)
Settingsbuttopn.BorderSizePixel = 0
Settingsbuttopn.Position = UDim2.new(0.403669715, 0, 0.0451127887, 0)
Settingsbuttopn.Size = UDim2.new(0, 25, 0, 25)
Settingsbuttopn.Font = Enum.Font.SourceSans
Settingsbuttopn.Text = ""
Settingsbuttopn.TextColor3 = Color3.fromRGB(0, 0, 0)
Settingsbuttopn.TextSize = 14.000
Settingsbuttopn.Image = "rbxassetid://15586940801"

SettingFrame.Name = "SettingFrame"
SettingFrame.Parent = ESPFRAME
SettingFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
SettingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
SettingFrame.BorderSizePixel = 0
SettingFrame.Position = UDim2.new(0.504587173, 0, 0, 0)
SettingFrame.Size = UDim2.new(0, 216, 0, 266)

title.Name = "title"
title.Parent = SettingFrame
title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1.000
title.BorderColor3 = Color3.fromRGB(0, 0, 0)
title.BorderSizePixel = 0
title.Position = UDim2.new(0.395833343, 0, 0.0451127887, 0)
title.Size = UDim2.new(0, 48, 0, 25)
title.Font = Enum.Font.SourceSansBold
title.Text = "Settings"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14.000

ESPColor.Name = "ESP Color"
ESPColor.Parent = SettingFrame
ESPColor.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
ESPColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
ESPColor.BorderSizePixel = 0
ESPColor.Position = UDim2.new(0.00462962976, 0, 0.17669173, 0)
ESPColor.Size = UDim2.new(0, 215, 0, 54)
ESPColor.Font = Enum.Font.SourceSans
ESPColor.Text = ""
ESPColor.TextColor3 = Color3.fromRGB(0, 0, 0)
ESPColor.TextSize = 14.000

ESPCOLOR.Name = "ESPCOLOR"
ESPCOLOR.Parent = ESPColor
ESPCOLOR.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
ESPCOLOR.BorderColor3 = Color3.fromRGB(0, 0, 0)
ESPCOLOR.BorderSizePixel = 0
ESPCOLOR.Position = UDim2.new(0.851000011, 0, 0.314814806, 0)
ESPCOLOR.Size = UDim2.new(0, 20, 0, 20)
ESPCOLOR.Font = Enum.Font.SourceSans
ESPCOLOR.Text = ""
ESPCOLOR.TextColor3 = Color3.fromRGB(0, 0, 0)
ESPCOLOR.TextSize = 14.000

UICorner_9.CornerRadius = UDim.new(0, 5)
UICorner_9.Parent = ESPCOLOR

Framae.Name = "Framae"
Framae.Parent = ESPColor
Framae.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Framae.BackgroundTransparency = 1.000
Framae.BorderColor3 = Color3.fromRGB(0, 0, 0)
Framae.BorderSizePixel = 0
Framae.Position = UDim2.new(0.0441988967, 0, 0.130989924, 0)
Framae.Size = UDim2.new(0, 146, 0, 43)
Framae.Visible = true

colorpi.Name = "colorpi"
colorpi.Parent = Framae
colorpi.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
colorpi.BorderColor3 = Color3.fromRGB(0, 0, 0)
colorpi.BorderSizePixel = 0
colorpi.Position = UDim2.new(-1.49315064, 0, -3.102602, 0)
colorpi.Size = UDim2.new(0, 206, 0, 150)

RGB.Name = "RGB"
RGB.Parent = colorpi
RGB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RGB.BorderColor3 = Color3.fromRGB(0, 0, 0)
RGB.BorderSizePixel = 0
RGB.Position = UDim2.new(0.0682255775, 0, 0.13333334, 0)
RGB.Size = UDim2.new(0, 137, 0, 122)
RGB.Image = "rbxassetid://15586675034"

Marker.Name = "Marker"
Marker.Parent = RGB
Marker.AnchorPoint = Vector2.new(0.5, 0.5)
Marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Marker.BorderColor3 = Color3.fromRGB(0, 0, 0)
Marker.BorderSizePixel = 0
Marker.Position = UDim2.new(1, 0, 1, 0)
Marker.Size = UDim2.new(0, 10, 0, 10)
Marker.Visible = true

UICorner_10.CornerRadius = UDim.new(0, 50)
UICorner_10.Parent = Marker

UICorner_11.CornerRadius = UDim.new(0, 5)
UICorner_11.Parent = colorpi

Preview.Name = "Preview"
Preview.Parent = colorpi
Preview.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Preview.BorderColor3 = Color3.fromRGB(0, 0, 0)
Preview.BorderSizePixel = 0
Preview.Position = UDim2.new(0.817478061, 0, 0.28, 0)
Preview.Size = UDim2.new(0, 20, 0, 20)
Preview.Image = "http://www.roblox.com/asset/?id=15586927870"
Preview.ImageColor3 = Color3.fromRGB(85, 170, 255)

OpenClose.Name = "OpenClose"
OpenClose.Parent = SettingFrame
OpenClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenClose.BackgroundTransparency = 1.000
OpenClose.BorderSizePixel = 0
OpenClose.Position = UDim2.new(0, 0, 0.447368413, 0)
OpenClose.Size = UDim2.new(0, 216, 0, 34)

BUTTONDESIGN.Name = "BUTTONDESIGN"
BUTTONDESIGN.Parent = OpenClose
BUTTONDESIGN.Active = false
BUTTONDESIGN.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
BUTTONDESIGN.BorderColor3 = Color3.fromRGB(0, 0, 0)
BUTTONDESIGN.BorderSizePixel = 0
BUTTONDESIGN.Position = UDim2.new(-0.0195446722, 0, -0.0294117648, 0)
BUTTONDESIGN.Selectable = false
BUTTONDESIGN.Size = UDim2.new(0, 194, 0, 33)
BUTTONDESIGN.Font = Enum.Font.SourceSans
BUTTONDESIGN.Text = ""
BUTTONDESIGN.TextColor3 = Color3.fromRGB(0, 0, 0)
BUTTONDESIGN.TextSize = 14.000

UICorner_12.CornerRadius = UDim.new(0, 4)
UICorner_12.Parent = BUTTONDESIGN

Title_9.Name = "Title"
Title_9.Parent = BUTTONDESIGN
Title_9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_9.BackgroundTransparency = 1.000
Title_9.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_9.BorderSizePixel = 0
Title_9.Position = UDim2.new(0.0331491716, 0, 0.175215289, 0)
Title_9.Size = UDim2.new(0, 129, 0, 20)
Title_9.Font = Enum.Font.SourceSansBold
Title_9.Text = "Open/Close GUI"
Title_9.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_9.TextSize = 14.000
Title_9.TextXAlignment = Enum.TextXAlignment.Left

TextButton_9.Name = "TextButton"
TextButton_9.Parent = BUTTONDESIGN
TextButton_9.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton_9.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_9.BorderSizePixel = 0
TextButton_9.Position = UDim2.new(0.851000011, 0, 0.205882356, 0)
TextButton_9.Size = UDim2.new(0, 20, 0, 20)
TextButton_9.Font = Enum.Font.SourceSans
TextButton_9.Text = ""
TextButton_9.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_9.TextSize = 14.000
TextButton_9.Image = "rbxassetid://6034176100"
TextButton_9.ImageColor3 = Color3.fromRGB(255, 255, 255)

UICorner_13.CornerRadius = UDim.new(0, 5)
UICorner_13.Parent = TextButton_9

OpenCloseMob.Name = "OpenCloseMob"
OpenCloseMob.Parent = SettingFrame
OpenCloseMob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenCloseMob.BackgroundTransparency = 1.000
OpenCloseMob.BorderSizePixel = 0
OpenCloseMob.Position = UDim2.new(0, 0, 0.582706749, 0)
OpenCloseMob.Size = UDim2.new(0, 216, 0, 34)

BUTTONDESIGN_2.Name = "BUTTONDESIGN"
BUTTONDESIGN_2.Parent = OpenCloseMob
BUTTONDESIGN_2.Active = false
BUTTONDESIGN_2.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
BUTTONDESIGN_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
BUTTONDESIGN_2.BorderSizePixel = 0
BUTTONDESIGN_2.Position = UDim2.new(-0.0195446722, 0, -0.0294117648, 0)
BUTTONDESIGN_2.Selectable = false
BUTTONDESIGN_2.Size = UDim2.new(0, 194, 0, 33)
BUTTONDESIGN_2.Font = Enum.Font.SourceSans
BUTTONDESIGN_2.Text = ""
BUTTONDESIGN_2.TextColor3 = Color3.fromRGB(0, 0, 0)
BUTTONDESIGN_2.TextSize = 14.000

UICorner_14.CornerRadius = UDim.new(0, 4)
UICorner_14.Parent = BUTTONDESIGN_2

Title_10.Name = "Title"
Title_10.Parent = BUTTONDESIGN_2
Title_10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_10.BackgroundTransparency = 1.000
Title_10.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_10.BorderSizePixel = 0
Title_10.Position = UDim2.new(0.0331491716, 0, 0.175215289, 0)
Title_10.Size = UDim2.new(0, 129, 0, 20)
Title_10.Font = Enum.Font.SourceSansBold
Title_10.Text = "Open/Close GUI (Mobile Only)"
Title_10.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_10.TextSize = 14.000
Title_10.TextXAlignment = Enum.TextXAlignment.Left

TextButton_10.Name = "TextButton"
TextButton_10.Parent = BUTTONDESIGN_2
TextButton_10.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
TextButton_10.BackgroundTransparency = 1.000
TextButton_10.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_10.BorderSizePixel = 0
TextButton_10.Position = UDim2.new(0.851000011, 0, 0.205882356, 0)
TextButton_10.Size = UDim2.new(0, 20, 0, 20)
TextButton_10.Image = "rbxassetid://6034176100"
TextButton_10.ImageColor3 = Color3.fromRGB(255, 255, 255)

o.Name = "o"
o.Parent = SettingFrame

ColorSwitch.Name = "ColorSwitch"
ColorSwitch.Parent = UESP1
ColorSwitch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ColorSwitch.BackgroundTransparency = 1.000
ColorSwitch.BorderColor3 = Color3.fromRGB(0, 0, 0)
ColorSwitch.BorderSizePixel = 0
ColorSwitch.Position = UDim2.new(0.320478141, 0, 0.00375939845, 0)
ColorSwitch.Size = UDim2.new(0, 19, 0, 17)
ColorSwitch.Image = "rbxassetid://15586927870"
ColorSwitch.ImageColor3 = Color3.fromRGB(85, 170, 255)

LTXOPEN.Name = "LTXOPEN"
LTXOPEN.Parent = UESP1
LTXOPEN.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
LTXOPEN.BorderColor3 = Color3.fromRGB(0, 0, 0)
LTXOPEN.BorderSizePixel = 0
LTXOPEN.Position = UDim2.new(0.0076045934, 0, 0.864661694, 0)
LTXOPEN.Size = UDim2.new(0, 194, 0, 33)
LTXOPEN.Image = "rbxassetid://15586675034"
LTXOPEN.ImageColor3 = Color3.fromRGB(0, 0, 0)
LTXOPEN.ImageTransparency = 1.000
LTXOPEN.ScaleType = Enum.ScaleType.Slice
LTXOPEN.SliceCenter = Rect.new(4, 4, 4, 4)
LTXOPEN.Visible = false

-- Scripts:

local function getdistance(targetPlayer)
    local localPlayer = game.Players.LocalPlayer
    if localPlayer.Character and targetPlayer.Character then
        local distance = (localPlayer.Character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude
        return math.floor(distance)
    end
    return 0
end

local function ZFLJAY_fake_script() -- TextButton_Aimbot.LocalScript (NEW SCRIPT)
    local script = TextButton_Aimbot
    local camera = game.Workspace.CurrentCamera
    local runService = game:GetService("RunService")
    local localPlayer = game.Players.LocalPlayer

    local aimbotSettings = {
        Enabled = false,
        Smoothness = 0.5, -- ค่าความนุ่มนวลในการเล็ง (ปรับได้ระหว่าง 0 ถึง 1, 1 คือเล็งทันที)
        FOV = 200, -- ขอบเขตการมองเห็น (Field of View) เป็น Studs
        TargetPart = "Head" -- เป้าหมายคือ Head
    }

    local function getClosestEnemyHead()
        local closestTarget = nil
        local shortestDistance = aimbotSettings.FOV

        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local targetPart = player.Character:FindFirstChild(aimbotSettings.TargetPart)
                
                if targetPart and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Ally Check: ตรวจสอบปุ่ม AllyESP (TextButton_8)
                    local allyCheckOn = TextButton_8.BackgroundColor3 ~= Color3.fromRGB(47, 47, 47)
                    if allyCheckOn and player.Team == localPlayer.Team then
                        continue -- ข้ามเพื่อนร่วมทีม
                    end

                    local distance = (localPlayer.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
                    
                    if distance < shortestDistance then
                        -- Optional: Check if the target is roughly in the screen (FOV Check)
                        local worldPoint, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                        local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                        local distanceToCenter = (Vector2.new(worldPoint.X, worldPoint.Y) - center).Magnitude

                        -- Basic FOV check (in screen space)
                        local screenFOV = 200 -- Screen radius (pixels)

                        if onScreen and distanceToCenter <= screenFOV then
                            shortestDistance = distance
                            closestTarget = targetPart
                        end
                    end
                end
            end
        end

        return closestTarget
    end

    script.MouseButton1Down:Connect(function()
        if script.Parent.BackgroundColor3 == Color3.fromRGB(47, 47, 47) then
            -- Toggle ON: ใช้สีจาก ColorSwitch
            script.Parent.BackgroundColor3 = ColorSwitch.ImageColor3
            script.Parent.Parent.BackgroundColor3 = ColorSwitch.ImageColor3
            script.Parent.Parent.BackgroundTransparency = 0.7
            aimbotSettings.Enabled = true
        else
            -- Toggle OFF
            script.Parent.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
            script.Parent.Parent.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
            script.Parent.Parent.BackgroundTransparency = 0
            aimbotSettings.Enabled = false
        end
    end)

    runService.Stepped:Connect(function()
        if aimbotSettings.Enabled and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            -- ต้องตรวจสอบว่าผู้เล่นกำลังควบคุมมุมกล้องหรือไม่ (CameraSubject) เพื่อให้ Aimbot ทำงานได้
            if camera.CameraSubject == localPlayer.Character.Humanoid then
                local targetPart = getClosestEnemyHead()

                if targetPart then
                    local targetPosition = targetPart.Position
                    local cameraCFrame = camera.CFrame

                    -- คำนวณ CFrame ใหม่เพื่อเล็งไปที่เป้าหมาย
                    local lookVector = (targetPosition - cameraCFrame.Position).Unit
                    local newCFrame = CFrame.new(cameraCFrame.Position, cameraCFrame.Position + lookVector)

                    -- ทำการ Lerp (ปรับมุมกล้องอย่างนุ่มนวล)
                    camera.CFrame = cameraCFrame:Lerp(newCFrame, aimbotSettings.Smoothness)
                end
            end
        end
    end)
end
coroutine.wrap(ZFLJAY_fake_script)()

local function LTXOPEN_fake_script() -- LTXOPEN.LocalScript
	local script = Instance.new('LocalScript', LTXOPEN)
	script.MouseButton1Click:Connect(function()
		script.Parent.Visible = false
		script.Parent.Parent.ESPFRAME.Visible = true
	end)
end
coroutine.wrap(LTXOPEN_fake_script)()
local function BFPWBAT_fake_script() -- UESP1.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(BFPWBAT_fake_script)()
local function XMMV_fake_script() -- Settingsbuttopn.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(XMMV_fake_script)()
local function VTBU_fake_script() -- ESPCOLOR.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(VTBU_fake_script)()
-- colorpi.ColorMain is disabled.
local function JXKWTO_fake_script() -- colorpi.ColorMain2
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(JXKWTO_fake_script)()
local function QKYM_fake_script() -- TextButton_9.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(QKYM_fake_script)()
local function TAJP_fake_script() -- BUTTONDESIGN_2.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(TAJP_fake_script)()
local function RJHCE_fake_script() -- ESPFRAME.tweening
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(RJHCE_fake_script)()
local function KBVRVKV_fake_script() -- ESPFRAME.drag
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(KBVRVKV_fake_script)()
local function NWHB_fake_script() -- Tracer.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(NWHB_fake_script)()
local function QFGMH_fake_script() -- BOXESP.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(QFGMH_fake_script)()
local function SFEB_fake_script() -- TextButton.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(SFEB_fake_script)()
local function RUHUSM_fake_script() -- TextButton_2.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(RUHUSM_fake_script)()
local function RXUPX_fake_script() -- TextButton_3.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(RXUPX_fake_script)()
local function OZSO_fake_script() -- TextButton_4.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(OZSO_fake_script)()
local function AHD_fake_script() -- TextButton_5.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(AHD_fake_script)()
local function CQQ_fake_script() -- TextButton_6.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(CQQ_fake_script)()
local function UVBZHX_fake_script() -- TextButton_7.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(UVBZHX_fake_script)()
local function FNODG_fake_script() -- TextButton_8.LocalScript
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(FNODG_fake_script)()
local function QFE_fake_script() -- TextButton_Aimbot.LocalScript (The old one is replaced by ZFLJAY)
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(QFE_fake_script)()
local function OQEQ_fake_script() -- ESPS.TextLabelUp
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(OQEQ_fake_script)()
local function HIFXYZJ_fake_script() -- ESPS.HIDEESP
-- [Script content omitted for brevity, keeping only the final coroutine calls]
end
coroutine.wrap(HIFXYZJ_fake_script)()

