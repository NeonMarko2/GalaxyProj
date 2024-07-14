
local Models = game.ReplicatedStorage.Models

local Enemy = workspace.Galaxy

local Animator = workspace.Galaxy.Humanoid.Animator

local debounce = game:GetService("Debris")

function PlayAnimation(Animation)
	
	local Animation = Animator:LoadAnimation(Animation)
	
	Animation:Play()
	
		Animation.Stopped:Connect(function()
		
		print("ay")
		script.Parent.GalaxyAI.DecideAttack:Fire()
		
	end)
	
	Animation:GetMarkerReachedSignal("Laser"):Connect(function()
		
		for i,v in pairs(workspace.Danger:GetChildren()) do
			
			task.spawn(function()
				
				local beam = game.ReplicatedStorage.Models.Beam:Clone()

				beam.Parent = workspace.Beams

				local danger = v

				beam.Position = danger.PrimaryPart.Position + Vector3.new(0, beam.Size.X/2, 0)

				danger:Destroy()

				local modelsBeamHit = {}

				beam.Touched:Connect(function(hit)

					if hit.Parent and hit.Parent:FindFirstChild("Humanoid") and modelsBeamHit[hit.Parent] == nil then

						hit.Parent.Humanoid.Health -= 25

						modelsBeamHit[hit.Parent] = 0

					end

				end)

				debounce:AddItem(beam, 1)

				wait(1)

				modelsBeamHit = nil
				
			end)
			
		end
		
	end)
	
	Animation:GetMarkerReachedSignal("DangerMarker"):Connect(function()
		
		for i,v in pairs(game.Players:GetPlayers()) do
			
			local Danger = Models.Danger:Clone()

			Danger.Parent = workspace.Danger

			local player = game.Players:GetPlayers()[i].Character

			--local RayParams = RaycastParams.new()

			--RayParams.CollisionGroup = "Floor"

			--local raycast = workspace:Raycast(Enemy.PrimaryPart.Position, (player.HumanoidRootPart.Position - Enemy.PrimaryPart.Position)*100, RayParams)

			--print(raycast.Position)
			Danger.PrimaryPart.CFrame = CFrame.new(player.HumanoidRootPart.CFrame.X, workspace.Baseplate.CFrame.Y + Danger.PrimaryPart.Size.Y/2, player.HumanoidRootPart.CFrame.Z)
			
		end
		--CFrame.new(raycast.Position.X, raycast.Position.Y, raycast.Position.Z)
		
	end)
	
end


script.PlayAnim.Event:Connect(PlayAnimation)
