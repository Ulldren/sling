local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EquipToolRemote = ReplicatedStorage:WaitForChild("EquipTool")

EquipToolRemote.OnServerEvent:Connect(function(player: Player, tool: Tool?)
	local character = player.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	if tool then
		-- Equip the tool
		humanoid:EquipTool(tool)
	else
		-- Unequip the tool
		humanoid:UnequipTools()
	end
end)
