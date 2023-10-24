local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

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
local distanceVisualizer = nil
local isRunning = false
local notifyparried = false
local PlayerGui = localPlayer:WaitForChild("PlayerGui")
local Hotbar = PlayerGui:WaitForChild("Hotbar")
local UseRage = false

local uigrad1 = Hotbar.Block.border1.UIGradient
local uigrad2 = Hotbar.Ability.border2.UIGradient

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

local Window = OrionLib:MakeWindow({Name = "LDQ HUB | BLADE BALL", HidePremium = false, SaveConfig = false, ConfigFolder = "OrionTest", IntroText = "LDQ HUB"})
 
local AutoParry = Window:MakeTab({
	Name = "Auto Parry",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
 
if character then
    print("Character found | LDQ HUB")
else
    print("Character not found | LDQ HUB")
    return
end
 
AutoParry:AddButton({
	Name = "Auto Parry (Hold Block Button To Spam)",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BinxGodteli/Auto-parry-op/main/Op.lua"))()
    getgenv().SpamSpeed = 1
loadstring(game:HttpGet("https://raw.githubusercontent.com/BinxGodteli/Auto-parry/main/Op-spam.lua"))()
    local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("SendNotification", {
                Title = "LDQ HUB",
                Text = "Auto Parry has been started!",
                Duration = 3,
    })
    end
    })

AutoParry:AddToggle({
	Name = "Bypass Anticheat (Don't turn off)",
	Default = true,
    Callback = function()
    local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("SendNotification", {
                Title = "LDQ HUB",
                Text = "Bypass Anticheat has been started!",
                Duration = 3,
    })
    end
    })

AutoParry:AddToggle({
    Name = "Auto TP Parry",
    Callback = function(Value)
        if Value then
            local StarterGui = game:GetService("StarterGui")
                    StarterGui:SetCore("SendNotification", {
                        Title = "LDQ HUB",
                        Text = "Auto TP Parry has been started!",
                        Duration = 3,
                    })
            getgenv().god = true
while getgenv().god and task.wait() do
    for _,ball in next, workspace.Balls:GetChildren() do
        if ball then
            if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position, ball.Position)
                if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Highlight") then
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = ball.CFrame * CFrame.new(0, 0, (ball.Velocity).Magnitude * -0.5)
                    game:GetService("ReplicatedStorage").Remotes.ParryButtonPress:Fire()
            end
        end
    end
end
end
        end
        if not Value then
            getgenv().god = false
            local StarterGui = game:GetService("StarterGui")
                    StarterGui:SetCore("SendNotification", {
                        Title = "LDQ HUB",
                        Text = "Auto TP Parry has been disabled!",
                        Duration = 3,
                    })
                    end
    end,
})

local Ability = Window:MakeTab({
	Name ="Abilities",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Ability:AddSection({
	Name = "Lưu ý: Phải chơi xong 1 trận mới dùng được."
})

Ability:AddSection({
	Name = "Note: Must complete 1 match to use."
})

Ability:AddButton({
    Name = "Dash",
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
            Title = "LDQ HUB",
            Text = "You got dash ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Phase Bypass",
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
            Title = "LDQ HUB",
            Text = "You got phase bypass ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Rapture",
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
            Title = "LDQ HUB",
            Text = "You got rapture ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Reaper",
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
            Title = "LDQ HUB",
            Text = "You got reaper ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Freeze",
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
            Title = "LDQ HUB",
            Text = "You got freeze ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Infinity",
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
            Title = "LDQ HUB",
            Text = "You got infinity ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Waypoint",
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
            Title = "LDQ HUB",
            Text = "You got waypoint ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Pull",
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
            Title = "LDQ HUB",
            Text = "You got pull ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Telekinesis",
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
            Title = "LDQ HUB",
            Text = "You got telekinesis ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Raging Deflect",
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
            Title = "LDQ HUB",
            Text = "You got raging deflect ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Swap",
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
            Title = "LDQ HUB",
            Text = "You got swap ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Forcefield",
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
            Title = "LDQ HUB",
            Text = "You got forcefield ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Shadow Step",
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
            Title = "LDQ HUB",
            Text = "You got shadow step ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Super Jump",
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
            Title = "LDQ HUB",
            Text = "You got super jump ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Thunder Dash",
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
            Title = "LDQ HUB",
            Text = "You got thunder dash ability!",
            Duration = 3,
        })
    end,
})

Ability:AddButton({
    Name = "Wind Cloak",
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
            Title = "LDQ HUB",
            Text = "You got wind cloak ability!",
            Duration = 3,
        })
    end,
})

local Misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Discord = Misc:AddSection({
	Name = "Server Discord"
})

Misc:AddButton({
	Name = "Copy Link Discord Server",
	Callback = function()
	setclipboard("https://discord.gg/ppDqYsPUSm")
	end
	})

Misc:AddSection({
	Name = "Inf Skill (No CD)"
})

local upgrades = localPlayer.Upgrades

Misc:AddButton({
    Name = "Inf Dash",
    Callback = function()
        upgrades:WaitForChild("Dash").Value = 999999999999999999
            local StarterGui = game:GetService("StarterGui")
                    StarterGui:SetCore("SendNotification", {
                        Title = "LDQ HUB",
                        Text = "You got inf dash!",
                        Duration = 3,
                    })
    end,
})

Misc:AddButton({
    Name = "Inf Shadow Step",
    Callback = function()
        upgrades:WaitForChild("Shadow Step").Value = 999999999999999999
            local StarterGui = game:GetService("StarterGui")
                    StarterGui:SetCore("SendNotification", {
                        Title = "LDQ HUB",
                        Text = "You got inf shadow step!",
                        Duration = 3,
                    })
    end,
})

Misc:AddButton({
    Name = "Inf Super Jump",
    Callback = function()
        upgrades:WaitForChild("Super Jump").Value = 999999999999999999
            local StarterGui = game:GetService("StarterGui")
                    StarterGui:SetCore("SendNotification", {
                        Title = "LDQ HUB",
                        Text = "You got inf super jump!",
                        Duration = 3,
                    })
    end,
})

Misc:AddButton({
    Name = "Inf Thunder Dash",
    Callback = function()
        upgrades:WaitForChild("Thunder Dash").Value = 999999999999999999
            local StarterGui = game:GetService("StarterGui")
                    StarterGui:SetCore("SendNotification", {
                        Title = "LDQ HUB",
                        Text = "You got inf thunder dash!",
                        Duration = 3,
                    })
    end,
})

local Other = Misc:AddSection({
	Name = "Other"
})

local x2Code = {
    "1BVISITSTHANKS",
    "HALLOWEEN",
    "3MLIKES"
}

Misc:AddButton({
    Name = "Redeem All Codes",
    Callback = function()
        function RedeemCode(value)
            game:GetService("ReplicatedStorage").Remotes.SubmitCodeRequest:InvokeServer(value)
        end
        for i,v in pairs(x2Code) do
            RedeemCode(v)
        end
        local StarterGui = game:GetService("StarterGui")
                StarterGui:SetCore("SendNotification", {
                    Title = "LDQ HUB",
                    Text = "Redeemed all codes!",
                    Duration = 3,
                })
    end,
})

Misc:AddButton({
    Name = "Server Hop",
    Callback = function()
        local StarterGui = game:GetService("StarterGui")
                StarterGui:SetCore("SendNotification", {
                    Title = "LDQ HUB",
                    Text = "Hopping to another server!",
                    Duration = 3,
                })
            local PlaceID = game.PlaceId
                                local AllIDs = {}
                                local foundAnything = ""
                                local actualHour = os.date("!*t").hour
                                local Deleted = false
                                function TPReturner()
                                local Site;
                                if foundAnything == "" then
                                Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
                                else
                                Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
                                end
                                local ID = ""
                                if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                                foundAnything = Site.nextPageCursor
                                end
                                local num = 0;
                                for i,v in pairs(Site.data) do
                                local Possible = true
                                ID = tostring(v.id)
                                if tonumber(v.maxPlayers) > tonumber(v.playing) then
                                for _,Existing in pairs(AllIDs) do
                                if num ~= 0 then
                                if ID == tostring(Existing) then
                                Possible = false
                                end
                                else
                                if tonumber(actualHour) ~= tonumber(Existing) then
                                local delFile = pcall(function()
                                -- delfile("NotSameServers.json")
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                                end)
                                end
                                end
                                num = num + 1
                                end
                                if Possible == true then
                                table.insert(AllIDs, ID)
                                wait()
                                pcall(function()
                                -- writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                                wait()
                                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                                end)
                                wait(4)
                                end
                                end
                                end
                                end
                                function Teleport()
                                while wait() do
                                pcall(function()
                                TPReturner()
                                if foundAnything ~= "" then
                                TPReturner()
                                end
                                end)
                                end
                                end
                                Teleport()
    end,
})

OrionLib:Init()