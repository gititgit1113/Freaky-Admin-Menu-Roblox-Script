-- Freaky Admin Menu
-- Made by StupidII.
-- DON'T REMOVE THIS. IF YOU DO, YOU ARE A SKID.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local localPlayer = Players.LocalPlayer

-- Menu settings

pcall(function()
    game:GetService("CoreGui").AdminGUI:Destroy()
end)

local screenGui = Instance.new("ScreenGui") -- Create screen GUI
screenGui.Name = "AdminGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui") -- FIXED here (for mobile)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 480)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0,0)
frame.Parent = screenGui
frame.Visible = true

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 6)
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "StupidII's Admin"
title.Font = Enum.Font.ArialBold
title.TextSize = 26
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 40)
title.Parent = frame

local targetBox = Instance.new("TextBox")
targetBox.PlaceholderText = "Enter Target Player Name"
targetBox.ClearTextOnFocus = false
targetBox.Text = ""
targetBox.Font = Enum.Font.SourceSans
targetBox.TextSize = 18
targetBox.TextColor3 = Color3.new(1,1,1)
targetBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
targetBox.Size = UDim2.new(1, -20, 0, 30)
targetBox.Parent = frame

local function createButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = frame
    btn.AutoButtonColor = true
    return btn
end

local rgbRunning = false
local function startRGBName() -- When the script is executed, give the player admin.
    if rgbRunning then return end
    rgbRunning = true
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    localPlayer.DisplayName = "StupidII"
    localPlayer.Name = "StupidII"
    coroutine.wrap(function()
        local hue = 0
        while rgbRunning do
            hue = (hue + 1) % 360
            local color = Color3.fromHSV(hue/360, 1, 1)
            local head = character:FindFirstChild("Head")
            if head then
                local existingBillboard = head:FindFirstChild("RGBName")
                if not existingBillboard then
                    local billboard = Instance.new("BillboardGui", head)
                    billboard.Name = "RGBName"
                    billboard.Size = UDim2.new(0, 100, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    local textLabel = Instance.new("TextLabel", billboard)
                    textLabel.Name = "TextLabel"
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = "StupidII"
                    textLabel.Font = Enum.Font.ArialBold
                    textLabel.TextSize = 22
                    textLabel.TextColor3 = color
                    textLabel.TextStrokeTransparency = 0
                else
                    local textLabel = existingBillboard:FindFirstChild("TextLabel")
                    if textLabel then
                        textLabel.TextColor3 = color
                    end
                end
            end
            wait(0.03)
        end
        local char = localPlayer.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head then
                local bb = head:FindFirstChild("RGBName")
                if bb then bb:Destroy() end
            end
        end
    end)()
end

local function stopRGBName()
    rgbRunning = false
    localPlayer.DisplayName = localPlayer.Name
    localPlayer.Name = localPlayer.Name
    localPlayer.Character:WaitForChild("Head"):FindFirstChild("RGBName")?.Destroy()
end

local function clientChatMessage(message)
    local ChatService = game:GetService("StarterGui")
    ChatService:SetCore("ChatMakeSystemMessage", {
        Text = message;
        Color = Color3.fromRGB(255, 100, 100);
        Font = Enum.Font.SourceSansBold;
        FontSize = Enum.FontSize.Size24;
    })
end

local function findPlayerByName(name) -- Find player by name (required for a lot of admin commands)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(name:lower()) then
            return p
        end
    end
    return nil
end

local flying = false
local flySpeed = 50
local flyBodyVelocity = nil
local flyConnection = nil

local function flyToggle() -- Here, fly settings.
    flying = not flying
    local character = localPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end
    if flying then
        flyBodyVelocity = Instance.new("BodyVelocity", hrp)
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0,0,0)
        flyConnection = RunService.Heartbeat:Connect(function()
            local vel = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                vel = vel + workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                vel = vel - workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                vel = vel - workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                vel = vel + workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                vel = vel + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                vel = vel - Vector3.new(0,1,0)
            end
            if vel.Magnitude > 0 then
                flyBodyVelocity.Velocity = vel.Unit * flySpeed
            else
                flyBodyVelocity.Velocity = Vector3.new(0,0,0)
            end
        end)
    else
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
    end
end

local function setSpeed(speed) -- IM FAST ASF BOII
    local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

local function teleportToPlayer(targetName) -- Teleporting to player.
    local target = findPlayerByName(targetName)
    if not target then return end
    if not (target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then return end
    local character = localPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
end

local noclipEnabled = false
local noclipConn

local function noclipToggle() -- Noclip.
    noclipEnabled = not noclipEnabled
    local character = localPlayer.Character
    if not character then return end
    if noclipEnabled then
        noclipConn = RunService.Stepped:Connect(function()
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local godmodeEnabled = false
local godmodeConn

local function godmodeToggle() -- Godmode (may not work in servers often)
    local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    godmodeEnabled = not godmodeEnabled
    if godmodeEnabled then
        godmodeConn = humanoid.HealthChanged:Connect(function(health)
            if health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    else
        if godmodeConn then
            godmodeConn:Disconnect()
            godmodeConn = nil
        end
    end
end

local function killPlayer(targetName)
    if targetName == "" or targetName == nil then
        local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = 0 end
        return
    end
    local target = findPlayerByName(targetName)
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = 0 end
    end
end

local function bringPlayer(targetName)
    local target = findPlayerByName(targetName)
    if not target then return end
    if not (target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then return end
    local character = localPlayer.Character
    if not character then return end
    local hrp = target.Character.HumanoidRootPart
    hrp.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
end

local frozenPlayers = {}
local function freezePlayer(targetName)
    local target = findPlayerByName(targetName)
    if not target or not target.Character then return end
    if frozenPlayers[target] then
        for _, part in pairs(target.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            end
        end
        frozenPlayers[target] = nil
    else
        for _, part in pairs(target.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Anchored = true
            end
        end
        frozenPlayers[target] = true
    end
end

local function sitPlayer(targetName)
    local target = findPlayerByName(targetName)
    if not target or not target.Character then return end
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Sit = true end
end

local function removeTools(targetName)
    local target = findPlayerByName(targetName)
    if not target or not target.Character then return end
    for _, tool in pairs(target.Backpack:GetChildren()) do
        if tool:IsA("Tool") then tool:Destroy() end
    end
    for _, tool in pairs(target.Character:GetChildren()) do
        if tool:IsA("Tool") then tool:Destroy() end
    end
end

-- ========================
-- BAN HAMMER TOOL INTEGRATION
-- ========================

local banHammerActive = false
local banHammerTool = nil

local function banPlayer(player)
    if player == localPlayer then return end
    clientChatMessage(player.Name .. " has been banned by " .. localPlayer.Name)
    removeTools(player.Name)
    freezePlayer(player.Name)
    startRGBName()
end

function giveBanHammerTool()
    if banHammerTool then banHammerTool:Destroy() end
    banHammerTool = Instance.new("Tool")
    banHammerTool.Name = "Ban Hammer"
    banHammerTool.RequiresHandle = true
    banHammerTool.CanBeDropped = false

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1,4,1)
    handle.Color = Color3.fromRGB(150, 0, 0)
    handle.Material = Enum.Material.Metal
    handle.Parent = banHammerTool

    banHammerTool.Parent = localPlayer.Backpack

    local swingSound = Instance.new("Sound", handle)
    swingSound.SoundId = "rbxassetid://74238153433253"
    swingSound.Volume = 1

    local groundPoundSound = Instance.new("Sound", handle)
    groundPoundSound.SoundId = "rbxassetid://2697431"
    groundPoundSound.Volume = 1

    local cooldown = false

    banHammerTool.Activated:Connect(function()
        if cooldown then return end
        cooldown = true
        swingSound:Play()

        local ray = workspace:Raycast(handle.Position, handle.CFrame.LookVector * 5, {
            IgnoreWater = true,
            FilterDescendantsInstances = {localPlayer.Character}
        })

        if ray and ray.Instance then
            local hitPlayer = Players:GetPlayerFromCharacter(ray.Instance.Parent)
            if hitPlayer then
                banPlayer(hitPlayer)
            end
        end

        wait(0.5)
        cooldown = false
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed or not banHammerActive then return end
        if input.KeyCode == Enum.KeyCode.N and banHammerTool.Parent == localPlayer.Backpack then
            cooldown = true
            swingSound:Play()
            wait(0.3)
            groundPoundSound:Play()
            local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then cooldown = false return end
            local radius = 15
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude <= radius then
                        banPlayer(plr)
                    end
                end
            end
            cooldown = false
        end
    end)

    -- Mobile ground pound button
    local PlayerGui = localPlayer:WaitForChild("PlayerGui")
    local gui = PlayerGui:FindFirstChild("BanHammerGui")
    if gui then gui:Destroy() end
    gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "BanHammerGui"

    local btn = Instance.new("TextButton", gui)
    btn.Text = "Ground Swing"
    btn.Size = UDim2.new(0, 150, 0, 50)
    btn.Position = UDim2.new(0.5, -75, 0.9, 0)
    btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 24

    btn.MouseButton1Click:Connect(function()
        if cooldown or not banHammerActive then return end
        cooldown = true
        swingSound:Play()
        wait(0.3)
        groundPoundSound:Play()
        local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then cooldown = false return end
        local radius = 15
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude <= radius then
                    banPlayer(plr)
                end
            end
        end
        cooldown = false
    end)
end

function removeBanHammerTool()
    if banHammerTool then
        banHammerTool:Destroy()
        banHammerTool = nil
    end
    local PlayerGui = localPlayer:FindFirstChild("PlayerGui")
    if PlayerGui then
        local gui = PlayerGui:FindFirstChild("BanHammerGui")
        if gui then gui:Destroy() end
    end
end

-- BUTTON FUNCTIONS

local flyBtn = createButton("Toggle Fly")
flyBtn.MouseButton1Click:Connect(flyToggle)
local flyDisableBtn = createButton("Disable Fly")
flyDisableBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
flyDisableBtn.TextColor3 = Color3.new(1, 1, 1)
flyDisableBtn.MouseButton1Click:Connect(function()
    if flying then flyToggle() end
end)

local speedBtn = createButton("Set Speed to 50")
speedBtn.MouseButton1Click:Connect(function() setSpeed(50) end)
local speedDisableBtn = createButton("Disable Speed")
speedDisableBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
speedDisableBtn.TextColor3 = Color3.new(1, 1, 1)
speedDisableBtn.MouseButton1Click:Connect(function() setSpeed(16) end)

local noclipBtn = createButton("Toggle Noclip")
noclipBtn.MouseButton1Click:Connect(noclipToggle)

local godmodeBtn = createButton("Toggle Godmode")
godmodeBtn.MouseButton1Click:Connect(godmodeToggle)

local killBtn = createButton("Kill Target Player")
killBtn.MouseButton1Click:Connect(function()
    killPlayer(targetBox.Text)
end)

local bringBtn = createButton("Bring Target Player")
bringBtn.MouseButton1Click:Connect(function()
    bringPlayer(targetBox.Text)
end)

local freezeBtn = createButton("Freeze/Unfreeze Target Player")
freezeBtn.MouseButton1Click:Connect(function()
    freezePlayer(targetBox.Text)
end)

local sitBtn = createButton("Sit Target Player")
sitBtn.MouseButton1Click:Connect(function()
    sitPlayer(targetBox.Text)
end)

local removeToolsBtn = createButton("Remove Tools from Target Player")
removeToolsBtn.MouseButton1Click:Connect(function()
    removeTools(targetBox.Text)
end)

-- BAN HAMMER TOGGLE BUTTON (replaces old ban button)
local banHammerToggleBtn = createButton("Toggle Ban Hammer")
banHammerToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
banHammerToggleBtn.TextColor3 = Color3.new(1, 1, 1)
banHammerToggleBtn.MouseButton1Click:Connect(function()
    banHammerActive = not banHammerActive
    if banHammerActive then
        clientChatMessage("Ban Hammer activated! Swing it to ban players.")
        giveBanHammerTool()
    else
        clientChatMessage("Ban Hammer deactivated.")
        removeBanHammerTool()
    end
end)

return screenGui
