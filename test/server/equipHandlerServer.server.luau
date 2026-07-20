local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EquipToolRemote = Instance.new("RemoteEvent")
EquipToolRemote.Name = "EquipTool"
EquipToolRemote.Parent = ReplicatedStorage

EquipToolRemote.OnServerEvent:Connect(function(player: Player, tool: Tool?)
	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	if tool then
		humanoid:EquipTool(tool)
	else
		humanoid:UnequipTools()
	end
end)
