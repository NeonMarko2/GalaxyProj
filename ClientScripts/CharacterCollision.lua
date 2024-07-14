
local HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

HumanoidRootPart.Touched:Connect(function(hit)
	
	if hit.Name == "Debree" then
		
		HumanoidRootPart.Parent.Humanoid.Health -= 100
		
	end
	
end)
