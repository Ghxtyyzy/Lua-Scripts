-- Advanced script to prevent the character from being killed in Roblox.
-- This updated version addresses other types of player interactions and uses a TweenService for smooth transition.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Camera = workspace.CurrentCamera

local function GetCameraChanged()
    Camera = workspace.CurrentCamera 
end

local function AntiKill()
    local Character = Player.Character or false
    local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
    local RootPart = Humanoid and Humanoid.RootPart or false
    
    if Character and Humanoid and RootPart and Camera then
        if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
            local X, Y, Z = Camera.CFrame:ToEulerAnglesYXZ()
            
            -- TweenService to make the transition smoother
            local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local Goals = {CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, Y, 0)}
            local Tween = TweenService:Create(RootPart, TweenInfo, Goals)
            Tween:Play()
        end
        
        -- Prevent character from climbing to avoid errors
        if Humanoid.PlatformStand then
            Humanoid.PlatformStand = false
        end
        
        Humanoid.Sit = true
        Humanoid:SetStateEnabled("Seated", false)
    end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(GetCameraChanged)
RunService.RenderStepped:Connect(AntiKill)
