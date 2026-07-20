local equipHandler = {
	callback = nil :: ((tool: Tool?) -> ())?,
}

--[=[
	Sets a custom callback to handle equipping and unequipping tools.
	Used for server-authoritative games where equipping must be validated or executed on the server.

	```luau
	sling.setEquipHandler(function(tool)
		-- Fire a remote to the server
		-- 'tool' is nil when unequipping
		EquipToolRemote:FireServer(tool)
	end)
	```
]=]
local function setEquipHandler(callback: (tool: Tool?) -> ())
	equipHandler.callback = callback
end

return function()
	return equipHandler, setEquipHandler
end
