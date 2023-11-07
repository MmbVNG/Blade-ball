local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false 
gui.Parent = game.CoreGui 

local frame = Instance.new("Frame")
frame.Position = UDim2.new(0, 10, 0, 10)
frame.Size = UDim2.new(0, 150, 0, 75)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui

local button = Instance.new("TextButton")
button.Text = "LDQ HUB"
button.Size = UDim2.new(1, -20, 1, -20)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.new(1, 1, 1)
button.BorderColor3 = Color3.new(0, 0, 0)
button.BorderSizePixel = 2
button.Font = Enum.Font.SourceSans
button.TextColor3 = Color3.new(0, 0, 0)
button.TextSize = 16
button.Parent = frame

local activated = false

local function toggle()
    activated = not activated
    button.Text = activated and "Spam on" or "Spam off"
    
    while activated do
        local args = {
            [1] = 1.5,
            [2] = CFrame.new(-254.2939910888672, 112.13581848144531, -119.27256774902344) * CFrame.Angles(-2.029526710510254, 0.5662040710449219, 2.314905881881714),
            [3] = {
                ["2617721424"] = Vector3.new(-273.400146484375, -724.8031005859375, -20.92414093017578),
                
            },
            [4] = {
                [1] = 910,
                [2] = 154
            }
        }

        game:GetService("ReplicatedStorage").Remotes.ParryAttempt:FireServer(unpack(args))
        game:GetService("RunService").Stepped:Wait()
    end
end

button.MouseButton1Click:Connect(toggle)
