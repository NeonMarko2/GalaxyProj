
local PlayersReady = {}

local ReplicatedStorage = game.ReplicatedStorage

local GameStarted = false

game.Players.PlayerAdded:Connect(function(player)
	
	PlayersReady[player] = false
	
	player.CharacterAdded:Connect(function()
		
		local Highlight = Instance.new("Highlight", player.Character)
		
		Highlight.OutlineColor = Color3.new(1, 1, 1)
		
		Highlight.FillTransparency = 1
		
		Highlight.OutlineTransparency = .5
		
	end)
	
end)

game.Players.PlayerRemoving:Connect(function(player)
	
	PlayersReady[player] = nil
	
	CheckPlayersReady()
	
end)

function PlayerReadyUp(player, value)
	
	PlayersReady[player] = value
	
	print(player.Name .." is ready: ".. tostring(PlayersReady[player]))
	
	ReplicatedStorage.RemoteEvents.ReadyUp:FireAllClients(player, value)
	
	CheckPlayersReady()
	
end

function CheckPlayersReady()
	
	if GameStarted then
		return
	end
	
	local AllReady = true
	
	for i,v in pairs(PlayersReady) do
		
		if v == false then
			
			AllReady = false
			
		end
		
	end
	
	if AllReady then
		
		GameStarted = true
		
		ReplicatedStorage.Variables.GameStarted.Value = true
		
		print("StartGame")
		ReplicatedStorage.RemoteEvents.StartGame:FireAllClients()
		script.Parent.GalaxyAI.StartAi:Fire()
		
	else
		
		print("Not all ready")
		
	end
	
end

game.ReplicatedStorage.RemoteEvents.ReadyUp.OnServerEvent:Connect(PlayerReadyUp)
