– SENKU HUB | Fish Atelier
– Ultra Compact Version - Guaranteed to Work
local P=game:GetService(“Players”).LocalPlayer
local R=game:GetService(“RunService”)
local U=game:GetService(“UserInputService”)
local T=game:GetService(“TweenService”)
local C=game:GetService(“CoreGui”)
local S=game:GetService(“StarterGui”)

– Notify
local function N(t,m)
S:SetCore(“SendNotification”,{Title=“⚡ SENKU | “..t,Text=m,Duration=3})
end

– Anti AFK
game:GetService(“VirtualUser”):CaptureController()
P.Idled:Connect(function()
game:GetService(“VirtualUser”):ClickButton2(Vector2.new())
end)

– Config
local cfg={fish=false,reel=false,perfect=true,speed=false,fly=false,noclip=false}

– Functions
local function getChr()return P.Character or P.CharacterAdded:Wait()end
local function getHRP()local c=getChr()return c and c:FindFirstChild(“HumanoidRootPart”)end
local function getRod()
for _,t in pairs(P.Backpack:GetChildren())do
if t:IsA(“Tool”)and(t.Name:lower():find(“rod”)or t.Name:lower():find(“fish”))then return t end
end
for _,t in pairs(getChr():GetChildren())do
if t:IsA(“Tool”)and(t.Name:lower():find(“rod”)or t.Name:lower():find(“fish”))then return t end
end
end

– Auto Fish
local fc
local function startFish()
if fc then return end
N(“Auto Fish”,“Started!”)
fc=R.Heartbeat:Connect(function()
if not cfg.fish then return end
pcall(function()
local rod=getRod()
if not rod then return end
if rod.Parent==P.Backpack then
getChr():FindFirstChildOfClass(“Humanoid”):EquipTool(rod)
wait(0.2)
end
if rod:FindFirstChild(“events”)then
local e=rod.events
if e:FindFirstChild(“cast”)then e.cast:FireServer(100)end
end
if cfg.reel then
local pg=P:FindFirstChild(“PlayerGui”)
if pg then
local rl=pg:FindFirstChild(“reel”)
if rl and rl.Enabled then
wait(1)
if rod:FindFirstChild(“events”)then
local e=rod.events
if e:FindFirstChild(“reelfinished”)then
e.reelfinished:FireServer(100,cfg.perfect)
end
end
end
end
end
end)
end)
end

local function stopFish()
if fc then fc:Disconnect()fc=nil N(“Auto Fish”,“Stopped!”)end
end

– GUI
if C:FindFirstChild(“SenkuGUI”)then C.SenkuGUI:Destroy()end
local SG=Instance.new(“ScreenGui”)
SG.Name=“SenkuGUI”
SG.Parent=C
SG.ResetOnSpawn=false

local M=Instance.new(“Frame”)
M.Size=UDim2.new(0,350,0,300)
M.Position=UDim2.new(0.5,-175,0.5,-150)
M.BackgroundColor3=Color3.fromRGB(20,20,30)
M.BorderSizePixel=0
M.Active=true
M.Draggable=true
M.Parent=SG

local MC=Instance.new(“UICorner”)
MC.CornerRadius=UDim.new(0,12)
MC.Parent=M

local Tit=Instance.new(“Frame”)
Tit.Size=UDim2.new(1,0,0,35)
Tit.BackgroundColor3=Color3.fromRGB(15,15,25)
Tit.BorderSizePixel=0
Tit.Parent=M

local TC=Instance.new(“UICorner”)
TC.CornerRadius=UDim.new(0,12)
TC.Parent=Tit

local TF=Instance.new(“Frame”)
TF.Size=UDim2.new(1,0,0,18)
TF.Position=UDim2.new(0,0,1,-18)
TF.BackgroundColor3=Color3.fromRGB(15,15,25)
TF.BorderSizePixel=0
TF.Parent=Tit

local TL=Instance.new(“TextLabel”)
TL.Size=UDim2.new(1,-70,1,0)
TL.Position=UDim2.new(0,10,0,0)
TL.BackgroundTransparency=1
TL.Text=“⚡ SENKU HUB”
TL.TextColor3=Color3.fromRGB(255,215,0)
TL.TextSize=16
TL.Font=Enum.Font.GothamBold
TL.TextXAlignment=Enum.TextXAlignment.Left
TL.Parent=Tit

local X=Instance.new(“TextButton”)
X.Size=UDim2.new(0,25,0,20)
X.Position=UDim2.new(1,-32,0,7.5)
X.BackgroundColor3=Color3.fromRGB(220,50,50)
X.Text=“X”
X.TextColor3=Color3.fromRGB(255,255,255)
X.TextSize=14
X.Font=Enum.Font.GothamBold
X.Parent=Tit

local XC=Instance.new(“UICorner”)
XC.CornerRadius=UDim.new(0,5)
XC.Parent=X

X.MouseButton1Click:Connect(function()SG:Destroy()end)

local Sc=Instance.new(“ScrollingFrame”)
Sc.Size=UDim2.new(1,-15,1,-45)
Sc.Position=UDim2.new(0,7.5,0,40)
Sc.BackgroundTransparency=1
Sc.BorderSizePixel=0
Sc.ScrollBarThickness=4
Sc.CanvasSize=UDim2.new(0,0,0,0)
Sc.Parent=M

local L=Instance.new(“UIListLayout”)
L.Padding=UDim.new(0,6)
L.Parent=Sc

L:GetPropertyChangedSignal(“AbsoluteContentSize”):Connect(function()
Sc.CanvasSize=UDim2.new(0,0,0,L.AbsoluteContentSize.Y+10)
end)

local function Tgl(nm,df,cb)
local F=Instance.new(“Frame”)
F.Size=UDim2.new(1,-10,0,35)
F.BackgroundColor3=Color3.fromRGB(35,35,50)
F.BorderSizePixel=0
F.Parent=Sc

local FC=Instance.new(“UICorner”)
FC.CornerRadius=UDim.new(0,7)
FC.Parent=F

local Lb=Instance.new(“TextLabel”)
Lb.Size=UDim2.new(1,-60,1,0)
Lb.Position=UDim2.new(0,8,0,0)
Lb.BackgroundTransparency=1
Lb.Text=nm
Lb.TextColor3=Color3.fromRGB(255,255,255)
Lb.TextSize=12
Lb.Font=Enum.Font.Gotham
Lb.TextXAlignment=Enum.TextXAlignment.Left
Lb.Parent=F

local B=Instance.new(“TextButton”)
B.Size=UDim2.new(0,45,0,22)
B.Position=UDim2.new(1,-50,0.5,-11)
B.BackgroundColor3=df and Color3.fromRGB(50,200,100)or Color3.fromRGB(200,50,50)
B.Text=df and”ON”or”OFF”
B.TextColor3=Color3.fromRGB(255,255,255)
B.TextSize=10
B.Font=Enum.Font.GothamBold
B.Parent=F

local BC=Instance.new(“UICorner”)
BC.CornerRadius=UDim.new(0,5)
BC.Parent=B

local on=df
B.MouseButton1Click:Connect(function()
on=not on
B.Text=on and”ON”or”OFF”
T:Create(B,TweenInfo.new(0.2),{BackgroundColor3=on and Color3.fromRGB(50,200,100)or Color3.fromRGB(200,50,50)}):Play()
if cb then cb(on)end
end)
end

local function Btn(nm,cb)
local B=Instance.new(“TextButton”)
B.Size=UDim2.new(1,-10,0,35)
B.BackgroundColor3=Color3.fromRGB(100,150,255)
B.BorderSizePixel=0
B.Text=nm
B.TextColor3=Color3.fromRGB(255,255,255)
B.TextSize=12
B.Font=Enum.Font.GothamBold
B.Parent=Sc

local BC=Instance.new(“UICorner”)
BC.CornerRadius=UDim.new(0,7)
BC.Parent=B

B.MouseButton1Click:Connect(function()if cb then cb()end end)
end

Tgl(“🎣 Auto Fish”,false,function(v)
cfg.fish=v
if v then startFish()else stopFish()end
end)

Tgl(“🔄 Auto Reel”,false,function(v)cfg.reel=v end)
Tgl(“⭐ Perfect Catch”,true,function(v)cfg.perfect=v end)

Tgl(“⚡ Speed (50)”,false,function(v)
cfg.speed=v
local h=getChr():FindFirstChildOfClass(“Humanoid”)
if h then h.WalkSpeed=v and 50 or 16 end
end)

Tgl(“✈️ Fly (WASD)”,false,function(v)
cfg.fly=v
local hrp=getHRP()
if not hrp then return end
if v then
local BV=Instance.new(“BodyVelocity”)
BV.Name=“FV”
BV.MaxForce=Vector3.new(9e9,9e9,9e9)
BV.Velocity=Vector3.new(0,0,0)
BV.Parent=hrp
local BG=Instance.new(“BodyGyro”)
BG.Name=“FG”
BG.MaxTorque=Vector3.new(9e9,9e9,9e9)
BG.Parent=hrp
R.Heartbeat:Connect(function()
if not cfg.fly then return end
local cam=workspace.CurrentCamera
local dir=Vector3.new()
if U:IsKeyDown(Enum.KeyCode.W)then dir=dir+cam.CFrame.LookVector end
if U:IsKeyDown(Enum.KeyCode.S)then dir=dir-cam.CFrame.LookVector end
if U:IsKeyDown(Enum.KeyCode.A)then dir=dir-cam.CFrame.RightVector end
if U:IsKeyDown(Enum.KeyCode.D)then dir=dir+cam.CFrame.RightVector end
if U:IsKeyDown(Enum.KeyCode.Space)then dir=dir+Vector3.new(0,1,0)end
if U:IsKeyDown(Enum.KeyCode.LeftShift)then dir=dir-Vector3.new(0,1,0)end
BV.Velocity=dir.Unit*50
BG.CFrame=cam.CFrame
end)
else
for _,obj in pairs(hrp:GetChildren())do
if obj.Name==“FV”or obj.Name==“FG”then obj:Destroy()end
end
end
end)

Tgl(“🚫 NoClip”,false,function(v)
cfg.noclip=v
if v then
R.Stepped:Connect(function()
if not cfg.noclip then return end
for _,p in pairs(getChr():GetDescendants())do
if p:IsA(“BasePart”)then p.CanCollide=false end
end
end)
end
end)

Btn(“📍 TP Shop”,function()
local hrp=getHRP()
if hrp then
hrp.CFrame=CFrame.new(100,50,200)
N(“Teleport”,“Teleported!”)
end
end)

Btn(“🔄 Reset”,function()
getChr():FindFirstChildOfClass(“Humanoid”).Health=0
end)

U.InputBegan:Connect(function(i,g)
if g then return end
if i.KeyCode==Enum.KeyCode.Insert then
local gui=C:FindFirstChild(“SenkuGUI”)
if gui then gui.Enabled=not gui.Enabled end
end
end)

N(“SENKU HUB”,“Loaded! Press INSERT”)
print(“⚡ SENKU HUB Loaded!”)
