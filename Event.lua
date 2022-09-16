local ToUse = "Genos [Overdrive]" -- must be a hill unit
local UpgradeLimit = 3
local StartWith = 1

repeat wait() until game.Loaded
wait(2)
xpcall(function()
repeat wait() until game:GetService("Workspace").Camera:FindFirstChild(game.Players.LocalPlayer.Name)
repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end,function()
wait(6)
end)
--Functions
local LoadAntiAfk = function()
    spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/KazeOnTop/Rice-Anti-Afk/main/Wind", true))()
    end)
end
local AutoRejoin = function(Time)
    local TimeToWait = Time or 900
    spawn(function()
        while wait(TimeToWait) do
            local tps = game:GetService("TeleportService")
            local player = game.Players.LocalPlayer
            local gameid = game.PlaceId

            tps:Teleport(gameid,player)
        end
    end)
end
local CheckIfInLobby = function()
    return game:GetService("ReplicatedStorage"):WaitForChild("Lobby").Value
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
local GetAmountOfItemsInModel = function(Model)
    local Amount = 0
    for i,v in pairs(Model:GetChildren()) do
        Amount = Amount + 1
    end
    return Amount
end
local GetAmountOfTowersPlaced = function(TowerName)
    local Towers = 0
    local Tower = TowerName or ToUse
    for i,v in pairs(game.Workspace:WaitForChild("Unit"):GetChildren()) do
        if v:WaitForChild("Owner").Value == game.Players.LocalPlayer and v.Name == Tower then
            Towers = Towers + 1
        end
    end
    return Towers
end
local GetCFrameToPlace = function(Type,WhichOne)
    local CurrentHill = 0
    local ToFind = WhichOne or 1
    if Type == "Hill" then
        for i,v in pairs(game:GetService("Workspace"):WaitForChild("Placeable").Hill:GetChildren()) do
            CurrentHill = CurrentHill + 1
            if v.Name == "Hill" and v:FindFirstChild("Hill_Part") then
                if CurrentHill == ToFind and v.Hill_Part.CFrame ~= nil then
                    return v.Hill_Part.CFrame + Vector3.new(0,2,0)
                end
            elseif v.Name == "Hill" and v:FindFirstChild("Part") then
                if CurrentHill == ToFind and v.PrimaryPart.CFrame ~= nil then
                    return v.PrimaryPart.CFrame + Vector3.new(0,2,0)
                end
            elseif v.Name == "hill" and v:FindFirstChild("Rock") then
                if CurrentHill == ToFind and v.Rock.CFrame ~= nil then
                    return v.Rock.CFrame + Vector3.new(0,2,0)
                end
            end
        end
    end
end
local GetCurrentTimeLeft = function()
    local HUD = game.Players.LocalPlayer.PlayerGui:WaitForChild("HUD")
    local timer = string.gsub(HUD:WaitForChild("EventFrame"):WaitForChild("ChallengeTimer").Text,"Challenge Changes In: ","")
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
            wait()
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,game:GetService("Workspace").Queue["Exam"..String].ExamDoor,1)
        elseif string.find(GetCurrentEventChallenge(),"Raid")  then
            local String = string.gsub(GetCurrentEventChallenge(),"Raid","")
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,game:GetService("Workspace").Queue["Raid "..String].ExamDoor,0)
            wait()
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,game:GetService("Workspace").Queue["Raid "..String].ExamDoor,1)
        end
    else
        AutoRejoin(120)
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
    if CFrame == nil then return end
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
local UpgradeTower = function()
    pcall(function()
        local TowerTable = GetTower()
        local Tower = TowerTable[math.random(1,GetAmountOfItemsIntable(TowerTable))]
        if Tower.UpgradeTag.Value ~= Tower.MaxUpgradeTag.Value and Tower.UpgradeTag.Value ~= UpgradeLimit then
            local args = {
                [1] = "Upgrade",
                [2] = Tower
            }

            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(args))
        end
    end)
end
wait(4)
ChangeSpeed("2x")
ChangeMode("Normal")
if game:GetService("ReplicatedStorage").Map.Value == "Raid2" then
   StartWith = 3 
end    
if CheckIfInLobby() then
    wait(3)
    AutoRejoin(180)
    LoadAntiAfk()
    spawn(function()
        while wait() do
            JoinCurrentChallenge()
        end
    end)
else
    LoadAntiAfk()
    AutoRejoin(900)
    wait(2)
    spawn(function()
        while wait() do
            if GetAmountOfTowersPlaced(ToUse) < 3 then
                for i = StartWith,GetAmountOfItemsInModel(game.Workspace.Placeable.Hill) do
                    wait(0.05)
                    PlaceTower(ToUse,GetCFrameToPlace("Hill",i))
                end
            end
            wait(0.5)
            UpgradeTower()
        end
    end)
end
