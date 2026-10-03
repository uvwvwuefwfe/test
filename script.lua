-- All-In-One + Da Hood Silent Aim (Fixed)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

getgenv().Settings = {
    Speed = false,
    SpeedValue = 50,
    Fly = false,
    FlySpeed = 60,
    InfiniteJump = false,
    Noclip = false,
    ESP = false,
    SilentAim = false,
    SilentAimFOV = 180,
    TeamCheck = false
}

local Settings = getgenv().Settings
local ESPObjects = {} -- Fixed missing table

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AllInOne"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 370)
Main.Position = UDim2.new(0.5, -140, 0.5, -185)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.BorderSizePixel = 0
Title.Text = "All-In-One + Da Hood"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -12, 1, -48)
Container.Position = UDim2.new(0, 6, 0, 42)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.CanvasSize = UDim2.new(0, 0, 0, 400)
Container.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 6)
UIList.Parent = Container

local function CreateToggle(name, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    Frame.BorderSizePixel = 0
    Frame.Parent = Container
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -55, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 42, 0, 22)
    Button.Position = UDim2.new(1, -50, 0.5, -11)
    Button.BackgroundColor3 = default and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(160, 40, 40)
    Button.Text = default and "ON" or "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.Parent = Frame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)

    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = state and "ON" or "OFF"
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(160, 40, 40)
        callback(state)
    end)
end

CreateToggle("Speed", false, function(v) Settings.Speed = v end)
CreateToggle("Fly", false, function(v) Settings.Fly = v end)
CreateToggle("Infinite Jump", false, function(v) Settings.InfiniteJump = v end)
CreateToggle("Noclip", false, function(v) Settings.Noclip = v end)
CreateToggle("ESP", false, function(v) Settings.ESP = v end)
CreateToggle("Silent Aim (Da Hood)", false, function(v) Settings.SilentAim = v end)
CreateToggle("Team Check", false, function(v) Settings.TeamCheck = v end)

-- ========== SPEED (Stronger) ==========
RunService.Heartbeat:Connect(function()
    if Settings.Speed then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Settings.SpeedValue
        end
    end
end)

-- ========== FLY ==========
local flying = false
local bv, bg

local function StartFly()
    if flying then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    flying = true
    local hrp = char.HumanoidRootPart

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 9e4
    bg.Parent = hrp

    char.Humanoid.PlatformStand = true
end

local function StopFly()
    flying = false
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
end

RunService.Heartbeat:Connect(function()
    if Settings.Fly then
        if not flying then StartFly() end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and bv and bg then
            local cam = Camera.CFrame
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
            bv.Velocity = dir.Magnitude > 0 and dir.Unit * Settings.FlySpeed or Vector3.zero
            bg.CFrame = cam
        end
    else
        if flying then StopFly() end
    end
end)

-- ========== INFINITE JUMP ==========
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ========== NOCLIP ==========
RunService.Stepped:Connect(function()
    if Settings.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ========== ESP (Fixed) ==========
local function AddESP(player)
    if player == LocalPlayer or ESPObjects[player] then return end
    local char = player.Character
    if not char then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = Color3.fromRGB(255, 40, 40)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.55
    highlight.OutlineTransparency = 0
    highlight.Parent = char
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
        task.wait(1)
        if Settings.ESP then AddESP(player) end
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if Settings.ESP then AddESP(player) end
        end)
    end
end

RunService.Heartbeat:Connect(function()
    if Settings.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not ESPObjects[player] then
                AddESP(player)
            end
        end
    else
        for player, _ in pairs(ESPObjects) do
            RemoveESP(player)
        end
    end
end)

Players.PlayerRemoving:Connect(RemoveESP)

-- ========== DA HOOD SILENT AIM (Improved) ==========
local function GetClosest()
    local closest, shortest = nil, Settings.SilentAimFOV
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if Settings.TeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                -- skip teammate
            else
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = player
                        end
                    end
                end
            end
        end
    end
    return closest
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if Settings.SilentAim and not checkcaller() and method == "FireServer" then
        local remoteName = tostring(self)
        if remoteName:find("MainEvent") or remoteName == "MainEvent" then
            local target = GetClosest()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                -- Common Da Hood argument positions
                if typeof(args[2]) == "Vector3" then
                    args[2] = target.Character.Head.Position
                elseif typeof(args[3]) == "Vector3" then
                    args[3] = target.Character.Head.Position
                end
            end
        end
    end

    return oldNamecall(self, unpack(args))
end))

print("All-In-One Fixed + Da Hood Silent Aim loaded!")
