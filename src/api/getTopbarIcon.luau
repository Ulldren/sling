local topbarplus = require("../../topbarplus")

local function getTopbarIcon()
	return topbarplus.getIcon("VideBackpack") :: topbarplus.Icon?
end

return getTopbarIcon
