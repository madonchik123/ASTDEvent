local ToUse = "Genos [Overdrive]" -- must be a hill unit
repeat wait() until game.Loaded
--Functions
local LoadAntiAfk = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KazeOnTop/Rice-Anti-Afk/main/Wind", true))()
end   
local CheckIfInLobby = function()
   return game:GetService("ReplicatedStorage"):WaitForChild("Lobby").Value
end    
local GetCFrameToPlace = function(Type,WhichOne)
    local CurrentHill = 0
    local ToFind = WhichOne or 1
    if Type == "Hill" then
        for i,v in pairs(game:GetService("Workspace").Placeable.Hill:GetChildren()) do
            CurrentHill = CurrentHill + 1
            if v.Name == "Hill" then
		            
if CurrentHill == ToFind then
		                return v.Hill_Part.CFrame
		            end
		    elseif v.Name == "hill" then
		            if CurrentHill == ToFind then
		                return v.Rock.CFrame
		            end
		    elseif v.Name == "Land" then
		            if CurrentHill == ToFind then
		                return v.Part.CFrame
		            end		            
		    
        
            
end
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
        if String ~= "2" then
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,game:GetService("Workspace").Queue["Raid "..String].ExamDoor,0)
        end
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
    local Towers = {}
    for i,v in pairs(game.Workspace.Unit:GetChildren()) do
        if v.Owner.Value == game.Players.LocalPlayer then
            table.insert(Towers,v)
        end  
    end
    return Towers
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
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes").Input:FireServer(unpack(args)) 
end
local function GetAmountOfItemsIntable(tbl)
	local items = 0
	for index, value in pairs(tbl)do
		if typeof(value) == "table" then -- if the value is a table we reiterate to get the number of items in it
			items = items + getNumberOfItems(value) -- you can add 1 if you want to count the table aswell
		else
			items = items + 1
		end
	end
	return items
end
local UpgradeTower = function()
    local TowerTable = GetTower()
    local Tower = TowerTable[math.random(1,GetAmountOfItemsIntable(TowerTable))]
    if Tower.UpgradeTag.Value ~= Tower.MaxUpgradeTag.Value then
    local args = {
        [1] = "Upgrade",
        [2] = Tower
        }
    
    game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(args))   
    end
end   

wait(4)
ChangeSpeed("2x")
ChangeMode("Normal") 
if CheckIfInLobby() then
--Auto Rejoin
spawn(function()
    while wait(180) do
        local tps = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        local gameid = game.PlaceId
        
        tps:Teleport(gameid,player)        
    end    
end)

wait(3)
LoadAntiAfk()
spawn(function()
while wait() do
JoinCurrentChallenge()
end
end)
else
--Auto Rejoin
spawn(function()
    while wait(900) do
        local tps = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        local gameid = game.PlaceId
        
        tps:Teleport(gameid,player)        
    end    
end)
wait(4)  
LoadAntiAfk()
    spawn(function()
        while wait(2) do
            PlaceTower(ToUse,GetCFrameToPlace("Hill",math.random(1,2)))
            wait(0.5)
            UpgradeTower()
        end
    end)
end
