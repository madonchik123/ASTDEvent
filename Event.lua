local ToUse = "Genos [Overdrive]" -- must be a hill unit
local UpgradeLimit = 3
repeat wait() until game.Loaded
--Auto Rejoin
spawn(function()
    while wait(900) do
        local tps = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        local gameid = game.PlaceId
        
        tps:Teleport(gameid,player)        
    end    
end) 

--Functions
local LoadAntiAfk = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KazeOnTop/Rice-Anti-Afk/main/Wind", true))()
end   
local CheckIfInLobby = function()
   return game:GetService("ReplicatedStorage"):WaitForChild("Lobby").Value
end    
local GetCFrameToPlace = function(Type)
    if Type == "Hill" then
        if game:GetService("Workspace").Placeable.Hill:FindFirstChild("hill") then
            return game:GetService("Workspace").Placeable.Hill:FindFirstChild("hill").Rock.CFrame
        elseif game:GetService("Workspace").Placeable.Hill:FindFirstChild("Hill") then
            return game:GetService("Workspace").Placeable.Hill:FindFirstChild("Hill").Hill_Part.CFrame
        end    
    end   
end
local GetCurrentTimeLeft = function()
local HUD = game.Players.LocalPlayer.PlayerGui:WaitForChild("HUD")
local timer = string.gsub(HUD.EventFrame.ChallengeTimer.Text,"Challenge Changes In: ","")
local timervalue = string.gsub(timer,"m","")
return tonumber(timervalue)
end 
local GetCurrentEventChallenge = function()
local HUD = game.Players.LocalPlayer.PlayerGui:WaitForChild("HUD")
local Event = string.gsub(HUD.EventFrame.Challenge.Milestone1.Text,"Kill Enemies on ","")
local Event2 = string.gsub(Event,"<u>","")
local Event3 = string.gsub(Event2,"</u>","")
return Event3
end 
local JoinCurrentChallenge = function()
    if GetCurrentTimeLeft() == nil then return end
    if GetCurrentTimeLeft() > 1 then
        if string.find(GetCurrentEventChallenge(),"Trial") then
        local String = string.gsub(GetCurrentEventChallenge(),"Trial","")
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,game:GetService("Workspace").Queue["Exam"..String].ExamDoor,0)
        elseif string.find(GetCurrentEventChallenge(),"Raid")  then
        local String = string.gsub(GetCurrentEventChallenge(),"Raid","")
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,game:GetService("Workspace").Queue["Raid "..String].ExamDoor,0)
        end   
    end    
end    
local ChangeSpeed = function(Speed)
    if Speed == "2x" then
    local args = {
        [1] = "SpeedChange",
        [2] = true
    }
        
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes").Input:FireServer(unpack(args))
    elseif Speed == "1x" then
    local args = {
        [1] = "SpeedChange",
        [2] = false
    }
        
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes").Input:FireServer(unpack(args))
    end   
end  
local ChangeMode = function(Mode)
    if Mode == "Normal" then
        local args = {
            [1] = "VoteGameMode",
            [2] = Mode
        }
        
        game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(args))
    elseif Mode == "Extreme" then
        local args = {
            [1] = "VoteGameMode",
            [2] = Mode
        }
        
        game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(args))
    end   
end
local GetTower = function(TowerName)
   for i,v in pairs(game.Workspace.Unit:GetChildren()) do
      if v.Owner.Value == game.Players.LocalPlayer then
          return v
      end  
   end
end
local PlaceTower = function(TowerName,CFrame)
   local args = {
    [1] = "Summon",
        [2] = {
            ["Rotation"] = 0,
            ["cframe"] = CFrame,
            ["Unit"] = TowerName
        }
    }
    
    game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(args)) 
end    
local UpgradeTower = function(TowerName)
    local Tower = GetTower(TowerName)
    local args = {
        [1] = "Upgrade",
        [2] = Tower
        }
    
    game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(args))   
end    
if CheckIfInLobby() then
wait(3)
LoadAntiAfk()
spawn(function()
while wait() do
JoinCurrentChallenge()
end
end)
else
wait(4)  
LoadAntiAfk()
ChangeSpeed("2x")
ChangeMode("Normal")
repeat wait()
PlaceTower(ToUse,GetCFrameToPlace("Hill"))
until game:GetService("Workspace").Unit:FindFirstChild(ToUse)
repeat wait()
UpgradeTower(ToUse)
wait(0.5)
until workspace.Unit:FindFirstChild(ToUse):WaitForChild("UpgradeTag").Value == UpgradeLimit
end
