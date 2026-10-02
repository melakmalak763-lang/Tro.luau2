-- ============================================================
-- DEDSEC COMPLETE (Fixed + أداة جديدة)
-- ============================================================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local Run = game:GetService("RunService")
local SG = game:GetService("StarterGui")
local player = Players.LocalPlayer

if CG:FindFirstChild("DEDSEC_PythonPureGUI") then CG.DEDSEC_PythonPureGUI:Destroy() end
if CG:FindFirstChild("DEDSEC_PythonToggle") then CG.DEDSEC_PythonToggle:Destroy() end

local dataService = RS:FindFirstChild("RemoteEvents")
if dataService then dataService = dataService:FindFirstChild("DataService") end
local cmdRemote = RS:FindFirstChild("HDAdminHDClient")
if cmdRemote then
    cmdRemote = cmdRemote:FindFirstChild("Signals")
    if cmdRemote then cmdRemote = cmdRemote:FindFirstChild("RequestCommandModification") end
end

local function sendText(t)
    if dataService then pcall(function() dataService:FireServer(t) end) end
    if cmdRemote then
        pcall(function()
            if cmdRemote:IsA("RemoteEvent") then cmdRemote:FireServer(t)
            elseif cmdRemote:IsA("RemoteFunction") then cmdRemote:InvokeServer(t) end
        end)
    end
end

local InfiniteJump = false
local Noclip = false
local JumpPower = 50
local CurrentTarget = nil
local FlingOriginalPos = nil
_G.BlueProtection = false
_G.LastTargetName = ""
_G.T1 = false
_G.T2 = false
_G.T3 = false
_G.T4 = false
_G.T5 = false
_G.T6 = false
local TargetStats = {}

local aflActive = false
local aflConn = nil
local aflLastCF = nil
local aflBlocked = 0
local AFL_MAX_VEL = 300

local function getHRP()
    local c = player.Character
    if c then return c:FindFirstChild("HumanoidRootPart") end
    return nil
end

local function clearBodyMovers(hrp)
    if not hrp then return end
    for _, v in ipairs(hrp:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyForce")
            or v:IsA("BodyThrust") or v:IsA("BodyGyro") or v:IsA("VectorForce")
            or v:IsA("Torque") or v:IsA("AngularVelocity") or v:IsA("LinearVelocity")
            or v:IsA("AlignPosition") or v:IsA("AlignOrientation") then
            pcall(function() v:Destroy() end)
        end
    end
end

local function sendNotify(t, x)
    pcall(function()
        SG:SetCore("SendNotification", {Title = t, Text = x, Duration = 5})
    end)
end

-- TOGGLE
local tgGui = Instance.new("ScreenGui")
tgGui.Name = "DEDSEC_PythonToggle"
tgGui.ResetOnSpawn = false
tgGui.Parent = CG

local tgBtn = Instance.new("TextButton", tgGui)
tgBtn.Size = UDim2.new(0, 50, 0, 50)
tgBtn.Position = UDim2.new(0.93, 0, 0.05, 0)
tgBtn.BackgroundColor3 = Color3.fromRGB(10, 20, 12)
tgBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
tgBtn.Text = "PY"
tgBtn.TextSize = 14
tgBtn.Font = Enum.Font.Code
tgBtn.ZIndex = 50
local tgC = Instance.new("UICorner", tgBtn)
tgC.CornerRadius = UDim.new(0, 8)
local tgS = Instance.new("UIStroke", tgBtn)
tgS.Thickness = 2
tgS.Color = Color3.fromRGB(0, 255, 120)

-- MAIN GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DEDSEC_PythonPureGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CG

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 840, 0, 530)
main.Position = UDim2.new(0.5, -420, 0.5, -265)
main.BackgroundColor3 = Color3.fromRGB(6, 12, 8)
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.Active = true
local mainC = Instance.new("UICorner", main)
mainC.CornerRadius = UDim.new(0, 10)

local bgImg = Instance.new("ImageLabel", main)
bgImg.Size = UDim2.new(1, 0, 1, 0)
bgImg.BackgroundTransparency = 1
bgImg.Image = "rbxassetid://131961371008778"
bgImg.ScaleType = Enum.ScaleType.Stretch
bgImg.ZIndex = 0
local bgC = Instance.new("UICorner", bgImg)
bgC.CornerRadius = UDim.new(0, 10)

-- Matrix Rain
local matrixBox = Instance.new("Frame", main)
matrixBox.Size = UDim2.new(1, 0, 1, 0)
matrixBox.BackgroundTransparency = 1
matrixBox.ClipsDescendants = true
matrixBox.ZIndex = 1

local matrixPhrases = {
    "import tro_attack as ta", "initiate_core_sequence()", "loading remote_events...",
    "bypass_security_level = 99", "executing python_payload...", "connection established...",
    "root@dedsec-core:~$ attack_ready", "spawning threads: [OK]", "cve_exploit_module loaded"
}

task.spawn(function()
    while gui.Parent do
        if not main.Visible then
            task.wait(1)
        else
            local lbl = Instance.new("TextLabel", matrixBox)
            lbl.Size = UDim2.new(0, 300, 0, 20)
            lbl.Position = UDim2.new(math.random(5, 75) / 100, 0, 1.1, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(0, 255, 120)
            lbl.TextTransparency = 0.4
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Code
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Text = matrixPhrases[math.random(1, #matrixPhrases)]
            lbl.ZIndex = 1
            local tw = TS:Create(lbl, TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                Position = UDim2.new(lbl.Position.X.Scale, 0, -0.1, 0),
                TextTransparency = 1
            })
            tw:Play()
            tw.Completed:Connect(function() lbl:Destroy() end)
            task.wait(0.25)
        end
    end
end)

local shadow = Instance.new("UIStroke", main)
shadow.Thickness = 2
shadow.Color = Color3.fromRGB(0, 255, 120)
shadow.Transparency = 0.3

task.spawn(function()
    while gui.Parent do
        TS:Create(shadow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.7}):Play()
        TS:Create(tgS, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.7}):Play()
        task.wait(1.2)
        if not gui.Parent then break end
        TS:Create(shadow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
        TS:Create(tgS, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
        task.wait(1.2)
    end
end)

local tBar = Instance.new("Frame", main)
tBar.Size = UDim2.new(1, 0, 0, 42)
tBar.BackgroundColor3 = Color3.fromRGB(10, 20, 12)
tBar.BackgroundTransparency = 0.85
tBar.BorderSizePixel = 0
tBar.ZIndex = 5
local tBarC = Instance.new("UICorner", tBar)
tBarC.CornerRadius = UDim.new(0, 10)

local tText = Instance.new("TextLabel", tBar)
tText.Size = UDim2.new(0.85, 0, 1, 0)
tText.Position = UDim2.new(0.02, 0, 0, 0)
tText.BackgroundTransparency = 1
tText.TextColor3 = Color3.fromRGB(0, 255, 120)
tText.Text = "root@dedsec-core:~/tro_attack/main.py --user=سـجّـاد"
tText.TextSize = 12
tText.Font = Enum.Font.Code
tText.TextXAlignment = Enum.TextXAlignment.Left
tText.ZIndex = 6

local closeBtn = Instance.new("TextButton", tBar)
closeBtn.Size = UDim2.new(0, 40, 0, 30)
closeBtn.Position = UDim2.new(1, -45, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
closeBtn.BackgroundTransparency = 0.2
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.Code
closeBtn.ZIndex = 20
local closeC = Instance.new("UICorner", closeBtn)
closeC.CornerRadius = UDim.new(0, 6)

local isVisible = true
local function toggleWin()
    isVisible = not isVisible
    if isVisible then
        main.Visible = true
        TS:Create(main, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -420, 0.5, -265)}):Play()
    else
        local tw = TS:Create(main, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -420, 1.5, 0)})
        tw:Play()
        tw.Completed:Connect(function()
            if not isVisible then main.Visible = false end
        end)
    end
end
closeBtn.MouseButton1Click:Connect(toggleWin)
tgBtn.MouseButton1Click:Connect(toggleWin)

local side = Instance.new("ScrollingFrame", main)
side.Size = UDim2.new(0.28, 0, 1, -55)
side.Position = UDim2.new(0.01, 0, 0, 48)
side.BackgroundColor3 = Color3.fromRGB(8, 15, 10)
side.BackgroundTransparency = 0.85
side.BorderSizePixel = 0
side.CanvasSize = UDim2.new(0, 0, 0, 500)
side.ScrollBarThickness = 2
side.ZIndex = 5
local sideC = Instance.new("UICorner", side)
sideC.CornerRadius = UDim.new(0, 8)

local sideLayout = Instance.new("UIListLayout", side)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Padding = UDim.new(0, 5)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local content = Instance.new("Frame", main)
content.Size = UDim2.new(0.69, 0, 1, -55)
content.Position = UDim2.new(0.30, 0, 0, 48)
content.BackgroundColor3 = Color3.fromRGB(8, 15, 10)
content.BackgroundTransparency = 0.85
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.ZIndex = 2
local contentC = Instance.new("UICorner", content)
contentC.CornerRadius = UDim.new(0, 8)

local function mkPage()
    local p = Instance.new("ScrollingFrame", content)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.CanvasSize = UDim2.new(0, 0, 0, 1400)
    p.ScrollBarThickness = 2
    p.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 100)
    p.Visible = false
    p.ZIndex = 3
    return p
end

local pages = {}
local homeP = mkPage(); homeP.Visible = true; pages["HOME"] = homeP
local troP = mkPage(); pages["TRO"] = troP
local plrP = mkPage(); pages["PLR"] = plrP
local tgtP = mkPage(); pages["TGT"] = tgtP
local protP = mkPage(); pages["PROT"] = protP
local antP = mkPage(); pages["ANT"] = antP
local trkP = mkPage(); pages["TRK"] = trkP
local extP = mkPage(); pages["EXT"] = extP
local setP = mkPage(); pages["SET"] = setP

local sideOrder = 0
local function mkSideTab(txt, pageKey)
    sideOrder = sideOrder + 1
    local b = Instance.new("TextButton", side)
    b.Size = UDim2.new(0.92, 0, 0, 35)
    b.LayoutOrder = sideOrder
    b.BackgroundColor3 = Color3.fromRGB(12, 25, 15)
    b.BackgroundTransparency = 0.4
    b.TextColor3 = Color3.fromRGB(200, 255, 200)
    b.Text = txt
    b.Font = Enum.Font.Gotham
    b.TextSize = 11
    b.TextWrapped = true
    b.ZIndex = 10
    local bc = Instance.new("UICorner", b)
    bc.CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        for k, p in pairs(pages) do
            p.Visible = (k == pageKey)
        end
    end)
end

mkSideTab("🏠 الرئيسية", "HOME")
mkSideTab("⚡ TRO Attack", "TRO")
mkSideTab("🏃 أدوات اللاعب", "PLR")
mkSideTab("🎯 نظام الاستهداف", "TGT")
mkSideTab("🛡️ الحماية", "PROT")
mkSideTab("🔴 TRO ANT", "ANT")
mkSideTab("📍 Tracker", "TRK")
mkSideTab("📦 أدوات إضافية", "EXT")
mkSideTab("⚙️ الألوان", "SET")

-- HOME
local hc = Instance.new("Frame", homeP)
hc.Size = UDim2.new(0.92, 0, 0, 200)
hc.Position = UDim2.new(0.04, 0, 0, 20)
hc.BackgroundColor3 = Color3.fromRGB(12, 25, 15)
hc.BackgroundTransparency = 0.2
hc.BorderSizePixel = 0
hc.ZIndex = 4
local hcC = Instance.new("UICorner", hc)
hcC.CornerRadius = UDim.new(0, 8)

local hcT = Instance.new("TextLabel", hc)
hcT.Size = UDim2.new(0.9, 0, 0, 30)
hcT.Position = UDim2.new(0.05, 0, 0, 15)
hcT.BackgroundTransparency = 1
hcT.TextColor3 = Color3.fromRGB(0, 255, 120)
hcT.Text = "[+] DEDSEC PYTHON x TRO ATTACK ENGINE"
hcT.TextSize = 11
hcT.Font = Enum.Font.Gotham
hcT.TextXAlignment = Enum.TextXAlignment.Left
hcT.ZIndex = 5

local hcD = Instance.new("TextLabel", hc)
hcD.Size = UDim2.new(0.9, 0, 0, 130)
hcD.Position = UDim2.new(0.05, 0, 0, 55)
hcD.BackgroundTransparency = 1
hcD.TextColor3 = Color3.fromRGB(180, 255, 200)
hcD.Text = "import tro_attack\nimport theme_config\nimport player_tools\nimport target_system\nimport protection_system\nimport tracker\nimport extra_tools"
hcD.TextSize = 10
hcD.Font = Enum.Font.Gotham
hcD.TextXAlignment = Enum.TextXAlignment.Left
hcD.TextYAlignment = Enum.TextYAlignment.Top
hcD.ZIndex = 5

-- PLAYER
local pT = Instance.new("TextLabel", plrP)
pT.Size = UDim2.new(0.9, 0, 0, 30)
pT.Position = UDim2.new(0.04, 0, 0, 10)
pT.BackgroundTransparency = 1
pT.TextColor3 = Color3.fromRGB(0, 255, 120)
pT.Text = "[*] أدوات اللاعب // player_tools.py"
pT.TextSize = 11
pT.Font = Enum.Font.Gotham
pT.TextXAlignment = Enum.TextXAlignment.Left
pT.ZIndex = 4

local spdL = Instance.new("TextLabel", plrP)
spdL.Size = UDim2.new(0.9, 0, 0, 25)
spdL.Position = UDim2.new(0.04, 0, 0, 50)
spdL.BackgroundTransparency = 1
spdL.TextColor3 = Color3.fromRGB(0, 255, 120)
spdL.Text = "⚡ السرعة: 0.0"
spdL.TextSize = 11
spdL.Font = Enum.Font.Gotham
spdL.TextXAlignment = Enum.TextXAlignment.Left
spdL.ZIndex = 4

local jmpL = Instance.new("TextLabel", plrP)
jmpL.Size = UDim2.new(0.9, 0, 0, 25)
jmpL.Position = UDim2.new(0.04, 0, 0, 85)
jmpL.BackgroundTransparency = 1
jmpL.TextColor3 = Color3.fromRGB(0, 255, 120)
jmpL.Text = "🦘 القفز: 50"
jmpL.TextSize = 11
jmpL.Font = Enum.Font.Gotham
jmpL.TextXAlignment = Enum.TextXAlignment.Left
jmpL.ZIndex = 4

local ijB = Instance.new("TextButton", plrP)
ijB.Size = UDim2.new(0.92, 0, 0, 40)
ijB.Position = UDim2.new(0.04, 0, 0, 120)
ijB.BackgroundColor3 = Color3.fromRGB(20, 50, 30)
ijB.BackgroundTransparency = 0.2
ijB.TextColor3 = Color3.fromRGB(200, 255, 200)
ijB.Text = "♾️ قفز لا نهائي: OFF"
ijB.TextSize = 11
ijB.Font = Enum.Font.Gotham
ijB.ZIndex = 10
local ijC = Instance.new("UICorner", ijB)
ijC.CornerRadius = UDim.new(0, 6)

ijB.MouseButton1Click:Connect(function()
    InfiniteJump = not InfiniteJump
    if InfiniteJump then
        ijB.Text = "♾️ قفز لا نهائي: ON"
        ijB.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        ijB.Text = "♾️ قفز لا نهائي: OFF"
        ijB.BackgroundColor3 = Color3.fromRGB(20, 50, 30)
    end
end)

local ncB = Instance.new("TextButton", plrP)
ncB.Size = UDim2.new(0.92, 0, 0, 40)
ncB.Position = UDim2.new(0.04, 0, 0, 170)
ncB.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
ncB.BackgroundTransparency = 0.2
ncB.TextColor3 = Color3.fromRGB(200, 255, 200)
ncB.Text = "🌀 Noclip: OFF"
ncB.TextSize = 11
ncB.Font = Enum.Font.Gotham
ncB.ZIndex = 10
local ncC = Instance.new("UICorner", ncB)
ncC.CornerRadius = UDim.new(0, 6)

ncB.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    if Noclip then
        ncB.Text = "🌀 Noclip: ON"
        ncB.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        ncB.Text = "🌀 Noclip: OFF"
        ncB.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    end
end)

local jF = Instance.new("Frame", plrP)
jF.Size = UDim2.new(0.92, 0, 0, 40)
jF.Position = UDim2.new(0.04, 0, 0, 220)
jF.BackgroundColor3 = Color3.fromRGB(15, 30, 18)
jF.BackgroundTransparency = 0.2
jF.BorderSizePixel = 0
jF.ZIndex = 4
local jFC = Instance.new("UICorner", jF)
jFC.CornerRadius = UDim.new(0, 6)

local jD = Instance.new("TextButton", jF)
jD.Size = UDim2.new(0.3, 0, 1, 0)
jD.Position = UDim2.new(0.02, 0, 0, 0)
jD.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
jD.Text = "-"
jD.TextColor3 = Color3.fromRGB(200, 255, 200)
jD.TextSize = 16
jD.Font = Enum.Font.Gotham
jD.ZIndex = 10
local jdC = Instance.new("UICorner", jD)
jdC.CornerRadius = UDim.new(0, 6)

jD.MouseButton1Click:Connect(function()
    JumpPower = math.max(JumpPower - 5, 10)
    jmpL.Text = "🦘 القفز: " .. JumpPower
    local c = player.Character
    if c then
        local h = c:FindFirstChild("Humanoid")
        if h then h.JumpPower = JumpPower end
    end
end)

local jU = Instance.new("TextButton", jF)
jU.Size = UDim2.new(0.3, 0, 1, 0)
jU.Position = UDim2.new(0.68, 0, 0, 0)
jU.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
jU.Text = "+"
jU.TextColor3 = Color3.fromRGB(200, 255, 200)
jU.TextSize = 16
jU.Font = Enum.Font.Gotham
jU.ZIndex = 10
local juC = Instance.new("UICorner", jU)
juC.CornerRadius = UDim.new(0, 6)

jU.MouseButton1Click:Connect(function()
    JumpPower = math.min(JumpPower + 5, 150)
    jmpL.Text = "🦘 القفز: " .. JumpPower
    local c = player.Character
    if c then
        local h = c:FindFirstChild("Humanoid")
        if h then h.JumpPower = JumpPower end
    end
end)

local jV = Instance.new("TextLabel", jF)
jV.Size = UDim2.new(0.3, 0, 1, 0)
jV.Position = UDim2.new(0.35, 0, 0, 0)
jV.BackgroundTransparency = 1
jV.Text = "50"
jV.TextColor3 = Color3.fromRGB(0, 255, 120)
jV.TextSize = 11
jV.Font = Enum.Font.Gotham
jV.TextXAlignment = Enum.TextXAlignment.Center
jV.ZIndex = 5

-- TARGET
local tT = Instance.new("TextLabel", tgtP)
tT.Size = UDim2.new(0.9, 0, 0, 30)
tT.Position = UDim2.new(0.04, 0, 0, 10)
tT.BackgroundTransparency = 1
tT.TextColor3 = Color3.fromRGB(0, 255, 120)
tT.Text = "[*] نظام الاستهداف // target_system.py"
tT.TextSize = 11
tT.Font = Enum.Font.Gotham
tT.TextXAlignment = Enum.TextXAlignment.Left
tT.ZIndex = 4

local tBox = Instance.new("Frame", tgtP)
tBox.Size = UDim2.new(0.92, 0, 0, 110)
tBox.Position = UDim2.new(0.04, 0, 0, 50)
tBox.BackgroundColor3 = Color3.fromRGB(8, 18, 12)
tBox.BackgroundTransparency = 0.2
tBox.BorderSizePixel = 0
tBox.ZIndex = 4
local tBoxC = Instance.new("UICorner", tBox)
tBoxC.CornerRadius = UDim.new(0, 8)

local pImg = Instance.new("ImageLabel", tBox)
pImg.Size = UDim2.new(0, 80, 0, 80)
pImg.Position = UDim2.new(0, 10, 0, 15)
pImg.BackgroundColor3 = Color3.fromRGB(4, 10, 6)
pImg.ZIndex = 5
local pImgC = Instance.new("UICorner", pImg)
pImgC.CornerRadius = UDim.new(0, 6)

local tNm = Instance.new("TextLabel", tBox)
tNm.Size = UDim2.new(1, -110, 0, 22)
tNm.Position = UDim2.new(0, 100, 0, 15)
tNm.Text = "---"
tNm.TextColor3 = Color3.fromRGB(220, 255, 225)
tNm.Font = Enum.Font.Gotham
tNm.TextSize = 11
tNm.TextXAlignment = Enum.TextXAlignment.Left
tNm.BackgroundTransparency = 1
tNm.ZIndex = 5

local tDt = Instance.new("TextLabel", tBox)
tDt.Size = UDim2.new(1, -110, 0, 20)
tDt.Position = UDim2.new(0, 100, 0, 42)
tDt.Text = "تاريخ الانضمام: -- / -- / --"
tDt.TextColor3 = Color3.fromRGB(140, 255, 150)
tDt.Font = Enum.Font.Gotham
tDt.TextSize = 10
tDt.TextXAlignment = Enum.TextXAlignment.Left
tDt.BackgroundTransparency = 1
tDt.ZIndex = 5

local tInp = Instance.new("TextBox", tBox)
tInp.Size = UDim2.new(0, 150, 0, 30)
tInp.Position = UDim2.new(0, 100, 0, 70)
tInp.PlaceholderText = "اكتب اسم اللاعب..."
tInp.PlaceholderColor3 = Color3.fromRGB(100, 200, 110)
tInp.TextColor3 = Color3.fromRGB(200, 255, 200)
tInp.BackgroundColor3 = Color3.fromRGB(10, 25, 14)
tInp.Font = Enum.Font.Gotham
tInp.TextSize = 10
tInp.ZIndex = 5
local tInpC = Instance.new("UICorner", tInp)
tInpC.CornerRadius = UDim.new(0, 5)

local selB = Instance.new("TextButton", tBox)
selB.Size = UDim2.new(0, 35, 0, 30)
selB.Position = UDim2.new(0, 255, 0, 70)
selB.Text = "🎯"
selB.TextColor3 = Color3.fromRGB(200, 255, 200)
selB.BackgroundColor3 = Color3.fromRGB(15, 60, 30)
selB.Font = Enum.Font.Gotham
selB.TextSize = 12
selB.ZIndex = 10
local selC = Instance.new("UICorner", selB)
selC.CornerRadius = UDim.new(0, 5)

local function updateTarget(p)
    if not p or not p:IsA("Player") then return end
    if _G.BlueProtection and p == player then
        sendNotify("صاحب السكربت", "محمي")
        return
    end
    CurrentTarget = p
    _G.LastTargetName = p.Name
    pImg.Image = "rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=150&h=150"
    tNm.Text = p.DisplayName or p.Name
    local d = os.date("!*t", os.time() - (p.AccountAge * 86400))
    tDt.Text = "تاريخ الانضمام: "..d.day.." / "..d.month.." / "..d.year
end

selB.MouseButton1Click:Connect(function()
    local q = tInp.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if q == "" then sendNotify("System", "❌ اكتب اسم") return end
    local lq = string.lower(q)
    for _, p in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(p.Name), lq, 1, true) or string.find(string.lower(p.DisplayName), lq, 1, true) then
            updateTarget(p)
            sendNotify("System", "✅ تم: "..p.Name)
            return
        end
    end
    sendNotify("System", "❌ غير موجود")
end)

local function mkTB(txt, y)
    local b = Instance.new("TextButton", tgtP)
    b.Size = UDim2.new(0.92, 0, 0, 36)
    b.Position = UDim2.new(0.04, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
    b.BackgroundTransparency = 0.3
    b.TextColor3 = Color3.fromRGB(200, 255, 200)
    b.Text = txt
    b.TextSize = 10
    b.Font = Enum.Font.Gotham
    b.ZIndex = 10
    local bc = Instance.new("UICorner", b)
    bc.CornerRadius = UDim.new(0, 6)
    local bs = Instance.new("UIStroke", b)
    bs.Thickness = 0.8
    bs.Color = Color3.fromRGB(0, 255, 120)
    local st = Instance.new("TextLabel", b)
    st.Size = UDim2.new(0, 25, 0, 25)
    st.Position = UDim2.new(1, -30, 0.5, -12.5)
    st.BackgroundTransparency = 1
    st.Text = ""
    st.TextColor3 = Color3.fromRGB(0, 255, 100)
    st.Font = Enum.Font.Gotham
    st.TextSize = 10
    st.ZIndex = 11
    return b, st
end

local function targetAct(stat, key)
    if not CurrentTarget then sendNotify("System", "❌ حدد ضحية!") return end
    if _G.BlueProtection and CurrentTarget == player then
        sendNotify("صاحب السكربت", "محمي")
        if stat then stat.Text = "" end
        return
    end
    if key ~= "T1" and key ~= "T5" then
        for t, s in pairs(TargetStats) do
            if t ~= "T1" and t ~= "T5" and t ~= key and _G[t] then
                _G[t] = false
                if s then s.Text = "" end
            end
        end
    end
    local was = _G[key]
    _G[key] = not _G[key]
    if stat then stat.Text = _G[key] and "✓" or "" end
    if was and not _G[key] then
        if key == "T4" or key == "T3" then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Sit = false
            end
        elseif key == "T6" then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if FlingOriginalPos then
                    player.Character.HumanoidRootPart.CFrame = FlingOriginalPos
                    FlingOriginalPos = nil
                end
                player.Character.Humanoid.PlatformStand = false
            end
        elseif key == "T2" then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                for _, anim in pairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do
                    anim:Stop()
                end
            end
        end
    end
    if _G[key] and key == "T6" then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            FlingOriginalPos = player.Character.HumanoidRootPart.CFrame
        end
    end
    task.spawn(function()
        local oldCF = nil
        while _G[key] do
            Run.Heartbeat:Wait()
            if CurrentTarget and CurrentTarget.Character and player.Character then
                local tH = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
                local mH = player.Character:FindFirstChild("HumanoidRootPart")
                if tH and mH then
                    if key == "T1" then
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        if tool then
                            if not oldCF then oldCF = mH.CFrame end
                            workspace.CurrentCamera.CameraSubject = CurrentTarget.Character:FindFirstChild("Humanoid")
                            local dist = 10 + (math.sin(tick() * 40) * 11)
                            mH.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            mH.CFrame = tH.CFrame * CFrame.new(0, 1.5, dist)
                        else
                            if oldCF then
                                mH.CFrame = oldCF
                                workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
                                oldCF = nil
                            end
                        end
                    elseif key == "T2" then
                        for _, anim in pairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do
                            anim:Stop()
                        end
                        local off = math.sin(tick() * 50) * 0.6
                        mH.CFrame = tH.CFrame * CFrame.new(0, 0, 0.7 + off)
                    elseif key == "T3" then
                        player.Character.Humanoid.Sit = true
                        local off = math.sin(tick() * 20) * 0.4
                        mH.CFrame = tH.CFrame * CFrame.new(0, -0.6, off) * CFrame.Angles(math.rad(-45), 0, 0)
                    elseif key == "T4" then
                        player.Character.Humanoid.Sit = true
                        local off = math.sin(tick() * 80) * 0.8
                        mH.CFrame = tH.CFrame * CFrame.new(0, 1.9, -1.2 + off) * CFrame.Angles(0, math.rad(180), 0)
                    elseif key == "T6" then
                        player.Character.Humanoid.PlatformStand = true
                        local rot = (tick() * 1000000) % 360
                        local ud = math.sin(tick() * 50) * 2
                        mH.CFrame = tH.CFrame * CFrame.new(0, ud, 1.5) * CFrame.Angles(math.rad(90), math.rad(rot), 0)
                        mH.AssemblyLinearVelocity = Vector3.new(0, 1000, 0)
                    elseif key == "T5" then
                        mH.CFrame = CFrame.new(mH.Position, Vector3.new(tH.Position.X, mH.Position.Y, tH.Position.Z))
                    end
                end
            else
                break
            end
        end
        pcall(function()
            if key ~= "T5" and player.Character and player.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
            end
        end)
    end)
end

local B6, S6 = mkTB("فلنق (Fling)", 185)
local B4, S4 = mkTB("يمص (Sit Forward)", 228)
local B3, S3 = mkTB("بانق عكسي (Reverse Bang)", 271)
local B2, S2 = mkTB("بانق (Bang)", 314)
TargetStats["T6"] = S6
TargetStats["T4"] = S4
TargetStats["T3"] = S3
TargetStats["T2"] = S2
B6.MouseButton1Click:Connect(function() targetAct(S6, "T6") end)
B4.MouseButton1Click:Connect(function() targetAct(S4, "T4") end)
B3.MouseButton1Click:Connect(function() targetAct(S3, "T3") end)
B2.MouseButton1Click:Connect(function() targetAct(S2, "T2") end)

local tpf = Instance.new("Frame", tgtP)
tpf.Size = UDim2.new(0.92, 0, 0, 36)
tpf.Position = UDim2.new(0.04, 0, 0, 357)
tpf.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
tpf.BackgroundTransparency = 0.3
tpf.ZIndex = 4
local tpfC = Instance.new("UICorner", tpf)
tpfC.CornerRadius = UDim.new(0, 6)

local tpb = Instance.new("TextButton", tpf)
tpb.Size = UDim2.new(1, 0, 1, 0)
tpb.Text = "⚡ التنقل إليه (Teleport)"
tpb.TextColor3 = Color3.fromRGB(200, 255, 200)
tpb.Font = Enum.Font.Gotham
tpb.TextSize = 10
tpb.BackgroundTransparency = 1
tpb.ZIndex = 10

tpb.MouseButton1Click:Connect(function()
    if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local c = player.Character
        if c then
            local root = c:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CurrentTarget.Character.HumanoidRootPart.CFrame
                sendNotify("System", "✅ تم: "..CurrentTarget.Name)
            end
        end
    else
        sendNotify("System", "❌ حدد ضحية!")
    end
end)

local B1, S1 = mkTB("إعطاء القنبلة (Tool Bomb)", 400)
local B5, S5 = mkTB("التركيز عليه (Lock View)", 443)
TargetStats["T1"] = S1
TargetStats["T5"] = S5
B1.MouseButton1Click:Connect(function() targetAct(S1, "T1") end)
B5.MouseButton1Click:Connect(function() targetAct(S5, "T5") end)

Players.PlayerRemoving:Connect(function(p)
    if CurrentTarget and p.UserId == CurrentTarget.UserId then
        sendNotify("System", "❌ خرج الضحية: "..p.Name)
        CurrentTarget = nil
        pImg.Image = ""
        tNm.Text = "---"
        tDt.Text = "تاريخ الانضمام: -- / -- / --"
        for t, s in pairs(TargetStats) do
            if s then s.Text = "" end
            _G[t] = false
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    if _G.LastTargetName ~= "" and (p.Name == _G.LastTargetName or p.DisplayName == _G.LastTargetName) then
        updateTarget(p)
        sendNotify("System", "✅ رجع الضحية: "..p.Name)
    end
end)

local function updatePlayerStats()
    local c = player.Character
    if not c then return end
    local root = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChild("Humanoid")
    if not root or not hum then return end
    local v = root.AssemblyLinearVelocity
    local speed = math.floor((v.X * v.X + v.Z * v.Z) ^ 0.5 * 10) / 10
    spdL.Text = "⚡ السرعة: " .. speed
    JumpPower = hum.JumpPower
    jmpL.Text = "🦘 القفز: " .. JumpPower
    jV.Text = JumpPower
    if InfiniteJump and hum then
        hum.JumpPower = 50
    end
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.2)
        updatePlayerStats()
    end
end)

Run.Stepped:Connect(function()
    if Noclip and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if InfiniteJump and player.Character then
        local h = player.Character:FindFirstChild("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- TRO PAGE
local trT = Instance.new("TextLabel", troP)
trT.Size = UDim2.new(0.9, 0, 0, 30)
trT.Position = UDim2.new(0.04, 0, 0, 10)
trT.BackgroundTransparency = 1
trT.TextColor3 = Color3.fromRGB(0, 255, 120)
trT.Text = "[*] نظام السبام // tro_attack.py"
trT.TextSize = 11
trT.Font = Enum.Font.Gotham
trT.TextXAlignment = Enum.TextXAlignment.Left
trT.ZIndex = 4

local iHold = Instance.new("Frame", troP)
iHold.Size = UDim2.new(0.92, 0, 0, 120)
iHold.Position = UDim2.new(0.04, 0, 0, 50)
iHold.BackgroundTransparency = 1
iHold.ZIndex = 4

local grid = Instance.new("UIGridLayout", iHold)
grid.CellSize = UDim2.new(0, 68, 0, 28)
grid.CellPadding = UDim2.new(0, 3, 0, 5)
grid.FillDirection = Enum.FillDirection.Horizontal
grid.FillDirectionMaxCells = 7
grid.SortOrder = Enum.SortOrder.LayoutOrder

local pInputs = {}
for i = 1, 14 do
    local c = Instance.new("Frame", iHold)
    c.BackgroundColor3 = Color3.fromRGB(15, 30, 18)
    c.BorderSizePixel = 0
    c.ZIndex = 4
    local cc = Instance.new("UICorner", c)
    cc.CornerRadius = UDim.new(0, 4)
    local cs = Instance.new("UIStroke", c)
    cs.Color = Color3.fromRGB(0, 255, 120)
    local inp = Instance.new("TextBox", c)
    inp.Size = UDim2.new(1, 0, 1, 0)
    inp.BackgroundTransparency = 1
    inp.TextColor3 = Color3.fromRGB(200, 255, 200)
    inp.PlaceholderText = "لاعب " .. i
    inp.PlaceholderColor3 = Color3.fromRGB(100, 200, 110)
    inp.Text = ""
    inp.Font = Enum.Font.Gotham
    inp.TextSize = 9
    inp.TextXAlignment = Enum.TextXAlignment.Center
    inp.ClearTextOnFocus = false
    inp.ZIndex = 5
    pInputs[i] = inp
end

local cBox = Instance.new("TextBox", troP)
cBox.Size = UDim2.new(0.92, 0, 0, 45)
cBox.Position = UDim2.new(0.04, 0, 0, 180)
cBox.BackgroundColor3 = Color3.fromRGB(15, 30, 18)
cBox.TextColor3 = Color3.fromRGB(200, 255, 200)
cBox.PlaceholderText = "الأمر المدمج..."
cBox.Text = ""
cBox.Font = Enum.Font.Gotham
cBox.TextSize = 11
cBox.TextWrapped = true
cBox.ClearTextOnFocus = false
cBox.ZIndex = 5
local cBoxC = Instance.new("UICorner", cBox)
cBoxC.CornerRadius = UDim.new(0, 8)
local cBoxS = Instance.new("UIStroke", cBox)
cBoxS.Color = Color3.fromRGB(0, 255, 120)
cBoxS.Thickness = 1

local lbls = {"تجهيز 1", "تجهيز 2", "تجهيز 3", "هيد ادمن", "غامض 5"}
local mysteryCmd = ";jc me ;ice me ;loopwarp me ;loopkill me ;blur me ;loopexplode me ;noclip me -inf ;squash me ;size me 2 ;warn me ;logs me ;ap me -inf ;smoke me ;sup me ;change me ;nv me"

local rawCmds = {
    [1] = ";re me ;res me ;clogs me ;logs me ",
    [2] = ";re me ;nv me ;clogs me ;logs me ",
    [3] = ";ap me inf ;jc mc me ;nv me ;clogs me ;ice me ",
    [4] = ";jc ss ;ice ss ;explode ss ;loopkill ss ;warn ss ;squash ss ;size ss 2 ;nv ss ;logs ss",
    [5] = mysteryCmd
}

local bW = 0.174
local bG = 0.012
local sY4 = 240
local pBtns = {}
for i = 1, 5 do
    local b = Instance.new("TextButton", troP)
    b.Size = UDim2.new(bW, 0, 0, 32)
    b.Position = UDim2.new(0.04 + (i - 1) * (bW + bG), 0, 0, sY4)
    b.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
    b.Text = lbls[i]
    b.TextColor3 = Color3.fromRGB(200, 255, 200)
    b.Font = Enum.Font.Gotham
    b.TextSize = 11
    b.ZIndex = 10
    local bc = Instance.new("UICorner", b)
    bc.CornerRadius = UDim.new(0, 6)
    local bs = Instance.new("UIStroke", b)
    bs.Color = Color3.fromRGB(0, 255, 120)
    pBtns[i] = b
end

local cpB = Instance.new("TextButton", troP)
cpB.Size = UDim2.new(0.92, 0, 0, 32)
cpB.Position = UDim2.new(0.04, 0, 0, 290)
cpB.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
cpB.Text = "📋 نسخ جميع الأسماء"
cpB.TextColor3 = Color3.fromRGB(200, 255, 200)
cpB.Font = Enum.Font.Gotham
cpB.TextSize = 10
cpB.ZIndex = 10
local cpC = Instance.new("UICorner", cpB)
cpC.CornerRadius = UDim.new(0, 6)

local spamB = Instance.new("TextButton", troP)
spamB.Size = UDim2.new(0.92, 0, 0, 45)
spamB.Position = UDim2.new(0.04, 0, 0, 335)
spamB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
spamB.Text = "⚠ INITIATE SPAM"
spamB.TextColor3 = Color3.fromRGB(200, 255, 200)
spamB.Font = Enum.Font.Gotham
spamB.TextSize = 14
spamB.ZIndex = 10
local spamBC = Instance.new("UICorner", spamB)
spamBC.CornerRadius = UDim.new(0, 8)
local spamBS = Instance.new("UIStroke", spamB)
spamBS.Color = Color3.fromRGB(0, 255, 120)
spamBS.Thickness = 2

local spamL = Instance.new("TextLabel", troP)
spamL.Size = UDim2.new(1, 0, 0, 20)
spamL.Position = UDim2.new(0, 0, 0, 390)
spamL.BackgroundTransparency = 1
spamL.Text = "SYSTEM STANDBY"
spamL.TextColor3 = Color3.fromRGB(150, 255, 150)
spamL.Font = Enum.Font.Gotham
spamL.TextSize = 10
spamL.ZIndex = 5

local spamming = false
local spamThread = nil

local function getTgts()
    local t = {}
    for i = 1, 14 do
        local v = pInputs[i].Text:gsub("%s+", "")
        if v ~= "" then table.insert(t, v) end
    end
    return t
end

local function genPayload(v)
    local t = getTgts()
    if #t == 0 then
        spamL.Text = "ERROR: NO TARGETS"
        spamL.TextColor3 = Color3.fromRGB(255, 100, 100)
        return ""
    end
    local combined = table.concat(t, ",")
    local raw = rawCmds[v] or ""
    if v == 4 then
        raw = string.gsub(raw, "ss", combined)
    else
        raw = string.gsub(raw, "me", combined)
    end
    return raw
end

for i = 1, 5 do
    pBtns[i].MouseButton1Click:Connect(function()
        local pl = genPayload(i)
        if pl ~= "" then cBox.Text = pl end
    end)
end

cpB.MouseButton1Click:Connect(function()
    local t = getTgts()
    if #t == 0 then
        spamL.Text = "⚠ لا يوجد أسماء!"
        spamL.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    cBox.Text = string.gsub(rawCmds[5], "me", table.concat(t, ","))
    spamL.Text = "📋 تم نسخ " .. #t .. " لاعب"
    spamL.TextColor3 = Color3.fromRGB(0, 255, 100)
end)

spamB.MouseButton1Click:Connect(function()
    if not spamming then
        local pl = cBox.Text
        if pl == "" then
            spamL.Text = "ERROR: NO PAYLOAD"
            return
        end
        spamming = true
        spamB.Text = "■ ABORT ATTACK"
        spamB.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        spamL.Text = "🔥 SPAMMING..."
        spamL.TextColor3 = Color3.fromRGB(0, 255, 50)
        spamThread = task.spawn(function()
            while spamming do
                sendText(pl)
                task.wait()
            end
        end)
    else
        spamming = false
        if spamThread then pcall(function() task.cancel(spamThread) end) end
        spamB.Text = "⚠ INITIATE SPAM"
        spamB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
        spamL.Text = "SYSTEM STANDBY"
        spamL.TextColor3 = Color3.fromRGB(150, 255, 150)
    end
end)

-- PROTECTION
local protTitle = Instance.new("TextLabel", protP)
protTitle.Size = UDim2.new(0.9, 0, 0, 30)
protTitle.Position = UDim2.new(0.04, 0, 0, 10)
protTitle.BackgroundTransparency = 1
protTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
protTitle.Text = "[*] نظام الحماية // protection.py"
protTitle.TextSize = 11
protTitle.Font = Enum.Font.Gotham
protTitle.ZIndex = 4

local function mkProtBox(title, desc, y, h)
    local f = Instance.new("Frame", protP)
    f.Size = UDim2.new(0.92, 0, 0, h or 100)
    f.Position = UDim2.new(0.04, 0, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0
    f.ZIndex = 4
    local fc = Instance.new("UICorner", f)
    fc.CornerRadius = UDim.new(0, 8)
    local fs2 = Instance.new("UIStroke", f)
    fs2.Color = Color3.fromRGB(0, 255, 120)
    fs2.Thickness = 1
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(0.9, 0, 0, 25)
    t.Position = UDim2.new(0.05, 0, 0, 10)
    t.BackgroundTransparency = 1
    t.TextColor3 = Color3.fromRGB(0, 255, 120)
    t.Text = title
    t.TextSize = 11
    t.Font = Enum.Font.Gotham
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.ZIndex = 5
    local d = Instance.new("TextLabel", f)
    d.Size = UDim2.new(0.9, 0, 0, 18)
    d.Position = UDim2.new(0.05, 0, 0, 35)
    d.BackgroundTransparency = 1
    d.TextColor3 = Color3.fromRGB(180, 255, 200)
    d.Text = desc
    d.TextSize = 9
    d.Font = Enum.Font.Gotham
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.ZIndex = 5
    return f
end

local exF = mkProtBox("💥 حماية Explode", "# حماية ضد الانفجارات", 50)
local exB = Instance.new("TextButton", exF)
exB.Size = UDim2.new(0.35, 0, 0, 30)
exB.Position = UDim2.new(0.05, 0, 0, 60)
exB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
exB.Text = "تشغيل"
exB.TextColor3 = Color3.fromRGB(200, 255, 200)
exB.Font = Enum.Font.Gotham
exB.TextSize = 11
exB.ZIndex = 10
local exBC = Instance.new("UICorner", exB)
exBC.CornerRadius = UDim.new(0, 6)
exB.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://pastefy.app/PJZbrpPP/raw"))() end)
end)

local bsF = mkProtBox("🛡️ حماية أساسية", "# حماية أساسية", 165)
local bsB = Instance.new("TextButton", bsF)
bsB.Size = UDim2.new(0.35, 0, 0, 30)
bsB.Position = UDim2.new(0.05, 0, 0, 60)
bsB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
bsB.Text = "تشغيل"
bsB.TextColor3 = Color3.fromRGB(200, 255, 200)
bsB.Font = Enum.Font.Gotham
bsB.TextSize = 11
bsB.ZIndex = 10
local bsBC = Instance.new("UICorner", bsB)
bsBC.CornerRadius = UDim.new(0, 6)
bsB.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://pastefy.app/Ypq1uLlT/raw"))() end)
end)

local afF = mkProtBox("🌀 مضاد Fling (Anti-Fling)", "# حماية ضد الفلنق", 280, 130)
local afB = Instance.new("TextButton", afF)
afB.Size = UDim2.new(0.35, 0, 0, 30)
afB.Position = UDim2.new(0.05, 0, 0, 60)
afB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
afB.Text = "تشغيل"
afB.TextColor3 = Color3.fromRGB(200, 255, 200)
afB.Font = Enum.Font.Gotham
afB.TextSize = 11
afB.ZIndex = 10
local afBC = Instance.new("UICorner", afB)
afBC.CornerRadius = UDim.new(0, 6)

local afS = Instance.new("TextLabel", afF)
afS.Size = UDim2.new(0.5, 0, 0, 25)
afS.Position = UDim2.new(0.45, 0, 0, 63)
afS.BackgroundTransparency = 1
afS.Text = "⛔ معطل"
afS.TextColor3 = Color3.fromRGB(255, 100, 100)
afS.Font = Enum.Font.Gotham
afS.TextSize = 10
afS.ZIndex = 5

local afC = Instance.new("TextLabel", afF)
afC.Size = UDim2.new(0.9, 0, 0, 20)
afC.Position = UDim2.new(0.05, 0, 0, 100)
afC.BackgroundTransparency = 1
afC.Text = "BLOCKED: 0"
afC.TextColor3 = Color3.fromRGB(120, 200, 160)
afC.Font = Enum.Font.Code
afC.TextSize = 10
afC.TextXAlignment = Enum.TextXAlignment.Left
afC.ZIndex = 5

afB.MouseButton1Click:Connect(function()
    aflActive = not aflActive
    if aflActive then
        afB.Text = "إيقاف"
        afB.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        afS.Text = "✅ مفعل"
        afS.TextColor3 = Color3.fromRGB(0, 255, 100)
        aflBlocked = 0
        local hrp = getHRP()
        if hrp then aflLastCF = hrp.CFrame end
        if aflConn then aflConn:Disconnect() end
        aflConn = Run.Heartbeat:Connect(function()
            if not aflActive then return end
            local h = getHRP()
            if not h then return end
            local vel = h.AssemblyLinearVelocity
            local angVel = h.AssemblyAngularVelocity
            if vel.Magnitude > AFL_MAX_VEL then
                h.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                h.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                if aflLastCF then h.CFrame = aflLastCF end
                clearBodyMovers(h)
                aflBlocked = aflBlocked + 1
            else
                aflLastCF = h.CFrame
            end
            if angVel.Magnitude > 100 then
                h.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                aflBlocked = aflBlocked + 1
            end
        end)
        task.spawn(function()
            while aflActive do
                afC.Text = "BLOCKED: " .. aflBlocked
                task.wait(0.3)
            end
        end)
    else
        afB.Text = "تشغيل"
        afB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
        afS.Text = "⛔ معطل"
        afS.TextColor3 = Color3.fromRGB(255, 100, 100)
        if aflConn then aflConn:Disconnect() aflConn = nil end
    end
end)

local apF = mkProtBox("⚡ مضاد AP (Anti-Teleport)", "# يمنع AP me inf", 425, 130)
local apB = Instance.new("TextButton", apF)
apB.Size = UDim2.new(0.35, 0, 0, 30)
apB.Position = UDim2.new(0.05, 0, 0, 60)
apB.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
apB.Text = "تشغيل"
apB.TextColor3 = Color3.fromRGB(200, 255, 200)
apB.Font = Enum.Font.Gotham
apB.TextSize = 11
apB.ZIndex = 10
local apBC = Instance.new("UICorner", apB)
apBC.CornerRadius = UDim.new(0, 6)

local apS = Instance.new("TextLabel", apF)
apS.Size = UDim2.new(0.5, 0, 0, 25)
apS.Position = UDim2.new(0.45, 0, 0, 63)
apS.BackgroundTransparency = 1
apS.Text = "⛔ معطل"
apS.TextColor3 = Color3.fromRGB(255, 100, 100)
apS.Font = Enum.Font.Gotham
apS.TextSize = 10
apS.ZIndex = 5

local apLoaded = false

apB.MouseButton1Click:Connect(function()
    if apLoaded then
        sendNotify("Anti-AP", "✅ مفعل مسبقاً")
        return
    end
    apLoaded = true
    apB.Text = "✅ مفعل"
    apB.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    apS.Text = "✅ مفعل"
    apS.TextColor3 = Color3.fromRGB(0, 255, 100)
    sendNotify("Anti-AP", "✅ تم التحميل")
    pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/iNn9DNTk/raw"))()
    end)
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if aflActive then
        aflLastCF = nil
        local h = getHRP()
        if h then aflLastCF = h.CFrame end
    end
end)

-- TRO ANT
local antT = Instance.new("TextLabel", antP)
antT.Size = UDim2.new(0.9, 0, 0, 30)
antT.Position = UDim2.new(0.04, 0, 0, 10)
antT.BackgroundTransparency = 1
antT.TextColor3 = Color3.fromRGB(255, 60, 60)
antT.Text = "🔴 TRO ANT"
antT.TextSize = 12
antT.Font = Enum.Font.GothamBold
antT.ZIndex = 4

local antF = Instance.new("Frame", antP)
antF.Size = UDim2.new(0.92, 0, 0, 100)
antF.Position = UDim2.new(0.04, 0, 0, 50)
antF.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
antF.BackgroundTransparency = 0.2
antF.BorderSizePixel = 0
antF.ZIndex = 4
local antFC = Instance.new("UICorner", antF)
antFC.CornerRadius = UDim.new(0, 8)

local antB = Instance.new("TextButton", antF)
antB.Size = UDim2.new(0.3, 0, 0, 30)
antB.Position = UDim2.new(0.05, 0, 0, 60)
antB.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
antB.Text = "🔴 تشغيل"
antB.TextColor3 = Color3.fromRGB(255, 200, 200)
antB.Font = Enum.Font.Gotham
antB.TextSize = 11
antB.ZIndex = 10
local antBC = Instance.new("UICorner", antB)
antBC.CornerRadius = UDim.new(0, 6)

local antS = Instance.new("TextLabel", antF)
antS.Size = UDim2.new(0.5, 0, 0, 25)
antS.Position = UDim2.new(0.4, 0, 0, 63)
antS.BackgroundTransparency = 1
antS.Text = "⛔ معطل"
antS.TextColor3 = Color3.fromRGB(255, 100, 100)
antS.Font = Enum.Font.Gotham
antS.TextSize = 10
antS.ZIndex = 5

local antToggle = false
local antLastPos = nil
local antTargetPos = Vector3.new(0, -80000000, 0)
local antDb = false
local antVelConn = nil
local antGazePart = nil

local function antToggleTween()
    if antDb then return end
    local c = player.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if antToggle then
        antDb = true
        antToggle = false
        if antVelConn then antVelConn:Disconnect() antVelConn = nil end
        local tw = TS:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(antLastPos)})
        antB.Text = "⏳ جاري..."
        tw:Play()
        tw.Completed:Wait()
        antB.Text = "🔴 تشغيل"
        antB.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        antDb = false
        workspace.FallenPartsDestroyHeight = -500
        if workspace.CurrentCamera then
            workspace.CurrentCamera.CameraSubject = c:FindFirstChild("Humanoid")
        end
        if antGazePart then antGazePart:Destroy() antGazePart = nil end
        antS.Text = "⛔ معطل"
        antS.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        antDb = true
        antLastPos = hrp.Position
        antGazePart = Instance.new("Part")
        antGazePart.Size = Vector3.new(4, 5, 4)
        antGazePart.Position = antLastPos
        antGazePart.Anchored = true
        antGazePart.CanCollide = false
        antGazePart.Transparency = 0.5
        antGazePart.Name = "Gaze"
        antGazePart.Parent = workspace
        workspace.CurrentCamera.CameraSubject = antGazePart
        antToggle = true
        local tw = TS:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(antTargetPos)})
        antB.Text = "⏳ جاري..."
        tw:Play()
        tw.Completed:Wait()
        antB.Text = "🔴 إيقاف"
        antB.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
        antDb = false
        antVelConn = Run.Heartbeat:Connect(function()
            if antToggle and hrp then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end)
        antS.Text = "✅ مفعل"
        antS.TextColor3 = Color3.fromRGB(0, 255, 100)
    end
end

antB.MouseButton1Click:Connect(antToggleTween)

-- ============================================================
-- TRACKER PAGE
-- ============================================================
local trackerTitle = Instance.new("TextLabel", trkP)
trackerTitle.Size = UDim2.new(0.9, 0, 0, 30)
trackerTitle.Position = UDim2.new(0.04, 0, 0, 10)
trackerTitle.BackgroundTransparency = 1
trackerTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
trackerTitle.Text = "[*] تتبع لاعبين معينين // tracker.py"
trackerTitle.TextSize = 11
trackerTitle.Font = Enum.Font.Gotham
trackerTitle.TextXAlignment = Enum.TextXAlignment.Left
trackerTitle.ZIndex = 4

local trackerHint = Instance.new("TextLabel", trkP)
trackerHint.Size = UDim2.new(0.9, 0, 0, 16)
trackerHint.Position = UDim2.new(0.04, 0, 0, 32)
trackerHint.BackgroundTransparency = 1
trackerHint.TextColor3 = Color3.fromRGB(120, 180, 140)
trackerHint.Text = "اكتب اسم اللاعب أو جزء من اليوزر → ينضاف للقائمة"
trackerHint.TextSize = 9
trackerHint.Font = Enum.Font.Gotham
trackerHint.TextXAlignment = Enum.TextXAlignment.Left
trackerHint.ZIndex = 4

local trackerInput = Instance.new("TextBox", trkP)
trackerInput.Size = UDim2.new(0.62, 0, 0, 32)
trackerInput.Position = UDim2.new(0.04, 0, 0, 55)
trackerInput.BackgroundColor3 = Color3.fromRGB(8, 18, 12)
trackerInput.TextColor3 = Color3.fromRGB(200, 255, 200)
trackerInput.PlaceholderText = "اسم اللاعب أو جزء منه..."
trackerInput.PlaceholderColor3 = Color3.fromRGB(80, 160, 100)
trackerInput.Text = ""
trackerInput.Font = Enum.Font.Gotham
trackerInput.TextSize = 10
trackerInput.ClearTextOnFocus = false
trackerInput.ZIndex = 5
local tiC = Instance.new("UICorner", trackerInput)
tiC.CornerRadius = UDim.new(0, 6)
local tiS = Instance.new("UIStroke", trackerInput)
tiS.Color = Color3.fromRGB(0, 180, 80)
tiS.Thickness = 0.8

local trackerAddBtn = Instance.new("TextButton", trkP)
trackerAddBtn.Size = UDim2.new(0.14, 0, 0, 32)
trackerAddBtn.Position = UDim2.new(0.68, 0, 0, 55)
trackerAddBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
trackerAddBtn.TextColor3 = Color3.fromRGB(200, 255, 200)
trackerAddBtn.Text = "إضافة"
trackerAddBtn.TextSize = 10
trackerAddBtn.Font = Enum.Font.Gotham
trackerAddBtn.ZIndex = 10
local taC = Instance.new("UICorner", trackerAddBtn)
taC.CornerRadius = UDim.new(0, 6)

local trackerResetBtn = Instance.new("TextButton", trkP)
trackerResetBtn.Size = UDim2.new(0.14, 0, 0, 32)
trackerResetBtn.Position = UDim2.new(0.83, 0, 0, 55)
trackerResetBtn.BackgroundColor3 = Color3.fromRGB(60, 15, 15)
trackerResetBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
trackerResetBtn.Text = "تصفير"
trackerResetBtn.TextSize = 10
trackerResetBtn.Font = Enum.Font.Gotham
trackerResetBtn.ZIndex = 10
local trC = Instance.new("UICorner", trackerResetBtn)
trC.CornerRadius = UDim.new(0, 6)

local loggerList = Instance.new("ScrollingFrame", trkP)
loggerList.Size = UDim2.new(0.92, 0, 0, 440)
loggerList.Position = UDim2.new(0.04, 0, 0, 100)
loggerList.BackgroundColor3 = Color3.fromRGB(4, 10, 6)
loggerList.BackgroundTransparency = 0.4
loggerList.BorderSizePixel = 0
loggerList.CanvasSize = UDim2.new(0, 0, 0, 500)
loggerList.ScrollBarThickness = 3
loggerList.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 80)
loggerList.ZIndex = 4
local llC = Instance.new("UICorner", loggerList)
llC.CornerRadius = UDim.new(0, 6)

local listLayout = Instance.new("UIListLayout", loggerList)
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local trackedUsers = {}

local function formatTime(seconds)
    seconds = math.floor(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    end
    return string.format("%02d:%02d", m, s)
end

local function trackNotify(title, text)
    pcall(function()
        SG:SetCore("SendNotification", {Title = title, Text = text, Duration = 5})
    end)
end

local function playLeaveSound()
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://6042053626"
        s.Volume = 0.5
        s.Parent = workspace
        s:Play()
        s.Ended:Connect(function()
            pcall(function() s:Destroy() end)
        end)
        task.spawn(function()
            task.wait(3)
            pcall(function()
                if s and s.Parent then s:Destroy() end
            end)
        end)
    end)
end

local function createEntry(query, playerObj, displayName, userId)
    if trackedUsers[query] then return trackedUsers[query] end

    local entry = Instance.new("Frame", loggerList)
    entry.Size = UDim2.new(0.96, 0, 0, 95)
    entry.BackgroundColor3 = Color3.fromRGB(45, 8, 8)
    entry.BackgroundTransparency = 0.05
    entry.BorderSizePixel = 0
    entry.ZIndex = 5
    local eC = Instance.new("UICorner", entry)
    eC.CornerRadius = UDim.new(0, 8)
    local eS = Instance.new("UIStroke", entry)
    eS.Color = Color3.fromRGB(200, 40, 40)
    eS.Thickness = 1.5
    eS.Transparency = 0.2

    local avatar = Instance.new("ImageLabel", entry)
    avatar.Size = UDim2.new(0, 55, 0, 55)
    avatar.Position = UDim2.new(0, 8, 0, 8)
    avatar.BackgroundColor3 = Color3.fromRGB(4, 10, 6)
    avatar.Image = ""
    if userId then
        avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"
    end
    avatar.ZIndex = 6
    local aC = Instance.new("UICorner", avatar)
    aC.CornerRadius = UDim.new(0, 8)
    local aS = Instance.new("UIStroke", avatar)
    aS.Color = Color3.fromRGB(200, 40, 40)
    aS.Thickness = 1

    local nameLabel = Instance.new("TextLabel", entry)
    nameLabel.Size = UDim2.new(0.4, 0, 0, 24)
    nameLabel.Position = UDim2.new(0, 8, 0, 65)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Text = displayName or ("[بحث] " .. query)
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextYAlignment = Enum.TextYAlignment.Top
    nameLabel.TextWrapped = true
    nameLabel.ZIndex = 6

    local joinsLabel = Instance.new("TextLabel", entry)
    joinsLabel.Size = UDim2.new(0.5, 0, 0, 22)
    joinsLabel.Position = UDim2.new(0, 72, 0, 8)
    joinsLabel.BackgroundTransparency = 1
    joinsLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
    joinsLabel.Text = "عدد الدخول: 0"
    joinsLabel.TextSize = 14
    joinsLabel.Font = Enum.Font.GothamBold
    joinsLabel.TextXAlignment = Enum.TextXAlignment.Left
    joinsLabel.ZIndex = 6

    local leavesLabel = Instance.new("TextLabel", entry)
    leavesLabel.Size = UDim2.new(0.5, 0, 0, 22)
    leavesLabel.Position = UDim2.new(0, 72, 0, 34)
    leavesLabel.BackgroundTransparency = 1
    leavesLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    leavesLabel.Text = "عدد الخروج: 0"
    leavesLabel.TextSize = 14
    leavesLabel.Font = Enum.Font.GothamBold
    leavesLabel.TextXAlignment = Enum.TextXAlignment.Left
    leavesLabel.ZIndex = 6

    local infoLabel = Instance.new("TextLabel", entry)
    infoLabel.Size = UDim2.new(0.5, 0, 0, 22)
    infoLabel.Position = UDim2.new(0, 72, 0, 62)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(200, 220, 210)
    infoLabel.Text = "00:00"
    infoLabel.TextSize = 14
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.ZIndex = 6

    local statusBtn = Instance.new("TextButton", entry)
    statusBtn.Size = UDim2.new(0, 32, 0, 32)
    statusBtn.Position = UDim2.new(1, -42, 0, 8)
    statusBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
    statusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusBtn.Text = "✕"
    statusBtn.TextSize = 16
    statusBtn.Font = Enum.Font.GothamBold
    statusBtn.ZIndex = 10
    local sbC = Instance.new("UICorner", statusBtn)
    sbC.CornerRadius = UDim.new(0, 8)

    local removeBtn = Instance.new("TextButton", entry)
    removeBtn.Size = UDim2.new(0, 32, 0, 32)
    removeBtn.Position = UDim2.new(1, -42, 1, -40)
    removeBtn.BackgroundColor3 = Color3.fromRGB(100, 15, 15)
    removeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
    removeBtn.Text = "✕"
    removeBtn.TextSize = 14
    removeBtn.Font = Enum.Font.GothamBold
    removeBtn.ZIndex = 10
    local rbC = Instance.new("UICorner", removeBtn)
    rbC.CornerRadius = UDim.new(0, 8)
    local rbS = Instance.new("UIStroke", removeBtn)
    rbS.Color = Color3.fromRGB(200, 50, 50)
    rbS.Thickness = 1

    local data = {
        entry = entry,
        avatar = avatar,
        nameLabel = nameLabel,
        joinsLabel = joinsLabel,
        leavesLabel = leavesLabel,
        infoLabel = infoLabel,
        statusBtn = statusBtn,
        eS = eS,
        aS = aS,
        userId = userId,
        joins = 0,
        leaves = 0,
        startTime = 0,
        totalTime = 0,
        inGame = false
    }

    removeBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if entry and entry.Parent then entry:Destroy() end
        end)
        trackedUsers[query] = nil
        trackNotify("Tracker", "🗑️ تم إزالة: " .. query)
    end)

    trackedUsers[query] = data
    return data
end

local function updateEntry(query)
    local data = trackedUsers[query]
    if not data or not data.entry or not data.entry.Parent then return end

    local foundPlayer = nil
    local lq = string.lower(query)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            if string.find(string.lower(plr.Name), lq, 1, true) or string.find(string.lower(plr.DisplayName), lq, 1, true) then
                foundPlayer = plr
                break
            end
        end
    end

    if foundPlayer then
        if not data.inGame then
            data.inGame = true
            data.startTime = os.time()
            data.joins = data.joins + 1
            data.userId = foundPlayer.UserId
            trackNotify("📥 دخول", "اللاعب: " .. foundPlayer.Name)
        end

        data.entry.BackgroundColor3 = Color3.fromRGB(8, 35, 18)
        data.eS.Color = Color3.fromRGB(0, 200, 90)
        data.aS.Color = Color3.fromRGB(0, 200, 90)
        data.statusBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
        data.statusBtn.Text = "✓"
        data.nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

        pcall(function()
            data.avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. foundPlayer.UserId .. "&w=150&h=150"
        end)
        data.nameLabel.Text = foundPlayer.Name

        local session = os.time() - data.startTime
        data.joinsLabel.Text = "عدد الدخول: " .. data.joins
        data.leavesLabel.Text = "عدد الخروج: " .. data.leaves
        data.infoLabel.Text = formatTime(session)
    else
        if data.inGame then
            data.totalTime = data.totalTime + (os.time() - data.startTime)
            data.inGame = false
            data.leaves = data.leaves + 1

            trackNotify("📤 خرج لاعب", "اللاعب: " .. query .. " خرج!")
            playLeaveSound()
        end

        data.entry.BackgroundColor3 = Color3.fromRGB(45, 8, 8)
        data.eS.Color = Color3.fromRGB(220, 50, 50)
        data.aS.Color = Color3.fromRGB(220, 50, 50)
        data.statusBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        data.statusBtn.Text = "✕"
        data.nameLabel.TextColor3 = Color3.fromRGB(255, 200, 200)

        data.joinsLabel.Text = "عدد الدخول: " .. data.joins
        data.leavesLabel.Text = "عدد الخروج: " .. data.leaves
        data.infoLabel.Text = formatTime(data.totalTime)
    end
end

local function addQuery(q)
    q = q:gsub("^%s+", ""):gsub("%s+$", "")
    if q == "" then
        trackNotify("Tracker", "❌ اكتب اسم")
        return false
    end
    if trackedUsers[q] then
        trackNotify("Tracker", "⚠️ مضاف مسبقاً")
        return false
    end

    local found = nil
    local lq = string.lower(q)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            if string.find(string.lower(plr.Name), lq, 1, true) or string.find(string.lower(plr.DisplayName), lq, 1, true) then
                found = plr
                break
            end
        end
    end

    if found then
        createEntry(q, found, found.Name, found.UserId)
        updateEntry(q)
        trackNotify("Tracker", "✅ تم إضافة: " .. found.Name)
    else
        createEntry(q, nil, "[بحث] " .. q, nil)
        updateEntry(q)
        trackNotify("Tracker", "👁️ مراقبة: " .. q)
    end
    return true
end

trackerAddBtn.MouseButton1Click:Connect(function()
    if addQuery(trackerInput.Text) then
        trackerInput.Text = ""
    end
end)

trackerResetBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(loggerList:GetChildren()) do
        if child:IsA("Frame") then
            pcall(function() child:Destroy() end)
        end
    end
    trackedUsers = {}
    trackNotify("Tracker", "🗑️ تم تصفير القائمة")
end)

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    for query, _ in pairs(trackedUsers) do
        updateEntry(query)
    end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.3)
    for query, _ in pairs(trackedUsers) do
        updateEntry(query)
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(1)
        for query, _ in pairs(trackedUsers) do
            updateEntry(query)
        end
    end
end)

-- EXTRA
local exT = Instance.new("TextLabel", extP)
exT.Size = UDim2.new(0.9, 0, 0, 30)
exT.Position = UDim2.new(0.04, 0, 0, 10)
exT.BackgroundTransparency = 1
exT.TextColor3 = Color3.fromRGB(0, 255, 120)
exT.Text = "[*] أدوات إضافية // extra_tools.py"
exT.TextSize = 11
exT.Font = Enum.Font.Gotham
exT.ZIndex = 4

local function mkExtra(title, desc, y, link)
    local f = Instance.new("Frame", extP)
    f.Size = UDim2.new(0.92, 0, 0, 100)
    f.Position = UDim2.new(0.04, 0, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0
    f.ZIndex = 4
    local fc = Instance.new("UICorner", f)
    fc.CornerRadius = UDim.new(0, 8)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(0.9, 0, 0, 25)
    t.Position = UDim2.new(0.05, 0, 0, 10)
    t.BackgroundTransparency = 1
    t.TextColor3 = Color3.fromRGB(0, 255, 120)
    t.Text = title
    t.TextSize = 11
    t.Font = Enum.Font.Gotham
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.ZIndex = 5
    local d = Instance.new("TextLabel", f)
    d.Size = UDim2.new(0.9, 0, 0, 30)
    d.Position = UDim2.new(0.05, 0, 0, 40)
    d.BackgroundTransparency = 1
    d.TextColor3 = Color3.fromRGB(180, 255, 200)
    d.Text = desc
    d.TextSize = 10
    d.Font = Enum.Font.Gotham
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.ZIndex = 5
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0.35, 0, 0, 28)
    b.Position = UDim2.new(0.05, 0, 0, 65)
    b.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
    b.Text = "تشغيل"
    b.TextColor3 = Color3.fromRGB(200, 255, 200)
    b.Font = Enum.Font.Gotham
    b.TextSize = 11
    b.ZIndex = 10
    local bc = Instance.new("UICorner", b)
    bc.CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        pcall(function() loadstring(game:HttpGet(link))() end)
    end)
end

mkExtra("🚀 TRO FPS", "# تحسين الأداء", 50, "https://pastefy.app/f211Hg4s/raw")
mkExtra("🤖 AUTO TRO", "# النقر التلقائي", 165, "https://pastefy.app/eY5seATd/raw")
mkExtra("📻 راديو TRO", "# الراديو", 280, "https://pastefy.app/3i1B279F/raw")
mkExtra("🆕 أداة جديدة", "# الأداة الإضافية", 395, "https://pastefy.app/QLYVlvgF/raw")

-- SETTINGS
local sT = Instance.new("TextLabel", setP)
sT.Size = UDim2.new(0.9, 0, 0, 30)
sT.Position = UDim2.new(0.04, 0, 0, 10)
sT.BackgroundTransparency = 1
sT.TextColor3 = Color3.fromRGB(0, 255, 120)
sT.Text = "[*] إعدادات الألوان // theme_config.py"
sT.TextSize = 11
sT.Font = Enum.Font.Gotham
sT.TextXAlignment = Enum.TextXAlignment.Left
sT.ZIndex = 4

local function applyTheme(col)
    shadow.Color = col
    tgS.Color = col
    tgBtn.TextColor3 = col
    tText.TextColor3 = col
    sT.TextColor3 = col
end

local function mkTheme(name, y, col)
    local b = Instance.new("TextButton", setP)
    b.Size = UDim2.new(0.92, 0, 0, 45)
    b.Position = UDim2.new(0.04, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(15, 30, 18)
    b.BackgroundTransparency = 0.3
    b.TextColor3 = col
    b.Text = name
    b.TextSize = 11
    b.Font = Enum.Font.Gotham
    b.ZIndex = 10
    local bc = Instance.new("UICorner", b)
    bc.CornerRadius = UDim.new(0, 6)
    local bs = Instance.new("UIStroke", b)
    bs.Thickness = 1.5
    bs.Color = col
    b.MouseButton1Click:Connect(function() applyTheme(col) end)
end

mkTheme("🟢 Hack Green", 50, Color3.fromRGB(0, 255, 120))
mkTheme("🔵 Cyber Blue", 105, Color3.fromRGB(0, 200, 255))
mkTheme("🔴 Red Alert", 160, Color3.fromRGB(255, 50, 50))
mkTheme("🟡 Gold Hacker", 215, Color3.fromRGB(255, 215, 0))
mkTheme("🟣 Purple Matrix", 270, Color3.fromRGB(200, 50, 255))

-- MOBILE
local MIN_W = 320
local MIN_H = 260
local MAX_W = 1400
local MAX_H = 1000

local mb = Instance.new("Frame", main)
mb.Size = UDim2.new(0, 160, 0, 12)
mb.Position = UDim2.new(0.5, -80, 1, -18)
mb.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mb.BackgroundTransparency = 0.2
mb.BorderSizePixel = 0
mb.ZIndex = 25
local mbC = Instance.new("UICorner", mb)
mbC.CornerRadius = UDim.new(1, 0)

local mbL = Instance.new("Frame", mb)
mbL.Size = UDim2.new(0.7, 0, 0, 4)
mbL.Position = UDim2.new(0.15, 0, 0.5, -2)
mbL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mbL.BorderSizePixel = 0
mbL.ZIndex = 26
local mbLC = Instance.new("UICorner", mbL)
mbLC.CornerRadius = UDim.new(1, 0)

local rH = Instance.new("TextButton", main)
rH.Size = UDim2.new(0, 40, 0, 40)
rH.Position = UDim2.new(1, -40, 1, -40)
rH.BackgroundTransparency = 1
rH.Text = ""
rH.ZIndex = 27

local rC = Instance.new("Frame", rH)
rC.Size = UDim2.new(0, 22, 0, 4)
rC.Position = UDim2.new(1, -26, 1, -10)
rC.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
rC.BorderSizePixel = 0
rC.Rotation = -45
rC.ZIndex = 28
local rCC = Instance.new("UICorner", rC)
rCC.CornerRadius = UDim.new(1, 0)

local isDrag = false
local isRsz = false
local dsP, fsP, rsP, fsS

local function gp(i) return Vector2.new(i.Position.X, i.Position.Y) end
local function isP(i)
    return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end
local function isM(i)
    return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end

mb.InputBegan:Connect(function(i)
    if isP(i) then
        isDrag = true
        dsP = gp(i)
        fsP = main.Position
    end
end)

rH.InputBegan:Connect(function(i)
    if isP(i) then
        isRsz = true
        rsP = gp(i)
        fsS = main.AbsoluteSize
    end
end)

UIS.InputChanged:Connect(function(i)
    if isDrag and isM(i) then
        local d = gp(i) - dsP
        main.Position = UDim2.new(fsP.X.Scale, fsP.X.Offset + d.X, fsP.Y.Scale, fsP.Y.Offset + d.Y)
    elseif isRsz and isM(i) then
        local d = gp(i) - rsP
        local nW = math.clamp(fsS.X + d.X, MIN_W, MAX_W)
        local nH = math.clamp(fsS.Y + d.Y, MIN_H, MAX_H)
        main.Size = UDim2.new(0, nW, 0, nH)
    end
end)

UIS.InputEnded:Connect(function(i)
    if isP(i) then
        isDrag = false
        isRsz = false
    end
end)

task.spawn(function()
    task.wait(1)
    pcall(function()
        local vp = workspace.CurrentCamera.ViewportSize
        if vp.X < 800 then
            local nW = math.min(vp.X - 30, 520)
            local nH = math.min(vp.Y - 100, 420)
            main.Size = UDim2.new(0, nW, 0, nH)
            main.Position = UDim2.new(0.5, -nW/2, 0.5, -nH/2)
        elseif vp.X < 1200 then
            main.Size = UDim2.new(0, 680, 0, 470)
            main.Position = UDim2.new(0.5, -340, 0.5, -235)
        end
    end)
end)

-- CLEANUP
closeBtn.MouseButton1Click:Connect(function()
    if spamming and spamThread then
        spamming = false
        pcall(function() task.cancel(spamThread) end)
    end
    if aflActive and aflConn then
        aflActive = false
        pcall(function() aflConn:Disconnect() end)
    end
    if antToggle and antVelConn then
        pcall(function() antVelConn:Disconnect() end)
    end
    if antGazePart then
        pcall(function() antGazePart:Destroy() end)
    end
    pcall(function() gui:Destroy() end)
    pcall(function() tgGui:Destroy() end)
end)

pcall(function()
    SG:SetCore("SendNotification", {
        Title = "DEDSEC",
        Text = "✅ تم التحميل",
        Duration = 5
    })
end)

print("[+] DEDSEC LOADED")
