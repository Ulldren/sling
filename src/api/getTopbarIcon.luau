local ReplicatedStorage = game:GetService("ReplicatedStorage")

local topbarplus = require(ReplicatedStorage.Shared.Packages.topbarplus)

local function getTopbarIcon()
	return topbarplus.getIcon("Sling") :: topbarplus.Icon?
end

return getTopbarIcon
