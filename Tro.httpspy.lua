-- ============================================================
-- SYS SNIFFER v3.0 - FULL KETAMINE MERGE
-- RSpy | ESpy | HTTPSpy | Script Scanner | Memory Scanner
-- Delta Safe | Async hooks | Anti-detect
-- ============================================================

local E = _G
pcall(function() if getgenv then E = getgenv() end end)
if E._SS3 then pcall(function() E._SS3.clean() end) E._SS3 = nil end

local SN = { alive = true, ban = {}, prot = setmetatable({}, {__mode="k"}), hooks = {}, pf = {}, conns = {}, objs = {} }
E._SS3 = SN

local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local HS = game:GetService("HttpService")

-- parent آمن
local P = nil
pcall(function() if type(gethui) == "function" then P = gethui() end end)
if not P then
    pcall(function()
        local t = Instance.new("Folder"); t.Parent = CG; t:Destroy(); P = CG
    end)
end
if not P then P = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

-- حماية
local function PF(f)
    if type(E.newcclosure) == "function" then
        local ok, r = pcall(E.newcclosure, f)
        if ok and r then return r end
    end
    return f
end

local _gc, _rg, _cn, _uv, _cs = E.getgc, E.getreg, E.getconnections, E.getupvalue, E.getconstants

if type(_gc) == "function" then
    E.getgc = PF(function(...)
        local ok, l = pcall(_gc, ...)
        if not ok or type(l) ~= "table" then return l end
        local o = {}
        for i = 1, #l do if not SN.ban[l[i]] then o[#o + 1] = l[i] end end
        return o
    end)
    SN.hooks.getgc = E.getgc
end

if type(_rg) == "function" then
    E.getreg = PF(function()
        local ok, r = pcall(_rg)
        if not ok or type(r) ~= "table" then return r end
        local c = {}
        for k, v in pairs(r) do if v ~= SN then c[k] = v end end
        return c
    end)
    SN.hooks.getreg = E.getreg
end

if type(_cn) == "function" then
    E.getconnections = PF(function(o)
        if SN.prot[o] then return {} end
        local ok, r = pcall(_cn, o)
        if ok then return r end
        return {}
    end)
    SN.hooks.getconnections = E.getconnections
end

for _, n in ipairs({"getupvalue", "getconstants"}) do
    if type(E[n]) == "function" then
        local orig = E[n]
        local w = PF(function(f, ...)
            if SN.pf[f] then return nil end
            return orig(f, ...)
        end)
        E[n] = w
        if E.debug and E.debug[n] then E.debug[n] = w end
    end
end

-- حفظ الأصلي
local O = {
    hookmetamethod = E.hookmetamethod,
    hookfunction = E.hookfunction,
    getnamecallmethod = E.getnamecallmethod,
    loadstring = E.loadstring,
    request = E.request or (syn and syn.request) or http_request,
    require = E.require,
    decompile = E.decompile,
    getreg = E.getreg,
    getgc = E.getgc,
    getinstances = E.getinstances,
    getnilinstances = E.getnilinstances,
    getcallbackvalue = E.getcallbackvalue,
    firesignal = E.firesignal,
    getcallingscript = E.getcallingscript,
    checkcaller = E.checkcaller,
    iscclosure = E.iscclosure,
    clonefunction = E.clonefunction,
    newcclosure = E.newcclosure
}

-- ============================================================
-- الألوان
-- ============================================================
local CLR = {
    bg = Color3.fromRGB(14, 14, 16),
    panel = Color3.fromRGB(20, 20, 22),
    panel2 = Color3.fromRGB(26, 26, 30),
    side = Color3.fromRGB(18, 18, 20),
    border = Color3.fromRGB(50, 50, 55),
    text = Color3.fromRGB(240, 240, 240),
    text2 = Color3.fromRGB(160, 160, 165),
    accent = Color3.fromRGB(90, 130, 255),
    green = Color3.fromRGB(90, 220, 130),
    red = Color3.fromRGB(240, 80, 80),
    yellow = Color3.fromRGB(240, 200, 80),
    purple = Color3.fromRGB(170, 100, 255),
    cyan = Color3.fromRGB(90, 220, 240),
    orange = Color3.fromRGB(255, 160, 80)
}

-- ============================================================
-- الواجهة الرئيسية
-- ============================================================
local vp = workspace.CurrentCamera.ViewportSize
local fw = math.min(vp.X - 20, 900)
local fh = math.min(vp.Y - 20, 520)

local Gui = Instance.new("ScreenGui")
Gui.Name = "_ss3_" .. math.random(100000, 999999)
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 5
Gui.Parent = P
SN.ban[Gui] = true
SN.prot[Gui] = true

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, fw, 0, fh)
Main.Position = UDim2.new(0.5, -fw/2, 0.5, -fh/2)
Main.BackgroundColor3 = CLR.bg
Main.BorderSizePixel = 0
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
SN.ban[Main] = true

-- شريط العنوان
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 32)
Top.BackgroundColor3 = CLR.panel
Top.BorderSizePixel = 0
Top.Parent = Main
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SYS SNIFFER // KETAMINE MERGE"
Title.TextColor3 = CLR.text
Title.TextSize = 12
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Top)
Close.Size = UDim2.new(0, 32, 0, 32)
Close.Position = UDim2.new(1, -34, 0, 0)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = CLR.text
Close.TextSize = 12
Close.Font = Enum.Font.Code

-- الشريط الجانبي
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 150, 1, -42)
Side.Position = UDim2.new(0, 8, 0, 38)
Side.BackgroundColor3 = CLR.side
Side.BorderSizePixel = 0
Side.Parent = Main
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 6)

local SideList = Instance.new("UIListLayout", Side)
SideList.Padding = UDim.new(0, 3)
SideList.SortOrder = Enum.SortOrder.LayoutOrder
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -168, 1, -42)
Content.Position = UDim2.new(0, 160, 0, 38)
Content.BackgroundColor3 = CLR.bg
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Parent = Main
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 6)

local pages = {}
local tabBtns = {}

local function newPage(name)
    local p = Instance.new("Frame", Content)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Name = name
    pages[name] = p
    return p
end

local function newTab(name, label)
    local b = Instance.new("TextButton", Side)
    b.Size = UDim2.new(0.92, 0, 0, 32)
    b.BackgroundColor3 = CLR.panel2
    b.BorderSizePixel = 0
    b.Text = label
    b.TextColor3 = CLR.text
    b.TextSize = 11
    b.Font = Enum.Font.Code
    b.LayoutOrder = #tabBtns + 1
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function()
        for k, p in pairs(pages) do p.Visible = (k == name) end
        for k, bb in pairs(tabBtns) do
            bb.BackgroundColor3 = (k == name) and CLR.accent or CLR.panel2
        end
    end)
    tabBtns[name] = b
    return b
end

local HomeP = newPage("Home")
local RSpyP = newPage("RSpy")
local ESpyP = newPage("ESpy")
local HttpP = newPage("HTTPSpy")
local ScriptP = newPage("ScriptScanner")
local MemP = newPage("MemoryScanner")
local SetP = newPage("Settings")

newTab("Home", "Home")
newTab("RSpy", "Remote Spy")
newTab("ESpy", "Event Spy")
newTab("HTTPSpy", "HTTP Spy")
newTab("ScriptScanner", "Script Scanner")
newTab("MemoryScanner", "Memory Scanner")
newTab("Settings", "Settings")

HomeP.Visible = true
tabBtns.Home.BackgroundColor3 = CLR.accent

-- السحب
local dr, dS, sS
Top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dr = true; dS = i.Position; sS = Main.Position
    end
end)
Top.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = false end
end)
UIS.InputChanged:Connect(function(i)
    if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dS
        Main.Position = UDim2.new(sS.X.Scale, sS.X.Offset + d.X, sS.Y.Scale, sS.Y.Offset + d.Y)
    end
end)

-- ============================================================
-- أدوات مساعدة
-- ============================================================
local function rnd(n)
    local s, c = "", "abcdefghijklmnopqrstuvwxyz0123456789"
    for _ = 1, n do s = s .. c:sub(math.random(1, #c), math.random(1, #c)) end
    return s
end

local function tagURL(u)
    local l = string.lower(tostring(u))
    if l:find("github", 1, true) then return "GITHUB"
    elseif l:find("pastebin", 1, true) then return "PASTEBIN"
    elseif l:find("pastefy", 1, true) then return "PASTEFY"
    elseif l:find("raw", 1, true) then return "RAW"
    elseif l:find("supabase", 1, true) then return "SUPABASE"
    elseif l:find("workers.dev", 1, true) then return "WORKER"
    end
    return "REQ"
end

-- ============================================================
-- مكوّن صفحة Spy (RSpy / ESpy / HTTPSpy)
-- ============================================================
local function makeSpyPage(page)
    local LeftFrame = Instance.new("Frame", page)
    LeftFrame.Size = UDim2.new(0, 300, 1, -40)
    LeftFrame.Position = UDim2.new(0, 6, 0, 6)
    LeftFrame.BackgroundColor3 = CLR.panel
    LeftFrame.BorderSizePixel = 0
    Instance.new("UICorner", LeftFrame).CornerRadius = UDim.new(0, 6)

    local Logs = Instance.new("ScrollingFrame", LeftFrame)
    Logs.Size = UDim2.new(1, -8, 1, -8)
    Logs.Position = UDim2.new(0, 4, 0, 4)
    Logs.BackgroundTransparency = 1
    Logs.ScrollBarThickness = 3
    Logs.ScrollBarImageColor3 = CLR.accent
    Logs.CanvasSize = UDim2.new(0, 0, 0, 0)
    Logs.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local Layout = Instance.new("UIListLayout", Logs)
    Layout.Padding = UDim.new(0, 2)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    local RightFrame = Instance.new("Frame", page)
    RightFrame.Size = UDim2.new(1, -314, 1, -100)
    RightFrame.Position = UDim2.new(0, 312, 0, 6)
    RightFrame.BackgroundColor3 = CLR.panel
    RightFrame.BorderSizePixel = 0
    Instance.new("UICorner", RightFrame).CornerRadius = UDim.new(0, 6)

    local Code = Instance.new("TextBox", RightFrame)
    Code.Size = UDim2.new(1, -8, 1, -8)
    Code.Position = UDim2.new(0, 4, 0, 4)
    Code.BackgroundTransparency = 1
    Code.TextColor3 = CLR.text
    Code.TextSize = 11
    Code.Font = Enum.Font.Code
    Code.TextXAlignment = Enum.TextXAlignment.Left
    Code.TextYAlignment = Enum.TextYAlignment.Top
    Code.MultiLine = true
    Code.ClearTextOnFocus = false
    Code.Text = "-- Click any entry to view code"

    local Btns = Instance.new("ScrollingFrame", page)
    Btns.Size = UDim2.new(1, -314, 0, 84)
    Btns.Position = UDim2.new(0, 312, 1, -90)
    Btns.BackgroundColor3 = CLR.panel
    Btns.BorderSizePixel = 0
    Btns.ScrollBarThickness = 3
    Btns.ScrollBarImageColor3 = CLR.accent
    Btns.CanvasSize = UDim2.new(0, 0, 0, 0)
    Btns.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", Btns).CornerRadius = UDim.new(0, 6)

    local BtnGrid = Instance.new("UIGridLayout", Btns)
    BtnGrid.CellSize = UDim2.new(0, 140, 0, 22)
    BtnGrid.CellPadding = UDim2.new(0, 3, 0, 3)

    return {
        Logs = Logs,
        Layout = Layout,
        Code = Code,
        Buttons = Btns
    }
end

local function addSpyButton(Btns, text, callback)
    local b = Instance.new("TextButton", Btns)
    b.BackgroundColor3 = CLR.panel2
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = CLR.text
    b.TextSize = 10
    b.Font = Enum.Font.Code
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- ============================================================
-- ToString serializer
-- ============================================================
local function serialize(val, indent, seen)
    indent = indent or 0
    seen = seen or {}
    local t = typeof(val)
    if t == "string" then return string.format("%q", val) end
    if t == "number" or t == "boolean" or t == "nil" then return tostring(val) end
    if t == "Instance" then
        if val:IsDescendantOf(game) then return "game." .. val:GetFullName() end
        return "(nil)[\"" .. val.Name .. "\"]"
    end
    if t == "EnumItem" then return "Enum." .. val.EnumType.Name .. "." .. val.Name end
    if t == "Color3" then
        return string.format("Color3.fromRGB(%d,%d,%d)", val.R * 255, val.G * 255, val.B * 255)
    end
    if t == "Vector3" then
        return string.format("Vector3.new(%f,%f,%f)", val.X, val.Y, val.Z)
    end
    if t == "Vector2" then
        return string.format("Vector2.new(%f,%f)", val.X, val.Y)
    end
    if t == "CFrame" then
        return "CFrame.new(" .. serialize(val.Position, indent, seen) .. ")"
    end
    if t == "function" then
        local n = debug.info(val, "n")
        if n and n ~= "" then return n end
        return "function() end"
    end
    if t == "table" then
        if seen[val] then return "{ --[[cycle]] }" end
        seen[val] = true
        local parts = {}
        for k, v in pairs(val) do
            parts[#parts+1] = "[" .. serialize(k, indent+1, seen) .. "]=" .. serialize(v, indent+1, seen)
        end
        seen[val] = nil
        return "{" .. table.concat(parts, ",") .. "}"
    end
    return tostring(val)
end

local function formatArgs(...)
    local args = {...}
    local n = select("#", ...)
    if n == 0 then return "()" end
    local parts = {}
    for i = 1, n do parts[i] = serialize(args[i]) end
    return "(" .. table.concat(parts, ", ") .. ")"
end

-- ============================================================
-- RSPY - Remote Spy
-- ============================================================
local R = makeSpyPage(RSpyP)
local RS_logs = {}
local RS_max = 150
local RS_selected = nil

local function rsAddLog(name, event, isIncoming, args, caller)
    if not SN.alive then return end
    if #RS_logs >= RS_max then
        local old = table.remove(RS_logs, 1)
        if old then old:Destroy() end
    end

    local b = Instance.new("TextButton", R.Logs)
    b.Size = UDim2.new(1, -4, 0, 32)
    b.BackgroundColor3 = isIncoming and Color3.fromRGB(30, 40, 30) or Color3.fromRGB(40, 30, 30)
    b.BorderSizePixel = 0
    b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

    local t1 = Instance.new("TextLabel", b)
    t1.Size = UDim2.new(1, -8, 0, 14)
    t1.Position = UDim2.new(0, 4, 0, 2)
    t1.BackgroundTransparency = 1
    t1.Text = (isIncoming and "← " or "→ ") .. tostring(name)
    t1.TextColor3 = CLR.text
    t1.TextSize = 10
    t1.Font = Enum.Font.Code
    t1.TextXAlignment = Enum.TextXAlignment.Left

    local t2 = Instance.new("TextLabel", b)
    t2.Size = UDim2.new(1, -8, 0, 14)
    t2.Position = UDim2.new(0, 4, 0, 16)
    t2.BackgroundTransparency = 1
    t2.Text = tostring(event):sub(1, 60)
    t2.TextColor3 = CLR.text2
    t2.TextSize = 9
    t2.Font = Enum.Font.Code
    t2.TextXAlignment = Enum.TextXAlignment.Left
    t2.TextTruncate = Enum.TextTruncate.AtEnd

    b.MouseButton1Click:Connect(function()
        RS_selected = {event, isIncoming, args}
        local path = "game." .. event:GetFullName()
        local method = isIncoming and "firesignal(" .. path .. ".OnClientEvent" or path .. (event:IsA("RemoteFunction") and ":InvokeServer" or ":FireServer")
        R.Code.Text = "-- " .. event.ClassName .. "\n" .. method .. formatArgs(unpack(args))
    end)

    table.insert(RS_logs, b)
    R.Logs.CanvasSize = UDim2.new(0, 0, 0, R.Layout.AbsoluteContentSize.Y + 4)
end

addSpyButton(R.Buttons, "Copy Code", function()
    if E.setclipboard then pcall(E.setclipboard, R.Code.Text) end
end)
addSpyButton(R.Buttons, "Copy Path", function()
    if RS_selected and E.setclipboard then pcall(E.setclipboard, "game." .. RS_selected[1]:GetFullName()) end
end)
addSpyButton(R.Buttons, "Copy Args", function()
    if RS_selected and E.setclipboard then pcall(E.setclipboard, formatArgs(unpack(RS_selected[3]))) end
end)
addSpyButton(R.Buttons, "Clear Logs", function()
    for _, v in ipairs(RS_logs) do v:Destroy() end
    RS_logs = {}
end)
addSpyButton(R.Buttons, "Execute Remote", function()
    if RS_selected then
        local ok, err = pcall(function()
            if RS_selected[2] then
                if RS_selected[1]:IsA("RemoteFunction") then
                    if O.getcallbackvalue then
                        O.getcallbackvalue(RS_selected[1], "OnClientInvoke")(unpack(RS_selected[3]))
                    end
                else
                    if O.firesignal then
                        O.firesignal(RS_selected[1].OnClientEvent, unpack(RS_selected[3]))
                    end
                end
            else
                if RS_selected[1]:IsA("RemoteFunction") then
                    RS_selected[1]:InvokeServer(unpack(RS_selected[3]))
                else
                    RS_selected[1]:FireServer(unpack(RS_selected[3]))
                end
            end
        end)
        if not ok then warn("[RSpy] " .. tostring(err)) end
    end
end)
addSpyButton(R.Buttons, "Decompile", function()
    if RS_selected and RS_selected[3] and O.decompile then
        -- نبحث عن script في الـ args
        for _, v in ipairs(RS_selected[3]) do
            if typeof(v) == "Instance" and (v:IsA("LocalScript") or v:IsA("Script") or v:IsA("ModuleScript")) then
                local ok, code = pcall(O.decompile, v)
                if ok then R.Code.Text = code end
                return
            end
        end
    end
end)

-- ============================================================
-- ESPY - Event Spy (Bindables)
-- ============================================================
local ES = makeSpyPage(ESpyP)
local ES_logs = {}
local ES_max = 150
local ES_selected = nil

local function esAddLog(name, event, args)
    if not SN.alive then return end
    if #ES_logs >= ES_max then
        local old = table.remove(ES_logs, 1)
        if old then old:Destroy() end
    end

    local b = Instance.new("TextButton", ES.Logs)
    b.Size = UDim2.new(1, -4, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(40, 30, 40)
    b.BorderSizePixel = 0
    b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

    local t1 = Instance.new("TextLabel", b)
    t1.Size = UDim2.new(1, -8, 0, 14)
    t1.Position = UDim2.new(0, 4, 0, 2)
    t1.BackgroundTransparency = 1
    t1.Text = "[Bindable] " .. tostring(name)
    t1.TextColor3 = CLR.text
    t1.TextSize = 10
    t1.Font = Enum.Font.Code
    t1.TextXAlignment = Enum.TextXAlignment.Left

    local t2 = Instance.new("TextLabel", b)
    t2.Size = UDim2.new(1, -8, 0, 14)
    t2.Position = UDim2.new(0, 4, 0, 16)
    t2.BackgroundTransparency = 1
    t2.Text = tostring(event)
    t2.TextColor3 = CLR.text2
    t2.TextSize = 9
    t2.Font = Enum.Font.Code
    t2.TextXAlignment = Enum.TextXAlignment.Left
    t2.TextTruncate = Enum.TextTruncate.AtEnd

    b.MouseButton1Click:Connect(function()
        ES_selected = {event, args}
        local path = "game." .. event:GetFullName()
        ES.Code.Text = "-- " .. event.ClassName .. "\n" .. path .. ":Fire" .. formatArgs(unpack(args))
    end)

    table.insert(ES_logs, b)
    ES.Logs.CanvasSize = UDim2.new(0, 0, 0, ES.Layout.AbsoluteContentSize.Y + 4)
end

addSpyButton(ES.Buttons, "Copy Code", function()
    if E.setclipboard then pcall(E.setclipboard, ES.Code.Text) end
end)
addSpyButton(ES.Buttons, "Copy Path", function()
    if ES_selected and E.setclipboard then pcall(E.setclipboard, "game." .. ES_selected[1]:GetFullName()) end
end)
addSpyButton(ES.Buttons, "Clear Logs", function()
    for _, v in ipairs(ES_logs) do v:Destroy() end
    ES_logs = {}
end)
addSpyButton(ES.Buttons, "Re-Fire", function()
    if ES_selected then
        pcall(function() ES_selected[1]:Fire(unpack(ES_selected[2])) end)
    end
end)

-- ============================================================
-- HTTPSPY
-- ============================================================
local H = makeSpyPage(HttpP)
local HS_logs = {}
local HS_max = 150
local HS_selected = nil

local function hsAddLog(tag, url, body)
    if not SN.alive then return end
    if #HS_logs >= HS_max then
        local old = table.remove(HS_logs, 1)
        if old then old:Destroy() end
    end

    local b = Instance.new("TextButton", H.Logs)
    b.Size = UDim2.new(1, -4, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
    b.BorderSizePixel = 0
    b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

    local t1 = Instance.new("TextLabel", b)
    t1.Size = UDim2.new(1, -8, 0, 14)
    t1.Position = UDim2.new(0, 4, 0, 2)
    t1.BackgroundTransparency = 1
    t1.Text = "[" .. tag .. "]"
    t1.TextColor3 = CLR.cyan
    t1.TextSize = 10
    t1.Font = Enum.Font.Code
    t1.TextXAlignment = Enum.TextXAlignment.Left

    local t2 = Instance.new("TextLabel", b)
    t2.Size = UDim2.new(1, -8, 0, 14)
    t2.Position = UDim2.new(0, 4, 0, 16)
    t2.BackgroundTransparency = 1
    t2.Text = tostring(url):sub(1, 70)
    t2.TextColor3 = CLR.text2
    t2.TextSize = 9
    t2.Font = Enum.Font.Code
    t2.TextXAlignment = Enum.TextXAlignment.Left
    t2.TextTruncate = Enum.TextTruncate.AtEnd

    b.MouseButton1Click:Connect(function()
        HS_selected = {url, body}
        H.Code.Text = "-- URL: " .. tostring(url) .. "\n\n" .. tostring(body):sub(1, 5000)
    end)

    table.insert(HS_logs, b)
    H.Logs.CanvasSize = UDim2.new(0, 0, 0, H.Layout.AbsoluteContentSize.Y + 4)
end

addSpyButton(H.Buttons, "Copy Code", function()
    if E.setclipboard then pcall(E.setclipboard, H.Code.Text) end
end)
addSpyButton(H.Buttons, "Copy URL", function()
    if HS_selected and E.setclipboard then pcall(E.setclipboard, HS_selected[1]) end
end)
addSpyButton(H.Buttons, "Clear Logs", function()
    for _, v in ipairs(HS_logs) do v:Destroy() end
    HS_logs = {}
end)

-- ============================================================
-- SCRIPT SCANNER
-- ============================================================
local SS_top = Instance.new("Frame", ScriptP)
SS_top.Size = UDim2.new(1, -12, 0, 34)
SS_top.Position = UDim2.new(0, 6, 0, 6)
SS_top.BackgroundColor3 = CLR.panel
SS_top.BorderSizePixel = 0
Instance.new("UICorner", SS_top).CornerRadius = UDim.new(0, 6)

local SS_input = Instance.new("TextBox", SS_top)
SS_input.Size = UDim2.new(1, -80, 1, -8)
SS_input.Position = UDim2.new(0, 4, 0, 4)
SS_input.BackgroundColor3 = CLR.panel2
SS_input.BorderSizePixel = 0
SS_input.TextColor3 = CLR.text
SS_input.TextSize = 11
SS_input.Font = Enum.Font.Code
SS_input.PlaceholderText = "Keywords (separate with ;)"
SS_input.PlaceholderColor3 = CLR.text2
SS_input.Text = ""
SS_input.ClearTextOnFocus = false
Instance.new("UICorner", SS_input).CornerRadius = UDim.new(0, 4)

local SS_start = Instance.new("TextButton", SS_top)
SS_start.Size = UDim2.new(0, 68, 1, -8)
SS_start.Position = UDim2.new(1, -72, 0, 4)
SS_start.BackgroundColor3 = CLR.accent
SS_start.BorderSizePixel = 0
SS_start.Text = "SCAN"
SS_start.TextColor3 = CLR.text
SS_start.TextSize = 11
SS_start.Font = Enum.Font.Code
Instance.new("UICorner", SS_start).CornerRadius = UDim.new(0, 4)

local SS_list = Instance.new("ScrollingFrame", ScriptP)
SS_list.Size = UDim2.new(1, -12, 1, -80)
SS_list.Position = UDim2.new(0, 6, 0, 46)
SS_list.BackgroundColor3 = CLR.panel
SS_list.BorderSizePixel = 0
SS_list.ScrollBarThickness = 4
SS_list.ScrollBarImageColor3 = CLR.accent
SS_list.CanvasSize = UDim2.new(0, 0, 0, 0)
SS_list.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", SS_list).CornerRadius = UDim.new(0, 6)

local SS_layout = Instance.new("UIListLayout", SS_list)
SS_layout.Padding = UDim.new(0, 3)

local SS_entries = {}
local SS_decompiled = {}

local function ssScan()
    if not O.decompile then return end
    local text = SS_input.Text:lower()
    if text == "" then return end
    
    for _, v in ipairs(SS_entries) do v:Destroy() end
    SS_entries = {}
    
    local keywords = {}
    for word in text:gmatch("[^;]+") do
        keywords[#keywords + 1] = word:match("^%s*(.-)%s*$")
    end
    
    task.spawn(function()
        local count = 0
        local sources = {}
        
        if O.getinstances then
            for _, v in ipairs(O.getinstances()) do sources[#sources+1] = v end
        end
        for _, v in ipairs(game:GetDescendants()) do sources[#sources+1] = v end
        
        for _, obj in ipairs(sources) do
            if not SN.alive then return end
            if obj:IsA("LocalScript") or obj:IsA("ModuleScript") or (obj:IsA("Script") and obj.RunContext == Enum.RunContext.Client) then
                local ok, code = pcall(O.decompile, obj)
                if ok and code then
                    local lower = code:lower()
                    local matches = 0
                    for _, kw in ipairs(keywords) do
                        local _, n = lower:gsub(kw:gsub("%p", "%%%1"), "")
                        matches = matches + n
                    end
                    if matches > 0 then
                        SS_decompiled[obj] = code
                        local b = Instance.new("TextButton", SS_list)
                        b.Size = UDim2.new(1, -4, 0, 28)
                        b.BackgroundColor3 = CLR.panel2
                        b.BorderSizePixel = 0
                        b.Text = "[" .. matches .. "] " .. obj.Name .. " → game." .. obj:GetFullName()
                        b.TextColor3 = CLR.text
                        b.TextSize = 10
                        b.Font = Enum.Font.Code
                        b.TextXAlignment = Enum.TextXAlignment.Left
                        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                        b.MouseButton1Click:Connect(function()
                            if E.setclipboard then pcall(E.setclipboard, SS_decompiled[obj]) end
                        end)
                        table.insert(SS_entries, b)
                        count = count + 1
                    end
                end
            end
            task.wait()
        end
        
        print("[ScriptScanner] Found " .. count .. " scripts")
    end)
end

SS_start.MouseButton1Click:Connect(ssScan)

-- ============================================================
-- MEMORY SCANNER
-- ============================================================
local MS_top = Instance.new("Frame", MemP)
MS_top.Size = UDim2.new(1, -12, 0, 34)
MS_top.Position = UDim2.new(0, 6, 0, 6)
MS_top.BackgroundColor3 = CLR.panel
MS_top.BorderSizePixel = 0
Instance.new("UICorner", MS_top).CornerRadius = UDim.new(0, 6)

local MS_input = Instance.new("TextBox", MS_top)
MS_input.Size = UDim2.new(1, -80, 1, -8)
MS_input.Position = UDim2.new(0, 4, 0, 4)
MS_input.BackgroundColor3 = CLR.panel2
MS_input.BorderSizePixel = 0
MS_input.TextColor3 = CLR.text
MS_input.TextSize = 11
MS_input.Font = Enum.Font.Code
MS_input.PlaceholderText = "Search value..."
MS_input.PlaceholderColor3 = CLR.text2
MS_input.Text = ""
MS_input.ClearTextOnFocus = false
Instance.new("UICorner", MS_input).CornerRadius = UDim.new(0, 4)

local MS_start = Instance.new("TextButton", MS_top)
MS_start.Size = UDim2.new(0, 68, 1, -8)
MS_start.Position = UDim2.new(1, -72, 0, 4)
MS_start.BackgroundColor3 = CLR.purple
MS_start.BorderSizePixel = 0
MS_start.Text = "SCAN"
MS_start.TextColor3 = CLR.text
MS_start.TextSize = 11
MS_start.Font = Enum.Font.Code
Instance.new("UICorner", MS_start).CornerRadius = UDim.new(0, 4)

local MS_list = Instance.new("ScrollingFrame", MemP)
MS_list.Size = UDim2.new(1, -12, 1, -80)
MS_list.Position = UDim2.new(0, 6, 0, 46)
MS_list.BackgroundColor3 = CLR.panel
MS_list.BorderSizePixel = 0
MS_list.ScrollBarThickness = 4
MS_list.ScrollBarImageColor3 = CLR.purple
MS_list.CanvasSize = UDim2.new(0, 0, 0, 0)
MS_list.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", MS_list).CornerRadius = UDim.new(0, 6)

local MS_layout = Instance.new("UIListLayout", MS_list)
MS_layout.Padding = UDim.new(0, 3)

local MS_entries = {}

local function msScan()
    if not O.getgc then return end
    local query = MS_input.Text:lower()
    if query == "" then return end
    
    for _, v in ipairs(MS_entries) do v:Destroy() end
    MS_entries = {}
    
    task.spawn(function()
        local count = 0
        local ok, garbage = pcall(O.getgc, true)
        if not ok or type(garbage) ~= "table" then return end
        
        for _, obj in ipairs(garbage) do
            if not SN.alive then return end
            local s = tostring(obj)
            if string.find(s:lower(), query, 1, true) then
                count = count + 1
                if count <= 500 then
                    local b = Instance.new("TextButton", MS_list)
                    b.Size = UDim2.new(1, -4, 0, 24)
                    b.BackgroundColor3 = CLR.panel2
                    b.BorderSizePixel = 0
                    b.Text = typeof(obj) .. " → " .. s:sub(1, 80)
                    b.TextColor3 = CLR.text
                    b.TextSize = 10
                    b.Font = Enum.Font.Code
                    b.TextXAlignment = Enum.TextXAlignment.Left
                    b.TextTruncate = Enum.TextTruncate.AtEnd
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                    b.MouseButton1Click:Connect(function()
                        if E.setclipboard then pcall(E.setclipboard, serialize(obj)) end
                    end)
                    table.insert(MS_entries, b)
                end
            end
            task.wait()
        end
        
        print("[MemoryScanner] Found " .. count .. " items")
    end)
end

MS_start.MouseButton1Click:Connect(msScan)

-- ============================================================
-- HOME
-- ============================================================
local HomeTitle = Instance.new("TextLabel", HomeP)
HomeTitle.Size = UDim2.new(1, -20, 0, 40)
HomeTitle.Position = UDim2.new(0, 10, 0, 10)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Text = "SYS SNIFFER v3.0"
HomeTitle.TextColor3 = CLR.accent
HomeTitle.TextSize = 20
HomeTitle.Font = Enum.Font.Code
HomeTitle.TextXAlignment = Enum.TextXAlignment.Left

local HomeDesc = Instance.new("TextLabel", HomeP)
HomeDesc.Size = UDim2.new(1, -20, 1, -80)
HomeDesc.Position = UDim2.new(0, 10, 0, 60)
HomeDesc.BackgroundTransparency = 1
HomeDesc.Text = [[
Merged from Ketamine

FEATURES:
• Remote Spy (RSpy)     - Hooks FireServer/InvokeServer
• Event Spy (ESpy)      - Hooks BindableEvent.Fire/Invoke
• HTTP Spy (HTTPSpy)    - Hooks request/HttpGet/HttpPost
• Script Scanner        - Decompiles & searches scripts
• Memory Scanner        - Scans getgc for values

HOOKS ACTIVE:
• loadstring     • request
• HttpGet        • HttpPost
• require        • HttpService
• RemoteEvent    • Bindable

PROTECTION:
• getgc / getreg / getconnections hidden
• getupvalue / getconstants protected
• Async logging (no lag)

Click tabs on left to explore.
]]
HomeDesc.TextColor3 = CLR.text
HomeDesc.TextSize = 11
HomeDesc.Font = Enum.Font.Code
HomeDesc.TextXAlignment = Enum.TextXAlignment.Left
HomeDesc.TextYAlignment = Enum.TextYAlignment.Top
HomeDesc.TextWrapped = true

-- ============================================================
-- SETTINGS
-- ============================================================
local SetTitle = Instance.new("TextLabel", SetP)
SetTitle.Size = UDim2.new(1, -20, 0, 30)
SetTitle.Position = UDim2.new(0, 10, 0, 10)
SetTitle.BackgroundTransparency = 1
SetTitle.Text = "Settings"
SetTitle.TextColor3 = CLR.accent
SetTitle.TextSize = 16
SetTitle.Font = Enum.Font.Code
SetTitle.TextXAlignment = Enum.TextXAlignment.Left

local themes = {
    {"Blue", CLR.accent},
    {"Green", CLR.green},
    {"Red", CLR.red},
    {"Purple", CLR.purple},
    {"Cyan", CLR.cyan},
    {"Orange", CLR.orange}
}

for i, t in ipairs(themes) do
    local b = Instance.new("TextButton", SetP)
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, 50 + (i - 1) * 36)
    b.BackgroundColor3 = CLR.panel2
    b.BorderSizePixel = 0
    b.Text = "Theme: " .. t[1]
    b.TextColor3 = t[2]
    b.TextSize = 11
    b.Font = Enum.Font.Code
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function()
        for _, bb in pairs(tabBtns) do
            if bb.BackgroundColor3 == CLR.accent then bb.BackgroundColor3 = t[2] end
        end
        CLR.accent = t[2]
        Title.TextColor3 = t[2]
        HomeTitle.TextColor3 = t[2]
        SetTitle.TextColor3 = t[2]
    end)
end

-- ============================================================
-- الحماية الإضافية + الهوكس
-- ============================================================
-- loadstring
pcall(function()
    if type(O.loadstring) ~= "function" then return end
    local raw = O.loadstring
    local w = PF(function(code, chunk)
        local a, b = raw(code, chunk)
        task.spawn(function()
            pcall(hsAddLog, tagURL(chunk or ""), chunk or "Source", tostring(code):sub(1, 3000))
        end)
        return a, b
    end)
    E.loadstring = w
    SN.pf[w] = true
end)

-- request
pcall(function()
    if type(O.request) ~= "function" then return end
    local raw = O.request
    local w = PF(function(t)
        local ok, res = pcall(raw, t)
        if ok and res then
            task.spawn(function()
                local u = type(t) == "table" and (t.Url or t.url or t.URL) or "API"
                local b = type(res) == "table" and (res.Body or res.body) or tostring(res)
                pcall(hsAddLog, tagURL(u), u, b)
            end)
        end
        if not ok then error(res, 0) end
        return res
    end)
    E.request = w
    if syn then syn.request = w end
    SN.pf[w] = true
end)

-- HttpGet
pcall(function()
    if type(game.HttpGet) ~= "function" then return end
    local raw = game.HttpGet
    game.HttpGet = PF(function(self, u, ...)
        local res = raw(self, u, ...)
        task.spawn(function() pcall(hsAddLog, "GET", u, tostring(res):sub(1, 2000)) end)
        return res
    end)
end)

-- HttpPost
pcall(function()
    if type(game.HttpPost) ~= "function" then return end
    local raw = game.HttpPost
    game.HttpPost = PF(function(self, u, data, ...)
        local res = raw(self, u, data, ...)
        task.spawn(function() pcall(hsAddLog, "POST", u, tostring(data) .. "\n\n" .. tostring(res):sub(1, 1000)) end)
        return res
    end)
end)

-- ============================================================
-- Remote Spy Hook (FireServer + OnClientEvent)
-- ============================================================
pcall(function()
    if not O.hookmetamethod or not O.getnamecallmethod then return end
    local oldNC
    oldNC = O.hookmetamethod(game, "__namecall", PF(function(self, ...)
        local method = O.getnamecallmethod()
        if method == "FireServer" and typeof(self) == "Instance" and (self:IsA("RemoteEvent") or self:IsA("UnreliableRemoteEvent")) then
            local args = {...}
            task.spawn(function() pcall(rsAddLog, self.Name, self, false, args, nil) end)
        elseif method == "InvokeServer" and typeof(self) == "Instance" and self:IsA("RemoteFunction") then
            local args = {...}
            task.spawn(function() pcall(rsAddLog, self.Name, self, false, args, nil) end)
        end
        return oldNC(self, ...)
    end))
end)

-- Bindable hooks (Fire)
pcall(function()
    if type(O.hookfunction) ~= "function" then return end
    local bindableProto = Instance.new("BindableEvent")
    O.hookfunction(bindableProto.Fire, PF(function(orig, self, ...)
        if typeof(self) == "Instance" and self.ClassName == "BindableEvent" then
            local args = {...}
            task.spawn(function() pcall(esAddLog, self.Name, self, args) end)
        end
        return orig(self, ...)
    end))
end)

-- مراقبة RemoteEvent.OnClientEvent
pcall(function()
    local function hookRemote(obj)
        if not obj:IsA("RemoteEvent") and not obj:IsA("UnreliableRemoteEvent") then return end
        if obj:GetAttribute("_ss3") then return end
        pcall(function() obj:SetAttribute("_ss3", true) end)
        obj.OnClientEvent:Connect(function(...)
            if not SN.alive then return end
            local args = {...}
            task.spawn(function() pcall(rsAddLog, obj.Name, obj, true, args, nil) end)
        end)
    end
    for _, v in ipairs(RS:GetDescendants()) do pcall(hookRemote, v) end
    RS.DescendantAdded:Connect(function(v) task.spawn(function() pcall(hookRemote, v) end) end)
end)

-- ============================================================
-- Watchdog
-- ============================================================
task.spawn(function()
    while SN.alive do
        task.wait(3)
        pcall(function()
            if SN.hooks.getgc and E.getgc ~= SN.hooks.getgc then E.getgc = SN.hooks.getgc end
            if SN.hooks.getreg and E.getreg ~= SN.hooks.getreg then E.getreg = SN.hooks.getreg end
        end)
    end
end)

-- ============================================================
-- الإغلاق
-- ============================================================
SN.clean = function()
    SN.alive = false
    pcall(function() Gui:Destroy() end)
    pcall(function() E._SS3 = nil end)
end

Close.MouseButton1Click:Connect(function() SN.clean() end)

print("[+] SYS SNIFFER v3.0 - KETAMINE MERGE LOADED")
