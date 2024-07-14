
local uis = game:GetService("UserInputService")

local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera

local Cooldown = 0

uis.InputBegan:Connect(function(input)
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		
		if Cooldown > 0 then
			return
		end
		
		Cooldown = 1
		
		local MousePos = uis:GetMouseLocation()
		
		local ray = Camera:ScreenPointToRay(MousePos.X, MousePos.Y-36)
		
		local params = RaycastParams.new()
		
		params.FilterDescendantsInstances = { game.Players.LocalPlayer.Character, game.Workspace.Galaxy, game.Workspace.Baseplate }
		
		params.FilterType = Enum.RaycastFilterType.Exclude
		
		local raycast = workspace:Raycast(ray.Origin, ray.Direction*500, params)
		
		game.ReplicatedStorage.RemoteEvents.RockThrow:FireServer(raycast.Position)
		
	end
	
end)

RunService.Heartbeat:Connect(function(dt)
	
	if Cooldown > 0 then
		
		Cooldown -= dt
		
	end
	
end)
