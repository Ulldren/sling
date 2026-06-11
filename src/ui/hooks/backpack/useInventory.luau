local states = require("../../../core/states")
local vide = require("../../../../vide")

local source = vide.source
local derive = vide.derive

local function useInventory()
	local inventoryItems = derive(function()
		local slots = states.slots()
		local items = states.items()
		local initialCount = slots + 1
		local maxIndex = math.max(table.maxn(items), initialCount)

		local newInventory = {}
		local count = 0
		for i = initialCount, maxIndex do
			local item = items[i]
			if item then
				count += 1
				newInventory[count] = item
			end
		end
		return newInventory
	end)

	local selectedCategoryIndex = derive(function()
		local selectedCategory = states.selectedCategory()
		local categories = states.categories()
		for i, category in categories do
			if category.category == selectedCategory then
				return i
			end
		end
		return 0
	end)

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

	local function isVisible(item: BackpackItem)
		local categoryIndex = selectedCategoryIndex()
		local selectedCategory = states.categories()[categoryIndex]

		if selectedCategory and not selectedCategory.predicate(item) then
			return false
		end
		if not searchMatches(item) then
			return false
		end

		return true
	end

	return {
		searchText = searchText,
		items = inventoryItems,
		isVisible = isVisible,
	}
end

return useInventory
