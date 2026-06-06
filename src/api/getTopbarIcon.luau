local topbarplus = require("../../topbarplus")

local function getTopbarIcon()
	return topbarplus.getIcon("Sling") :: topbarplus.Icon?
end

return getTopbarIcon
