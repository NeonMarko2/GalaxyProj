
local TextLabel = script.Parent.TextLabel

local TS = game:GetService("TweenService")



game.ReplicatedStorage.RemoteEvents.WarnAttack.OnClientEvent:Connect(function(text)
	
	TextLabel.Text = text
	
	TS:Create(
		TextLabel,
		TweenInfo.new(1, Enum.EasingStyle.Cubic),
		{Position = UDim2.new(0.5, 0, 0.2, 0)}
	):Play()
	
	wait(2)
	
	TS:Create(
		TextLabel,
		TweenInfo.new(1, Enum.EasingStyle.Cubic),
		{Position = UDim2.new(0.5, 0, -0.2, 0)}
	):Play()
	
end)
