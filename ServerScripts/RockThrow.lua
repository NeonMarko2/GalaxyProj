
local Debris = game:GetService("Debris")

function RockThrow(player, position)
	
	local Rock = game.ReplicatedStorage.Models.Rock:Clone()
	
	Rock.Parent = workspace
	
	Rock.Position = player.Character.PrimaryPart.Position
	
	Rock.CanCollide = false
	
	Rock.LinearVelocity.VectorVelocity = -(player.Character.PrimaryPart.Position-position).Unit*100
	
	Rock:SetNetworkOwner(player)
	
	Rock.Touched:Connect(function(hit)
		
		if hit.Parent and hit.Parent.Name == "Galaxy" then
			
			Rock:Destroy()
			hit.Parent:FindFirstChild("Humanoid").Health -= 1
			
		elseif hit.Name == "Bomb" then
			
			Rock:Destroy()
			hit.Health.Value -= 1
			
			if hit.Health.Value <= 0 then
				
				hit:Destroy()
				
			end
			
		end
		
	end)
	
	Debris:AddItem(Rock, 5)
	
end


game.ReplicatedStorage.RemoteEvents.RockThrow.OnServerEvent:Connect(RockThrow)
