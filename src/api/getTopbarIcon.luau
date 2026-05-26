local topbarplus = require("../../topbarplus")

local function getTopbarIcon()
	return topbarplus.getIcon("InventoryPlus") :: topbarplus.Icon?
end

return getTopbarIcon
