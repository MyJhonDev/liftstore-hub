--[[
    D&M Imperial — Muscle Legends
    UI: Fluent-Renewed + SaveManager + InterfaceManager
    Autor original: marmortabw
    Recriado com Fluent-Renewed, apenas features essenciais
]]

local KEY_VALIDATE_URL = "https://SEU-DOMINIO.com/api/validate"
local KEY_GUILD_ID = "SEU_GUILD_ID_AQUI"
local KEY_DISCORD_INVITE = "https://discord.gg/SEUINVITE"
local KEY_SAVE_FILE = "dm_imperial_key.txt"

local HttpService = game:GetService("HttpService")

local function httpGet(url)
    local ok, result = pcall(function()
        if syn and syn.request then
            local res = syn.request({ Url = url, Method = "GET" })
            return res.Body
        elseif http_request then
            local res = http_request({ Url = url, Method = "GET" })
            return res.Body
        elseif request then
            local res = request({ Url = url, Method = "GET" })
            return res.Body
        else
            return game:HttpGet(url)
        end
    end)
    if ok then return result end
    return nil
end

local function readSavedKey()
    local ok, value = pcall(function()
        if isfile and isfile(KEY_SAVE_FILE) then
            return readfile(KEY_SAVE_FILE)
        end
        return nil
    end)
    if ok then return value end
    return nil
end

local function saveKey(keyValue)
    pcall(function()
        if writefile then
            writefile(KEY_SAVE_FILE, keyValue)
        end
    end)
end

local function validateKey(keyValue)
    if not keyValue or keyValue == "" then
        return false, "empty"
    end
    local url = KEY_VALIDATE_URL .. "?key=" .. HttpService:UrlEncode(keyValue) .. "&guildId=" .. HttpService:UrlEncode(KEY_GUILD_ID)
    local body = httpGet(url)
    if not body then
        return false, "network_error"
    end
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not ok or not decoded then
        return false, "invalid_response"
    end
    if decoded.valid then
        return true, nil
    end
    return false, decoded.reason or "invalid"
end

local KeyValidated = false

local savedKey = readSavedKey()
if savedKey then
    local ok = validateKey(savedKey)
    if ok then
        KeyValidated = true
    end
end

if not KeyValidated then
    local player = game:GetService("Players").LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DMImperialKeyGate"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 220)
    Frame.Position = UDim2.new(0.5, -160, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "D&M Imperial — Insira sua key"
    Title.TextColor3 = Color3.fromRGB(201, 162, 75)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local InviteLabel = Instance.new("TextButton")
    InviteLabel.Size = UDim2.new(1, -20, 0, 20)
    InviteLabel.Position = UDim2.new(0, 10, 0, 44)
    InviteLabel.BackgroundTransparency = 1
    InviteLabel.Text = "Não tem uma key? Clique aqui: " .. KEY_DISCORD_INVITE
    InviteLabel.TextColor3 = Color3.fromRGB(156, 163, 175)
    InviteLabel.Font = Enum.Font.Gotham
    InviteLabel.TextSize = 12
    InviteLabel.TextXAlignment = Enum.TextXAlignment.Left
    InviteLabel.Parent = Frame
    InviteLabel.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(KEY_DISCORD_INVITE)
        end)
    end)

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -20, 0, 36)
    KeyBox.Position = UDim2.new(0, 10, 0, 76)
    KeyBox.BackgroundColor3 = Color3.fromRGB(26, 26, 29)
    KeyBox.TextColor3 = Color3.fromRGB(245, 245, 240)
    KeyBox.PlaceholderText = "Cole sua key aqui"
    KeyBox.PlaceholderColor3 = Color3.fromRGB(107, 114, 128)
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 14
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = Frame

    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 6)
    KeyBoxCorner.Parent = KeyBox

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 20)
    StatusLabel.Position = UDim2.new(0, 10, 0, 118)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 12
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextWrapped = true
    StatusLabel.Parent = Frame

    local ValidateButton = Instance.new("TextButton")
    ValidateButton.Size = UDim2.new(1, -20, 0, 36)
    ValidateButton.Position = UDim2.new(0, 10, 0, 164)
    ValidateButton.BackgroundColor3 = Color3.fromRGB(201, 162, 75)
    ValidateButton.Text = "Validar"
    ValidateButton.TextColor3 = Color3.fromRGB(11, 11, 12)
    ValidateButton.Font = Enum.Font.GothamBold
    ValidateButton.TextSize = 14
    ValidateButton.Parent = Frame

    local ValidateButtonCorner = Instance.new("UICorner")
    ValidateButtonCorner.CornerRadius = UDim.new(0, 6)
    ValidateButtonCorner.Parent = ValidateButton

    ValidateButton.MouseButton1Click:Connect(function()
        local inputKey = KeyBox.Text
        StatusLabel.Text = "Validando..."
        StatusLabel.TextColor3 = Color3.fromRGB(156, 163, 175)

        local valid, reason = validateKey(inputKey)
        if valid then
            saveKey(inputKey)
            KeyValidated = true
            ScreenGui:Destroy()
        else
            local messages = {
                empty = "Digite uma key.",
                not_found = "Key inválida.",
                expired = "Sua key expirou.",
                revoked = "Sua key foi revogada.",
                network_error = "Falha ao conectar no servidor de validação.",
                invalid_response = "Resposta inválida do servidor.",
            }
            StatusLabel.Text = messages[reason] or "Key inválida."
            StatusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
        end
    end)

    while not KeyValidated do
        task.wait(0.25)
    end
end

-- ============================
-- LIBRARIES
-- ============================
local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

-- ============================
-- SERVICES
-- ============================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local Options = Library.Options

-- ============================
-- HELPER FUNCTIONS
-- ============================

local function getCharacter()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        return char
    end
    return nil
end

local function notify(title, text, duration)
    pcall(function()
        Library:Notify{
            Title = title or "D&M",
            Content = text or "",
            Duration = duration or 3
        }
    end)
end

local function pressE()
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

local function equipPunch()
    local char = getCharacter()
    if not char then return end
    if char:FindFirstChild("Punch") then return end
    local backpack = player.Backpack
    if not backpack then return end
    for _, tool in pairs(backpack:GetChildren()) do
        if tool.ClassName == "Tool" and tool.Name == "Punch" then
            pcall(function() char.Humanoid:EquipTool(tool) end)
            return
        end
    end
end

local function equipTool(toolName)
    local char = getCharacter()
    if not char or not char:FindFirstChild("Humanoid") then return end
    if char:FindFirstChild(toolName) then return end
    local tool = player.Backpack:FindFirstChild(toolName)
    if tool then
        pcall(function() char.Humanoid:EquipTool(tool) end)
    end
end

local function unequipTool(toolName)
    local char = getCharacter()
    if not char then return end
    local equipped = char:FindFirstChild(toolName)
    if equipped then
        equipped.Parent = player.Backpack
    end
end

local function formatNumber(n)
    n = n or 0
    if n >= 1e15 then return string.format("%.2fQ", n / 1e15)
    elseif n >= 1e12 then return string.format("%.2fT", n / 1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n / 1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n / 1e3)
    end
    return tostring(math.floor(n))
end

local function formatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    if days > 0 then
        return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, secs)
    end
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- ============================
-- ANTI-AFK
-- ============================
local antiAFKConnection

local function setupAntiAFK()
    if antiAFKConnection then antiAFKConnection:Disconnect() end
    antiAFKConnection = player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
setupAntiAFK()

-- ============================
-- DATA TABLES
-- ============================
local rockThresholds = {
    ["Tiny Rock"]        = 0,
    ["Starter Rock"]     = 100,
    ["Legend Beach Rock"] = 5000,
    ["Frozen Rock"]      = 150000,
    ["Mythical Rock"]    = 400000,
    ["Eternal Rock"]     = 750000,
    ["Legend Rock"]      = 1000000,
    ["Muscle King Rock"] = 5000000,
    ["Jungle Rock"]      = 10000000
}

local teleportLocations = {
    {"Spawn",            CFrame.new(2, 8, 115)},
    {"Secret Area",      CFrame.new(1947, 2, 6191)},
    {"Tiny Island",      CFrame.new(-34, 7, 1903)},
    {"Frozen",           CFrame.new(-2600, 3.68, -404)},
    {"Mythical",         CFrame.new(2255, 7, 1071)},
    {"Inferno",          CFrame.new(-6768, 7, -1287)},
    {"Legend",           CFrame.new(4604, 991, -3887)},
    {"Muscle King Gym",  CFrame.new(-8646, 17, -5738)},
    {"Jungle",           CFrame.new(-8659, 6, 2384)},
    {"Brawl Lava",       CFrame.new(4471, 119, -8836)},
    {"Brawl Desert",     CFrame.new(960, 17, -7398)},
    {"Brawl Regular",    CFrame.new(-1849, 20, -6335)},
}

-- ============================
-- WINDOW
-- ============================
local Window = Library:CreateWindow{
    Title = "D&M Imperial",
    SubTitle = "Muscle Legends",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
}

-- Tabs
local Tabs = {
    Farm     = Window:CreateTab{Title = "Farm",     Icon = "phosphor-dumbbell-bold"},
    Teleport = Window:CreateTab{Title = "Teleport", Icon = "phosphor-map-pin-bold"},
    Misc     = Window:CreateTab{Title = "Misc",     Icon = "phosphor-gear-six-bold"},
    Settings = Window:CreateTab{Title = "Settings", Icon = "settings"},
}

-- ═══════════════════════════════════════════
-- FARM TAB
-- ═══════════════════════════════════════════

-- -- Auto Rock Section --
local RockSection = Tabs.Farm:Section("Auto Rock")

RockSection:CreateDropdown("RockType", {
    Title = "Select Rock",
    Values = {
        "Tiny Rock", "Starter Rock", "Legend Beach Rock",
        "Frozen Rock", "Mythical Rock", "Eternal Rock",
        "Legend Rock", "Muscle King Rock", "Jungle Rock"
    },
    Multi = false,
    Default = 1,
})

local AutoRockToggle = RockSection:CreateToggle("AutoRock", {Title = "Auto Rock", Default = false})
AutoRockToggle:OnChanged(function()
    local Value = Options.AutoRock.Value
    getgenv().autoFarm = Value
    if Value then
        task.spawn(function()
            while getgenv().autoFarm do
                task.wait()
                if not getgenv().autoFarm then break end

                local selected = Options.RockType.Value
                local threshold = rockThresholds[selected]
                if not threshold then break end

                if player.Durability.Value >= threshold then
                    local char = getCharacter()
                    if not char then continue end

                    for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
                        if not getgenv().autoFarm then break end
                        if v.Name == "neededDurability" and v.Value == threshold then
                            local rock = v.Parent:FindFirstChild("Rock")
                            local lh = char:FindFirstChild("LeftHand")
                            local rh = char:FindFirstChild("RightHand")
                            if rock and lh and rh then
                                pcall(function()
                                    firetouchinterest(rock, rh, 0)
                                    firetouchinterest(rock, rh, 1)
                                    firetouchinterest(rock, lh, 0)
                                    firetouchinterest(rock, lh, 1)
                                end)
                                equipPunch()
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- -- Auto Tools Section --
local ToolsSection = Tabs.Farm:Section("Auto Tools")

for _, toolName in ipairs({"Weight", "Pushups", "Handstands", "Situps"}) do
    local key = "Auto" .. toolName
    local toggle = ToolsSection:CreateToggle(key, {Title = "Auto " .. toolName, Default = false})
    toggle:OnChanged(function()
        local Value = Options[key].Value
        getgenv()[key] = Value
        if Value then
            equipTool(toolName)
            task.spawn(function()
                while getgenv()[key] do
                    pcall(function()
                        player.muscleEvent:FireServer("rep")
                    end)
                    task.wait(0.1)
                end
            end)
        else
            unequipTool(toolName)
        end
    end)
end

local AutoPunchToggle = ToolsSection:CreateToggle("AutoPunch", {Title = "Auto Punch", Default = false})
AutoPunchToggle:OnChanged(function()
    local Value = Options.AutoPunch.Value
    getgenv().autoPunch = Value
    if Value then
        task.spawn(function()
            while getgenv().autoPunch do
                pcall(function()
                    equipPunch()
                    player.muscleEvent:FireServer("punch", "rightHand")
                    player.muscleEvent:FireServer("punch", "leftHand")
                    local char = getCharacter()
                    if char then
                        local p = char:FindFirstChild("Punch")
                        if p then p:Activate() end
                    end
                end)
                task.wait(0.05)
            end
        end)
    else
        unequipTool("Punch")
    end
end)

-- -- Fast Tools --
local FastSection = Tabs.Farm:Section("Fast Tools")

local FastToolsToggle = FastSection:CreateToggle("FastTools", {Title = "Fast Tools", Default = false})
FastToolsToggle:OnChanged(function()
    local Value = Options.FastTools.Value
    getgenv().fastTools = Value
    local toolSpeeds = {
        {"Punch",       "attackTime", Value and 0 or 0.35},
        {"Ground Slam", "attackTime", Value and 0 or 6},
        {"Stomp",       "attackTime", Value and 0 or 7},
        {"Handstands",  "repTime",    Value and 0 or 1},
        {"Pushups",     "repTime",    Value and 0 or 1},
        {"Weight",      "repTime",    Value and 0 or 1},
        {"Situps",      "repTime",    Value and 0 or 1},
    }
    for _, info in ipairs(toolSpeeds) do
        pcall(function()
            local tool = player.Backpack:FindFirstChild(info[1])
            if tool and tool:FindFirstChild(info[2]) then
                tool[info[2]].Value = info[3]
            end
            local char = getCharacter()
            if char then
                local eq = char:FindFirstChild(info[1])
                if eq and eq:FindFirstChild(info[2]) then
                    eq[info[2]].Value = info[3]
                end
            end
        end)
    end
end)

-- -- Auto Rebirth Section --
local RebirthSection = Tabs.Farm:Section("Auto Rebirth")

local InfiniteRebirthToggle = RebirthSection:CreateToggle("InfiniteRebirth", {Title = "Auto Rebirth (Infinite)", Default = false})
InfiniteRebirthToggle:OnChanged(function()
    local Value = Options.InfiniteRebirth.Value
    getgenv().infiniteRebirth = Value
    if Value then
        Options.TargetRebirth:SetValue(false)
        task.spawn(function()
            while getgenv().infiniteRebirth do
                pcall(function()
                    ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
                task.wait(0.1)
            end
        end)
    end
end)

RebirthSection:CreateInput("TargetRebirthInput", {
    Title = "Rebirth Target",
    Default = "",
    Placeholder = "Numero de rebirths alvo...",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        getgenv().targetRebirthValue = tonumber(Value) or 0
    end
})

local TargetRebirthToggle = RebirthSection:CreateToggle("TargetRebirth", {Title = "Auto Rebirth (Target)", Default = false})
TargetRebirthToggle:OnChanged(function()
    local Value = Options.TargetRebirth.Value
    getgenv().targetRebirthActive = Value
    if Value then
        Options.InfiniteRebirth:SetValue(false)
        task.spawn(function()
            while getgenv().targetRebirthActive do
                local current = 0
                pcall(function() current = player.leaderstats.Rebirths.Value end)
                local target = getgenv().targetRebirthValue or 0
                if target > 0 and current >= target then
                    getgenv().targetRebirthActive = false
                    Options.TargetRebirth:SetValue(false)
                    notify("Objetivo Alcanzado!", "Llegaste a " .. tostring(target) .. " renacimientos")
                    break
                end
                pcall(function()
                    ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
                task.wait(0.1)
            end
        end)
    end
end)

local AutoSizeToggle = RebirthSection:CreateToggle("AutoSize", {Title = "Auto Size 1", Default = false})
AutoSizeToggle:OnChanged(function()
    local Value = Options.AutoSize.Value
    getgenv().autoSize = Value
    if Value then
        task.spawn(function()
            while getgenv().autoSize do
                pcall(function()
                    ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
                end)
                task.wait(1)
            end
        end)
    end
end)

-- -- Auto Brawls Section --
local BrawlsSection = Tabs.Farm:Section("Auto Brawls")

local AutoJoinToggle = BrawlsSection:CreateToggle("AutoJoinBrawl", {Title = "Auto Join Brawl", Default = false})
AutoJoinToggle:OnChanged(function()
    local Value = Options.AutoJoinBrawl.Value
    getgenv().autoJoinBrawl = Value
    if Value then
        task.spawn(function()
            while getgenv().autoJoinBrawl do
                pcall(function()
                    if player.PlayerGui.gameGui.brawlJoinLabel.Visible then
                        ReplicatedStorage.rEvents.brawlEvent:FireServer("joinBrawl")
                        player.PlayerGui.gameGui.brawlJoinLabel.Visible = false
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)

local AutoWinToggle = BrawlsSection:CreateToggle("AutoWinBrawl", {Title = "Auto Win Brawl", Default = false})
AutoWinToggle:OnChanged(function()
    local Value = Options.AutoWinBrawl.Value
    getgenv().autoWinBrawl = Value
    if Value then
        -- Loop 1: Join + Equip
        task.spawn(function()
            while getgenv().autoWinBrawl do
                pcall(function()
                    if player.PlayerGui.gameGui.brawlJoinLabel.Visible then
                        ReplicatedStorage.rEvents.brawlEvent:FireServer("joinBrawl")
                        player.PlayerGui.gameGui.brawlJoinLabel.Visible = false
                    end
                end)
                equipPunch()
                task.wait(0.5)
            end
        end)
        -- Loop 2: Punch + Kill
        task.spawn(function()
            while getgenv().autoWinBrawl do
                local char = getCharacter()
                if not char then task.wait(0.05) continue end

                local lh = char:FindFirstChild("LeftHand")
                local rh = char:FindFirstChild("RightHand")
                if not lh and not rh then task.wait(0.05) continue end

                local inBrawl = false
                pcall(function() inBrawl = ReplicatedStorage.brawlInProgress.Value end)
                if not inBrawl then task.wait(0.1) continue end

                pcall(function()
                    player.muscleEvent:FireServer("punch", "rightHand")
                    player.muscleEvent:FireServer("punch", "leftHand")
                end)

                for _, plr in pairs(Players:GetPlayers()) do
                    if not getgenv().autoWinBrawl then break end
                    pcall(function()
                        if plr ~= player
                            and plr.Character
                            and plr.Character:FindFirstChild("HumanoidRootPart")
                            and plr.Character:FindFirstChild("Humanoid")
                            and plr.Character.Humanoid.Health > 0
                        then
                            local target = plr.Character.HumanoidRootPart
                            if rh then
                                firetouchinterest(target, rh, 0)
                                task.wait(0.01)
                                firetouchinterest(target, rh, 1)
                            end
                            if lh then
                                firetouchinterest(target, lh, 0)
                                task.wait(0.01)
                                firetouchinterest(target, lh, 1)
                            end
                        end
                    end)
                    task.wait(0.01)
                end
                task.wait(0.05)
            end
        end)
    end
end)

-- ═══════════════════════════════════════════
-- TELEPORT TAB
-- ═══════════════════════════════════════════
local TeleSection = Tabs.Teleport:Section("Locations")

for _, loc in ipairs(teleportLocations) do
    local name, cframe = loc[1], loc[2]
    TeleSection:CreateButton{
        Title = name,
        Description = "Teleport to " .. name,
        Callback = function()
            local char = getCharacter()
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = cframe
                notify("Teleport", "Teletransportado a " .. name)
            end
        end
    }
end

-- ═══════════════════════════════════════════
-- MISC TAB
-- ═══════════════════════════════════════════

-- -- Movement --
local MoveSection = Tabs.Misc:Section("Movement")

-- No-Clip
getgenv().noClip = false
RunService.Stepped:Connect(function()
    if getgenv().noClip then
        local char = getCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

local NoClipToggle = MoveSection:CreateToggle("NoClip", {Title = "No-Clip", Default = false})
NoClipToggle:OnChanged(function()
    getgenv().noClip = Options.NoClip.Value
end)

-- Infinite Jump
getgenv().infiniteJump = false
UserInputService.JumpRequest:Connect(function()
    if getgenv().infiniteJump then
        local char = getCharacter()
        if char and char:FindFirstChildOfClass("Humanoid") then
            pcall(function()
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end
end)

local InfJumpToggle = MoveSection:CreateToggle("InfiniteJump", {Title = "Infinite Jump", Default = false})
InfJumpToggle:OnChanged(function()
    getgenv().infiniteJump = Options.InfiniteJump.Value
end)

-- Change Time
MoveSection:CreateDropdown("ChangeTime", {
    Title = "Change Time",
    Values = {"Night", "Day", "Midnight"},
    Multi = false,
    Default = 1,
    Callback = function(Value)
        pcall(function()
            local lighting = game:GetService("Lighting")
            if Value == "Night" then
                lighting.ClockTime = 0
            elseif Value == "Day" then
                lighting.ClockTime = 12
            elseif Value == "Midnight" then
                lighting.ClockTime = 6
            end
        end)
    end
})

-- -- Utility --
local UtilSection = Tabs.Misc:Section("Utility")

local AntiAFKToggle = UtilSection:CreateToggle("AntiAFK", {Title = "Anti-AFK", Default = true})
AntiAFKToggle:OnChanged(function()
    local Value = Options.AntiAFK.Value
    if Value then
        setupAntiAFK()
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
    end
end)

local AutoSpinToggle = UtilSection:CreateToggle("AutoSpinWheel", {Title = "Auto Spin Wheel", Default = false})
AutoSpinToggle:OnChanged(function()
    local Value = Options.AutoSpinWheel.Value
    getgenv().autoSpinWheel = Value
    if Value then
        task.spawn(function()
            while getgenv().autoSpinWheel do
                pcall(function()
                    ReplicatedStorage.rEvents.openFortuneWheelRemote:InvokeServer(
                        "openFortuneWheel",
                        ReplicatedStorage.fortuneWheelChances["Fortune Wheel"]
                    )
                end)
                task.wait(1)
            end
        end)
    end
end)

local AutoGiftsToggle = UtilSection:CreateToggle("AutoClaimGifts", {Title = "Auto Claim Gifts", Default = false})
AutoGiftsToggle:OnChanged(function()
    local Value = Options.AutoClaimGifts.Value
    getgenv().autoClaimGifts = Value
    if Value then
        task.spawn(function()
            while getgenv().autoClaimGifts do
                pcall(function()
                    for i = 1, 8 do
                        ReplicatedStorage.rEvents.freeGiftClaimRemote:InvokeServer("claimGift", i)
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

UtilSection:CreateButton{
    Title = "Remove Portals",
    Description = "Remove Roblox ad portals",
    Callback = function()
        pcall(function()
            for _, portal in pairs(game:GetDescendants()) do
                if portal.Name == "RobloxForwardPortals" then
                    portal:Destroy()
                end
            end
            if _G.AdRemovalConn then _G.AdRemovalConn:Disconnect() end
            _G.AdRemovalConn = game.DescendantAdded:Connect(function(d)
                if d.Name == "RobloxForwardPortals" then d:Destroy() end
            end)
            notify("Portais", "Anuncios de Roblox eliminados")
        end)
    end
}

-- -- Session Stats --
local StatsSection = Tabs.Misc:Section("Session Stats")

local sessionStart = {
    Strength  = 0,
    Durability = 0,
    Rebirths  = 0,
    Kills     = 0,
    Brawls    = 0,
    Time      = os.time()
}

local function initStats()
    pcall(function()
        sessionStart.Strength  = player.leaderstats.Strength.Value
        sessionStart.Durability = player.Durability.Value
        sessionStart.Rebirths  = player.leaderstats.Rebirths.Value
        sessionStart.Kills     = player.leaderstats.Kills.Value
        sessionStart.Brawls    = player.leaderstats.Brawls.Value
        sessionStart.Time      = os.time()
    end)
end
initStats()

local lblStr   = StatsSection:CreateParagraph("StatsStr",  {Title = "Strength",  Content = "Waiting..."})
local lblDur   = StatsSection:CreateParagraph("StatsDur",  {Title = "Durability", Content = "Waiting..."})
local lblReb   = StatsSection:CreateParagraph("StatsReb",  {Title = "Rebirths",  Content = "Waiting..."})
local lblKill  = StatsSection:CreateParagraph("StatsKill", {Title = "Kills",     Content = "Waiting..."})
local lblBrawl = StatsSection:CreateParagraph("StatsBrawl",{Title = "Brawls",    Content = "Waiting..."})
local lblTime  = StatsSection:CreateParagraph("StatsTime", {Title = "Session",   Content = "00:00:00"})

UtilSection:CreateButton{
    Title = "Reset Stats",
    Description = "Reset session tracking",
    Callback = function()
        initStats()
        notify("Stats", "Estadisticas de sesion reiniciadas!")
    end
}

task.spawn(function()
    while task.wait(2) do
        if Library.Unloaded then break end
        pcall(function()
            local s = player.leaderstats.Strength.Value
            local d = player.Durability.Value
            local r = player.leaderstats.Rebirths.Value
            local k = player.leaderstats.Kills.Value
            local b = player.leaderstats.Brawls.Value
            local elapsed = os.time() - sessionStart.Time

            lblStr:SetValue("Strength:  " .. formatNumber(s) .. "  (+" .. formatNumber(s - sessionStart.Strength) .. ")")
            lblDur:SetValue("Durability:  " .. formatNumber(d) .. "  (+" .. formatNumber(d - sessionStart.Durability) .. ")")
            lblReb:SetValue("Rebirths:  " .. formatNumber(r) .. "  (+" .. formatNumber(r - sessionStart.Rebirths) .. ")")
            lblKill:SetValue("Kills:  " .. formatNumber(k) .. "  (+" .. formatNumber(k - sessionStart.Kills) .. ")")
            lblBrawl:SetValue("Brawls:  " .. formatNumber(b) .. "  (+" .. formatNumber(b - sessionStart.Brawls) .. ")")
            lblTime:SetValue("Session:  " .. formatTime(elapsed))
        end)
    end
end)

-- ═══════════════════════════════════════════
-- SETTINGS TAB
-- ═══════════════════════════════════════════
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetLibrary(Library)
InterfaceManager:SetFolder("D&M Imperial")
SaveManager:SetFolder("D&M Imperial/MuscleLegends")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- ============================
-- STARTUP
-- ============================
Window:SelectTab(1)
Library:Notify{
    Title = "D&M Imperial",
    Content = "Script cargado correctamente!",
    Duration = 5
}
SaveManager:LoadAutoloadConfig()