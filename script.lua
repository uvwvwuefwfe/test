-- All-In-One Script + Da Hood Silent Aim
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Settings
getgenv().Settings = {
    Speed = false,
    SpeedValue = 50,
    Fly = false,
    FlySpeed = 50,
    InfiniteJump = false,
    Noclip = false,
    ESP = false,
    SilentAim = false,
    SilentAimFOV = 150,
    SilentAimHitChance = 100, -- 100 = always hit
    TeamCheck = false
}

local Settings = getgenv().Settings

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AllInOne"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 380)
Main.Position = UDim2.new(0.5, -140, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0
Title.Text = "All-In-One + Da Hood"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -10, 1, -45)
Container.Position = UDim2.new(0, 5, 0, 40)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.CanvasSize = UDim2.new(0, 0, 0, 420)
Container.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 6)
UIList.Parent = Container

-- Toggle creator
local function CreateToggle(name, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Frame.BorderSizePixel = 0
    Frame.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 40, 0, 22)
    Button.Position = UDim2.new(1, -48, 0.5, -11)
    Button.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    Button.Text = default and "ON" or "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Button

    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = state and "ON" or "OFF"
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        callback(state)
    end)
end

-- Create toggles
CreateToggle("Speed", false, function(v) Settings.Speed = v end)
CreateToggle("Fly", false, function(v) Settings.Fly = v end)
CreateToggle("Infinite Jump", false, function(v) Settings.InfiniteJump = v end)
CreateToggle("Noclip", false, function(v) Settings.Noclip = v end)
CreateToggle("ESP", false, function(v) Settings.ESP = v end)
CreateToggle("Silent Aim (Da Hood)", false, function(v) Settings.SilentAim = v end)
CreateToggle("Team Check", false, function(v) Settings.TeamCheck = v end)

-- ========== SPEED ==========
RunService.Heartbeat:Connect(function()
    if Settings.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Settings.SpeedValue
    end
end)

-- ========== FLY ==========
local flying = false
local flyBodyVelocity, flyBodyGyro

local function StartFly()
    if flying then return end
    flying = true
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local hrp = char.HumanoidRootPart
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Velocity = Vector3.zero
    flyBodyVelocity.Parent = hrp

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.P = 9e4
    flyBodyGyro.Parent = hrp

    char.Humanoid.PlatformStand = true
end

local function StopFly()
    flying = false
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

RunService.Heartbeat:Connect(function()
    if Settings.Fly then
        if not flying then StartFly() end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and flyBodyVelocity and flyBodyGyro then
            local camCF = Camera.CFrame
            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
            flyBodyVelocity.Velocity = move.Magnitude > 0 and move.Unit * Settings.FlySpeed or Vector3.zero
            flyBodyGyro.CFrame = camCF
        end
    else
        if flying then StopFly() end
    end
end)

-- ========== INFINITE JUMP ==========
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ========== NOCLIP ==========
RunService.Stepped:Connect(function()
    if Settings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ========== ESP ==========
local function CreateESP(player)
    if player == LocalPlayer then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.Parent = player.Character or player.CharacterAdded:Wait()
    ESPObjects[player] = highlight
end

local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if Settings.ESP then
            task.wait(0.5)
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(RemoveESP)

RunService.Heartbeat:Connect(function()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not ESPObjects[player] then
                CreateESP(player)
            end
        end
    else
        for player, _ in pairs(ESPObjects) do
            RemoveESP(player)
        end
    end
end)

-- ========== DA HOOD SILENT AIM ==========
local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = Settings.SilentAimFOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if Settings.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end

            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < shortestDistance then
                    closest = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if Settings.SilentAim and method == "FireServer" then
        if tostring(self) == "MainEvent" or tostring(self.Name) == "MainEvent" then
            local closest = GetClosestPlayer()
            if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                if math.random(1, 100) <= Settings.SilentAimHitChance then
                    args[2] = closest.Character.Head.Position -- changes target position
                end
            end
        end
    end

    return oldNamecall(self, unpack(args))
end)

setreadonly(mt, true)

print("All-In-One + Da Hood Silent Aim loaded!")
