--!optimize 2
setfpscap(240)
repeat task.wait() setfpscap(math.huge) until game:IsLoaded()

local LigmaUIVersion
if not isfolder('ligma') then
    makefolder('ligma')
end

local verdata = game:HttpGet('https://raw.githubusercontent.com/Phemeti/Project-Ligma-Recreation/refs/heads/main/info/version.txt')

if not isfile('ligma/version.txt') then
    writefile('ligma/version.txt', verdata)
elseif isfile('ligma/version.txt') and readfile('ligma/version.txt') ~= verdata then
    writefile('ligma/version.txt', verdata)
end

if hookfunction then
    if identifyexecutor and ({identifyexecutor()})[1] ~= 'Project Ligma' then
        hookfunction(getgenv().identifyexecutor, function()
            return 'Project Ligma', LigmaUIVersion
        end)
    elseif getexecutorname and getexecutorname() ~= 'Project Ligma' then
        hookfunction(getgenv().getexecutorname, function()
            return 'Project Ligma'
        end)
    end
else
    if identifyexecutor and ({identifyexecutor()})[1] ~= 'Project Ligma' then
        getgenv().identifyexecutor = function()
            return 'Project Ligma', LigmaUIVersion
        end
    elseif getexecutorname and getexecutorname() ~= 'Project Ligma' then
        getgenv().getexecutorname = function()
            return 'Project Ligma'
        end
    end
end    

local Whitelist = {
    ['6monthbanomg'] = true
}

local __DEBUG = true
local ALLOW_I_DONT_WANT_THESE_PEOPLE_TO_HAVE__DEBUG = false
local I_DONT_WANT_THESE_PEOPLE_TO_HAVE__DEBUG = {
    ['6monthbanomg'] = true
}

local playersService = game:GetService('Players')
local coreGui = game:GetService('CoreGui')
local tweenService = game:GetService('TweenService')
local http = game:GetService('HttpService')
local soundService = game:GetService('SoundService')
local UIS = game:GetService("UserInputService")
local chatservice = game:GetService("TextChatService")
local runservice = game:GetService('RunService')
local rbxreplicatedstorage = game:GetService('RobloxReplicatedStorage')

local function draggable(Frame)
    Frame.Active = true
    Frame.Draggable = true
    -- code is sloppy anyway
    --[[dragToggle = nil
    local dragSpeed = 0
    dragInput = nil
    dragStart = nil
    local dragPos = nil
    function updateInput(input)
        local Delta = input.Position - dragStart
        local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        Frame.Position = Position
    end
    Frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
            dragToggle = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)]]
end

-- Exploit Functions
local ExploitFunctions = {
    filetype = function(file)
        return ((isfile(file) and 'file') or (isfolder(file) and 'folder')) or nil
    end
}

for name, func in ExploitFunctions do
    getgenv()[name] = func
end

local player = playersService.LocalPlayer

local Ligma = {}

if ALLOW_I_DONT_WANT_THESE_PEOPLE_TO_HAVE__DEBUG then
    if I_DONT_WANT_THESE_PEOPLE_TO_HAVE__DEBUG[player.Name] then
        __DEBUG = false
    end
end

if shared.LigmaMaid then
    for _, v in shared.LigmaMaid do
        pcall(function() v:Destroy() end)
        pcall(function() v:Disable() end)
        pcall(function() v:Stop() end)
        pcall(function() v:Disconnect() end)
    end
end
shared.LigmaMaid = {}
local Maid = {}

Maid.AddCleanup = function(self, obj)
    table.insert(shared.LigmaMaid, obj)
    return obj
end

local function check(plr)
    if Whitelist[plr.Name] then
        local whisper = rbxreplicatedstorage.ExperienceChat.WhisperChat:InvokeServer(plr.UserId)
        
        if whisper then
            local old = chatservice.OnIncomingMessage
            
            chatservice.OnIncomingMessage = function(message)
                local props = Instance.new("TextChatMessageProperties")

                if message.TextSource then
                    local target = playersService:GetPlayerByUserId(message.TextSource.UserId)
                    if enabled and target == player then
                        return nil
                    end
                end
                
                return props    
            end
            
            whisper:SendAsync('iamusingproject')
            task.wait(0.05)
            chatservice.OnIncomingMessage = old
            old = nil
        end
    end
end

for _, v in playersService:GetPlayers() do
    if v ~= player then
        check(v)
    end
end

Maid:AddCleanup(playersService.PlayerAdded:Connect(function(v)
    if v ~= player then
        check(v)
    end
end))

-- my bad i dont fucking know how to make shit config systems
--if not isfolder('ligma') then
    --makefolder('ligma')
--end
if not isfolder('ligma/config') then
    makefolder('ligma/config')
end
if not isfolder('ligma/.cache') then
    makefolder('ligma/.cache')
end

Ligma.AddConfig = function(self, name, setval)
    if not isfile('ligma/config/'..name) then
        writefile('ligma/config/'..name, setval)
    end
    local module = {}

    module.SetValue = function(self, val)
        writefile('ligma/config/'..name, val)
    end
    module.GetValue = function(self)
        return readfile('ligma/config/'..name)
    end

    return module
end

local Config = {
    Keybind = Ligma:AddConfig('Keybind', 'Z'),
    PS4Logo = Ligma:AddConfig('PS4Logo', 'true'),
    FPSCounter = Ligma:AddConfig('FPSCounter', 'true'),
    IgnoreScriptwarning = Ligma:AddConfig('IgnoreScriptWarning', 'false')
}

local function toBool(v)
    return v == true or v == "true"
end

local function ApplyPS4(value)
    local state = toBool(value)
    if shared.PS4Logo then
        shared.PS4Logo.Visible = state
    end
end

Ligma.AddSound = function(self, soundsettings)
    local startupmodule = {}

    local startup = Instance.new('Sound')
    Maid:AddCleanup(startup)
    startup.SoundId = soundsettings.Id
    startup.Parent = soundService
    startup.Volume = soundsettings.Volume or 1.3
    startup.PlaybackSpeed = soundsettings.Speed or 1
    startup.Looped = soundsettings.Looped or false
    if soundsettings.Playing then
        startup:Play()
    end

    startupmodule.Play = function(self)
        startup:Play()
    end
    startupmodule.Stop = function(self)
        startup:Stop()
    end
    startupmodule.SetProperty = function(self, prop, val)
        startup[prop] = val
    end

    return startupmodule
end

local function Priority(frame)
    local function bringToFront(frame)
        local maxZ = 0
        for _, obj in ipairs(frame.Parent:GetChildren()) do
            if obj ~= frame and (obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("ImageLabel")) then
                if obj.ZIndex > maxZ then
                    maxZ = obj.ZIndex
                end
            end
        end
        frame.ZIndex = maxZ + 1
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            bringToFront(frame)
        end
    end)
end

local closesound = Ligma:AddSound({
    Id = 'rbxassetid://88440088035194',
    Volume = 1,
    Speed = 1,
    Looped = false
})

local opensound = Ligma:AddSound({
    Id = 'rbxassetid://83200075873367',
    Volume = 1,
    Speed = 1,
    Looped = false
})

local hoversound = Ligma:AddSound({
    Id = 'rbxassetid://124400323975890',
    Volume = 1,
    Speed = 1,
    Looped = false
})

local function AddSounds(obj)
    obj.MouseButton1Down:Connect(function()
        opensound:Play()
        --gui.Visible = false
    end)
    obj.MouseEnter:Connect(function()
        hoversound:Play()
        --gui.Visible = false
    end)
end

if shared.oldligmagui then
    shared.oldligmagui:Destroy()
end
local ScreenGui = Instance.new("ScreenGui")
shared.oldligmagui = ScreenGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = gethui and gethui() or coreGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 540, 0, 310)
Main.Position = UDim2.new(0.5, -270, 0.5, -155)
Main.BackgroundColor3 = Color3.fromRGB(240,240,240)
Main.BorderColor3 = Color3.fromRGB(120,120,120)
Main.Visible = false

shared.PS4Logo = nil

if not __DEBUG then
    do
        local size = 700
        Ligma:AddSound({
            Id = 'rbxassetid://123072435492721',
            Volume = 1,
            Speed = 1,
            Looped = false
        }):Play()
        local icon = Instance.new('ImageButton')
        shared.PS4Logo = icon
        icon.BackgroundTransparency = 1
        icon.ImageTransparency = 1
        icon.Size = UDim2.new(0, size, 0, size)
        icon.AnchorPoint = Vector2.new(0.5, 0.5)
        icon.Position = UDim2.new(0.5, 0, 0.5, 0)
        icon.Image = 'rbxassetid://87162794'
        icon.Parent = ScreenGui
        icon.ZIndex = 9e9

        tweenService:Create(
            icon,
            TweenInfo.new(
                1,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                ImageTransparency = 0,
                Size = UDim2.new(0, 200, 0, 200)
            }
        ):Play()

        task.delay(1, function()
            tweenService:Create(
                icon,
                TweenInfo.new(
                    1,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.InOut
                ),
                {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 30, 1, -30),
                    Rotation = -360,
                    Size = UDim2.new(0, 150, 0, 150)
                }
            ):Play()
        end)

        task.wait(2)
        icon.Rotation = 0

        local spinning = false
        local resetTween = nil

        icon.MouseEnter:Connect(function()
            spinning = true
            if resetTween then resetTween:Cancel() end
        end)
        icon.MouseLeave:Connect(function()
            icon.ImageColor3 = Color3.fromRGB(255,255,255)
            spinning = false
            resetTween = tweenService:Create(
                icon,
                TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Rotation = 0 }
            )
            resetTween:Play()
        end)
        icon.MouseButton1Down:Connect(function()
            icon.ImageColor3 = Color3.fromRGB(199, 199, 199)
        end)
        icon.MouseButton1Up:Connect(function()
            icon.ImageColor3 = Color3.fromRGB(255,255,255)
        end)

        runservice.RenderStepped:Connect(function(dt)
            if spinning then
                icon.Rotation += 180 * dt
            end
        end)
    end
else
    local icon = Instance.new('ImageButton')
    shared.PS4Logo = icon
    icon.BackgroundTransparency = 1
    icon.ImageTransparency = 0
    icon.Size = UDim2.new(0, 150, 0, 150)
    icon.AnchorPoint = Vector2.new(0, 1)
    icon.Position = UDim2.new(0, 30, 1, -30)
    icon.Image = 'rbxassetid://87162794'
    icon.Parent = ScreenGui
    icon.ZIndex = 9e9

    local spinning = false
    local resetTween = nil

    icon.MouseEnter:Connect(function()
        spinning = true
        if resetTween then resetTween:Cancel() end
    end)
    icon.MouseLeave:Connect(function()
        spinning = false
        resetTween = tweenService:Create(
            icon,
            TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Rotation = 0 }
        )
        resetTween:Play()
    end)
    icon.MouseButton1Down:Connect(function()
        icon.ImageColor3 = Color3.fromRGB(199, 199, 199)
    end)
    icon.MouseButton1Up:Connect(function()
        icon.ImageColor3 = Color3.fromRGB(255,255,255)
    end)
    runservice.RenderStepped:Connect(function(dt)
        if spinning then
            icon.Rotation += 180 * dt
        end
    end)
end
ApplyPS4(Config.PS4Logo:GetValue())

local function addClose(gui)
    local TextButton_2 = Instance.new("TextButton")
    TextButton_2.Parent = gui
    TextButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_2.BorderColor3 = Color3.fromRGB(200, 200, 200)
    TextButton_2.Position = UDim2.new(1, -25, 0, 0)
    TextButton_2.Size = UDim2.new(0, 25, 0, 25)
    TextButton_2.Font = Enum.Font.SourceSans
    TextButton_2.Text = "X"
    TextButton_2.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextButton_2.TextSize = 16.000
    TextButton_2.AutoButtonColor = false
    TextButton_2.MouseButton1Down:Connect(function()
        closesound:Play()
        gui.Visible = false
    end)
    TextButton_2.MouseEnter:Connect(function()
        tweenService:Create(
            TextButton_2,
            TweenInfo.new(
                0.2,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                BackgroundColor3 = Color3.fromRGB(200, 40, 40)
            }
        ):Play()
    end)
    TextButton_2.MouseLeave:Connect(function()
        tweenService:Create(
            TextButton_2,
            TweenInfo.new(
                0.4,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }
        ):Play()
    end)
    return TextButton_2
end

local function createinteractivefeature(btn)
    btn.AutoButtonColor = false
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(222,222,222)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(245,245,245)
    end)
    btn.MouseButton1Down:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(177,177,177)
    end)
    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(235,235,235)
    end)
    btn.MouseButton1Click:Connect(function()
        btn.BorderColor3 = Color3.fromRGB(0,120,215)
    end)
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local m = UIS:GetMouseLocation()
            
            if not (
                m.X >= btn.AbsolutePosition.X and
                m.X <= btn.AbsolutePosition.X + btn.AbsoluteSize.X and
                m.Y >= btn.AbsolutePosition.Y and
                m.Y <= btn.AbsolutePosition.Y + btn.AbsoluteSize.Y
            ) then
                btn.BorderColor3 = Color3.fromRGB(150,150,150)
            end
        end
    end)
end

Main.Visible = true

local TopBar = Instance.new("Frame")
TopBar.Parent = Main
TopBar.Size = UDim2.new(1,0,0,18)
TopBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
TopBar.BorderColor3 = Color3.fromRGB(150,150,150)

local BallFrame = Instance.new("ImageLabel")
BallFrame.Parent = TopBar
BallFrame.Size = UDim2.new(0,14,0,14)
BallFrame.Position = UDim2.new(0,3,0,2)
BallFrame.BackgroundTransparency = 1
BallFrame.Image = 'rbxassetid://87162794'
BallFrame.BackgroundColor3 = Color3.fromRGB(210,210,210)
BallFrame.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(0,180,1,0)
Title.Position = UDim2.new(0,22,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Project Ligma"
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.Font = Enum.Font.Arial
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

do
    local FPS = Instance.new("TextLabel")
    shared.FPSCounter = FPS
    FPS.Parent = TopBar
    FPS.Size = UDim2.new(0,180,1,0)
    FPS.Position = UDim2.new(0,98,0,0)
    FPS.BackgroundTransparency = 1
    FPS.Text = ""
    FPS.TextColor3 = Color3.fromRGB(0,0,0)
    FPS.TextTransparency = 0.5
    FPS.Font = Enum.Font.Arial
    FPS.TextSize = 8
    FPS.TextXAlignment = Enum.TextXAlignment.Left
    runservice.RenderStepped:Connect(function(dt)
        local frames = (math.floor(math.abs(1 / dt)))
        if frames % 2 == 0 then
            FPS.Text = readfile('ligma/config/FPSCounter') == 'true' and 'FPS: '..tostring(frames) or ''
        end

    end)
end

local Minimize = Instance.new("TextButton")
Minimize.Parent = TopBar
Minimize.Size = UDim2.new(0,16,1,0)
Minimize.Position = UDim2.new(1,-34,0,0)
Minimize.Text = "-"
Minimize.BackgroundTransparency = 1
Minimize.TextColor3 = Color3.fromRGB(0,0,0)
Minimize.Font = Enum.Font.Arial
Minimize.TextSize = 14

local Close = Instance.new("TextButton")
Close.Parent = TopBar
Close.Size = UDim2.new(0,16,1,0)
Close.Position = UDim2.new(1,-18,0,0)
Close.Text = "X"
Close.BorderSizePixel = 0
Close.BackgroundColor3 = Color3.fromRGB(255,50,50)
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(0,0,0)
Close.Font = Enum.Font.Arial
Close.TextSize = 12

Close.MouseEnter:Connect(function()
    tweenService:Create(
        Close,
        TweenInfo.new(
            0.2,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            BackgroundTransparency = 0
        }
    ):Play()
end)
Close.MouseLeave:Connect(function()
    tweenService:Create(
        Close,
        TweenInfo.new(
            0.4,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            BackgroundTransparency = 1
        }
    ):Play()
end)

local TextService = game:GetService("TextService")
local Scroller = Instance.new("ScrollingFrame")
Scroller.Parent = Main
Scroller.Size = UDim2.new(0, 370, 0, 255)
Scroller.Position = UDim2.new(0, 5, 0, 24)
Scroller.BackgroundColor3 = Color3.fromRGB(245,245,245)
Scroller.BorderColor3 = Color3.fromRGB(150,150,150)
Scroller.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
Scroller.ScrollBarThickness = 6
Scroller.ScrollingDirection = Enum.ScrollingDirection.XY
Scroller.CanvasSize = UDim2.new(0,0,0,255)

local Lines = Instance.new("TextLabel")
Lines.Parent = Scroller
Lines.Size = UDim2.new(0,30,0,255)
Lines.BackgroundColor3 = Color3.fromRGB(200,200,200)
Lines.TextColor3 = Color3.fromRGB(100,100,100)
Lines.Font = Enum.Font.Code
Lines.TextSize = 12
Lines.TextXAlignment = Enum.TextXAlignment.Center
Lines.TextYAlignment = Enum.TextYAlignment.Top
Lines.Text = "1"

local ScriptBox = Instance.new("TextBox")
ScriptBox.Parent = Scroller
ScriptBox.Position = UDim2.new(0,35,0,0)
ScriptBox.Size = UDim2.new(1,-35,0,255)
ScriptBox.BackgroundTransparency = 0
ScriptBox.BackgroundColor3 = Color3.fromRGB(ScriptBoxBackgroundColor,ScriptBoxBackgroundColor,ScriptBoxBackgroundColor)
ScriptBox.Text = "print('hello world')"
ScriptBox.TextColor3 = Color3.fromRGB(ScriptBoxTextColor,ScriptBoxTextColor,ScriptBoxTextColor)
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.ClearTextOnFocus = false
ScriptBox.MultiLine = true
ScriptBox.TextWrapped = false
ScriptBox.Font = Enum.Font.Code
ScriptBox.TextSize = 12

local function updatescriptboxcolors(bkgcolor, txtcolor)
    -- this is like the only time i've seen column be "useful"
    local ScriptBoxBackgroundColor = bkgcolor or 233
    local ScriptBoxTextColor       = txtcolor or 10
    ScriptBox.BackgroundColor3     = Color3.fromRGB(ScriptBoxBackgroundColor,ScriptBoxBackgroundColor,ScriptBoxBackgroundColor)
    ScriptBox.TextColor3           = Color3.fromRGB(ScriptBoxTextColor,ScriptBoxTextColor,ScriptBoxTextColor)
end

updatescriptboxcolors()

local function GetLineHeight()
    local testSize = TextService:GetTextSize(
        "A",
        ScriptBox.TextSize,
        ScriptBox.Font,
        Vector2.new(math.huge, math.huge)
    )
    return testSize.Y
end

local LINE_HEIGHT = GetLineHeight()

local function GetCursorLine()
    local pos = ScriptBox.CursorPosition
    if pos < 1 then return nil end 
    local textBefore = ScriptBox.Text:sub(1, pos - 1)
    local line = 1
    for _ in textBefore:gmatch("\n") do
        line += 1
    end
    return line
end

local function GetCursorX()
    local pos = ScriptBox.CursorPosition
    if pos < 1 then return nil end 
    local textBefore = ScriptBox.Text:sub(1, pos - 1)
    local lastLine = textBefore:match("([^\n]*)$") or ""
    local size = TextService:GetTextSize(
        lastLine,
        ScriptBox.TextSize,
        ScriptBox.Font,
        Vector2.new(math.huge, math.huge)
    )
    return size.X
end

local function GetMaxLineWidth()
    local maxWidth = 0
    for line in ScriptBox.Text:gmatch("([^\n]*)\n?") do
        local size = TextService:GetTextSize(
            line,
            ScriptBox.TextSize,
            ScriptBox.Font,
            Vector2.new(math.huge, math.huge)
        )
        if size.X > maxWidth then
            maxWidth = size.X
        end
    end
    return maxWidth
end

local function UpdateLayout()
    if Scroller.AbsoluteSize.X < 1 or Scroller.AbsoluteSize.Y < 1 then return end

    local count = 1
    for _ in ScriptBox.Text:gmatch("\n") do
        count += 1
    end

    local nums = {}
    for i = 1, count do
        nums[i] = tostring(i)
    end
    Lines.Text = table.concat(nums, "\n")

    local height = math.max(count * LINE_HEIGHT + LINE_HEIGHT, 255)
    local maxWidth = GetMaxLineWidth()
    local width = math.max(maxWidth + 100, Scroller.AbsoluteSize.X)

    ScriptBox.Size = UDim2.new(0, math.max(width - 35, Scroller.AbsoluteSize.X - 35), 0, height)
    Lines.Size = UDim2.new(0, 30, 0, height)
    Scroller.CanvasSize = UDim2.new(0, width, 0, height)
end

local function UpdateScroll()
    if Scroller.AbsoluteSize.X < 1 or Scroller.AbsoluteSize.Y < 1 then return end

    local currentLine = GetCursorLine()
    local cursorX = GetCursorX()

    if not currentLine or not cursorX then return end

    local width = Scroller.CanvasSize.X.Offset
    local height = Scroller.CanvasSize.Y.Offset

    local y = (currentLine - 1) * LINE_HEIGHT
    local visibleTop = Scroller.CanvasPosition.Y
    local visibleBottom = visibleTop + Scroller.AbsoluteWindowSize.Y

    local newY = Scroller.CanvasPosition.Y
    if y < visibleTop then
        newY = math.max(0, y)
    elseif y + LINE_HEIGHT > visibleBottom then
        newY = math.max(0, y - Scroller.AbsoluteWindowSize.Y + LINE_HEIGHT + 4)
    end

    local visibleLeft = Scroller.CanvasPosition.X
    local visibleRight = visibleLeft + Scroller.AbsoluteWindowSize.X

    local newX = Scroller.CanvasPosition.X
    if cursorX < visibleLeft then
        newX = math.max(0, cursorX)
    elseif cursorX > visibleRight - 60 then
        newX = math.max(0, cursorX - Scroller.AbsoluteWindowSize.X + 80)
    end

    newX = math.min(newX, math.max(0, width - Scroller.AbsoluteWindowSize.X))
    newY = math.min(newY, math.max(0, height - Scroller.AbsoluteWindowSize.Y))

    Scroller.CanvasPosition = Vector2.new(newX, newY)
end

ScriptBox:GetPropertyChangedSignal("Text"):Connect(function()
    UpdateLayout()
    UpdateScroll()
end)

ScriptBox:GetPropertyChangedSignal("CursorPosition"):Connect(UpdateScroll)

Scroller:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateLayout)

UpdateLayout()

Lines.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

    local relativeY = (input.Position.Y - Lines.AbsolutePosition.Y) + Scroller.CanvasPosition.Y
    local lineIndex = math.floor(relativeY / LINE_HEIGHT) + 1

    local totalLines = 1
    for _ in ScriptBox.Text:gmatch("\n") do
        totalLines += 1
    end
    lineIndex = math.clamp(lineIndex, 1, totalLines)

    local text = ScriptBox.Text
    local lineStart = 1
    local currentLine = 1

    while currentLine < lineIndex do
        local nl = text:find("\n", lineStart, true)
        if not nl then break end
        lineStart = nl + 1
        currentLine += 1
    end

    local nl = text:find("\n", lineStart, true)

    ScriptBox:CaptureFocus()
    ScriptBox.SelectionStart = lineStart
    if nl then
        ScriptBox.CursorPosition = nl + 1
    else
        ScriptBox.CursorPosition = #text + 1
    end
end)

local SidePanel = Instance.new("ScrollingFrame")
SidePanel.Parent = Main
SidePanel.Size = UDim2.new(0,70,0,255)
SidePanel.Position = UDim2.new(0,360,0,24)
SidePanel.BackgroundColor3 = Color3.fromRGB(188,188,188)
SidePanel.BorderColor3 = Color3.fromRGB(150,150,150)
SidePanel.ScrollBarThickness = 6
SidePanel.ScrollingDirection = Enum.ScrollingDirection.Y
SidePanel.CanvasSize = UDim2.new(0,0,0,0)

do
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = SidePanel
    UIPadding.PaddingBottom = UDim.new(0, 1)
    UIPadding.PaddingLeft = UDim.new(0, 1)
    UIPadding.PaddingRight = UDim.new(0, 1)
    UIPadding.PaddingTop = UDim.new(0, 1)
end

local SidePanelLayout = Instance.new("UIListLayout")
SidePanelLayout.Parent = SidePanel
SidePanelLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidePanelLayout.FillDirection = Enum.FillDirection.Vertical

SidePanelLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SidePanel.CanvasSize = UDim2.new(0, 0, 0, SidePanelLayout.AbsoluteContentSize.Y)
end)

local function AddSideButton(text, fontSize)
    local btn = Instance.new("TextButton")
    btn.Parent = SidePanel
    btn.Size = UDim2.new(1,0,0,75)
    btn.Text = text..'  '
    btn.BackgroundColor3 = Color3.fromRGB(245,245,245)
    btn.BorderColor3 = Color3.fromRGB(150,150,150)
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.Arial
    btn.AutoButtonColor = false
    btn.TextSize = fontSize or 13
    createinteractivefeature(btn)
    return btn
end

local Exec = AddSideButton("EXE", 15)
local Clear = AddSideButton("CLEAR", 12)
local Copy = AddSideButton("COPY", 11)

Copy.MouseButton1Down:Connect(function()
    pcall(function()
        (toclipboard or setclipboard or clipboard or syn.toclipboard or syn.setclipboard)(tostring(ScriptBox.Text))
    end)
end)

--local R6 = AddSideButton("R6", 14)

do
    local Dissector = AddSideButton("EXHUME", 11)

    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local TextLabel_2 = Instance.new("TextLabel")
    local TextLabel_3 = Instance.new("TextLabel")
    local TextBox = Instance.new("TextBox")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local TextButton = Instance.new("TextButton")
    local UIStroke_2 = Instance.new("UIStroke")
    local UICorner_2 = Instance.new("UICorner")
    local TextButton_2 = Instance.new("TextButton")
    --local UIStroke_3 = Instance.new("UIStroke")

    Frame.Visible = false
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BorderColor3 = Color3.fromRGB(158, 158, 158)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)

    local UserInputService = game:GetService("UserInputService")

    local gui = Frame

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 347, 0, 257)

    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(0, 347, 0, 29)
    TextLabel.Font = Enum.Font.Arial
    TextLabel.Text = "Exhume Dissector"
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextSize = 20.000

    TextLabel_2.Parent = Frame
    TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel_2.BackgroundTransparency = 1.000
    TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel_2.BorderSizePixel = 0
    TextLabel_2.Position = UDim2.new(0, 0, 0.112840466, 0)
    TextLabel_2.Size = UDim2.new(0, 347, 0, 42)
    TextLabel_2.Font = Enum.Font.Arial
    TextLabel_2.Text = "Exhume is a Exploit API that allows you to view LocalScripts/ModuleScripts  contents, letting you see stuff like functions, variables, etc."
    TextLabel_2.TextColor3 = Color3.fromRGB(83, 83, 83)
    TextLabel_2.TextSize = 12.000
    TextLabel_2.TextStrokeColor3 = Color3.fromRGB(121, 121, 121)
    TextLabel_2.TextWrapped = true
    TextLabel_2.TextYAlignment = Enum.TextYAlignment.Top

    TextLabel_3.Parent = Frame
    TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel_3.BackgroundTransparency = 1.000
    TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel_3.BorderSizePixel = 0
    TextLabel_3.Position = UDim2.new(0, 0, 0.898832679, 0)
    TextLabel_3.Size = UDim2.new(0, 347, 0, 26)
    TextLabel_3.Font = Enum.Font.Arial
    TextLabel_3.Text = "To use this, first, put in the script name that you want, then, press \"Dissect\", and Exhume will do the work."
    TextLabel_3.TextColor3 = Color3.fromRGB(112, 112, 112)
    TextLabel_3.TextSize = 10.000
    TextLabel_3.TextStrokeColor3 = Color3.fromRGB(121, 121, 121)
    TextLabel_3.TextWrapped = true
    TextLabel_3.TextYAlignment = Enum.TextYAlignment.Top

    TextBox.Parent = Frame
    TextBox.BackgroundColor3 = Color3.fromRGB(238, 238, 238)
    TextBox.BorderColor3 = Color3.fromRGB(188, 188, 188)
    TextBox.Position = UDim2.new(0.0778097957, 0, 0.365758747, 0)
    TextBox.Size = UDim2.new(0, 294, 0, 41)
    TextBox.ClearTextOnFocus = false
    TextBox.Font = Enum.Font.RobotoMono
    TextBox.Text = ""
    TextBox.PlaceholderText = 'Animate...'
    TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextBox.TextSize = 15.000

    UICorner.CornerRadius = UDim.new(0, 3)
    UICorner.Parent = TextBox

    UIStroke.Parent = TextBox
    UIStroke.Color = Color3.fromRGB(186, 186, 186)
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    TextButton.Parent = Frame
    TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BorderSizePixel = 0
    TextButton.Position = UDim2.new(0.291066289, 0, 0.61867702, 0)
    TextButton.Size = UDim2.new(0, 146, 0, 32)
    TextButton.Font = Enum.Font.SourceSans
    TextButton.Text = "Dissect"
    TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.TextScaled = true

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = TextButton
    UIPadding.PaddingBottom = UDim.new(0, 6)
    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.PaddingTop = UDim.new(0, 6)

    local canDissect = true

    TextButton.MouseButton1Down:Connect(function()
        if not canDissect then return end
        local name = TextBox.Text
        local script = nil
        canDissect = false
        TextButton.Text = 'Finding script...'
        for _, v in game:GetDescendants() do
            if (v:IsA('LocalScript') or v:IsA('ModuleScript')) and v.Name:find(name) then
                script = v
                break
            end
        end
        if script == nil then
            TextButton.Text = 'Couldn\'t find: '..name
            task.wait(1)
            TextButton.Text = "Dissect"
            canDissect = true
            return
        end
        TextButton.Text = 'Loading Exhume API...'
        local Exhume = loadstring(game:HttpGet('https://raw.githubusercontent.com/Phemeti/Exhume/refs/heads/main/ExhumeAPI.lua', true))()
        TextButton.Text = 'Dissecting script, please wait...'
        local suc, res = pcall(function()
            return Exhume:RunDissector(script)
        end)
        if suc then
            ScriptBox.Text = res:GetContents()
            TextButton.Text = 'Finished!'
            task.wait(1)
            TextButton.Text = 'Dissect'
            canDissect = true
        else
            TextButton.Text = 'Failed to dissect...'
            task.wait(1)
            TextButton.Text = 'Dissect'
            canDissect = true
        end
    end)

    UIStroke_2.Parent = TextButton
    UIStroke_2.Color = Color3.fromRGB(186, 186, 186)
    UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    UICorner_2.CornerRadius = UDim.new(0, 3)
    UICorner_2.Parent = TextButton

    TextButton_2.Parent = Frame
    TextButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_2.BorderColor3 = Color3.fromRGB(200, 200, 200)
    TextButton_2.Position = UDim2.new(0.927953899, 0, 0, 0)
    TextButton_2.Size = UDim2.new(0, 25, 0, 25)
    TextButton_2.Font = Enum.Font.SourceSans
    TextButton_2.Text = "X"
    TextButton_2.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextButton_2.TextSize = 16.000
    TextButton_2.AutoButtonColor = false

    --UIStroke_3.Parent = Frame
    --UIStroke_3.Color = Color3.fromRGB(186, 186, 186)
    --UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    Dissector.MouseButton1Down:Connect(function()
        Frame.Visible = not Frame.Visible
    end)
    TextButton_2.MouseButton1Down:Connect(function()
        Frame.Visible = false
    end)
    TextButton_2.MouseEnter:Connect(function()
        tweenService:Create(
            TextButton_2,
            TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { BackgroundColor3 = Color3.fromRGB(200, 40, 40) }
        ):Play()
    end)
    TextButton_2.MouseLeave:Connect(function()
        tweenService:Create(
            TextButton_2,
            TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }
        ):Play()
    end)
    createinteractivefeature(TextButton)
end

local RightPanel = Instance.new("ScrollingFrame")
local PANELIST = Instance.new("UIListLayout")
PANELIST.Parent = RightPanel
RightPanel.Parent = Main
RightPanel.ScrollBarThickness = 5
RightPanel.Size = UDim2.new(0,90,0,255)
RightPanel.Position = UDim2.new(0,445,0,24)
RightPanel.BackgroundColor3 = Color3.fromRGB(177,177,177)
RightPanel.BorderColor3 = Color3.fromRGB(150,150,150)

local function AddFile(name, script)
    local thing = Instance.new("TextButton")
    thing.Parent = RightPanel
    thing.Size = UDim2.new(1,0,0,20)
    thing.Position = UDim2.new(0,0,0,66)
    thing.Text = tostring(name)..' '
    thing.BackgroundColor3 = Color3.fromRGB(245,245,245)
    thing.BorderSizePixel = 0.7
    thing.TextColor3 = Color3.fromRGB(0,0,0)
    thing.Font = Enum.Font.Arial
    thing.TextSize = 11
    thing.MouseButton1Down:Connect(function()
        ScriptBox.Text = tostring(script)
    end)
end

local CoolGui = Instance.new("TextButton")
CoolGui.Parent = RightPanel
CoolGui.Size = UDim2.new(1,0,0,20)
CoolGui.Position = UDim2.new(0,0,0,0)
CoolGui.Text = "c00lgui"
CoolGui.BackgroundColor3 = Color3.fromRGB(245,245,245)
CoolGui.BorderSizePixel = 0
CoolGui.TextColor3 = Color3.fromRGB(0,0,0)
CoolGui.Font = Enum.Font.Arial
CoolGui.TextSize = 13

local InfYield = Instance.new("TextButton")
InfYield.Parent = RightPanel
InfYield.Size = UDim2.new(1,0,0,20)
InfYield.Position = UDim2.new(0,0,0,22)
InfYield.Text = "Infinite Yield"
InfYield.BackgroundColor3 = Color3.fromRGB(245,245,245)
InfYield.BorderSizePixel = 0.7
InfYield.TextColor3 = Color3.fromRGB(0,0,0)
InfYield.Font = Enum.Font.Arial
InfYield.TextSize = 11

local GonerHub = Instance.new("TextButton")
GonerHub.Parent = RightPanel
GonerHub.Size = UDim2.new(1,0,0,20)
GonerHub.Position = UDim2.new(0,0,0,44)
GonerHub.Text = "Goner Hub"
GonerHub.BackgroundColor3 = Color3.fromRGB(245,245,245)
GonerHub.BorderSizePixel = 0.7
GonerHub.TextColor3 = Color3.fromRGB(0,0,0)
GonerHub.Font = Enum.Font.Arial
GonerHub.TextSize = 11

local MessageTxt = Instance.new("TextButton")
MessageTxt.Parent = RightPanel
MessageTxt.Size = UDim2.new(1,0,0,20)
MessageTxt.Position = UDim2.new(0,0,0,66)
MessageTxt.Text = "message.txt"
MessageTxt.BackgroundColor3 = Color3.fromRGB(245,245,245)
MessageTxt.BorderSizePixel = 0.7
MessageTxt.TextColor3 = Color3.fromRGB(0,0,0)
MessageTxt.Font = Enum.Font.Arial
MessageTxt.TextSize = 11

AddFile('John Doe', 'require(8973689388).load("'..(player.Name or 'yourusername')..'")')
AddFile('Kasper Trolling', 'require(6414405864).KUTG("'..(player.Name or 'yourusername')..'")')
AddFile('Krono Hub', 'require(9275293020).load("'..(player.Name or 'yourusername')..'")')
AddFile('Sonic Hub', 'require(5352721272):Fire("'..(player.Name or 'yourusername')..'")')

AddFile('Abuse Detection', 'require(8626754476):AD()')
AddFile('Anti-Kick', 'require(4820862445).load')

AddFile('C00lKidd', 'require(12621812058).yeskido("'..(player.Name or 'yourusername')..'")')
AddFile('Noot Noot', 'require(5034863407).subtosyntax64("'..(player.Name or 'yourusername')..'")')
AddFile('Destroyer GUI', 'require(5257685661):Fire("'..(player.Name or 'yourusername')..'")')
AddFile('cXyzGUI', 'require(12861793677).cXyzskidd("'..(player.Name or 'yourusername')..'")')
AddFile('Virus Troll 😔', 'require(7192763922).load("'..('username, not u btw')..'")')

AddFile('HD Admin', 'require(6707668066).virus("'..(player.Name or 'yourusername')..'")')

local minimized = false
local closed = false

local NormalSize = Main.Size
local NormalPos = Main.Position

local function SetVisible(state)
	ScriptBox.Visible = state
	SidePanel.Visible = state
	RightPanel.Visible = state
end

Minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then
		SetVisible(false)
		Main.Size = UDim2.new(0,540,0,18)
	else
		SetVisible(true)
		Main.Size = NormalSize
		Main.Position = NormalPos
	end
end)

Close.MouseButton1Click:Connect(function()
	closed = true
	Main.Visible = false
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode[Config.Keybind:GetValue()] then

		if closed then
			closed = false
			Main.Visible = true
		else
			Main.Visible = not Main.Visible
		end
	end
end)

Clear.MouseButton1Click:Connect(function()
	ScriptBox.Text = ""
end)

-- R6 BUTTON
--R6.MouseButton1Click:Connect(function()
--	ScriptBox.Text = "R6 Enabled"
--end)

CoolGui.MouseButton1Click:Connect(function()
	ScriptBox.Text = "require(14125553864)"
end)

InfYield.MouseButton1Click:Connect(function()
	ScriptBox.Text = "require(7634392335)"
end)

GonerHub.MouseButton1Click:Connect(function()
	ScriptBox.Text = "require(5954678096)"
end)

MessageTxt.MouseButton1Click:Connect(function()
	ScriptBox.Text = [[
local msg = Instance.new("Hint")
msg.Text = "chirafinalphase was here"
msg.Parent = workspace

task.wait(5)

msg:Destroy()
]]
end)

Exec.MouseButton1Click:Connect(function()
	local source = ScriptBox.Text
	local func, err = loadstring(source)

	if func then
		pcall(func)
	else
		warn(err)
	end
end)

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart

	Main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

TopBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

local Gear = Instance.new("ImageButton")
Gear.Parent = Main
Gear.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Gear.BackgroundTransparency = 1
Gear.ImageTransparency = 0.2
Gear.BorderColor3 = Color3.fromRGB(0, 0, 0)
AddSounds(Gear)
Gear.Position = UDim2.new(
    0,
    0,
    0,
    280
)
Gear.BorderSizePixel = 0
Gear.Size = UDim2.new(0, 30, 0, 30)
Gear.Image = "rbxassetid://2484550853"
Gear.ImageColor3 = Color3.fromRGB(0, 0, 0)

local SETTINGS = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local TextLabel = Instance.new("TextLabel")
local ImageLabel = Instance.new("ImageLabel")
local TextLabel_2 = Instance.new("TextLabel")
local SettingsSlider = Instance.new("ScrollingFrame")
local SETTINGSLIST = Instance.new("UIListLayout")
SETTINGSLIST.Parent = SettingsSlider
SETTINGSLIST.Padding = UDim.new(0, 10)
local UIStroke_2 = Instance.new("UIStroke")
local UIPadding = Instance.new("UIPadding")
local UIPadding_2 = Instance.new("UIPadding")

SETTINGS.Name = "SETTINGS"
SETTINGS.Parent = ScreenGui
SETTINGS.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SETTINGS.BorderColor3 = Color3.fromRGB(158, 158, 158)
SETTINGS.ClipsDescendants = true
SETTINGS.Visible = false
SETTINGS.AnchorPoint = Vector2.new(0.5, 0.5)
SETTINGS.Position = UDim2.new(0.5, 0, 0.5, 0)
SETTINGS.Size = UDim2.new(0, 347, 0, 257)

draggable(SETTINGS)

addClose(SETTINGS)

Gear.MouseButton1Down:Connect(function()
    SETTINGS.Visible = not SETTINGS.Visible
end)

UIStroke.Parent = SETTINGS
UIStroke.Color = Color3.fromRGB(186, 186, 186)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

TextLabel.Parent = SETTINGS
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.308357358, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 133, 0, 29)
TextLabel.Font = Enum.Font.Arial
TextLabel.Text = "Ligma Settings"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 20.000

ImageLabel.Parent = SETTINGS
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(-0.544668615, 0, -0.264591426, 0)
ImageLabel.Size = UDim2.new(0, 450, 0, 450)
ImageLabel.Image = "rbxassetid://2484550853"
ImageLabel.ImageColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.ImageTransparency = 0.950

TextLabel_2.Parent = SETTINGS
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.0605187304, 0, 0.112840466, 0)
TextLabel_2.Size = UDim2.new(0, 305, 0, 31)
TextLabel_2.Font = Enum.Font.Arial
TextLabel_2.Text = "Change keybinds, theme, ETC."
TextLabel_2.TextColor3 = Color3.fromRGB(109, 109, 109)
TextLabel_2.TextSize = 14.000
TextLabel_2.TextWrapped = true
TextLabel_2.TextYAlignment = Enum.TextYAlignment.Top

SettingsSlider.Name = "SettingsSlider"
SettingsSlider.Parent = SETTINGS
SettingsSlider.Active = true
SettingsSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SettingsSlider.BackgroundTransparency = 1.000
SettingsSlider.BorderColor3 = Color3.fromRGB(0, 0, 0)
SettingsSlider.BorderSizePixel = 0
SettingsSlider.Position = UDim2.new(0.0459483899, 0, 0.22965309, 0)
SettingsSlider.Size = UDim2.new(0, 314, 0, 180)
SettingsSlider.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
SettingsSlider.ScrollBarThickness = 8

UIPadding_2.Parent = SettingsSlider
UIPadding_2.PaddingBottom = UDim.new(0, 8)
UIPadding_2.PaddingLeft = UDim.new(0, 5)
UIPadding_2.PaddingRight = UDim.new(0, 5)
UIPadding_2.PaddingTop = UDim.new(0, 8)

local function createtoggle(name, default, callback)
    local state = default

    local frame = Instance.new("Frame")
    frame.Parent = SettingsSlider
    frame.Size = UDim2.new(0, 286, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BorderColor3 = Color3.fromRGB(186, 186, 186)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 6, 0, 0)
    label.Font = Enum.Font.Arial
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.Text = name

    local button = Instance.new("TextButton")
    button.Parent = frame
    button.Size = UDim2.new(0, 23, 0, 23)
    button.Position = UDim2.new(1, -23 - 7, 0.5, -11)
    button.Font = Enum.Font.Arial
    button.BorderSizePixel = 2
    button.Text = ''
    button.TextSize = 12
    button.AutoButtonColor = false
    local function update()
        button.BackgroundColor3 = state and Color3.fromRGB(120, 220, 120)
            or Color3.fromRGB(220, 120, 120)
    end

    button.MouseButton1Click:Connect(function()
        state = not state
        update()
        if callback then
            callback(state)
        end
    end)

    update()

    return {
        GetValue = function()
            return state
        end
    }
end

local function toBool(v)
    return v == true or v == "true"
end
local function createtextbox(name, val, onChange)
    local TEXTBOX_MODULE = Instance.new("Frame")
    local TEXTBOX_TextLabel = Instance.new("TextLabel")
    local TEXTBOX_UIStroke = Instance.new("UIStroke")
    local TEXTBOX_TextBox = Instance.new("TextBox")
    local UIStroke_2 = Instance.new("UIStroke")
    local UIPadding = Instance.new("UIPadding")

    TEXTBOX_MODULE.Name = "TEXTBOX_MODULE"
    TEXTBOX_MODULE.Parent = SettingsSlider
    TEXTBOX_MODULE.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TEXTBOX_MODULE.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TEXTBOX_MODULE.BorderSizePixel = 0
    TEXTBOX_MODULE.Size = UDim2.new(0, 286, 0, 48)
    
    TEXTBOX_TextLabel.Name = "TEXTBOX_TextLabel"
    TEXTBOX_TextLabel.Parent = TEXTBOX_MODULE
    TEXTBOX_TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TEXTBOX_TextLabel.BackgroundTransparency = 1.000
    TEXTBOX_TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TEXTBOX_TextLabel.BorderSizePixel = 0
    TEXTBOX_TextLabel.Position = UDim2.new(0, 0, -0.0214460511, 0)
    TEXTBOX_TextLabel.Size = UDim2.new(0, 285, 0, 17)
    TEXTBOX_TextLabel.Font = Enum.Font.Arial
    TEXTBOX_TextLabel.Text = name
    TEXTBOX_TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TEXTBOX_TextLabel.TextSize = 14.000
    
    TEXTBOX_UIStroke.Name = "TEXTBOX_UIStroke"
    TEXTBOX_UIStroke.Parent = TEXTBOX_MODULE
    TEXTBOX_UIStroke.Color = Color3.fromRGB(186, 186, 186)
    TEXTBOX_UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    TEXTBOX_TextBox.Name = "TEXTBOX_TextBox"
    TEXTBOX_TextBox.Parent = TEXTBOX_MODULE
    TEXTBOX_TextBox.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
    TEXTBOX_TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TEXTBOX_TextBox.BorderSizePixel = 0
    TEXTBOX_TextBox.Position = UDim2.new(0.0244755242, 0, 0.373902649, 0)
    TEXTBOX_TextBox.Size = UDim2.new(0, 270, 0, 24)
    TEXTBOX_TextBox.ClearTextOnFocus = false
    TEXTBOX_TextBox.Font = Enum.Font.Arial
    TEXTBOX_TextBox.Text = val or ''
    TEXTBOX_TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    TEXTBOX_TextBox.TextScaled = true
    TEXTBOX_TextBox.TextSize = 14.000
    TEXTBOX_TextBox.TextWrapped = true
    
    UIStroke_2.Parent = TEXTBOX_TextBox
    UIStroke_2.Color = Color3.fromRGB(186, 186, 186)
    UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    UIPadding.Parent = TEXTBOX_TextBox
    UIPadding.PaddingBottom = UDim.new(0, 5)
    UIPadding.PaddingLeft = UDim.new(0, 6)
    UIPadding.PaddingRight = UDim.new(0, 6)
    UIPadding.PaddingTop = UDim.new(0, 5)

    if onChange then
        TEXTBOX_TextBox:GetPropertyChangedSignal('Text'):Connect(function()
            onChange()
        end)
    end

    return {
        GetValue = function(self)
            return TEXTBOX_TextBox.Text
        end
    }
end

local keybind
keybind = createtextbox('Keybind', readfile('ligma/config/Keybind') or 'Z', function()
    Config.Keybind:SetValue(keybind:GetValue())
end)

local logotoggle
logotoggle = createtoggle('Ligma Logo', toBool(readfile('ligma/config/PS4Logo')), function()
    local state = logotoggle:GetValue()
    Config.PS4Logo:SetValue(state and 'true' or 'false')
    shared.PS4Logo.Visible = state
end)
local fpscounter
local showFPS = readfile('ligma/config/FPSCounter') == 'true' and true or false
fpscounter = createtoggle('FPS Counter', toBool(readfile('ligma/config/FPSCounter')), function()
    local state = fpscounter:GetValue()
    Config.FPSCounter:SetValue(state and 'true' or 'false')
    showFPS = readfile('ligma/config/FPSCounter') == 'true' and true or false
end)

local ignorescriptwarning
ignorescriptwarning = createtoggle('Ignore Script Warning', toBool(readfile('ligma/config/IgnoreScriptwarning')), function()
    local state = ignorescriptwarning:GetValue()
    Config.IgnoreScriptwarning:SetValue(state and 'true' or 'false')
end)

shared.PS4Logo.Visible = toBool(readfile('ligma/config/PS4Logo'))
--https://discord.gg/uGtE5D6gmX
do
    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local Scroller = Instance.new("ScrollingFrame")
    local TextLabel_2 = Instance.new("TextLabel")

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BorderColor3 = Color3.fromRGB(175, 175, 175)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Visible = false
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 418, 0, 290)

    draggable(Frame)
    addClose(Frame)

    TextLabel.Parent = Frame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0.210526317, 0, 0.0348837227, 0)
    TextLabel.Size = UDim2.new(0, 242, 0, 23)
    TextLabel.Font = Enum.Font.Arial
    TextLabel.Text = "Info"
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextScaled = true
    TextLabel.TextWrapped = true

    Scroller.Parent = Frame
    Scroller.BackgroundTransparency = 0.95
    Scroller.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Scroller.BorderSizePixel = 0
    Scroller.Position = UDim2.new(0.057, 0, 0.147, 0)
    Scroller.Size = UDim2.new(0, 380, 0, 185)
    Scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroller.ScrollBarThickness = 7
    Scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local stroke = Instance.new('UIStroke')
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(177,177,177)
    stroke.Parent = Scroller
    TextLabel_2.Parent = Scroller
    TextLabel_2.BackgroundTransparency = 1
    TextLabel_2.BorderSizePixel = 0
    TextLabel_2.Position = UDim2.new(0, 0, 0, 0)
    TextLabel_2.Size = UDim2.new(1, -5, 0, 0)
    TextLabel_2.AutomaticSize = Enum.AutomaticSize.Y
    TextLabel_2.Font = Enum.Font.Arial
    TextLabel_2.RichText = true

    local function bold(str)
        return '<b>' .. str .. '</b>'
    end

    TextLabel_2.Text =
        bold('Project Ligma')..' was a highly private Roblox executor and serverside framework that became infamous within the exploiting community for capabilities such as '..bold('FE (Filtering Enabled) bypass')..', advanced serverside execution, and later claims of '..bold('Byfron/Hyperion bypass')..'.\n\nUnlike most public executors at the time, Project Ligma was rumored to rely on '..bold('hidden backdoors')..', vulnerable remotes, and custom replication methods that allowed effects to appear server-sided in certain games.\n\n'..
        
        'The project gained '..bold('major notoriety')..' after being '..bold('associated with several Roblox game incidents and trolling showcases')..', most notably involving '..bold('MeepCity')..'.\n\nIts reputation was amplified through videos uploaded by '..bold('popular Roblox exploit YouTubers')..' such as '..bold('Blame')..', '..bold('Citizen')..' (known for serverside content), and '..bold('TypicalModders')..', many of which showcased what power Project Ligma held.\n\n'..
        
        'According to exploit-community discussions, the executor was never fully public and was distributed only among a small circle of users. However, around '..bold('2021-2022')..', reports began surfacing that parts of the project had been '..bold('leaked online')..', though many users claimed the leaked files were '..bold('incomplete, outdated, or missing the real core functionality')..'. Some of these files were later uploaded to '..bold('GitHub')..' by '..bold('third parties who stated they were not responsible for how the files were used')..'.\n\n'..
        
        'Following the leaks, Project Ligma was rumored to have collaborated or merged with another '..bold('private project')..' known as '..bold('"Voxel"')..', which allegedly continued development under updated branding and newer builds. Although many stories surrounding the project were likely exaggerated, Project Ligma remains one of the '..bold('most well-known and mythologized private executors from the late FE and early Hyperion-era Roblox exploiting scene')..'.'

    TextLabel_2.TextColor3 = Color3.fromRGB(118, 118, 118)
    TextLabel_2.TextSize = 14
    TextLabel_2.TextWrapped = true
    TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel_2.TextYAlignment = Enum.TextYAlignment.Top

    local CreditLabel = Instance.new("TextLabel")
    CreditLabel.Name = "CreditLabel"
    CreditLabel.Parent = Frame
    CreditLabel.BackgroundTransparency = 1
    CreditLabel.Position = UDim2.new(0.057, 0, 0.94, 0)
    CreditLabel.Size = UDim2.new(0, 369, 0, 16)
    CreditLabel.Font = Enum.Font.Arial
    CreditLabel.Text = "Credits: Squrri (@evohibit), chira (@chiraphase), King (@ima_lost_child) on discord"
    CreditLabel.TextColor3 = Color3.fromRGB(145,145,145)
    CreditLabel.TextSize = 10
    CreditLabel.TextWrapped = true
    CreditLabel.TextYAlignment = Enum.TextYAlignment.Top

    local ReadAloud = Instance.new("TextButton")
    ReadAloud.Parent = Frame
    ReadAloud.BackgroundColor3 = Color3.fromRGB(244,244,244)
    ReadAloud.BorderSizePixel = 1
    ReadAloud.BorderColor3 = Color3.fromRGB(150,150,150)
    ReadAloud.Position = UDim2.new(0.057, 0, 0.82, 0)
    ReadAloud.Size = UDim2.new(0, 100, 0, 24)
    ReadAloud.Font = Enum.Font.Arial
    ReadAloud.Text = "Read Aloud"
    ReadAloud.TextColor3 = Color3.fromRGB(10,10,10)
    ReadAloud.TextSize = 14

    AddSounds(ReadAloud)
    createinteractivefeature(ReadAloud)

    local canClick = true
    local reading = false
    ReadAloud.MouseButton1Click:Connect(function()
        if reading then
            if shared.speech then
                shared.speech:Stop()
            end
            canClick = true
            reading = false
            ReadAloud.Text = 'Read Aloud'
            return
        end
        if not canClick then return end
        canClick = false
        ReadAloud.Text = 'Please Wait...'
        writefile('ligma/ProjectLigmaInfo.mp3', game:HttpGet('https://github.com/Phemeti/Project-Ligma-Recreation/raw/refs/heads/main/ProjectLigmaInfo.mp3'))
        local Speech = Ligma:AddSound({
            Id = getcustomasset('ligma/ProjectLigmaInfo.mp3'),
            Volume = 2
        })
        shared.speech = Speech
        ReadAloud.Text = 'Stop reading'
        Speech:Play()
        reading = true
    end)

    local gridPlace = 1

    local Info = Instance.new("ImageButton")
    Info.Parent = Main
    Info.BackgroundTransparency = 1
    Info.ImageTransparency = 0.01
    Info.BorderSizePixel = 0
    Info.Position = UDim2.new(
        0,
        30 + 5 * gridPlace,
        0,
        282.5
    )
    -- Js's Duels on top son
    --  - PMR
    Info.Size = UDim2.new(0, 25, 0, 25)
    Info.Image = "rbxassetid://4562954602"
    Info.ImageColor3 = Color3.fromRGB(0, 0, 0)

    AddSounds(Info)

    Info.MouseButton1Down:Connect(function()
        Frame.Visible = not Frame.Visible
    end)
end

do -- Hub GUI
    local Hub = AddSideButton("HUB", 11)

    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local Objects = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local TextBox = Instance.new("TextBox")
    local UICorner = Instance.new("UICorner")
    local UIPadding_2 = Instance.new("UIPadding")

    shared.HubFrame = Frame
    
    Frame.Parent = ScreenGui
    Frame.Visible = false
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    Frame.BorderColor3 = Color3.fromRGB(175, 175, 175)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 562, 0, 291)

    addClose(Frame)
    
    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Position = UDim2.new(0.349111974, 0, 0.0306642931, 0)
    TextLabel.Size = UDim2.new(0, 170, 0, 21)
    TextLabel.Font = Enum.Font.Arial
    TextLabel.Text = "Hub"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextScaled = true
    TextLabel.TextSize = 14.000
    TextLabel.TextWrapped = true
    
    Objects.Name = "Objects"
    Objects.Parent = Frame
    Objects.Active = true
    Objects.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Objects.BackgroundTransparency = 1.000
    Objects.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Objects.BorderSizePixel = 0
    Objects.Position = UDim2.new(0.0180000495, 0, 0.256387204, 0)
    Objects.Size = UDim2.new(0, 544, 0, 209)
    Objects.ScrollBarThickness = 10    
    
    UIListLayout.Parent = Objects
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Padding = UDim.new(0, 15)

    local function UpdateCanvas()
        Objects.CanvasSize = UDim2.new(
            0,
            UIListLayout.AbsoluteContentSize.X + 20,
            0,
            0
        )
    end
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
    UpdateCanvas()
    
    UIPadding.Parent = Objects
    UIPadding.PaddingBottom = UDim.new(0, 1)
    UIPadding.PaddingLeft = UDim.new(0, 1)
    UIPadding.PaddingRight = UDim.new(0, 1)
    UIPadding.PaddingTop = UDim.new(0, 1)
    
    TextBox.Parent = Frame
    TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextBox.BackgroundTransparency = 0.500
    TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextBox.BorderSizePixel = 0
    TextBox.Position = UDim2.new(0.0177935939, 0, 0.126884222, 0)
    TextBox.Size = UDim2.new(0, 397, 0, 32)
    TextBox.ClearTextOnFocus = false
    TextBox.Font = Enum.Font.Arial
    TextBox.PlaceholderText = "Search..."
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextScaled = true
    TextBox.TextSize = 14.000
    TextBox.TextWrapped = true

    local Fetch = Instance.new("TextButton")

    Fetch.Name = "Fetch"
    Fetch.Parent = Frame
    Fetch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Fetch.BorderColor3 = Color3.fromRGB(147, 147, 147)
    Fetch.Position = UDim2.new(0.740213513, 0, 0.12371134, 0)
    Fetch.Size = UDim2.new(0, 134, 0, 32)
    Fetch.Font = Enum.Font.Arial
    Fetch.Text = "Fetch"
    Fetch.TextColor3 = Color3.fromRGB(0, 0, 0)
    Fetch.TextSize = 20.000
    
    UICorner.CornerRadius = UDim.new(0, 3)
    UICorner.Parent = TextBox
    
    UIPadding_2.Parent = TextBox
    UIPadding_2.PaddingBottom = UDim.new(0, 7)
    UIPadding_2.PaddingLeft = UDim.new(0, 7)
    UIPadding_2.PaddingRight = UDim.new(0, 7)
    UIPadding_2.PaddingTop = UDim.new(0, 7)

    local STATUS = Instance.new("TextLabel")
    local UIPadding = Instance.new("UIPadding")
    
    STATUS.Name = "STATUS"
    STATUS.Parent = Frame
    STATUS.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    STATUS.BackgroundTransparency = 1.000
    STATUS.BorderColor3 = Color3.fromRGB(0, 0, 0)
    STATUS.BorderSizePixel = 0
    STATUS.Size = UDim2.new(1, 0, 1, 0)
    STATUS.ZIndex = 656
    STATUS.Font = Enum.Font.Arial
    STATUS.RichText = true
    STATUS.Text = 'Welcome to the <b>Script Hub.</b>\nSearch up any script across ScriptBlox.'
    STATUS.TextColor3 = Color3.fromRGB(122, 122, 122)
    STATUS.TextSize = 25.000
    STATUS.TextStrokeTransparency = 0.000
    STATUS.TextTransparency = 0.400
    STATUS.TextYAlignment = Enum.TextYAlignment.Bottom
    
    UIPadding.Parent = STATUS
    UIPadding.PaddingBottom = UDim.new(0, 30)

    local function Status(str)
        print(str)
        STATUS.Text = str
    end

    local noproblemscriptblox = Instance.new("TextLabel")
    noproblemscriptblox.Name = "noproblemscriptblox"
    noproblemscriptblox.Parent = Frame
    noproblemscriptblox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    noproblemscriptblox.BackgroundTransparency = 1.000
    noproblemscriptblox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    noproblemscriptblox.BorderSizePixel = 0
    noproblemscriptblox.Position = UDim2.new(0.0302491095, 0, 0.0444099978, 0)
    noproblemscriptblox.Size = UDim2.new(0, 190, 0, 13)
    noproblemscriptblox.Font = Enum.Font.Arial
    noproblemscriptblox.Text = "docs.scriptblox.com"
    noproblemscriptblox.TextColor3 = Color3.fromRGB(95, 95, 95)
    noproblemscriptblox.TextSize = 14.000
    noproblemscriptblox.TextXAlignment = Enum.TextXAlignment.Left

    noproblemscriptblox.MouseButton1Down:Connect(function()
        noproblemscriptblox.TextColor3 = Color3.fromRGB(
            168    +    35,
            114    +    35,
            255    +    35
        )
        setclipboard('https://docs.scriptblox.com/')
    end)

    noproblemscriptblox.MouseEnter:Connect(function()
        tweenService:Create(
            noproblemscriptblox,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {
                TextColor3 = Color3.fromRGB(168, 114, 255)
            }
        ):Play()
    end)

    noproblemscriptblox.MouseLeave:Connect(function()
        tweenService:Create(
            noproblemscriptblox,
            TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {
                TextColor3 = Color3.fromRGB(95, 95, 95)
            }
        ):Play()
    end)

    Hub.MouseButton1Down:Connect(function()
        Frame.Visible = not Frame.Visible
    end)

    local function Clear()
        for _, v in ipairs(Objects:GetChildren()) do
            if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                v:Destroy()
            end
        end
    end

    -- Credits to Roblox Thot for showing solara vulnerabilites :^)
    --[[
        https://www.youtube.com/watch?v=w4JfAjhinV0
        https://www.youtube.com/watch?v=hGZ0O_yjFFs
        https://www.youtube.com/watch?v=pMCsj2xV4IA
    ]]
    -- surely solara already fixed these vulnerabilites, meaning I no longer need that warning thing
    -- but, contrary to what I believe, I'll still keep it. who cares lol ¯\_(ツ)_/¯

    local function AddScript(data)
        local Script = Instance.new("ImageLabel")
        local UICorner = Instance.new("UICorner")
        local UIStroke = Instance.new("UIStroke")
        local Name = Instance.new("TextLabel")
        local UIGradient = Instance.new("UIGradient")
        local Copy = Instance.new("TextButton")
        local Run = Instance.new("TextButton")
        
        Script.Name = "Script"
        Script.Parent = Objects
        Script.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Script.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Script.BorderSizePixel = 0
        Script.Size = UDim2.new(0, 166, 0, 130)
        Script.Image = data.Image or "rbxassetid://6558374856"
        Script.ImageTransparency = 0.400
        
        UICorner.CornerRadius = UDim.new(0, 3)
        UICorner.Parent = Script
        
        UIStroke.Parent = Script
        UIStroke.Color = Color3.fromRGB(198, 198, 198)
        
        Name.Name = "Name"
        Name.Parent = Script
        Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Name.BackgroundTransparency = 1.000
        Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Name.BorderSizePixel = 0
        Name.Position = UDim2.new(0, 0, 0.0538461544, 0)
        Name.Size = UDim2.new(0, 166, 0, 22)
        Name.Font = Enum.Font.Arial
        Name.Text = data.Name or "Script Name"
        Name.TextColor3 = Color3.fromRGB(255, 255, 255)
        Name.TextScaled = true
        Name.TextSize = 14.000
        Name.TextStrokeTransparency = 0.000
        Name.TextWrapped = true
        
        UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(49, 49, 49))}
        UIGradient.Rotation = -90
        UIGradient.Parent = Script
        
        Copy.Name = "Copy"
        Copy.Parent = Script
        Copy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Copy.BackgroundTransparency = 0.500
        Copy.BorderColor3 = Color3.fromRGB(179, 179, 179)
        Copy.Position = UDim2.new(0.0421686731, 0, 0.77692306, 0)
        Copy.Size = UDim2.new(0, 71, 0, 23)
        Copy.Font = Enum.Font.Arial
        Copy.Text = "Copy Script"
        Copy.TextColor3 = Color3.fromRGB(0, 0, 0)
        Copy.TextSize = 12.000
        createinteractivefeature(Copy)
        
        Run.Name = "Run"
        Run.Parent = Script
        Run.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Run.BackgroundTransparency = 0.500
        Run.BorderColor3 = Color3.fromRGB(179, 179, 179)
        Run.Position = UDim2.new(0.52409637, 0, 0.77692306, 0)
        Run.Size = UDim2.new(0, 71, 0, 23)
        Run.Font = Enum.Font.Arial
        Run.Text = "Run Script"
        Run.TextColor3 = Color3.fromRGB(0, 0, 0) 
        Run.TextSize = 12.000
        createinteractivefeature(Run)

        local ranSoTrusted = false

        Copy.MouseButton1Down:Connect(function()
            if data.Verified then
                setclipboard(tostring(data.Script))
            else
                setclipboard('--[[ This code is not verified by Scriptblox! Run with caution as script may contain malware by abusing exploit vulnerabilites. ]]\n'..tostring(data.Script))
            end
        end)

        Run.MouseButton1Down:Connect(function()
            if not data.Verified and not ranSoTrusted and readfile('ligma/config/IgnoreScriptwarning') == 'true' then
                local MainFrame = Instance.new("Frame")
                local ScriptTitle = Instance.new("TextLabel")
                local lol = Instance.new("TextLabel")
                local Run = Instance.new("TextButton")
                local Close = Instance.new("TextButton")
                
                MainFrame.Name = "MainFrame"
                MainFrame.Parent = ScreenGui
                MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                MainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
                MainFrame.BorderColor3 = Color3.fromRGB(175, 175, 175)
                MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                MainFrame.Size = UDim2.new(0, 332, 0, 228)

                addClose(MainFrame)
                
                ScriptTitle.Name = "ScriptTitle"
                ScriptTitle.Parent = MainFrame
                ScriptTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ScriptTitle.BackgroundTransparency = 1.000
                ScriptTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ScriptTitle.BorderSizePixel = 0
                ScriptTitle.Position = UDim2.new(0.036144577, 0, 0.0701754391, 0)
                ScriptTitle.Size = UDim2.new(0, 307, 0, 25)
                ScriptTitle.Font = Enum.Font.Arial
                ScriptTitle.Text = "Run script: "..data.Name.."?"
                ScriptTitle.TextColor3 = Color3.fromRGB(253, 253, 253)
                ScriptTitle.TextScaled = true
                ScriptTitle.TextSize = 14.000
                ScriptTitle.TextWrapped = true
                
                lol.Name = "lol"
                lol.Parent = MainFrame
                lol.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                lol.BackgroundTransparency = 1.000
                lol.BorderColor3 = Color3.fromRGB(0, 0, 0)
                lol.BorderSizePixel = 0
                lol.Position = UDim2.new(0.036144577, 0, 0.210526317, 0)
                lol.Size = UDim2.new(0, 307, 0, 88)
                lol.Font = Enum.Font.Arial
                lol.RichText = true
                lol.Text = "This script may contain malware by abusing exploit vulnerabilities, or steal your account info.\n\n<font size='11' color='rgb(75, 75, 75)'>Source: Reddit and YouTube have shown that exploits like Solara have been prone to many vulnerabilites, letting users run windows programs. Some channels, many of which are \"Roblox Thot\" shown a screen melter using Solara.</font>"
                lol.TextColor3 = Color3.fromRGB(129, 129, 129)
                lol.TextSize = 17.000
                lol.TextWrapped = true
                lol.TextYAlignment = Enum.TextYAlignment.Top
                
                Run.Name = "Run"
                Run.Parent = MainFrame
                Run.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Run.BorderColor3 = Color3.fromRGB(150, 150, 150)
                Run.Position = UDim2.new(0.0451807231, 0, 0.758771837, 0)
                Run.Size = UDim2.new(0, 146, 0, 34)
                Run.Font = Enum.Font.Arial
                Run.Text = "Run"
                Run.TextColor3 = Color3.fromRGB(0, 0, 0)
                Run.TextSize = 20.000
                
                createinteractivefeature(Run)
                
                Close.Name = "Close"
                Close.Parent = MainFrame
                Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Close.BorderColor3 = Color3.fromRGB(150, 150, 150)
                Close.Position = UDim2.new(0.512048185, 0, 0.758771837, 0)
                Close.Size = UDim2.new(0, 146, 0, 34)
                Close.Font = Enum.Font.Arial
                Close.Text = "Close"
                Close.TextColor3 = Color3.fromRGB(0, 0, 0)
                Close.TextSize = 20.000

                createinteractivefeature(Close)

                Close.MouseButton1Down:Connect(function()
                    MainFrame:Destroy()
                end)

                Run.MouseButton1Down:Connect(function()
                    MainFrame:Destroy()
                    loadstring(tostring(data.Script))()
                    ranSoTrusted = true
                end)

                draggable(MainFrame)
            else
                loadstring(tostring(data.Script))()
            end
        end)
    end

    --[[
        {
            "result": {
                "totalPages": number,
                "nextPage": number,
                "max": number,
                "scripts": [
                    {
                        "_id": "string",
                        "title": "string",
                        "game": {
                            "_id": "string",
                            "name": "string",
                            "imageUrl": "string"
                        },
                        "slug": "string",
                        "verified": boolean,
                        "key": boolean,
                        "views": number,
                        "scriptType": "string",
                        "isUniversal": boolean,
                        "isPatched": boolean,
                        "image": "string",
                        "createdAt": "string",
                        "script": "string"
                    },
                    ...
                ]
            }
        }        
    ]]

    local canFetch = true
    local function FetchScripts(search)
        if not canFetch then
            return
        end
        canFetch = true
        Clear()
        Status("Fetching Scripts... Please Wait.")
        local suc, data = pcall(function()
            local url
            if search ~= nil and search ~= "" then
                url = "https://scriptblox.com/api/script/search?q="..http:UrlEncode(search)
            else
                url = "https://scriptblox.com/api/script/fetch"
            end
            local response = game:HttpGet(url)
            return http:JSONDecode(response)
        end)
        if not suc then
            Status(tostring(data))
            canFetch = true
            return
        end
        if not data or not data.result or not data.result.scripts or #data.result.scripts <= 0 then
            Status("No Available Scripts...")
            canFetch = true
            return
        end
    
        Status("Results for: "..tostring(search)..' (may take a while...)')
    
        for _, script in ipairs(data.result.scripts) do
            local imageUrl = tostring(script.image or "")
            local cachedFile
            for _, file in ipairs(listfiles('ligma/.cache')) do
                local suc, contents = pcall(readfile, file)
                if suc and contents == game:HttpGet("https://scriptblox.com"..imageUrl) then
                    cachedFile = file
                    break
                end
            end
            if not cachedFile then
                local fileName = tostring(math.random(1000, 1000000))..".png"
                cachedFile = 'ligma/.cache'.."/"..fileName
                writefile(cachedFile, game:HttpGet("https://scriptblox.com"..imageUrl))
            end
            AddScript({
                Image = getcustomasset(cachedFile) or 'rbxassetid://16202377195',
                Name = script.title or "Unknown",
                Script = script.script or "-- no script",
                Verified = script.verified or false
            })
        end
    
        task.wait(0.05)
    
        Status("")
        canFetch = true
    end

    Fetch.MouseButton1Down:Connect(function()
        FetchScripts(tostring(TextBox.Text))
    end)

end

draggable(shared.HubFrame)
