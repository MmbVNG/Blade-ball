local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = players.LocalPlayer
local BASE_THRESHOLD = 0.2
local VELOCITY_SCALING_FACTOR_FAST = 0.050
local VELOCITY_SCALING_FACTOR_SLOW = 0.1
local IMMEDIATE_PARRY_DISTANCE = 11
local IMMEDIATE_HIGH_VELOCITY_THRESHOLD = 85
local UserInputService = game:GetService("UserInputService")
local heartbeatConnection
local focusedBall, displayBall = nil, nil
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local ballsFolder = workspace:WaitForChild("Balls")
local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
local abilityButtonPress = replicatedStorage.Remotes.AbilityButtonPress
local sliderValue = 25
local distanceVisualizer = nil
local isRunning = false
local notifyparried = false
local PlayerGui = localPlayer:WaitForChild("PlayerGui")
local Hotbar = PlayerGui:WaitForChild("Hotbar")
local UseRage = false


local function onCharacterAdded(newCharacter)
    character = newCharacter
    abilitiesFolder = character:WaitForChild("Abilities")
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)

local TruValue = Instance.new("StringValue")
if workspace:FindFirstChild("AbilityThingyk1212") then
    workspace:FindFirstChild("AbilityThingyk1212"):Remove()
    task.wait(0.1)
    TruValue.Parent = game:GetService("Workspace")
        TruValue.Name = "AbilityThingyk1212"
        TruValue.Value = "Dash"
    else
        TruValue.Parent = game:GetService("Workspace")
        TruValue.Name = "AbilityThingyk1212"
        TruValue.Value = "Dash"
end

if character then
    print("Character found | Asmodeus Hub")
else
    print("Character not found | Asmodeus Hub")
    return
end

local parryon = false
local autoparrydistance = 10

 

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = game:GetService("Players")
local Balls = workspace:WaitForChild("Balls")
local Player = LocalPlayer.LocalPlayer or LocalPlayer.PlayerAdded:Wait()

local IsTargeted = false
local CanHit = false

function VerifyBall1()
local RealBall
for i, v in pairs(Balls:GetChildren()) do
        if v:GetAttribute("realBall") == true then
  RealBall = v
        end
        end
    return RealBall
  end
  
function IsTarget1()
    return (Player.Character and Player.Character:FindFirstChild("Highlight"))

end

function DetectBall()
    local Ball = VerifyBall1()
    
  	if Ball then
        local BallVelocity = Ball.Velocity.Magnitude
        local BallPosition = Ball.Position
  
        local PlayerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
  
        local Distance = (BallPosition - PlayerPosition).Magnitude
        local PingAccountability = BallVelocity * (game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
  
        Distance -= PingAccountability
        Distance -= 3.7
  
        local Hit = Distance / BallVelocity
  
        if Hit <= 0.5 then
            return true
        end
    end
    return false
end

function DeflectBall()
    if IsTargeted and DetectBall() then
            ReplicatedStorage.Remotes.ParryButtonPress:Fire()
end
end

game:GetService('RunService').PostSimulation:Connect(function()
    IsTargeted = IsTarget1()
        DeflectBall()
end)

local Window = Fluent:CreateWindow({
    Title = "Asmodeus Hub",
    SubTitle = "by akasukishin99727 and binxgodteli (LDQ HUB owner)",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    AutoParry = Window:AddTab({ Title = "Auto Parry", Icon = "" }),
    Ability = Window:AddTab({ Title = "Abilities", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "" })
}

local Options = Fluent.Options


    local AutoParryToggle = Tabs.AutoParry:AddToggle("MyToggle", {Title = "Auto Parry", Default = false })

    AutoParryToggle:OnChanged(function(Value)
        if Value then
            parryon1 = true
            local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("SendNotification", {
                Title = "Asmodeus Hub",
                Text = "Auto Parry has been started!",
                Duration = 3,
            })
        else
            parryon1 = false
            local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("SendNotification", {
                Title = "Asmodeus Hub",
                Text = "Auto Parry has been disabled!",
                Duration = 3,
            })
        end
    end)

    Options.MyToggle:SetValue(false)

local AutoFarmToggle = Tabs.AutoParry:AddToggle("MyToggle", {Title = "Auto Farm(Need Freeze And Turn On Auto Parry)", Default = false })
    
    AutoFarmToggle:OnChanged(function(Value)
    if Value then
    getgenv().stop = false
 
while game:GetService("RunService").RenderStepped:wait() do
   if not getgenv().stop then
       game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-287, 239, 154)
       game:GetService("ReplicatedStorage").Remotes.Freeze:FireServer()
   else
       break
   end
end
end
if not Value then
getgenv().stop = true
end
end)

    local Slider = Tabs.AutoParry:AddSlider("Slider", {
        Title = "Distance Configuration",
        Description = "For Auto Parry",
        Default = 11,
        Min = 5,
        Max = 50,
        Rounding = 0,
        Callback = function(Value)
            autoparrydistance = Value
        end
    })

    Tabs.Ability:AddButton({
        Title = "Dash",
        Description = "Note: Must complete 1 match to use.",
        Callback = function()
           local args = {
            [1] = "Dash"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
        
            local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Dash"
        
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got Dash ability!",
            Duration = 3,
        })
    end,
    })
    
    Tabs.Ability:AddButton({
        Title = "Phase Bypass",
        Description = "Note: Must complete 1 match to use.",
        Callback = function()
           local args = {
            [1] = "Phase Bypass"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
        
            local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Phase Bypass"
        
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got Phase Bypass ability!",
            Duration = 3,
        })
    end,
    })
    
    Tabs.Ability:AddButton({
        Title = "Rapture",
        Description = "Note: Must complete 1 match to use.",
        Callback = function()
           local args = {
            [1] = "Rapture"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
        
            local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Rapture"
        
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got Rapture ability!",
            Duration = 3,
        })
    end,
    })
    
    Tabs.Ability:AddButton({
    Title = "Reaper",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Reaper"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Reaper"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got reaper ability!",
            Duration = 3,
        })
    end,
})
    
Tabs.Ability:AddButton({
    Title = "Phantom",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Phantom"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Phantom"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got phantom ability!",
            Duration = 3,
        })
    end,
})    
    
Tabs.Ability:AddButton({
    Title = "Freeze",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Freeze"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Freeze"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got freeze ability!",
            Duration = 3,
        })
    end,
})
  
Tabs.Ability:AddButton({
    Title = "Infinity",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Infinity"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Infinity"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got infinity ability!",
            Duration = 3,
        })
    end,
})

Tabs.Ability:AddButton({
    Title = "Waypoint",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Waypoint"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Waypoint"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got waypoint ability!",
            Duration = 3,
        })
    end,
})

Tabs.Ability:AddButton({
    Title = "Pull",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Pull"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Pull"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got pull ability!",
            Duration = 3,
        })
    end,
})

Tabs.Ability:AddButton({
    Title = "Telekinesis",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Telekinesis"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Telekinesis"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got telekinesis ability!",
            Duration = 3,
        })
    end,
})

Tabs.Ability:AddButton({
    Title = "Raging Deflect",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Raging Deflection"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Raging Deflection"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got raging deflect ability!",
            Duration = 3,
        })
    end,
})

Tabs.Ability:AddButton({
    Title = "Swap",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Swap"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Swap"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got swap ability!",
            Duration = 3,
        })
    end,
})

Tabs.Ability:AddButton({
    Title = "Forcefield",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Forcefield"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Forcefield"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got forcefield ability!",
            Duration = 3,
        })
    end,
})

Tabs.Ability:AddButton({
    Title = "Shadow Step",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Shadow Step"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Shadow Step"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got shadow step ability!",
            Duration = 3,
        })
    end,
})

Tabs.Ability:AddButton({
    Title = "Super Jump",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Super Jump"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Super Jump"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got super jump ability!",
            Duration = 3,
        })
    end,
})

Tabs.Ability:AddButton({
    Title = "Thunder Dash",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Thunder Dash"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Thunder Dash"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got thunder dash ability!",
            Duration = 3,
        })
    end,
})

Tabs.Ability:AddButton({
    Title = "Wind Cloak",
    Description = "Note: Must complete 1 match to use.",
    Callback = function()
        local args = {
            [1] = "Wind Cloak"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Store.RequestEquipAbility:InvokeServer(unpack(args))
        
        game:GetService("ReplicatedStorage").Remotes.Store.GetOwnedAbilities:InvokeServer()
        
        game:GetService("ReplicatedStorage").Remotes.kebaind:FireServer()
                    
        local function AbilityValue2()
        local TruValue = Instance.new("StringValue")
        workspace:FindFirstChild("AbilityThingyk1212"):Remove()
                TruValue.Parent = game:GetService("Workspace")
                TruValue.Name = "AbilityThingyk1212"
                TruValue.Value = "Wind Cloak"
        end
        
        for i,v in pairs(abilitiesFolder:GetChildren()) do
        
        
        for i,b in pairs(abilitiesFolder:GetChildren()) do
            local Ability = b
            
            if v.Enabled == true then
                local EquippedAbility = v
                local ChosenAbility = {}
                spawn(function()
                ChosenAbility = AbilityValue2()
            end)
        
            task.wait(0.05)
                local AbilityValue = workspace.AbilityThingyk1212
                if b.Name == AbilityValue.Value then
        
                    v.Enabled = false
                    b.Enabled = true
            end
        end
        end
        end
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Asmodeus Hub",
            Text = "You got wind cloak ability!",
            Duration = 3,
        })
    end,
})

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Asmodeus Hub",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
