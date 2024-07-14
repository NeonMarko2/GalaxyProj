
local RS = game:GetService("RunService")

local Camera = workspace.CurrentCamera

local Character = game.Players.LocalPlayer.Character

local intensity = 0

RS.RenderStepped:Connect(function(dt)
	
	if intensity > 0 then
		
		Character.Humanoid.CameraOffset = Vector3.new(math.random(-intensity*100, intensity*100), math.random(-intensity*100, intensity*100), math.random(-intensity*100, intensity*100))/100
		intensity -= dt*4
		
	elseif intensity < 0 then
		
		Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
		intensity = 0
		
	end
	
end)

script:WaitForChild("SetStrength").Event:Connect(function(strength)
	
	intensity = strength
	
end)
