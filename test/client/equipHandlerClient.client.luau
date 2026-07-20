local Sling = require("./Sling")

local EquipToolRemote = script.Parent:WaitForChild("EquipTool") :: RemoteEvent

Sling.setEquipHandler(function(tool)
	-- Fire a remote to the server
	-- 'tool' is nil when unequipping
	EquipToolRemote:FireServer(tool)
end)
