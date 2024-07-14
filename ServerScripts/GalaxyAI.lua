
local Debris = game:GetService("Debris")

local RS = game:GetService("RunService")

local Enemy = workspace.Galaxy

local Animations = game.ServerStorage.Animations

local PlayAnim = script.Parent.GalaxyAIAnimationHandler.PlayAnim

local WarnPlayers = game.ReplicatedStorage.RemoteEvents.WarnAttack

local UsedCommonAttack = false

local CurrentSpecialAttack = 0

local SkipIntro = true

local Enraged = false

function SetTransparent(val)
	
	for i,v in pairs(Enemy:GetChildren()) do

		if v.ClassName == "Part" or v.ClassName == "MeshPart" then

			v.Transparency = val

		end

	end
	
end

SetTransparent(1)

function DecideAbility()
	
	print(CurrentSpecialAttack)
	
	if UsedCommonAttack == false then
		
		PlayAnim:Fire(Animations.LaserShoot)
		UsedCommonAttack = true
		
		return
		
	end
	
	UsedCommonAttack = false
	
	if CurrentSpecialAttack == 0 then
		
		WarnPlayers:FireAllClients("Meteors")
		
		wait(.5)
		
		for i = 0, 30, 1 do
			
			local debree = game.ReplicatedStorage.Models.Debree:Clone()
			
			debree.Parent = workspace.Debree
			
			debree.Position = Vector3.new(150, 5, math.random(-80, 80))
			
			debree.LinearVelocity.VectorVelocity = Vector3.new(-50, 0 , 0)
			
			debree.Rotation = Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360))
			
			debree:SetNetworkOwner(nil)
			
			Debris:AddItem(debree, 5)
			
			wait(.2)
			
		end
		
		wait(5)
		
		DecideAbility()
		-- Debree
		
	elseif CurrentSpecialAttack == 1 then
		
		WarnPlayers:FireAllClients("Bombs")

		wait(.5)
		
		PlayAnim:Fire(Animations.Bomb)
		
		for i,v in pairs(game.Players:GetPlayers()) do
			
			local bomb = game.ReplicatedStorage.Models.Bomb:Clone()

			bomb.Parent = workspace.OtherEffects

			bomb.Position = Vector3.new(math.random(-10,10), 0, math.random(-10,10)).Unit * 40

			bomb.Position = Vector3.new(bomb.Position.X, 8, bomb.Position.Z)
			
  		end
		
	elseif CurrentSpecialAttack == 2 then
		
		WarnPlayers:FireAllClients("Black Holes")

		wait(.5)
		
		local players = game.Players:GetPlayers()
		
		for i,v in pairs(game.Players:GetPlayers()) do
			
			local Attachment = Instance.new("Attachment")
			
			Attachment.Parent = players[i].Character:FindFirstChild("HumanoidRootPart")

			local puller = game.ReplicatedStorage.Models.Puller:Clone()
			
			puller.Parent = workspace.Pullers
			
			puller:SetNetworkOwner(nil)
			
			local LinearVelocity = puller.LinearVelocity

			local Beam = puller.Beam
			
			Beam.Attachment1 = Attachment
			
			local offset = (Vector3.new(0.000000001,0,0.000000001) + Vector3.new(math.random(-1,1), 0, math.random(-1,1))).Unit*15
			
			print(offset)
			
			puller.CFrame = players[i].Character:FindFirstChild("HumanoidRootPart").CFrame + offset --(Vector3.new(math.random(-1, 1), 0, math.random(-1,1)).Unit*15)
			
			local direction = -(players[i].Character:FindFirstChild("HumanoidRootPart").Position-puller.Position).Unit
			
			local destroy = false
			
			wait(1)
			
			local connection
			
			connection = puller.Touched:Connect(function(hit)
				
				if hit.Parent and hit.Parent == Enemy then
					
					hit.Parent.Humanoid.Health -= 5
					
					destroy = true
					
					connection:Disconnect()
					
				elseif hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
					
					hit.Parent.Humanoid.Health -= 100
					
					destroy = true
					
					connection:Disconnect()
					
				end
				
			end)
			
			task.spawn(function()
				
				while wait() do
						
					direction = (players[i].Character:FindFirstChild("HumanoidRootPart").Position-puller.Position).Unit * 10

					LinearVelocity.VectorVelocity = direction
					
					if destroy == true or players[i].Character.Humanoid.Health <= 0 then
						
						puller:Destroy()
						
						LinearVelocity:Destroy()
						
						Attachment:Destroy()
						
						break
						
					end
					
				end
				
			end)
			
		end
		
		wait(13)
		
		DecideAbility()
		--for i, v in pairs(game.Players:GetPlayers()) do
			
		--	local LinearVelocity = Instance.new("LinearVelocity")
			
		--	LinearVelocity.Parent = v.Character:FindFirstChild("HumanoidRootPart")
			
		--	local Attachment = Instance.new("Attachment")
			
		--	Attachment.Parent = v.Character:FindFirstChild("HumanoidRootPart")
			
		--	LinearVelocity.Attachment0 = Attachment
			
		--end
		
	end
	
	CurrentSpecialAttack += 1
	
	if CurrentSpecialAttack > 2 then
		
		CurrentSpecialAttack = 0
		
	end
	
end

RS.Heartbeat:Connect(function()
	
	if Enemy.Humanoid.Health <= 0 then

		Death()
		
	end
	
end)

function Death()
	
	script.Parent.GalaxyAIAnimationHandler.Enabled = false
	Enemy.Script.Enabled = false
	script.Enabled = false
	
	workspace.Beams:ClearAllChildren()
	
	workspace.Danger:ClearAllChildren()
	
	workspace.Debree:ClearAllChildren()
	
	workspace.OtherEffects:ClearAllChildren()
	
	workspace.Pullers:ClearAllChildren()
	
	local beam = game.ReplicatedStorage.Models.Beam:Clone()

	beam.Parent = workspace.Beams

	beam.Position = Vector3.new(Enemy.PrimaryPart.Position.X, workspace.Baseplate.CFrame.Y, Enemy.PrimaryPart.Position.Z) + Vector3.new(0, beam.Size.X/2, 0)

	beam.Size = Vector3.new(beam.Size.X, 16, 16)
	
	Debris:AddItem(beam, 1)
	
	SetTransparent(1)
	
end

script.StartAi.Event:Connect(function()
	
	if SkipIntro then
		
		wait(1)
		
		SetTransparent(.99)

		DecideAbility()
		
		Enemy.Script.Enabled = true
		
		return
		
	end
	
	wait(2)
	
	local Danger = game.ReplicatedStorage.Models.Danger:Clone()

	Danger.Parent = workspace.Danger
	
	Danger.PrimaryPart.CFrame = CFrame.new(Enemy.PrimaryPart.Position.X, workspace.Baseplate.CFrame.Y + Danger.PrimaryPart.Size.Y/2, Enemy.PrimaryPart.Position.Z)
	
	wait(3)
	
	local beam = game.ReplicatedStorage.Models.Beam:Clone()

	beam.Parent = workspace.Beams

	local danger = workspace.Danger:FindFirstChild("Danger")

	beam.Position = danger.PrimaryPart.Position + Vector3.new(0, beam.Size.X/2, 0)
	
	beam.Size = Vector3.new(beam.Size.X, 16, 16)
	
	SetTransparent(.99)	
	
	danger:Destroy()

	local modelsBeamHit = {}

	beam.Touched:Connect(function(hit)

		if hit.Parent and hit.Parent:FindFirstChild("Humanoid") and modelsBeamHit[hit.Parent] == nil then

			hit.Parent.Humanoid.Health -= 25

			modelsBeamHit[hit.Parent] = 0

		end

	end)

	game:GetService("Debris"):AddItem(beam, 1)

	wait(1)

	modelsBeamHit = nil
	
	wait(1)
	
	Enemy.Script.Enabled = true
	
	DecideAbility()
	
end)

script.DecideAttack.Event:Connect(DecideAbility)
