local vide = require("../../../vide")

local source = vide.source
local derive = vide.derive

local function useSearch()
	local searchText = source("")

	local searchTokens = derive(function()
		local text = searchText():lower()
		local tokens = {}
		for token in text:gmatch("%S+") do
			table.insert(tokens, token)
		end
		return tokens
	end)

	local function searchMatches(item: BackpackItem)
		local tokens = searchTokens()
		if #tokens == 0 then
			return true
		end

		local name = item.Name:lower()
		local tooltipText = ""
		if item:IsA("Tool") then
			tooltipText = (item :: Tool).ToolTip:lower()
		end

		for _, token in tokens do
			if name:find(token, 1, true) or tooltipText:find(token, 1, true) then
				return true
			end
		end

		return false
	end

	return {
		searchText = searchText,
		searchMatches = searchMatches,
	}
end

return useSearch
