– SENKU HUB | Fish Atelier Edition
– Compact Version for Xeno Executor
– Version 1.0 Optimized

local Plr = game:GetService(“Players”).LocalPlayer
local Run = game:GetService(“RunService”)
local UIS = game:GetService(“UserInputService”)
local Tween = game:GetService(“TweenService”)
local CG = game:GetService(“CoreGui”)

– Anti-AFK
game:GetService(“VirtualUser”):CaptureController()
Plr.Idled:Connect(function()
game:GetService(“VirtualUser”):ClickButton2(Vector2.new())
end)

– Config
local C = {
AutoFish = false,
AutoSell = false,
AutoReel = false,
PerfectCatch = true,
Speed = false,
SpeedVal = 16,
Fly = false,
NoClip = false,
ESP = false
}

– Notify
local function N(t, m)
game:GetService(“StarterGui”):SetCore(“SendNotification”, {
Title = “⚡ SENKU | “ .. t,
Text = m,
Duration = 3
})
end

– Get Character
local function GetChar()
return Plr.Character or Plr.CharacterAdded:Wait()
end

local function GetHRP()
local c = GetChar()
return c and c:FindFirstChild(“HumanoidRootPart”)
end

– Get Rod
local function GetRod()
for _, t in pairs(Plr.Backpack:GetChildren()) do
if t:IsA(“Tool”) and (t.Name:lower():find(“rod”) or t.Name:lower():find(“fish”)) then
return t
end
end
for _, t in pairs(GetChar():GetChildren()) do
if t:IsA(“Tool”) and (t.Name:lower():find(“rod”) or t.Name:lower():find(“fish”)) then
return t
end
end
end

– Equip Rod
local function EquipRod()
local r = GetRod()
if r and r.Parent == Plr.Backpack then
GetChar():FindFirstChildOfClass(“Humanoid”):EquipTool(r)
wait(0.2)
end
end

– Auto Fishing
local FishConn
local function StartFish()
if FishConn then return end
N(“Auto Fish”, “Started!”)

```
FishConn = Run.Heartbeat:Connect(function()
    if not C.AutoFish then return end
    pcall(function()
        local r = GetRod()
        if not r then return end
        
        if r.Parent == Plr.Backpack then
            EquipRod()
        end
        
        -- Cast
        if r:FindFirstChild("events") then
            local e = r.events
            if e:FindFirstChild("cast") then
                e.cast:FireServer(100)
            end
        end
        
        -- Reel
        if C.AutoReel then
            local pg = Plr:FindFirstChild("PlayerGui")
            if pg then
                local reel = pg:FindFirstChild("reel")
                if reel and reel.Enabled then
                    wait(1.1)
                    if r:FindFirstChild("events") then
                        local e = r.events
                        if e:FindFirstChild("reelfinished") then
                            e.reelfinished:FireServer(100, C.PerfectCatch)
                        end
                    end
                end
            end
        end
    end)
end)
```

end

local function StopFish()
if FishConn then
FishConn:Disconnect()
FishConn = nil
N(“Auto Fish”, “Stopped!”)
end
end

– GUI
local function CreateGUI()
if CG:FindFirstChild(“SenkuGUI”) then
CG.SenkuGUI:Destroy()
end

```
local SG = Instance.new("ScreenGui")
SG.Name = "SenkuGUI"
SG.Parent = CG
SG.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 350)
Main.Position = UDim2.new(0.5, -200, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = SG

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0, 12)
MC.Parent = Main

-- Title
local Title = Instance.new("Frame")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.BorderSizePixel = 0
Title.Parent = Main

local TC = Instance.new("UICorner")
TC.CornerRadius = UDim.new(0, 12)
TC.Parent = Title

local TF = Instance.new("Frame")
TF.Size = UDim2.new(1, 0, 0, 20)
TF.Position = UDim2.new(0, 0, 1, -20)
TF.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
TF.BorderSizePixel = 0
TF.Parent = Title

local TL = Instance.new("TextLabel")
TL.Size = UDim2.new(1, -80, 1, 0)
TL.Position = UDim2.new(0, 10, 0, 0)
TL.BackgroundTransparency = 1
TL.Text = "⚡ SENKU HUB"
TL.TextColor3 = Color3.fromRGB(255, 215, 0)
TL.TextSize = 18
TL.Font = Enum.Font.GothamBold
TL.TextXAlignment = Enum.TextXAlignment.Left
TL.Parent = Title

-- Close
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 25)
Close.Position = UDim2.new(1, -38, 0, 7.5)
Close.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 16
Close.Font = Enum.Font.GothamBold
Close.Parent = Title

local CC = Instance.new("UICorner")
CC.CornerRadius = UDim.new(0, 6)
CC.Parent = Close

Close.MouseButton1Click:Connect(function()
    SG:Destroy()
end)

-- Content
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -55)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Main

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 8)
List.Parent = Scroll

List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 10)
end)

-- Create Toggle
local function Toggle(name, def, cb)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -10, 0, 38)
    F.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    F.BorderSizePixel = 0
    F.Parent = Scroll
    
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = F
    
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -70, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = Color3.fromRGB(255, 255, 255)
    L.TextSize = 13
    L.Font = Enum.Font.Gotham
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F
    
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 50, 0, 24)
    B.Position = UDim2.new(1, -58, 0.5, -12)
    B.BackgroundColor3 = def and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 50, 50)
    B.Text = def and "ON" or "OFF"
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.TextSize = 11
    B.Font = Enum.Font.GothamBold
    B.Parent = F
    
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = B
    
    local on = def
    
    B.MouseButton1Click:Connect(function()
        on = not on
        B.Text = on and "ON" or "OFF"
        Tween:Create(B, TweenInfo.new(0.2), {
            BackgroundColor3 = on and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 50, 50)
        }):Play()
        if cb then cb(on) end
    end)
end

-- Create Button
local function Btn(name, cb)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -10, 0, 38)
    B.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    B.BorderSizePixel = 0
    B.Text = name
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.TextSize = 13
    B.Font = Enum.Font.GothamBold
    B.Parent = Scroll
    
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 8)
    BC.Parent = B
    
    B.MouseButton1Click:Connect(function()
        if cb then cb() end
    end)
end

-- Toggles
Toggle("🎣 Instant Fishing", false, function(v)
    C.AutoFish = v
    if v then StartFish() else StopFish() end
end)

Toggle("🔄 Auto Reel", false, function(v)
    C.AutoReel = v
end)

Toggle("⭐ Perfect Catch", true, function(v)
    C.PerfectCatch = v
end)

Toggle("💰 Auto Sell", false, function(v)
    C.AutoSell = v
end)

Toggle("⚡ Speed Boost", false, function(v)
    C.Speed = v
    local h = GetChar():FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = v and 50 or 16
    end
end)

Toggle("✈️ Fly Mode", false, function(v)
    C.Fly = v
    local hrp = GetHRP()
    if not hrp then return end
    
    if v then
        local BV = Instance.new("BodyVelocity")
        BV.Name = "FlyV"
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.Parent = hrp
        
        local BG = Instance.new("BodyGyro")
        BG.Name = "FlyG"
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.Parent = hrp
        
        Run.Heartbeat:Connect(function()
            if not C.Fly then return end
            local cam = workspace.CurrentCamera
            local dir = Vector3.new()
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
            
            BV.Velocity = dir.Unit * 50
            BG.CFrame = cam.CFrame
        end)
    else
        for _, v in pairs(hrp:GetChildren()) do
            if v.Name == "FlyV" or v.Name == "FlyG" then
                v:Destroy()
            end
        end
    end
end)

Toggle("🚫 No Clip", false, function(v)
    C.NoClip = v
    if v then
        Run.Stepped:Connect(function()
            if not C.NoClip then return end
            for _, p in pairs(GetChar():GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end)
    end
end)

-- Buttons
Btn("📍 TP to Shop", function()
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = CFrame.new(100, 50, 200)
        N("Teleport", "Teleported to Shop!")
    end
end)

Btn("🔄 Reset Character", function()
    GetChar():FindFirstChildOfClass("Humanoid").Health = 0
end)

N("SENKU HUB", "Loaded! Press INSERT to toggle")
```

end

– Keybind
UIS.InputBegan:Connect(function(input, gp)
if gp then return end
if input.KeyCode == Enum.KeyCode.Insert then
local gui = CG:FindFirstChild(“SenkuGUI”)
if gui then
gui.Enabled = not gui.Enabled
end
end
end)

– Init
CreateGUI()
print(“⚡ SENKU HUB Loaded!”)