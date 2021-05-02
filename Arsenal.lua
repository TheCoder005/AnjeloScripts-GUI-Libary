
    
    --tabs
    local Main = Window:NewTab("Main")
    local AimbotSettings = Main:NewSection("Aimbot Settings")
    local ESPSetings = Main:NewSection("ESP Settings")
    local Player = Window:NewTab("Player")
    local PlayerSection = Player:NewSection("Player")
    local Settings = Window:NewTab("Settings")
    local SettingsSection = Settings:NewSection("Settings")
    --MainSection
    AimbotSettings:NewButton("Aimbot", "Injects Aimbot", function()
        print("Clicked")
        
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local GuiService = game:GetService("GuiService")
        
        local LocalPlayer = Players.LocalPlayer
        local Mouse = LocalPlayer:GetMouse()
        local Camera = workspace.CurrentCamera
        local sc = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        local Down = false
        local Inset = GuiService:GetGuiInset()
        
        --// Options \\--
        getgenv().Options = {
            Enabled = true,
            TeamCheck = true,
            Triggerbot = false,
            Smoothness = true,
            AimPart = "Head",
            FOV = 150
        }
        
        --// Functions \\--
        local gc = function()
        	local nearest = math.huge
        	local nearplr
        	for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        		if v ~= game:GetService("Players").LocalPlayer and v.Character and v.Character:FindFirstChild(Options.AimPart) then
        			if Options.TeamCheck then
        				if game:GetService("Players").LocalPlayer.Team ~= v.Team then
                            local pos = Camera:WorldToScreenPoint(v.Character[Options.AimPart].Position)
                            local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + Inset.Y - sc.Y) ^ 2)
                            if diff < nearest and diff < Options.FOV then
                                nearest = diff
                                nearplr = v
                            end
                        end
        			else
        				local pos = Camera:WorldToScreenPoint(v.Character[Options.AimPart].Position)
        				local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + Inset.Y - sc.Y) ^ 2)
        				if diff < nearest and diff < Options.FOV then
        					nearest = diff
        					nearplr = v
                        end
        			end
        		end
        	end
        	return nearplr
        end -- google chrome made this but i modified it for it to use teamcheck
        
        function Circle()
            local circ = Drawing.new('Circle')
            circ.Transparency = 1
            circ.Thickness = 1.5
            circ.Visible = true
            circ.Color = Color3.fromRGB(255,255,255)
        	circ.Filled = false
        	circ.NumSides = 150
            circ.Radius = Options.FOV
            return circ
        end
        
        curc = Circle()
        
        --// Main \\--
        UserInputService.InputBegan:Connect(function( input )
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                Down = true
        	end
        end)
        
        UserInputService.InputEnded:Connect(function( input )
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                Down = false
            end
        end)
        
        RunService.RenderStepped:Connect(function( ... )
            if Options.Enabled then
                if Down then
                    if gc() ~= nil and gc().Character:FindFirstChild(Options.AimPart) then
                        if Options.Smoothness then
                            pcall(function( ... )
                                local Info = TweenInfo.new(0.05,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
                                game:GetService("TweenService"):Create(Camera,Info,{
                                    CFrame = CFrame.new(Camera.CFrame.p,gc().Character[Options.AimPart].CFrame.p)
                                }):Play()
                            end)
                        else
                            pcall(function()
                                Camera.CFrame = CFrame.new(Camera.CFrame.p,gc().Character[Options.AimPart].CFrame.p)
                            end)
                        end
                    end
                end
                curc.Visible = true
                curc.Position = Vector2.new(Mouse.X, Mouse.Y+Inset.Y)
                curc.Radius = Options.FOV
            else
                -- do nothing except remove the fov
                curc.Visible = true
            end
        end)
    end)
        
    ESPSetings:NewButton("ESP", "Injects ESP", function()
        print("Clicked")
        local Holder = Instance.new("Folder", game.CoreGui)
        Holder.Name = "ESP"
        
        local Box = Instance.new("BoxHandleAdornment")
        Box.Name = "nilBox"
        Box.Size = Vector3.new(4, 7, 4)
        Box.Color3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
        Box.Transparency = 0.7
        Box.ZIndex = 0
        Box.AlwaysOnTop = true
        Box.Visible = true
        
        local NameTag = Instance.new("BillboardGui")
        NameTag.Name = "nilNameTag"
        NameTag.Enabled = false
        NameTag.Size = UDim2.new(0, 200, 0, 50)
        NameTag.AlwaysOnTop = true
        NameTag.StudsOffset = Vector3.new(0, 1.8, 0)
        local Tag = Instance.new("TextLabel", NameTag)
        Tag.Name = "Tag"
        Tag.BackgroundTransparency = 1
        Tag.Position = UDim2.new(0, -50, 0, 0)
        Tag.Size = UDim2.new(0, 300, 0, 20)
        Tag.TextSize = 20
        Tag.TextColor3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
        Tag.TextStrokeColor3 = Color3.new(0 / 255, 0 / 255, 0 / 255)
        Tag.TextStrokeTransparency = 0.4
        Tag.Text = "nil"
        Tag.Font = Enum.Font.SourceSansBold
        Tag.TextScaled = false
        
        local LoadCharacter = function(v)
        	repeat wait() until v.Character ~= nil
        	v.Character:WaitForChild("Humanoid")
        	local vHolder = Holder:FindFirstChild(v.Name)
        	vHolder:ClearAllChildren()
        	local b = Box:Clone()
        	b.Name = v.Name .. "Box"
        	b.Adornee = v.Character
        	b.Parent = vHolder
        	local t = NameTag:Clone()
        	t.Name = v.Name .. "NameTag"
        	t.Enabled = true
        	t.Parent = vHolder
        	t.Adornee = v.Character:WaitForChild("Head", 5)
        	if not t.Adornee then
        		return UnloadCharacter(v)
        	end
        	t.Tag.Text = v.Name
        	b.Color3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
        	t.Tag.TextColor3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
        	local Update
        	local UpdateNameTag = function()
        		if not pcall(function()
        			v.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        			local maxh = math.floor(v.Character.Humanoid.MaxHealth)
        			local h = math.floor(v.Character.Humanoid.Health)
        			t.Tag.Text = v.Name .. "\n" .. ((maxh ~= 0 and tostring(math.floor((h / maxh) * 100))) or "0") .. "%  " .. tostring(h) .. "/" .. tostring(maxh)
        		end) then
        			Update:Disconnect()
        		end
        	end
        	UpdateNameTag()
        	Update = v.Character.Humanoid.Changed:Connect(UpdateNameTag)
        end
        
        local UnloadCharacter = function(v)
        	local vHolder = Holder:FindFirstChild(v.Name)
        	if vHolder and (vHolder:FindFirstChild(v.Name .. "Box") ~= nil or vHolder:FindFirstChild(v.Name .. "NameTag") ~= nil) then
        		vHolder:ClearAllChildren()
        	end
        end
        
        local LoadPlayer = function(v)
        	local vHolder = Instance.new("Folder", Holder)
        	vHolder.Name = v.Name
        	v.CharacterAdded:Connect(function()
        		pcall(LoadCharacter, v)
        	end)
        	v.CharacterRemoving:Connect(function()
        		pcall(UnloadCharacter, v)
        	end)
        	v.Changed:Connect(function(prop)
        		if prop == "TeamColor" then
        			UnloadCharacter(v)
        			wait()
        			LoadCharacter(v)
        		end
        	end)
        	LoadCharacter(v)
        end
        
        local UnloadPlayer = function(v)
        	UnloadCharacter(v)
        	local vHolder = Holder:FindFirstChild(v.Name)
        	if vHolder then
        		vHolder:Destroy()
        	end
        end
        
        for i,v in pairs(game:GetService("Players"):GetPlayers()) do
        	spawn(function() pcall(LoadPlayer, v) end)
        end
        
        game:GetService("Players").PlayerAdded:Connect(function(v)
        	pcall(LoadPlayer, v)
        end)
        
        game:GetService("Players").PlayerRemoving:Connect(function(v)
        	pcall(UnloadPlayer, v)
        end)
        
        game:GetService("Players").LocalPlayer.NameDisplayDistance = 0
    end)
    
    --Player
    
    PlayerSection:NewSlider("WalkSpeed", "changes how fast you walk", 500, 16, function(s) -- 500 (MaxValue) | 0 (MinValue)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
    end)
    
    PlayerSection:NewSlider("Jump Power", "changes how high you jump", 500, 50, function(s) -- 500 (MaxValue) | 0 (MinValue)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
    end)
    
    -- Settings
    
    SettingsSection:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
    	Library:ToggleUI()
    end)
