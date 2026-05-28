const theme = require("../theme")
const types = require("../types")

const function setTheme(config: types.ThemeConfig)
	theme.selected(config)
end

return setTheme
