local XanaxUILib = loadstring(game:HttpGet("http://10.0.0.179/ScriptHub/index.txt"))()
local Ui = XanaxUILib:CreateWindow("Example UI7")
local Aimbot = Ui:CreateSection("Aimbot")

--aimbot settings
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Holding = false
local Locked = false
local Victim


Aimbot:CreateLabel("Aimbot Settings")
Aimbot:CreateToggle("Aimbot On/Off", "Turns on the Aimbot", function(Toggled) 
    _G.AimbotEnabled = Toggled  
end)
_G.TeamCheck = false -- If set to true then the script would only lock your aim at enemy team members.
_G.AimPart = "Head" -- Where the aimbot script would lock at.
_G.Sensitivity = 0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.
_G.CircleSides = 64 -- How many sides the FOV circle would have.
_G.CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
_G.CircleTransparency = 0.7 -- Transparency of the circle.
_G.CircleFilled = false -- Determines whether or not the circle is filled.
_G.CircleVisible = false  
Aimbot:CreateLabel("FOV Settings")
Aimbot:CreateToggle("FOV Circle On/Off", "FOV Circle", function(Toggled) 
    _G.CircleVisible = Toggled  
end)
_G.CircleRadius = 16
Aimbot:CreateSlider("Fov Circle Six", "Changes the FOV Circle six", 16, 500, false, function(ws)
   _G.CircleRadius = ws
end)

_G.CircleThickness = 0 -- The thickness of the circle.

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

local function GetClosestPlayer()
	local MaximumDistance = _G.CircleRadius
	local Target

	for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name ~= LocalPlayer.Name then
            if _G.TeamCheck == true then 
                if v.Team ~= LocalPlayer.Team then
                    if workspace:FindFirstChild(v.Name) ~= nil then
                        if workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                            if workspace[v.Name]:FindFirstChild("Humanoid") ~= nil and workspace[v.Name]:FindFirstChild("Humanoid").Health ~= 0 then
                                local ScreenPoint = Camera:WorldToScreenPoint(workspace[v.Name]:WaitForChild("HumanoidRootPart", math.huge).Position)
                                local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                                
                                if VectorDistance < MaximumDistance then
                                    Target = v
                                end
                            end
                        end
                    end
                end
            else
                if workspace:FindFirstChild(v.Name) ~= nil then
                    if workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                        if workspace[v.Name]:FindFirstChild("Humanoid") ~= nil and workspace[v.Name]:FindFirstChild("Humanoid").Health ~= 0 then
                            local ScreenPoint = Camera:WorldToScreenPoint(workspace[v.Name]:WaitForChild("HumanoidRootPart", math.huge).Position)
                            local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                            
                            if VectorDistance < MaximumDistance then
                                Target = v
                            end
                        end
                    end
                end
            end
		end
	end

	return Target
end

UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
        Locked = false
    end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness
    if Holding == true and _G.AimbotEnabled == true then
        TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[_G.AimPart].Position)}):Play()
        Locked = true
    end
end)








--ESP SETTINGS

_G.Configuration = {
   Tracers = false,
   PlayerInfo = false,
   Outlines = false,
   ShowAllyTeam = true,
   UseTeamColor = true
}

local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")

local Players = game:GetService("Players")
local LocalPlayer = game:GetService("Players").LocalPlayer
local DrawedPlayers = {}

local Vector2 = Vector2.new
local RGB = Color3.fromRGB

local function CreateDrawing(object, properties)
   local Object = Drawing.new(object)

   for i, v in pairs(properties) do
       Object[i] = v
   end
   
   return Object
end

local function AddVisuals(player)
   if DrawedPlayers[player.Name] then return end

   DrawedPlayers[player.Name] = {
       Player = player,
       Info = CreateDrawing("Text", {Text = "", Center = true, Outline = true, Size = 16, Transparency = 1, Position = Vector2(0, 0), Color = RGB(255, 255, 255), Visible = false}),
       TracerOutline = CreateDrawing("Line", {Transparency = 1, Thickness = 1.5, From = Vector2(0, 0), To = Vector2(0, 0), Color = RGB(0, 0, 0), Visible = false}),
       Tracer = CreateDrawing("Line", {Transparency = 1, Thickness = 1.5, From = Vector2(0, 0), To = Vector2(0, 0), Color = RGB(255, 255, 255), Visible = false}),
   }
end

local function IsOnTeam(player)
   if LocalPlayer.TeamColor.Color == player.TeamColor.Color then
       return true
   else
       return false
   end
end

local function SetVisuals(table, type, value) --// ugh this is so bad, stupid outlines
   if type == "Color" then
       table.Tracer.Color = value
   elseif type == "Visibility" then
       for i, v in pairs(table) do
           if tostring(i) ~= "Player" then
               v.Visible = value
           end
       end
   end
end

for i, v in pairs(Players:GetPlayers()) do
   if v ~= LocalPlayer then
       AddVisuals(v)
   end
end

Players.PlayerAdded:Connect(function(player)
   AddVisuals(player)
end)

Players.PlayerRemoving:Connect(function(player)
   for i, v in pairs(DrawedPlayers[player.Name]) do
       wait()
       v:Remove()
   end

   wait()
   DrawedPlayers[player.Name] = nil
end)

RunService:BindToRenderStep("Universal", 500, function()
   for i, v in pairs(Players:GetPlayers()) do
       if v ~= LocalPlayer then
           local Player = v
           local DrawedPlayer = DrawedPlayers[Player.Name]

           if DrawedPlayer then
               local Drawings = {
                   Info = DrawedPlayer.Info,
                   Tracer = DrawedPlayer.Tracer,
                   TracerOutline = DrawedPlayer.TracerOutline,
               }
               
               if Player then
                   local LocalCharacter = LocalPlayer.Character
                   local Character = Player.Character

                   if LocalCharacter and Character then
                       local LocalPlayerHumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
                       local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                       if LocalPlayerHumanoidRootPart and HumanoidRootPart then
                           local HumanoidRootPartPosition, PlayerOnScreen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)

                           Drawings.Info.Text = Player.Name
                           Drawings.Info.Position = Vector2(HumanoidRootPartPosition.X, (HumanoidRootPartPosition.Y - (6000 / HumanoidRootPartPosition.Z) / 2) - 20)
                           Drawings.Info.Outline = _G.Configuration.Outlines

                           Drawings.Tracer.From = Vector2(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                           Drawings.Tracer.To = Vector2(HumanoidRootPartPosition.X, HumanoidRootPartPosition.Y)
                           
                           Drawings.TracerOutline.Thickness = (Drawings.Tracer.Thickness * 2)
                           Drawings.TracerOutline.From = Drawings.Tracer.From
                           Drawings.TracerOutline.To = Drawings.Tracer.To
                           

                           if _G.Configuration.UseTeamColor then
                               SetVisuals(Drawings, "Color", Player.TeamColor.Color)
                           else
                               SetVisuals(Drawings, "Color", RGB(255, 255, 255))
                           end

                           Drawings.Info.Visible = _G.Configuration.PlayerInfo
                           Drawings.Tracer.Visible = _G.Configuration.Tracers
                           Drawings.TracerOutline.Visible = _G.Configuration.Outlines

                           if _G.Configuration.ShowAllyTeam then
                               SetVisuals(Drawings, "Visibility", true)
                           else
                               if IsOnTeam(Player) then
                                   SetVisuals(Drawings, "Visibility", false)
                               else
                                   SetVisuals(Drawings, "Visibility", true)
                               end
                           end
                           
                           if not PlayerOnScreen then
                               SetVisuals(Drawings, "Visibility", false)
                           end
                       else
                           SetVisuals(Drawings, "Visibility", false)
                       end
                   else
                       SetVisuals(Drawings, "Visibility", false)
                   end
               else
                   SetVisuals(Drawings, "Visibility", false)
               end
           end
       end
   end
end)
