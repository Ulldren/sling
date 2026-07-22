local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
if not RunService:IsRunning() then -- for use in studio
	return function()
		return nil :: Icon?
	end
end

local topbarplus = require(ReplicatedStorage.Shared.Packages.topbarplus)
type Icon = topbarplus.Icon

local function getTopbarIcon()
	return topbarplus.getIcon("Sling") :: Icon?
end

return getTopbarIcon
