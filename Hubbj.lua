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

-- NEW INSTANCES FOR HEADLOCK
local HeadLock = Instance.new("Frame")
local HeadLockTitle = Instance.new("TextLabel")
local HeadLockDescription = Instance.new("TextLabel")
local HeadLockToggle = Instance.new("TextButton")
local HeadLockUICorner = Instance.new("UICorner")

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
ESPS.CanvasSize = UDim2.new(0, 0, 1, 168)
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
Title_5
