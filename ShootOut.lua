 local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
        local Window = Library.CreateLib("AnjeloScripts ", Theme)
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
        --tabs
        local Main = Window:NewTab("Main")
        local AimbotSettings = Main:NewSection("Aimbot Settings")
        local ESPSetings = Main:NewSection("ESP Settings")
        local Player = Window:NewTab("Player")
        local PlayerSection = Player:NewSection("Player")
        local Settings = Window:NewTab("Settings")
        local SettingsSection = Settings:NewSection("Settings")
        
        --// Aimbot \\--
        local a = require(game:GetService("ReplicatedFirst")["_0xS0URC3X"].Shared.AimAssistSettings)
        a.MaxScreenCoverage = 0
        a.MaxKDR = 0
        a.MaxRange = 0
        
        AimbotSettings:NewToggle("SoftAim", "ToggleInfo", function(state)
            if state then
                print("Toggle On")
                a.MaxScreenCoverage = 999999
                a.MaxKDR = 99999999.99999999
                a.MaxRange = 999999999
            else
                print("Toggle Off")
                a.MaxScreenCoverage = 0
                a.MaxKDR = 0
                a.MaxRange = 0
            end
        end)
        
        AimbotSettings:NewSlider("FOV", "Changes the size of the ring", 500, 1, function(s) -- 500 (MaxValue) | 0 (MinValue)
            getgenv().Options = {
                    Enabled = true,
                    TeamCheck = true,
                    Triggerbot = false,
                    Smoothness = true,
                    AimPart = "Head",
                    FOV = s
                } 
        end)
        --// ESP \\--
                
        ESPSetings:NewToggle("ToggleText", "ToggleInfo", function(state)
            if state then
                print("Toggle On")
                local color = BrickColor.new(50,0,250)
                local transparency = .8
                
                local Players = game:GetService("Players")
                local function _ESP(c)
                  repeat wait() until c.PrimaryPart ~= nil
                  for i,p in pairs(c:GetChildren()) do
                    if p.ClassName == "Part" or p.ClassName == "MeshPart" then
                      if p:FindFirstChild("shit") then p.shit:Destroy() end
                      local a = Instance.new("BoxHandleAdornment",p)
                      a.Name = "shit"
                      a.Size = p.Size
                      a.Color = color
                      a.Transparency = transparency
                      a.AlwaysOnTop = true    
                      a.Visible = true    
                      a.Adornee = p
                      a.ZIndex = true    
                
                    end
                  end
                end
                local function ESP()
                  for i,v in pairs(Players:GetChildren()) do
                    if v ~= game.Players.LocalPlayer then
                      if v.Character then
                        _ESP(v.Character)
                      end
                      v.CharacterAdded:Connect(function(chr)
                        _ESP(chr)
                      end)
                    end
                  end
                  Players.PlayerAdded:Connect(function(player)
                    player.CharacterAdded:Connect(function(chr)
                      _ESP(chr)
                    end)  
                  end)
                end
                ESP()
            else
                print("Toggle Off")
            end
        end)
        
        
        --// Player \\--
        PlayerSection:NewSlider("WalkSpeed", "changes how fast you walk", 500, 16, function(s) -- 500 (MaxValue) | 0 (MinValue)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
        end)
    
        PlayerSection:NewSlider("Jump Power", "changes how high you jump", 500, 50, function(s) -- 500 (MaxValue) | 0 (MinValue)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
        end)
        --// Settings \\--
        SettingsSection:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
    	    Library:ToggleUI()
        end)
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
            circ.Radius = Options.FOV or 16
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
