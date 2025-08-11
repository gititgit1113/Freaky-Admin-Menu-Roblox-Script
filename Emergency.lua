-- Simple Admin Menu with Mobile Support
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Remove existing GUI if any
local existingGui = playerGui:FindFirstChild("AdminGUI")
if existingGui then existingGui:Destroy() end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminGUI"
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true -- Important for mobile safe area

-- Create main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.8, 0, 0.7, 0) -- relative size
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Admin Menu"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.ArialBold
title.TextSize = 28
title.Parent = frame

-- Player name input
local targetBox = Instance.new("TextBox")
targetBox.PlaceholderText = "Target player name"
targetBox.Size = UDim2.new(1, -20, 0, 30)
targetBox.Position = UDim2.new(0, 10, 0, 50)
targetBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
targetBox.TextColor3 = Color3.new(1,1,1)
targetBox.ClearTextOnFocus = false
targetBox.Parent = frame

-- Helper to create buttons
local function createButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Parent = frame
    return btn
end

-- Fly variables
local flying = false
local flyBodyVelocity = nil
local flyConnection = nil
local flySpeed = 50

-- Fly toggle function
local function flyToggle()
    local character = localPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flying = not flying

    if flying then
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = hrp

        flyConnection = RunService.Heartbeat:Connect(function()
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0,1,0)
            end

            if moveDir.Magnitude > 0 then
                flyBodyVelocity.Velocity = moveDir.Unit * flySpeed
            else
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
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

-- Ban Hammer Tool creation
local banHammerTool = nil
local function giveBanHammer()
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

    banHammerTool.Activated:Connect(function()
        local character = localPlayer.Character
        if not character then return end
        local handlePos = handle.Position
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist

        local rayResult = workspace:Raycast(handlePos, handle.CFrame.LookVector * 5, rayParams)
        if rayResult and rayResult.Instance then
            local targetChar = rayResult.Instance:FindFirstAncestorOfClass("Model")
            local targetPlayer = targetChar and Players:GetPlayerFromCharacter(targetChar)
            if targetPlayer and targetPlayer ~= localPlayer then
                -- Ban effect (for demo: just print and remove tools)
                print("Banned player: "..targetPlayer.Name)
                for _, tool in pairs(targetPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") then tool:Destroy() end
                end
            end
        end
    end)
end

local banHammerActive = false

-- Buttons

local flyButton = createButton("Toggle Fly", 90)
flyButton.MouseButton1Click:Connect(flyToggle)

local banHammerButton = createButton("Toggle Ban Hammer", 140)
banHammerButton.MouseButton1Click:Connect(function()
    banHammerActive = not banHammerActive
    if banHammerActive then
        giveBanHammer()
        print("Ban Hammer activated")
    else
        if banHammerTool then
            banHammerTool:Destroy()
            banHammerTool = nil
        end
        print("Ban Hammer deactivated")
    end
end)

-- Mobile Fly Button
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    local mobileFlyBtn = Instance.new("TextButton")
    mobileFlyBtn.Size = UDim2.new(0, 120, 0, 40)
    mobileFlyBtn.Position = UDim2.new(0.5, -60, 0.85, 0)
    mobileFlyBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    mobileFlyBtn.TextColor3 = Color3.new(1,1,1)
    mobileFlyBtn.Text = "Toggle Fly"
    mobileFlyBtn.Font = Enum.Font.SourceSansBold
    mobileFlyBtn.TextSize = 20
    mobileFlyBtn.Parent = screenGui

    mobileFlyBtn.MouseButton1Click:Connect(flyToggle)
end
