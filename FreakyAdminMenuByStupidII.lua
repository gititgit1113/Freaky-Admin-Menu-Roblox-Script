-- don't remove or ur a skid
-- made by stupidii, give creds (don't remove this)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer

pcall(function()
    game:GetService("CoreGui").StupidIIAdmin:Destroy()
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StupidIIAdmin"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 360)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 4
frame.AnchorPoint = Vector2.new(0, 0)
frame.Parent = screenGui
frame.ClipsDescendants = true
frame.Visible = true
frame.Active = true

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 6)

coroutine.wrap(function()
    local hue = 0
    while frame.Parent do
        hue = (hue + 1) % 360
        frame.BorderColor3 = Color3.fromHSV(hue / 360, 1, 1)
        wait(0.03)
    end
end)()

local title = Instance.new("TextLabel")
title.Text = "StupidII's Admin"
title.Font = Enum.Font.ArialBold
title.TextSize = 28
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.Parent = frame

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
buttonsHolder.Size = UDim2.new(0.9, 0, 0.75, 0)
buttonsHolder.Position = UDim2.new(0.05, 0, 0, 100)
buttonsHolder.BackgroundTransparency = 1
buttonsHolder.Parent = frame

local uiListLayout = Instance.new("UIListLayout", buttonsHolder)
uiListLayout.Padding = UDim.new(0, 8)
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = buttonsHolder
    btn.AutoButtonColor = true
    return btn
end

local buttonsText = {
    "Toggle Fly",
    "Disable Fly",
    "Set Speed to 50",
    "Disable Speed",
    "Toggle Noclip",
    "Toggle Godmode",
    "Kill Target Player",
    "Bring Target Player",
    "Freeze/Unfreeze Target Player",
    "Sit Target Player",
    "Remove Tools from Target Player",
    "Toggle Disco Mode",
    "Toggle Ban Hammer"
}

local buttons = {}

for _, text in ipairs(buttonsText) do
    buttons[text] = createButton(text)
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

local function flyDisable()
    if flying then flyToggle() end
end

local function setSpeed(speed)
    local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
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

local function godmodeToggle()
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

local function killPlayer(name)
    if name == "" or not name then
        local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = 0 end
        return
    end
    local target = findPlayerByName(name)
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = 0 end
    end
end

local function teleportToPlayer(name)
    local target = findPlayerByName(name)
    if not target then return end
    if not (target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then return end
    local character = localPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
end

local frozenPlayers = {}
local function freezePlayer(name)
    local target = findPlayerByName(name)
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

local function sitPlayer(name)
    local target = findPlayerByName(name)
    if not target or not target.Character then return end
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Sit = true end
end

local function removeTools(name)
    local target = findPlayerByName(name)
    if not target or not target.Character then return end
    for _, tool in pairs(target.Backpack:GetChildren()) do
        if tool:IsA("Tool") then tool:Destroy() end
    end
    for _, tool in pairs(target.Character:GetChildren()) do
        if tool:IsA("Tool") then tool:Destroy() end
    end
end

local discoRunning = false
local discoConnection

local function toggleDiscoMode()
    discoRunning = not discoRunning
    local character = localPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if discoRunning then
        discoConnection = RunService.Heartbeat:Connect(function()
            if hrp then
                hrp.Color = Color3.fromHSV(tick() % 1, 1, 1)
            end
        end)
        clientChatMessage("Disco mode ON")
    else
        if discoConnection then
            discoConnection:Disconnect()
            discoConnection = nil
        end
        if hrp then
            hrp.Color = Color3.fromRGB(255, 255, 255)
        end
        clientChatMessage("Disco mode OFF")
    end
end

local banHammerActive = false
local banHammerTool = nil

local function clientChatMessage(msg)
    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg;
        Color = Color3.fromRGB(255, 100, 100);
        Font = Enum.Font.SourceSansBold;
        FontSize = Enum.FontSize.Size24;
    })
end

local function removeBanHammerTool()
    if banHammerTool then
        banHammerTool:Destroy()
        banHammerTool = nil
    end
    local gui = localPlayer:FindFirstChild("PlayerGui"):FindFirstChild("BanHammerGui")
    if gui then
        gui:Destroy()
    end
end

local cooldown = false

local function banPlayer(player)
    if player == localPlayer then return end
    clientChatMessage(player.Name .. " has been banned by " .. localPlayer.Name)
    removeTools(player.Name)
    freezePlayer(player.Name)
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

local function toggleBanHammer()
    banHammerActive = not banHammerActive
    if banHammerActive then
        clientChatMessage("Ban Hammer activated! Swing it to ban players.")
        giveBanHammerTool()
    else
        clientChatMessage("Ban Hammer deactivated.")
        removeBanHammerTool()
    end
end

buttons["Toggle Fly"].MouseButton1Click:Connect(flyToggle)
buttons["Disable Fly"].MouseButton1Click:Connect(flyDisable)
buttons["Set Speed to 50"].MouseButton1Click:Connect(function() setSpeed(50) end)
buttons["Disable Speed"].MouseButton1Click:Connect(function() setSpeed(16) end)
buttons["Toggle Noclip"].MouseButton1Click:Connect(noclipToggle)
buttons["Toggle Godmode"].MouseButton1Click:Connect(godmodeToggle)
buttons["Kill Target Player"].MouseButton1Click:Connect(function()
    killPlayer(targetBox.Text)
end)
buttons["Bring Target Player"].MouseButton1Click:Connect(function()
    teleportToPlayer(targetBox.Text)
end)
buttons["Freeze/Unfreeze Target Player"].MouseButton1Click:Connect(function()
    freezePlayer(targetBox.Text)
end)
buttons["Sit Target Player"].MouseButton1Click:Connect(function()
    sitPlayer(targetBox.Text)
end)
buttons["Remove Tools from Target Player"].MouseButton1Click:Connect(function()
    removeTools(targetBox.Text)
end)
buttons["Toggle Disco Mode"].MouseButton1Click:Connect(toggleDiscoMode)
buttons["Toggle Ban Hammer"].MouseButton1Click:Connect(toggleBanHammer)

local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 40, 0, 40)
hideBtn.Position = UDim2.new(0, frame.Position.X.Offset + frame.Size.X.Offset - 20, 0, frame.Position.Y.Offset - 20)
hideBtn.AnchorPoint = Vector2.new(0.5, 0.5)
hideBtn.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
hideBtn.Text = "-"
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.TextSize = 28
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.Parent = screenGui
hideBtn.AutoButtonColor = true
local circleCorner = Instance.new("UICorner", hideBtn)
circleCorner.CornerRadius = UDim.new(1, 0)

local hideDragging, hideDragInput, hideDragStart, hideStartPos = false, nil, nil, nil

hideBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local now = tick()
        if hideDragging and (now - (hideBtn.LastClick or 0) < 0.3) then
            -- Double click to toggle menu visibility
            frame.Visible = not frame.Visible
            hideBtn.Text = frame.Visible and "-" or "+"
            hideDragging = false
            return
        end
        hideDragging = true
        hideDragStart = input.Position
        hideStartPos = hideBtn.Position
        hideBtn.LastClick = now
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                hideDragging = false
            end
        end)
    end
end)

hideBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        hideDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == hideDragInput and hideDragging then
        local delta = input.Position - hideDragStart
        local newX = math.clamp(hideStartPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - hideBtn.AbsoluteSize.X)
        local newY = math.clamp(hideStartPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - hideBtn.AbsoluteSize.Y)
        hideBtn.Position = UDim2.new(0, newX, 0, newY)
    end
end)
