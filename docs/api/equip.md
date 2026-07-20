# Equip Handler

Here contains the function for customizing how tools are equipped and unequipped.

## Functions

### setEquipHandler()
Sets a custom callback to handle equipping and unequipping tools. Used for server-authoritative games where equipping must be validated or executed on the server.

- **Type**

	```luau
	function sling.setEquipHandler(callback: (tool: Tool?) -> ())
	```

- **Example**

	```luau
	-- Client
	sling.setEquipHandler(function(tool)
		-- Fire a remote to the server
		-- 'tool' is nil when unequipping
		EquipToolRemote:FireServer(tool)
	end)
	```
