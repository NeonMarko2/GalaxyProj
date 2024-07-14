
local ReplicatedStorage = game.ReplicatedStorage

local TS = game:GetService("TweenService")

if ReplicatedStorage.Variables.GameStarted.Value == false then
	script.Parent.Enabled = true
else
	script.Parent.Parent:WaitForChild("BossHealth").Enabled = true
end

function JoinedGame()
	
	for i,v in pairs(game.Players:GetPlayers()) do
		
		local listItem = ReplicatedStorage.ReadyMenu.PlayerListItem:Clone()

		listItem.Parent = script.Parent.PlayerList

		listItem.Text = v.Name .."\n Not Ready"
		
		listItem:SetAttribute("Player", v.Name)
		
	end
	
end

function PlayerJoinedGame(player)
	
	local listItem = ReplicatedStorage.ReadyMenu.PlayerListItem:Clone()

	listItem.Parent = script.Parent.PlayerList

	listItem.Text = player.Name .."\n Not Ready"

	listItem:SetAttribute("Player", player.Name)
	
end

JoinedGame()

function Ready()
	
	ReplicatedStorage.RemoteEvents.ReadyUp:FireServer(true)
	
end

function PlayerSetReady(player, value)
	
	for i,v in pairs(script.Parent.PlayerList:GetChildren()) do
		
		if v.ClassName ~= "TextLabel" then
			continue
		end
		
			
		if v:GetAttribute("Player") == player.Name then
				
			v.Text = player.Name .."\n Ready"
				
		end
		
	end
	
end

function LeftGame(player)
	
	for i,v in pairs(script.Parent.PlayerList:GetChildren()) do

		if v.ClassName ~= "TextLabel" then
			continue
		end


		if v:GetAttribute("Player") == player.Name then

			v:Destroy()

		end

	end
	
end

function TweenOut()
	
	TS:Create(script.Parent.Background.ReadyButton, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(-.35, 0, .8, 0)}):Play()
	
	TS:Create(script.Parent.PlayerList, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(1.4, 0, .7, 0)}):Play()
	
	wait(.5)
	
	TS:Create(script.Parent.Background, TweenInfo.new(.5, Enum.EasingStyle.Linear), {Transparency = 1}):Play()
	
	wait(.5)
	
	script.Parent.Parent.BossHealth.Enabled = true
	
end

function StartGame()
	
	TweenOut()
	
end

ReplicatedStorage.RemoteEvents.ReadyUp.OnClientEvent:Connect(PlayerSetReady)

ReplicatedStorage.RemoteEvents.StartGame.OnClientEvent:Connect(StartGame)

game.Players.PlayerAdded:Connect(PlayerJoinedGame)

game.Players.PlayerRemoving:Connect(LeftGame)

script.Parent.Background.ReadyButton.Activated:Connect(Ready)


--function PlayerJoined(player)
	
--	local listItem = ReplicatedStorage.ReadyMenu.PlayerListItem:Clone()

--	listItem.Parent = script.Parent.PlayerList

--	listItem.Text = player.Name ..": Not Ready"
	
--end
