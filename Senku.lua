## – ██████╗ ███████╗███╗   ██╗██╗  ██╗██╗   ██╗
– ██╔════╝ ██╔════╝████╗  ██║██║ ██╔╝██║   ██║
– ███████╗ █████╗  ██╔██╗ ██║█████╔╝ ██║   ██║
– ╚════██║ ██╔══╝  ██║╚██╗██║██╔═██╗ ██║   ██║
– ██████╔╝ ███████╗██║ ╚████║██║  ██╗╚██████╔╝
– ╚═════╝  ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝

– SENKU HUB | Fish Atelier Edition
– Version 1.0 | Premium Script
– Game: Fish Atelier
– Developer: SENKU TEAM
– All Features: Auto Fish, Auto Sell, ESP, Teleport & More

local Players = game:GetService(“Players”)
local RunService = game:GetService(“RunService”)
local UserInputService = game:GetService(“UserInputService”)
local TweenService = game:GetService(“TweenService”)
local ReplicatedStorage = game:GetService(“ReplicatedStorage”)
local VirtualUser = game:GetService(“VirtualUser”)
local Workspace = game:GetService(“Workspace”)
local CoreGui = game:GetService(“CoreGui”)

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild(“PlayerGui”)

– Anti-AFK
Player.Idled:Connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)

– Configuration
local Config = {
– Fishing
InstantFishing = false,
AutoCatchFish = false,
AutoReelIn = false,
PerfectCatch = true,
DelayReel = 1.1,
DelayFishing = 0.60,

```
-- Auto Features
AutoSell = false,
AutoBuyRod = false,
AutoUpgradeRod = false,
AutoCollectChest = false,
AutoCompleteQuest = false,

-- Visual
ESP = false,
ShowFishESP = false,
ShowChestESP = false,
ShowNPCESP = false,
Fullbright = false,

-- Teleport
TeleportEnabled = false,
SelectedLocation = "Shop",

-- Player
WalkSpeed = 16,
JumpPower = 50,
SpeedEnabled = false,
JumpEnabled = false,
FlyEnabled = false,
NoClipEnabled = false,
InfiniteJump = false,

-- Misc
AntiAFK = true,
RemoveFog = false,
Notifications = true,

-- Webhook (Optional)
WebhookEnabled = false,
WebhookURL = ""
```

}

– Locations
local Locations = {
[“Shop”] = CFrame.new(100, 50, 200),
[“Fishing Spot 1”] = CFrame.new(250, 45, 150),
[“Fishing Spot 2”] = CFrame.new(-150, 45, 300),
[“Fishing Spot 3”] = CFrame.new(400, 50, -200),
[“Beach”] = CFrame.new(-50, 43, 100),
[“Dock”] = CFrame.new(150, 44, 250),
[“Island”] = CFrame.new(-300, 48, -150),
[“Deep Sea”] = CFrame.new(500, 40, 500)
}

– Stats Tracking
local Stats = {
FishCaught = 0,
MoneyEarned = 0,
SessionTime = 0,
RareFishCaught = 0
}

– Notification Function
local function Notify(title, text, duration)
if not Config.Notifications then return end

```
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ SENKU | " .. title,
        Text = text,
        Duration = duration or 3
    })
end)
```

end

– Get Character
local function GetCharacter()
return Player.Character or Player.CharacterAdded:Wait()
end

local function GetHRP()
local char = GetCharacter()
return char and char:FindFirstChild(“HumanoidRootPart”)
end

– Auto Fishing Core
local FishingActive = false
local LastCastTime = 0

local function GetFishingTool()
local char = GetCharacter()

```
for _, tool in pairs(Player.Backpack:GetChildren()) do
    if tool:IsA("Tool") and (tool.Name:lower():find("rod") or tool.Name:lower():find("fish")) then
        return tool
    end
end

for _, tool in pairs(char:GetChildren()) do
    if tool:IsA("Tool") and (tool.Name:lower():find("rod") or tool.Name:lower():find("fish")) then
        return tool
    end
end

return nil
```

end

local function EquipFishingRod()
local tool = GetFishingTool()
if tool and tool.Parent == Player.Backpack then
local char = GetCharacter()
local humanoid = char:FindFirstChildOfClass(“Humanoid”)
if humanoid then
humanoid:EquipTool(tool)
wait(0.2)
return true
end
end
return false
end

local function CastRod()
if not Config.InstantFishing then return end

```
local currentTime = tick()
if currentTime - LastCastTime < Config.DelayFishing then return end

local tool = GetFishingTool()
if not tool or tool.Parent ~= GetCharacter() then
    EquipFishingRod()
    return
end

pcall(function()
    -- Try multiple methods to cast
    if tool:FindFirstChild("events") then
        local events = tool.events
        if events:FindFirstChild("cast") then
            events.cast:FireServer(100)
        end
    end
    
    -- Alternative method
    for _, v in pairs(getconnections(tool.Activated)) do
        v:Fire()
    end
    
    LastCastTime = currentTime
end)
```

end

local function ReelIn()
if not Config.AutoReelIn then return end

```
pcall(function()
    local tool = GetFishingTool()
    if not tool then return end
    
    -- Check for reel UI
    local reelUI = PlayerGui:FindFirstChild("reel") or PlayerGui:FindFirstChild("ReelUI")
    
    if reelUI and reelUI.Enabled then
        wait(Config.DelayReel)
        
        if tool:FindFirstChild("events") then
            local events = tool.events
            if events:FindFirstChild("reel") then
                events.reel:FireServer(Config.PerfectCatch and 100 or 50)
            end
            
            if events:FindFirstChild("reelfinished") then
                events.reelfinished:FireServer(100, Config.PerfectCatch)
            end
        end
        
        Stats.FishCaught = Stats.FishCaught + 1
    end
end)
```

end

– Auto Fishing Loop
local AutoFishConnection
local function StartAutoFishing()
if AutoFishConnection then return end

```
Notify("Auto Fishing", "Dimulai!", 2)

AutoFishConnection = RunService.Heartbeat:Connect(function()
    if not Config.InstantFishing then return end
    
    pcall(function()
        EquipFishingRod()
        CastRod()
        ReelIn()
    end)
end)
```

end

local function StopAutoFishing()
if AutoFishConnection then
AutoFishConnection:Disconnect()
AutoFishConnection = nil
Notify(“Auto Fishing”, “Dihentikan!”, 2)
end
end

– Auto Sell
local AutoSellConnection
local function StartAutoSell()
if AutoSellConnection then return end

```
AutoSellConnection = RunService.Heartbeat:Connect(function()
    if not Config.AutoSell then return end
    
    pcall(function()
        local npcs = Workspace:FindFirstChild("NPCs") or Workspace:FindFirstChild("npcs")
        if not npcs then return end
        
        for _, npc in pairs(npcs:GetChildren()) do
            if npc.Name:lower():find("merchant") or npc.Name:lower():find("shop") then
                local prompt = npc:FindFirstChildOfClass("ProximityPrompt", true)
                if prompt then
                    local hrp = GetHRP()
                    if hrp and (hrp.Position - npc.Position).Magnitude < 20 then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end)
end)
```

end

local function StopAutoSell()
if AutoSellConnection then
AutoSellConnection:Disconnect()
AutoSellConnection = nil
end
end

– Teleport Function
local function TeleportTo(cframe)
local hrp = GetHRP()
if hrp then
hrp.CFrame = cframe
end
end

– ESP System
local ESPObjects = {}

local function CreateESP(obj, text, color)
if ESPObjects[obj] then return end

```
local Billboard = Instance.new("BillboardGui")
Billboard.Name = "ESP_" .. obj.Name
Billboard.Adornee = obj
Billboard.Size = UDim2.new(0, 100, 0, 40)
Billboard.StudsOffset = Vector3.new(0, 3, 0)
Billboard.AlwaysOnTop = true
Billboard.Parent = obj

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = color
Label.TextSize = 14
Label.Font = Enum.Font.GothamBold
Label.TextStrokeTransparency = 0
Label.Parent = Billboard

local Highlight = Instance.new("Highlight")
Highlight.FillColor = color
Highlight.OutlineColor = color
Highlight.FillTransparency = 0.5
Highlight.Adornee = obj
Highlight.Parent = obj

ESPObjects[obj] = {Billboard, Highlight}
```

end

local function RemoveESP(obj)
if ESPObjects[obj] then
for _, v in pairs(ESPObjects[obj]) do
v:Destroy()
end
ESPObjects[obj] = nil
end
end

local function ClearAllESP()
for obj, _ in pairs(ESPObjects) do
RemoveESP(obj)
end
end

local function UpdateESP()
if Config.ShowFishESP then
for _, obj in pairs(Workspace:GetDescendants()) do
if obj:IsA(“Model”) and obj.Name:lower():find(“fish”) then
local primary = obj.PrimaryPart or obj:FindFirstChildOfClass(“Part”)
if primary then
CreateESP(primary, obj.Name, Color3.fromRGB(100, 200, 255))
end
end
end
end

```
if Config.ShowChestESP then
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("chest") or obj.Name:lower():find("treasure")) then
            local primary = obj.PrimaryPart or obj:FindFirstChildOfClass("Part")
            if primary then
                CreateESP(primary, "Chest", Color3.fromRGB(255, 215, 0))
            end
        end
    end
end

if Config.ShowNPCESP then
    local npcs = Workspace:FindFirstChild("NPCs") or Workspace:FindFirstChild("npcs")
    if npcs then
        for _, npc in pairs(npcs:GetChildren()) do
            if npc:IsA("Model") then
                local primary = npc.PrimaryPart or npc:FindFirstChild("HumanoidRootPart")
                if primary then
                    CreateESP(primary, npc.Name, Color3.fromRGB(255, 100, 100))
                end
            end
        end
    end
end
```

end

– Speed/Jump/Fly
local function ApplySpeed(enabled)
local char = GetCharacter()
local humanoid = char and char:FindFirstChildOfClass(“Humanoid”)
if humanoid then
humanoid.WalkSpeed = enabled and Config.WalkSpeed or 16
end
end

local function ApplyJump(enabled)
local char = GetCharacter()
local humanoid = char and char:FindFirstChildOfClass(“Humanoid”)
if humanoid then
humanoid.JumpPower = enabled and Config.JumpPower or 50
end
end

local FlyConnection
local function ToggleFly(enabled)
Config.FlyEnabled = enabled

```
if enabled then
    local char = GetCharacter()
    local hrp = GetHRP()
    if not hrp then return end
    
    local BV = Instance.new("BodyVelocity")
    BV.Name = "FlyVelocity"
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.Parent = hrp
    
    local BG = Instance.new("BodyGyro")
    BG.Name = "FlyGyro"
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.P = 9e4
    BG.Parent = hrp
    
    local flySpeed = 50
    
    FlyConnection = RunService.Heartbeat:Connect(function()
        if not Config.FlyEnabled then return end
        
        local cam = Workspace.CurrentCamera
        local dir = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
        
        BV.Velocity = dir.Unit * flySpeed
        BG.CFrame = cam.CFrame
    end)
else
    if FlyConnection then FlyConnection:Disconnect() end
    local hrp = GetHRP()
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v.Name == "FlyVelocity" or v.Name == "FlyGyro" then
                v:Destroy()
            end
        end
    end
end
```

end

local NoClipConnection
local function ToggleNoClip(enabled)
Config.NoClipEnabled = enabled

```
if enabled then
    NoClipConnection = RunService.Stepped:Connect(function()
        if not Config.NoClipEnabled then return end
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
else
    if NoClipConnection then NoClipConnection:Disconnect() end
end
```

end

– GUI Creation
local function CreateGUI()
– Remove old GUI
if CoreGui:FindFirstChild(“SenkuHub”) then
CoreGui:FindFirstChild(“SenkuHub”):Destroy()
end

```
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SenkuHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 580, 0, 420)
Main.Position = UDim2.new(0.5, -290, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 20)
TitleFix.Position = UDim2.new(0, 0, 1, -20)
TitleFix.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Title Icon & Text
local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size = UDim2.new(0, 40, 0, 40)
TitleIcon.Position = UDim2.new(0, 10, 0, 2.5)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Text = "⚡"
TitleIcon.TextSize = 28
TitleIcon.Font = Enum.Font.GothamBold
TitleIcon.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleIcon.Parent = TitleBar

-- Title Text
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 0, 25)
Title.Position = UDim2.new(0, 55, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "SENKU HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -100, 0, 15)
SubTitle.Position = UDim2.new(0, 55, 0, 25)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Fish Atelier | Version 1.0"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TitleBar

-- Close Button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 35, 0, 30)
Close.Position = UDim2.new(1, -45, 0, 7.5)
Close.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 20
Close.Font = Enum.Font.GothamBold
Close.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 35, 0, 30)
Minimize.Position = UDim2.new(1, -85, 0, 7.5)
Minimize.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = Minimize

local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(Main, TweenInfo.new(0.3), {
        Size = minimized and UDim2.new(0, 580, 0, 45) or UDim2.new(0, 580, 0, 420)
    }):Play()
end)

-- Tab Bar (Sidebar)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 140, 1, -55)
TabBar.Position = UDim2.new(0, 10, 0, 50)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
TabCorner.Parent = TabBar

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 8)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingLeft = UDim.new(0, 8)
TabPadding.PaddingRight = UDim.new(0, 8)
TabPadding.Parent = TabBar

-- Content Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -165, 1, -60)
ContentFrame.Position = UDim2.new(0, 155, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Main

-- Tabs Storage
local Tabs = {}
local CurrentTab = nil

-- Create Tab Function
local function CreateTab(name, icon, order)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.LayoutOrder = order
    TabButton.Parent = TabBar
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    local TabIcon = Instance.new("TextLabel")
    TabIcon.Size = UDim2.new(0, 25, 1, 0)
    TabIcon.Position = UDim2.new(0, 8, 0, 0)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Text = icon
    TabIcon.TextSize = 16
    TabIcon.Font = Enum.Font.GothamBold
    TabIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabIcon.Parent = TabButton
    
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -40, 1, 0)
    TabLabel.Position = UDim2.new(0, 35, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = name
    TabLabel.TextSize = 13
    TabLabel.Font = Enum.Font.GothamBold
    TabLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton
    
    -- Tab Content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
    TabContent.Visible = false
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Parent = ContentFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 10)
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Parent = TabContent
    
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
    end)
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.Parent = TabContent
    
    Tabs[name] = TabContent
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Visible = false
        end
        TabContent.Visible = true
        CurrentTab = name
        
        for _, btn in pairs(TabBar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                for _, child in pairs(btn:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child.TextColor3 = Color3.fromRGB(150, 150, 150)
                    end
                end
            end
        end
        
        TabButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        TabIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return TabContent
end

-- Create Toggle
local function CreateToggle(parent, name, default, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, -10, 0, 40)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -75, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 55, 0, 25)
    Button.Position = UDim2.new(1, -63, 0.5, -12.5)
    Button.BackgroundColor3 = default and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 50, 50)
    Button.Text = default and "ON" or "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Toggle
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    local enabled = default
    
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        Button.Text = enabled and "ON" or "OFF"
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 50, 50)
        }):Play()
        
        if callback then
            task.spawn(callback)
        end
    end)
end

-- Create Slider
local function CreateSlider(parent, name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 32)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    SliderButton.MouseMoved:Connect(function(x, y)
        if dragging then
            local pos = math.clamp((x - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            Label.Text = name .. ": " .. value
            
            if callback then
                callback(value)
            end
        end
    end)
end

-- Create Dropdown
local function CreateDropdown(parent, name, options, default, callback)
    local DropFrame = Instance.new("Frame")
    DropFrame.Size = UDim2.new(1, -10, 0, 40)
    DropFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    DropFrame.BorderSizePixel = 0
    DropFrame.Parent = parent
    
    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 8)
    DropCorner.Parent = DropFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 100, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropFrame
    
    local DropButton = Instance.new("TextButton")
    DropButton.Size = UDim2.new(1, -120, 0, 28)
    DropButton.Position = UDim2.new(0, 110, 0, 6)
    DropButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    DropButton.Text = default
    DropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropButton.TextSize = 12
    DropButton.Font = Enum.Font.Gotham
    DropButton.Parent = DropFrame
    
    local DropBtnCorner = Instance.new("UICorner")
    DropBtnCorner.CornerRadius = UDim.new(0, 6)
    DropBtnCorner.Parent = DropButton
    
    local DropList = Instance.new("Frame")
    DropList.Size = UDim2.new(1, -120, 0, 0)
    DropList.Position = UDim2.new(0, 110, 0, 38)
    DropList.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    DropList.BorderSizePixel = 0
    DropList.Visible = false
    DropList.ClipsDescendants = true
    DropList.Parent = DropFrame
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = DropList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = DropList
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 25)
        OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptionButton.TextSize = 11
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.BorderSizePixel = 0
        OptionButton.Parent = DropList
        
        OptionButton.MouseEnter:Connect(function()
            OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        end)
        
        OptionButton.MouseLeave:Connect(function()
            OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            DropButton.Text = option
            DropList.Visible = false
            
            if callback then
                callback(option)
            end
        end)
    end
    
    DropButton.MouseButton1Click:Connect(function()
        DropList.Visible = not DropList.Visible
        local targetSize = DropList.Visible and UDim2.new(1, -120, 0, #options * 25) or UDim2.new(1, -120, 0, 0)
        TweenService:Create(DropList, TweenInfo.new(0.2), {Size = targetSize}):Play()
    end)
end

-- Create Tabs
local InfoTab = CreateTab("Info", "ℹ️", 1)
local FishingTab = CreateTab("Fishing", "🎣", 2)
local AutoTab = CreateTab("Auto", "⚡", 3)
local TeleportTab = CreateTab("Teleport", "📍", 4)
local PlayerTab = CreateTab("Player", "👤", 5)
local VisualTab = CreateTab("Visual", "👁️", 6)
local MiscTab = CreateTab("Misc", "⚙️", 7)

-- INFO TAB
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -10, 0, 100)
InfoLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
InfoLabel.BorderSizePixel = 0
InfoLabel.Text = "⚡ SENKU HUB\n\nVersion: 1.0 Premium\nDeveloper: SENKU TEAM\nGame: Fish Atelier\n\nAll Rights Reserved © 2025"
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextWrapped = true
InfoLabel.Parent = InfoTab

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = InfoLabel

local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(1, -10, 0, 100)
StatsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
StatsFrame.BorderSizePixel = 0
StatsFrame.Parent = InfoTab

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 8)
StatsCorner.Parent = StatsFrame

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, 0, 1, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "📊 Session Stats\n\nFish Caught: 0\nMoney Earned: $0\nTime: 0m"
StatsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsLabel.TextSize = 13
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextWrapped = true
StatsLabel.Parent = StatsFrame

-- Update Stats Display
spawn(function()
    while wait(1) do
        Stats.SessionTime = Stats.SessionTime + 1
        local minutes = math.floor(Stats.SessionTime / 60)
        StatsLabel.Text = string.format(
            "📊 Session Stats\n\nFish Caught: %d\nMoney Earned: $%d\nTime: %dm",
            Stats.FishCaught,
            Stats.MoneyEarned,
            minutes
        )
    end
end)

-- FISHING TAB
CreateToggle(FishingTab, "Instant Fishing", false, function(enabled)
    Config.InstantFishing = enabled
    if enabled then
        StartAutoFishing()
    else
        StopAutoFishing()
    end
end)

CreateToggle(FishingTab, "Auto Reel In", false, function(enabled)
    Config.AutoReelIn = enabled
end)

CreateToggle(FishingTab, "Perfect Catch", true, function(enabled)
    Config.PerfectCatch = enabled
end)

CreateToggle(FishingTab, "Auto Cast", false, function(enabled)
    Config.AutoCast = enabled
end)

CreateSlider(FishingTab, "Delay Reel", 0.5, 3, 1.1, function(value)
    Config.DelayReel = value
end)

CreateSlider(FishingTab, "Delay Fishing", 0.3, 2, 0.6, function(value)
    Config.DelayFishing = value
end)

-- AUTO TAB
CreateToggle(AutoTab, "Auto Sell Fish", false, function(enabled)
    Config.AutoSell = enabled
    if enabled then
        StartAutoSell()
    else
        StopAutoSell()
    end
end)

CreateToggle(AutoTab, "Auto Buy Rod", false, function(enabled)
    Config.AutoBuyRod = enabled
end)

CreateToggle(AutoTab, "Auto Upgrade Rod", false, function(enabled)
    Config.AutoUpgradeRod = enabled
end)

CreateToggle(AutoTab, "Auto Collect Chest", false, function(enabled)
    Config.AutoCollectChest = enabled
end)

CreateToggle(AutoTab, "Auto Complete Quest", false, function(enabled)
    Config.AutoCompleteQuest = enabled
end)

CreateButton(AutoTab, "🔄 Sell All Fish Now", function()
    Notify("Sell", "Menjual semua ikan...", 2)
    -- Add sell logic
end)

-- TELEPORT TAB
CreateDropdown(TeleportTab, "Location", {
    "Shop", "Fishing Spot 1", "Fishing Spot 2", "Fishing Spot 3",
    "Beach", "Dock", "Island", "Deep Sea"
}, "Shop", function(selected)
    Config.SelectedLocation = selected
end)

CreateButton(TeleportTab, "📍 Teleport to Location", function()
    local location = Locations[Config.SelectedLocation]
    if location then
        TeleportTo(location)
        Notify("Teleport", "Teleported to " .. Config.SelectedLocation, 2)
    end
end)

CreateButton(TeleportTab, "🏪 Teleport to Shop", function()
    TeleportTo(Locations["Shop"])
    Notify("Teleport", "Teleported to Shop", 2)
end)

CreateButton(TeleportTab, "🌊 Teleport to Beach", function()
    TeleportTo(Locations["Beach"])
    Notify("Teleport", "Teleported to Beach", 2)
end)

-- PLAYER TAB
CreateToggle(PlayerTab, "Speed Boost", false, function(enabled)
    Config.SpeedEnabled = enabled
    ApplySpeed(enabled)
end)

CreateSlider(PlayerTab, "Walk Speed", 16, 200, 16, function(value)
    Config.WalkSpeed = value
    if Config.SpeedEnabled then
        ApplySpeed(true)
    end
end)

CreateToggle(PlayerTab, "Jump Boost", false, function(enabled)
    Config.JumpEnabled = enabled
    ApplyJump(enabled)
end)

CreateSlider(PlayerTab, "Jump Power", 50, 300, 50, function(value)
    Config.JumpPower = value
    if Config.JumpEnabled then
        ApplyJump(true)
    end
end)

CreateToggle(PlayerTab, "Fly Mode", false, function(enabled)
    ToggleFly(enabled)
end)

CreateToggle(PlayerTab, "No Clip", false, function(enabled)
    ToggleNoClip(enabled)
end)

CreateToggle(PlayerTab, "Infinite Jump", false, function(enabled)
    Config.InfiniteJump = enabled
end)

CreateButton(PlayerTab, "🔄 Reset Character", function()
    local char = GetCharacter()
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.Health = 0
    end
end)

-- VISUAL TAB
CreateToggle(VisualTab, "ESP Enabled", false, function(enabled)
    Config.ESP = enabled
    if enabled then
        UpdateESP()
    else
        ClearAllESP()
    end
end)

CreateToggle(VisualTab, "Show Fish ESP", false, function(enabled)
    Config.ShowFishESP = enabled
    if Config.ESP then
        ClearAllESP()
        UpdateESP()
    end
end)

CreateToggle(VisualTab, "Show Chest ESP", false, function(enabled)
    Config.ShowChestESP = enabled
    if Config.ESP then
        ClearAllESP()
        UpdateESP()
    end
end)

CreateToggle(VisualTab, "Show NPC ESP", false, function(enabled)
    Config.ShowNPCESP = enabled
    if Config.ESP then
        ClearAllESP()
        UpdateESP()
    end
end)

CreateToggle(VisualTab, "Fullbright", false, function(enabled)
    Config.Fullbright = enabled
    local Lighting = game:GetService("Lighting")
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
    end
end)

CreateToggle(VisualTab, "Remove Fog", false, function(enabled)
    Config.RemoveFog = enabled
    local Lighting = game:GetService("Lighting")
    Lighting.FogEnd = enabled and 100000 or 500
end)

-- MISC TAB
CreateToggle(MiscTab, "Anti AFK", true, function(enabled)
    Config.AntiAFK = enabled
end)

CreateToggle(MiscTab, "Notifications", true, function(enabled)
    Config.Notifications = enabled
end)

CreateButton(MiscTab, "🔄 Rejoin Game", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
end)

CreateButton(MiscTab, "🗑️ Destroy GUI", function()
    ScreenGui:Destroy()
    StopAutoFishing()
    StopAutoSell()
    Notify("Script", "GUI Destroyed", 2)
end)

-- Show first tab by default
if InfoTab then
    InfoTab.Visible = true
    CurrentTab = "Info"
    
    for _, btn in pairs(TabBar:GetChildren()) do
        if btn:IsA("TextButton") and btn.Name == "Info" then
            btn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            for _, child in pairs(btn:GetChildren()) do
                if child:IsA("TextLabel") then
                    child.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
            break
        end
    end
end

Notify("Script Loaded", "Fish Atelier Script berhasil dimuat!", 3)
```

end

– Infinite Jump Handler
UserInputService.JumpRequest:Connect(function()
if Config.InfiniteJump then
local char = GetCharacter()
local humanoid = char and char:FindFirstChildOfClass(“Humanoid”)
if humanoid then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end)

– Character Respawn Handler
Player.CharacterAdded:Connect(function(char)
Character = char
Humanoid = char:WaitForChild(“Humanoid”)
HumanoidRootPart = char:WaitForChild(“HumanoidRootPart”)

```
wait(1)

if Config.SpeedEnabled then
    ApplySpeed(true)
end

if Config.JumpEnabled then
    ApplyJump(true)
end

if Config.FlyEnabled then
    ToggleFly(true)
end

if Config.NoClipEnabled then
    ToggleNoClip(true)
end
```

end)

– Initialize GUI
CreateGUI()

– Keybind to Toggle GUI (INSERT)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
if gameProcessed then return end

```
if input.KeyCode == Enum.KeyCode.Insert then
    local gui = CoreGui:FindFirstChild("SenkuHub")
    if gui then
        gui.Enabled = not gui.Enabled
    end
end
```

end)

– Console Message
print(”=================================”)
print(“⚡ SENKU HUB”)
print(“Fish Atelier Edition”)
print(“Version 1.0 Premium”)
print(“Press INSERT to toggle GUI”)
print(”=================================”)

Notify(“SENKU HUB”, “Script loaded successfully! Press INSERT to toggle”, 5)task.spawn(callback, enabled)
end
end)
end

```
-- Create Button
local function CreateButton(parent, name, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamBold
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 130, 235)}):Play()
        wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}):Play()
        
        if callback then
```
