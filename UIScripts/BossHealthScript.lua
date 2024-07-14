
local RS = game:GetService("RunService")

local Boss = workspace.Galaxy

local BossHumanoid = Boss.Humanoid

local HealthBar = script.Parent.HealthFrame.Health


RS.RenderStepped:Connect(function(dt)
	
	HealthBar.Size = UDim2.new(BossHumanoid.Health/BossHumanoid.MaxHealth, 0, 1, 0)
	
end)
