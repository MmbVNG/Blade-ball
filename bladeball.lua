local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = players.LocalPlayer
local BASE_THRESHOLD = 0.2
local VELOCITY_SCALING_FACTOR_FAST = 0.05
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

local Window = Fluent:CreateWindow({
    Title = "LDQ HUB",
    SubTitle = "by binxgodteli",
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
    Misc = Window:AddTab({ Title = "Misc", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "" })
}

if character then
    print("Character found | LDQ HUB")
else
    print("Character not found | LDQ HUB")
    return
end
 
 local function chooseNewFocusedBall()
    local balls = ballsFolder:GetChildren()
    for _, ball in ipairs(balls) do
        if ball:GetAttribute("realBall") ~= nil and ball:GetAttribute("realBall") == true then
            focusedBall = ball
            print(focusedBall.Name)
            break
        elseif ball:GetAttribute("target") ~= nil then
            focusedBall = ball
            print(focusedBall.Name)
            break
        end
    end
    
    
    if focusedBall == nil then
        print("Debug: Could not find a ball that's the realBall or has a target")
        wait(1)
        chooseNewFocusedBall()
    end
    return focusedBall
end

local function getDynamicThreshold(ballVelocityMagnitude)
    if ballVelocityMagnitude > 60 then
        return math.max(0.20, BASE_THRESHOLD - (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR_FAST))
    else
        return math.min(0.01, BASE_THRESHOLD + (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR_SLOW))
    end
end

local function timeUntilImpact(ballVelocity, distanceToPlayer, playerVelocity)
    if not character then return end
    local directionToPlayer = (character.HumanoidRootPart.Position - focusedBall.Position).Unit
    local velocityTowardsPlayer = ballVelocity:Dot(directionToPlayer) - playerVelocity:Dot(directionToPlayer)
    
    if velocityTowardsPlayer <= 0 then
        return math.huge
    end
    
    return (distanceToPlayer - sliderValue) / velocityTowardsPlayer
end

local function updateDistanceVisualizer()
    local charPos = character and character.PrimaryPart and character.PrimaryPart.Position
    if charPos and focusedBall then
        if distanceVisualizer then
            distanceVisualizer:Destroy()
        end

        local timeToImpactValue = timeUntilImpact(focusedBall.Velocity, (focusedBall.Position - charPos).Magnitude, character.PrimaryPart.Velocity)
        local ballFuturePosition = focusedBall.Position + focusedBall.Velocity * timeToImpactValue

        distanceVisualizer = Instance.new("Part")
        distanceVisualizer.Size = Vector3.new(1, 1, 1)
        distanceVisualizer.Anchored = true
        distanceVisualizer.CanCollide = false
        distanceVisualizer.Position = ballFuturePosition
        distanceVisualizer.Parent = workspace    
    end
end

local function checkIfTarget()
    for _, v in pairs(ballsFolder:GetChildren()) do
        if v:IsA("Part") and v.BrickColor == BrickColor.new("Really red") then 
            print("Ball is targetting player | LDQ HUB")
            return true 
        end 
    end 
    return false
end

local function isCooldownInEffect(uigradient)
    return uigradient.Offset.Y < 0.5
end


local function checkBallDistance()
    if not character or not checkIfTarget() then return end

    local charPos = character.PrimaryPart.Position
    local charVel = character.PrimaryPart.Velocity

    if focusedBall and not focusedBall.Parent then
        print("Focused ball lost parent, choosing a new focused ball | LDQ HUB")
        chooseNewFocusedBall()
    end
    if not focusedBall then 
        print("No focused ball | LDQ HUB")
        chooseNewFocusedBall()
    end

    local ball = focusedBall
    local distanceToPlayer = (ball.Position - charPos).Magnitude
    local ballVelocityTowardsPlayer = ball.Velocity:Dot((charPos - ball.Position).Unit)
    
    if distanceToPlayer < 15 then
        parryButtonPress:Fire()
        task.wait()
    end
    end


local function autoParryCoroutine()
    while isRunning do
        checkBallDistance()
        updateDistanceVisualizer()
        task.wait()
    end
end



localPlayer.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    chooseNewFocusedBall()
    updateDistanceVisualizer()
end)

localPlayer.CharacterRemoving:Connect(function()
    if distanceVisualizer then
        distanceVisualizer:Destroy()
        distanceVisualizer = nil
    end
end)



local function startAutoParry()
    print("Started Auto Parry | LDQ HUB")
    
    chooseNewFocusedBall()
    
    isRunning = true
    local co = coroutine.create(autoParryCoroutine)
    coroutine.resume(co)
end

local function stopAutoParry()
    isRunning = false
end

local parryon = false
local autoparrydistance = 11

 

local Debug = false -- Set this to true if you want my debug output.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")


local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9) -- A second argument in waitforchild what could it mean?

local Balls = workspace:WaitForChild("Balls", 9e9)


-- Functions


local function print(...) -- Debug print.

        if Debug then

                warn(...)

        end

end


local function VerifyBall(Ball) -- Returns nil if the ball isn't a valid projectile; true if it's the right ball.

        if typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true then

                return true

        end

end


local function IsTarget() -- Returns true if we are the current target.

        return (Player.Character and Player.Character:FindFirstChild("Highlight"))

end


local function Parry() -- Parries.

        ReplicatedStorage.Remotes.ParryButtonPress:Fire()

end


-- The actual code


Balls.ChildAdded:Connect(function(Ball)

        if not VerifyBall(Ball) then

                return

        end

        

        print(`Ball Spawned: {Ball}`)

        

        local OldPosition = Ball.Position

        local OldTick = tick()

        

        Ball:GetPropertyChangedSignal("Position"):Connect(function()

                if IsTarget() then -- No need to do the math if we're not being attacked.

                        local Distance = (Ball.Position - workspace.CurrentCamera.Focus.Position).Magnitude

                        local Velocity = (OldPosition - Ball.Position).Magnitude -- Fix for .Velocity not working. Yes I got the lowest possible grade in accuplacer math.

                        

                        print(`Distance: {Distance}\nVelocity: {Velocity}\nTime: {Distance / Velocity}`)

                

                        if (Distance / Velocity) <= autoparrydistance then -- Sorry for the magic number. This just works. No, you don't get a slider for this because it's 2am.
if parryon == true then
                                Parry()

                        end

                end

end
                

                if (tick() - OldTick >= 1/60) then -- Don't want it to update too quickly because my velocity implementation is aids. Yes, I tried Ball.Velocity. No, it didn't work.

                        OldTick = tick()

                        OldPosition = Ball.Position

                end

        end)

end)

local UserInputService = game:GetService("UserInputService")

local parryon1 = false
local LocalPlayer = game:GetService("Players")
local Balls1 = workspace:WaitForChild("Balls")

local IsTargeted = false
local CanHit = false

function VerifyBall1()
local RealBall
for i, v in pairs(Balls1:GetChildren()) do
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
    if parryon1 == true then
            ReplicatedStorage.Remotes.ParryButtonPress:Fire()
end
end
end

game:GetService('RunService').PostSimulation:Connect(function()
    IsTargeted = IsTarget1()
        DeflectBall()
end)

local Options = Fluent.Options

local ToggleAutoParryOp = Tabs.AutoParry:AddToggle("MyToggle", {Title = "Auto Parry Op(don't use with Auto Parry Legit)", Default = false })

ToggleAutoParryOp:OnChanged(function(Value)
if Value then
parryon1 = true
            local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("SendNotification", {
                Title = "LDQ HUB",
                Text = "Auto Parry Op has been started!",
                Duration = 3,
            })
        else
            parryon1 = false
            local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("SendNotification", {
                Title = "LDQ HUB",
                Text = "Auto Parry Op has been disabled!",
                Duration = 3,
            })
        end
    end)

local ToggleAutoParry = Tabs.AutoParry:AddToggle("MyToggle", {Title = "Auto Parry Legit(Some Time Die To Look Legit)", Default = false })

    ToggleAutoParry:OnChanged(function(Value)
        if Value then
            parryon = true
            local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("SendNotification", {
                Title = "LDQ HUB",
                Text = "Auto Parry has been started!",
                Duration = 3,
            })
        else
        parryon = false
            local StarterGui = game:GetService("StarterGui")
            StarterGui:SetCore("SendNotification", {
                Title = "LDQ HUB",
                Text = "Auto Parry has been disabled!",
                Duration = 3,
            })
        end
    end)

    Options.MyToggle:SetValue(false)

Tabs.AutoParry:AddButton({
        Title = "Spam",
        Description = "Spam Button",
        Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MmbVNG/Blade-ball/main/Spam.lua"))()
        end
    })

local ToggleAutoFarm = Tabs.AutoParry:AddToggle("MyToggle", {Title = "Auto Farm (Need Turn On Auto Parry Op)", Default = false })

ToggleAutoFarm:OnChanged(function(Value)
if Value then
            local StarterGui = game:GetService("StarterGui")
                    StarterGui:SetCore("SendNotification", {
                        Title = "LDQ HUB",
                        Text = "Auto Farm has been started!",
                        Duration = 3,
                    })
            getgenv().god = true
while getgenv().god and task.wait() do
    for _,ball in next, workspace.Balls:GetChildren() do
        if ball then
            if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position, ball.Position)
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = ball.CFrame * CFrame.new(0, -11, (ball.Velocity).Magnitude * -0.5)
                                       if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Highlight") then
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
                        Text = "Auto Farm has been disabled!",
                        Duration = 3,
                    })
        end
    end)
    
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
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
            Title = "LDQ HUB",
            Text = "You got wind cloak ability!",
            Duration = 3,
        })
    end,
})
  
Tabs.Misc:AddButton({
	Title = "Copy Link Discord Server",
	Description = "",
	Callback = function()
	setclipboard("https://discord.gg/ppDqYsPUSm")
	end
	})
  
  local upgrades = localPlayer.Upgrades

Tabs.Misc:AddButton({
    Title = "Inf Dash",
    Description = "",
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

Tabs.Misc:AddButton({
    Title = "Inf Super Jump",
    Description = "",
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

Tabs.Misc:AddButton({
    Title = "Inf Thunder Dash",
    Description = "",
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
  
  local x2Code = {
    "1BVISITSTHANKS",
    "HALLOWEEN",
    "HAPPYHALLOWEEN", 
    "3MLIKES"
}

Tabs.Misc:AddButton({
    Title = "Redeem All Codes",
    Description = "",
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

Tabs.Misc:AddButton({
    Title = "Server Hop",
    Description = "",
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
    Title = "LDQ HUB",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
