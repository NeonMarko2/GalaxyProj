
local TS = game:GetService("TweenService")

local RemoteEvents = game.ReplicatedStorage.RemoteEvents

local player = game.Players.LocalPlayer

	
game.Workspace.Danger.ChildAdded:Connect(function(danger)
	
	repeat wait() until danger.PrimaryPart
	
	while danger.PrimaryPart do
		
		local t = 0
		
		if danger.PrimaryPart.Transparency == 0 then
			t = 1
		end
		
		for i,v in pairs(danger:GetChildren()) do
			
			v.Transparency = t
			
		end
		
		wait(.075)
		
	end
	
end)



game.Workspace.Beams.ChildAdded:Connect(function(beam)
	
	TS:Create(
		beam,
		TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
		{Size = Vector3.new(beam.Size.X, 0, beam.Size.Z)}
	):Play()
	
	local distance = (player.Character.HumanoidRootPart.Position - Vector3.new(beam.Position.X, 0, beam.Position.Z)).Magnitude
	
	if distance < 15 then
		
		script.Parent.CameraShake.SetStrength:Fire(.5)
	
	end
	
end)



game.Workspace.Pullers.ChildAdded:Connect(function(puller)
	
	local OriginPos = puller.Position
	
	puller.Position -= Vector3.new(0,5,0)
	
	puller.Transparency = 1
	
	TS:Create(
		puller,
		TweenInfo.new(1),
		{Position = OriginPos, Transparency = 0}
	):Play()
	
end)



game.Workspace.Debree.ChildAdded:Connect(function(debree)
	
	debree.Transparency = 1
	
	TS:Create(
		debree,
		TweenInfo.new(.5),
		{Transparency = 0}
	):Play()
	
end)


game.Workspace.Debree.ChildRemoved:Connect(function(debree)
	
	local deb = debree:Clone()
	
	deb.Parent = workspace
	
	local tween = TS:Create(
		deb,
		TweenInfo.new(.5),
		{Transparency = 1}
	)
	
	tween:Play()
	
	tween.Completed:Connect(function()
		
		deb:Destroy()
		
	end)
	
end)

game.Workspace.OtherEffects.ChildAdded:Connect(function(bomb)
	
	local originSize = bomb.Size
	
	bomb.Size *= 3
	
	bomb.Transparency = 1
	
	local SpawnTween = TS:Create(
		bomb,
		TweenInfo.new(2),
		{Size = originSize, Transparency = 0}
	)
	
	local Tick1 = TS:Create(
		bomb,
		TweenInfo.new(.05, Enum.EasingStyle.Linear),
		{Size = originSize * 1.5}
	)
	
	local Tick2 = TS:Create(
		bomb,
		TweenInfo.new(.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut),
		{Size = originSize}
	)
	
	Tick1.Completed:Connect(function()
		
		Tick2:Play()
		
	end)
	
	Tick2.Completed:Connect(function()
		
		wait(.7)
		
		Tick1:Play()

	end)
	
	SpawnTween:Play()
	
	SpawnTween.Completed:Connect(function()
		
		Tick1:Play()
		
	end)
	
	bomb:WaitForChild("Health").Changed:Connect(function()
		
		bomb.Color = Color3.new(1, 0, 0)
		
		TS:Create(
			bomb,
			TweenInfo.new(.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut),
			{Color = Color3.fromHex("#a3a2a5")}
		):Play()
		
	end)
	
end)
