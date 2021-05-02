local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("AnjeloScripts ", Theme)

--Tabs

local Main = Window:NewTab("Main")
local MainSction = Main:NewSection("Main")
local Player = Window:NewTab("Player")
local PlayerSection = Player:NewSection("Player")
local Settings = Window:NewTab("Settings")
local SettingsSection = Settings:NewSection("Settings")

--Main
MainSction:NewToggle("AutoFarm", "Turns on auto farm still have not coded it to turn off", function(state)
    if state then
        shared.Enabled = true
          shared.Settings = {
          CanGetScroll = true,
          CanRankUp    = false,
          AllowBoss    = false,
          PlayerHeight = -15, -- If u got a free exploit, change this to above -20
          TweenSpeed = 1,
          }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Godne8825/Avakir/Scripts/Shinobi%20Life%202%20%5BV%3A%201.7%5D", true))()
    else
        print("Toggle Off")
    end
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
