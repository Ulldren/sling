local states = require("../core/states")
local types = require("../core/types")

--[=[
	Sets the active theme configuration.

	```luau
	-- Apply a predefined theme
	sling.setTheme(sling.themes.default)
	sling.setTheme(sling.themes.light)

	-- Apply custom style overrides
	sling.setTheme({
		backgroundColor = Color3.fromRGB(25, 27, 29),
		textColor = Color3.fromRGB(255, 255, 255),
	})
	```
]=]
local function setTheme(config: types.ThemeConfig)
	states.selectedTheme(config)
end

return setTheme
