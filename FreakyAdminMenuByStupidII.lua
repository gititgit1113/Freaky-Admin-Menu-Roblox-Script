-- Freaky Admin Menu
-- Made by StupidII.
-- DON'T REMOVE THIS. IF YOU DO, YOU ARE A SKID.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer

-- Menu settings

pcall(function()
    game:GetService("CoreGui").AdminGUI:Destroy()
end)

local screenGui = Instance.new("ScreenGui") -- Create screen GUI
screenGui.Name = "AdminGUI" -- Name it AdminGUI
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui") -- Get service of CoreGUI

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

local function banHammer(targetName) -- Our favorite, BAN HAMMER. (abuse it lol)
    local target = findPlayerByName(targetName)
    if not target then
        clientChatMessage("Player '"..targetName.."' not found.") -- Return this message if there is no player.
        return
    end
    clientChatMessage(target.Name .. " has been banned by " .. localPlayer.Name) -- Chat announcement.
    startRGBName()
    removeTools(targetName)
    freezePlayer(targetName)
end

-- BUTTON FUNCTIONS

local flyBtn = createButton("Toggle Fly")
flyBtn.MouseButton1Click:Connect(flyToggle)

local speedBtn = createButton("Set Speed to 50")
speedBtn.MouseButton1Click:Connect(function() setSpeed(50) end)

local resetSpeedBtn = createButton("Reset Speed")
resetSpeedBtn.MouseButton1Click:Connect(function() setSpeed(16) end)

local teleportBtn = createButton("Teleport To Player")
teleportBtn.MouseButton1Click:Connect(function()
    teleportToPlayer(targetBox.Text)
end)

local noclipBtn = createButton("Toggle Noclip")
noclipBtn.MouseButton1Click:Connect(noclipToggle)

local godmodeBtn = createButton("Toggle Godmode")
godmodeBtn.MouseButton1Click:Connect(godmodeToggle)

local killBtn = createButton("Kill Player")
killBtn.MouseButton1Click:Connect(function()
    killPlayer(targetBox.Text)
end)

local bringBtn = createButton("Bring Player")
bringBtn.MouseButton1Click:Connect(function()
    bringPlayer(targetBox.Text)
end)

local freezeBtn = createButton("Freeze Player")
freezeBtn.MouseButton1Click:Connect(function()
    freezePlayer(targetBox.Text)
end)

local sitBtn = createButton("Sit Player")
sitBtn.MouseButton1Click:Connect(function()
    sitPlayer(targetBox.Text)
end)

local removeToolsBtn = createButton("Remove Tools")
removeToolsBtn.MouseButton1Click:Connect(function()
    removeTools(targetBox.Text)
end)

local banBtn = createButton("Ban Player (Ban Hammer)")
banBtn.MouseButton1Click:Connect(function()
    banHammer(targetBox.Text)
end)

-- Turn the menu to a circle (if hidden)
local circleSize = 40
local circle = Instance.new("ImageButton")
circle.Name = "AdminCircle"
circle.Size = UDim2.new(0, circleSize, 0, circleSize)
circle.Position = UDim2.new(0, 10, 0, 10)
circle.AnchorPoint = Vector2.new(0, 0)
circle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
circle.AutoButtonColor = false
circle.Parent = screenGui
circle.Image = "rbxassetid://3570695787"
circle.ImageColor3 = Color3.fromRGB(50, 50, 50)
circle.Visible = false
circle.ZIndex = 10

local draggingFrame = nil
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updatePosition(input) -- Update POS
    local delta = input.Position - dragStart
    local newPos = UDim2.new(
        math.clamp(startPos.X.Scale, 0, 1),
        math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X),
        math.clamp(startPos.Y.Scale, 0, 1),
        math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
    )
    draggingFrame.Position = newPos
end

local function dragStartFunc(input) -- Drag start function
    dragInput = input
    dragStart = input.Position
    startPos = draggingFrame.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragInput = nil
        end
    end)
end

local function dragInputFunc(input) -- Drag input function
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        updatePosition(input)
    end
end

local function makeDraggable(frameToDrag) -- Make the circle draggable
    frameToDrag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingFrame = frameToDrag
            dragStartFunc(input)
        end
    end)
    frameToDrag.InputChanged:Connect(function(input)
        if input == dragInput then
            dragInputFunc(input)
        end
    end)
end

makeDraggable(frame)
makeDraggable(circle)

local hidden = false -- NOT HIDDEN LOL
local wasDraggingCircle = false

circle.MouseButton1Down:Connect(function()
    wasDraggingCircle = false
end)

circle.MouseMoved:Connect(function()
    wasDraggingCircle = true -- Dragging if the mouse is moving it
end)

circle.MouseButton1Up:Connect(function()
    if not wasDraggingCircle then
        hidden = false
        frame.Visible = true
        circle.Visible = false
    end
end)

local hideTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local showTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function hideMenu() -- Hide it
    if hidden then return end
    hidden = true
    local tween = TweenService:Create(frame, hideTweenInfo, {Size=UDim2.new(0, circleSize, 0, circleSize)})
    tween:Play()
    tween.Completed:Wait()
    frame.Visible = false
    circle.Visible = true
    circle.Position = frame.Position
    circle.Size = UDim2.new(0, circleSize, 0, circleSize)
end

local function showMenu() -- The whole menu setting
    if not hidden then return end
    hidden = false
    frame.Visible = true
    circle.Visible = false
    frame.Size = UDim2.new(0, 270, 0, 480)
end

local draggingFrameMenu = nil
local dragInputMenu = nil
local dragStartMenu = nil
local startPosMenu = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFrameMenu = frame
        dragInputMenu = input
        dragStartMenu = input.Position
        startPosMenu = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragInputMenu = nil
                draggingFrameMenu = nil
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input == dragInputMenu then
        local delta = input.Position - dragStartMenu
        local newPos = UDim2.new(
            math.clamp(startPosMenu.X.Scale, 0, 1),
            math.clamp(startPosMenu.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X),
            math.clamp(startPosMenu.Y.Scale, 0, 1),
            math.clamp(startPosMenu.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
        )
        frame.Position = newPos
    end
end)

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        hideMenu()
    end
end)

return screenGui

-- FREAKY ADMIN. ABUSE IT, AND USE IT.
-- Code ended.
