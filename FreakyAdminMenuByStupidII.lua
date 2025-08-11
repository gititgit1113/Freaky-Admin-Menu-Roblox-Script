-- made by StupidII. don't remove this or you are a skid.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer

pcall(function()
    game:GetService("CoreGui").AdminGUI:Destroy()
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 280)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 4
frame.AnchorPoint = Vector2.new(0, 0)
frame.Parent = screenGui
frame.ClipsDescendants = true
frame.Visible = true
frame.Active = true

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(1, 0)

coroutine.wrap(function()
    local hue = 0
    while frame.Parent do
        hue = (hue + 1) % 360
        frame.BorderColor3 = Color3.fromHSV(hue/360, 1, 1)
        wait(0.03)
    end
end)()

local title = Instance.new("TextLabel")
title.Text = "StupidII's Admin"
title.Font = Enum.Font.ArialBold
title.TextSize = 26
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.Parent = frame

local discoEnabled = false
local discoCoroutine = nil
local function startDisco()
    if discoCoroutine then return end
    discoEnabled = true
    discoCoroutine = coroutine.create(function()
        local hue = 0
        while discoEnabled do
            hue = (hue + 5) % 360
            title.TextColor3 = Color3.fromHSV(hue/360, 1, 1)
            wait(0.05)
        end
    end)
    coroutine.resume(discoCoroutine)
end
local function stopDisco()
    discoEnabled = false
    discoCoroutine = nil
    title.TextColor3 = Color3.new(1, 1, 1)
end

local targetBox = Instance.new("TextBox")
targetBox.PlaceholderText = "Enter Target Player Name"
targetBox.ClearTextOnFocus = false
targetBox.Text = ""
targetBox.Font = Enum.Font.SourceSans
targetBox.TextSize = 18
targetBox.TextColor3 = Color3.new(1, 1, 1)
targetBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
targetBox.Size = UDim2.new(0.9, 0, 0, 30)
targetBox.Position = UDim2.new(0.05, 0, 0, 60)
targetBox.Parent = frame

local buttonsHolder = Instance.new("Frame")
buttonsHolder.Size = UDim2.new(0.9, 0, 0.7, 0)
buttonsHolder.Position = UDim2.new(0.05, 0, 0, 100)
buttonsHolder.BackgroundTransparency = 1
buttonsHolder.Parent = frame

local uiListLayout = Instance.new("UIListLayout", buttonsHolder)
uiListLayout.Padding = UDim.new(0, 6)
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local toggleCircle = Instance.new("TextButton")
toggleCircle.Size = UDim2.new(0, 40, 0, 40)
toggleCircle.Position = UDim2.new(0, 10, 0, 10)
toggleCircle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleCircle.BorderSizePixel = 0
toggleCircle.Text = "☰"
toggleCircle.TextColor3 = Color3.new(1, 1, 1)
toggleCircle.Font = Enum.Font.SourceSansBold
toggleCircle.TextSize = 24
toggleCircle.AnchorPoint = Vector2.new(0, 0)
toggleCircle.Parent = screenGui
toggleCircle.Visible = true

local hidden = false
toggleCircle.MouseButton1Click:Connect(function()
    hidden = not hidden
    frame.Visible = not hidden
    if hidden then
        toggleCircle.Text = "▶"
    else
        toggleCircle.Text = "☰"
    end
end)

local function createButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = buttonsHolder
    btn.AutoButtonColor = true
    return btn
end

local function clientChatMessage(message)
    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = message;
        Color = Color3.fromRGB(255, 100, 100);
        Font = Enum.Font.SourceSansBold;
        FontSize = Enum.FontSize.Size24;
    })
end

local function findPlayerByName(name)
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

local function flyToggle()
    flying = not flying
    local character = localPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flying then
        clientChatMessage("Fly enabled")
        flyBodyVelocity = Instance.new("BodyVelocity", hrp)
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyConnection = RunService.Heartbeat:Connect(function()
            local vel = Vector3.new()
            if UserInputService.KeyboardEnabled then
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
                    vel = vel + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    vel = vel - Vector3.new(0, 1, 0)
                end
            else
                local t = tick()
                vel = Vector3.new(0, math.sin(t * 2) * 0.5, 0)
            end
            if vel.Magnitude > 0 then
                flyBodyVelocity.Velocity = vel.Unit * flySpeed
            else
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        clientChatMessage("Fly disabled")
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

local function setSpeed(speed)
    local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

local function teleportToPlayer(targetName)
    local target = findPlayerByName(targetName)
    if not target then return end
    if not (target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then return end
    local character = localPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
end

local noclipEnabled = false
local noclipConn

local function noclipToggle()
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
        clientChatMessage("Noclip enabled")
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
        clientChatMessage("Noclip disabled")
    end
end

local godmodeEnabled = false
local godmodeConn

local function godmodeToggle()
    local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    godmodeEnabled = not godmodeEnabled
    if godmodeEnabled then
        clientChatMessage("Godmode enabled")
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
        clientChatMessage("Godmode disabled")
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
    hrp.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
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
        clientChatMessage(target.Name .. " unfrozen")
    else
        for _, part in pairs(target.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Anchored = true
            end
        end
        frozenPlayers[target] = true
        clientChatMessage(target.Name .. " frozen")
    end
end

local function sitPlayer(targetName)
    local target = findPlayerByName(targetName)
    if not target or not target.Character then return end
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Sit = true
        clientChatMessage(target.Name .. " made to sit")
    end
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
    clientChatMessage("Removed tools from " .. target.Name)
end

local banHammerActive = false
local banHammerTool = nil
local cooldown = false

local function banPlayer(player)
    if player == localPlayer then return end
    clientChatMessage(player.Name .. " has been banned by " .. localPlayer.Name)
    removeTools(player.Name)
    freezePlayer(player.Name)
    -- Add any other ban logic here if you want
end

local function giveBanHammerTool()
    if banHammerTool then banHammerTool:Destroy() end
    banHammerTool = Instance.new("Tool")
    banHammerTool.Name = "Ban Hammer"
    banHammerTool.RequiresHandle = true
    banHammerTool.CanBeDropped = false

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 4, 1)
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

local function removeBanHammerTool()
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

local flyBtn = createButton("Toggle Fly")
flyBtn.MouseButton1Click:Connect(flyToggle)

local flyDisableBtn = createButton("Disable Fly")
flyDisableBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
flyDisableBtn.TextColor3 = Color3.new(1, 1, 1)
flyDisableBtn.MouseButton1Click:Connect(function()
    if flying then flyToggle() end
end)

local speedBtn = createButton("Set WalkSpeed 50")
speedBtn.MouseButton1Click:Connect(function()
    setSpeed(50)
    clientChatMessage("Speed set to 50")
end)

local speedBtn2 = createButton("Set WalkSpeed 16")
speedBtn2.MouseButton1Click:Connect(function()
    setSpeed(16)
    clientChatMessage("Speed set to 16")
end)

local noclipBtn = createButton("Toggle Noclip")
noclipBtn.MouseButton1Click:Connect(noclipToggle)

local godmodeBtn = createButton("Toggle Godmode")
godmodeBtn.MouseButton1Click:Connect(godmodeToggle)

local killBtn = createButton("Kill Target")
killBtn.MouseButton1Click:Connect(function()
    local targetName = targetBox.Text
    killPlayer(targetName)
    clientChatMessage("Killed player: "..(targetName ~= "" and targetName or localPlayer.Name))
end)

local bringBtn = createButton("Bring Target")
bringBtn.MouseButton1Click:Connect(function()
    local targetName = targetBox.Text
    teleportToPlayer(targetName)
    clientChatMessage("Teleported to "..targetName)
end)

local freezeBtn = createButton("Freeze/Unfreeze Target")
freezeBtn.MouseButton1Click:Connect(function()
    local targetName = targetBox.Text
    freezePlayer(targetName)
end)

local sitBtn = createButton("Make Target Sit")
sitBtn.MouseButton1Click:Connect(function()
    local targetName = targetBox.Text
    sitPlayer(targetName)
end)

local removeToolsBtn = createButton("Remove Target Tools")
removeToolsBtn.MouseButton1Click:Connect(function()
    local targetName = targetBox.Text
    removeTools(targetName)
end)

local discoBtn = createButton("Toggle Disco Mode")
discoBtn.MouseButton1Click:Connect(function()
    if discoEnabled then
        stopDisco()
        clientChatMessage("Disco Mode OFF")
    else
        startDisco()
        clientChatMessage("Disco Mode ON")
    end
end)

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
