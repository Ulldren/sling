local theme = require("../theme")
local types = require("../types")

local function setTheme(config: types.ThemeConfig)
	theme.selected(config)
end

return setTheme
