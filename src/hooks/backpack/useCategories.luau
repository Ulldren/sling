local cond = require("../../utils/cond")
local px = require("../../utils/px")
local states = require("../../states")
local vide = require("../../../vide")

local derive = vide.derive
local effect = vide.effect

type Props = {
	maxCategoryWidth: number,
	dropdownButtonWidth: number,
}

local function useCategories(props: Props)
	effect(function()
		local categories = states.categories()
		states.selectedCategory(if #categories > 0 then categories[1].category else "")
	end)

	local categories = states.categories()
	table.insert(categories, 1, {
		category = "All",
		predicate = function()
			return true
		end,
	})
	states.categories(categories)

	local allCategories = derive(function()
		local categories = states.categories()
		local width = states.width()

		local barCategories = {}
		local dropdownCategories = {}
		for i, category in categories do
			local sizeX = (1 / i) * width
			if sizeX > props.maxCategoryWidth then
				table.insert(barCategories, category)
			else
				table.insert(dropdownCategories, category)
			end
		end
		return { barCategories = barCategories, dropdownCategories = dropdownCategories }
	end)
	local barCategories = derive(function()
		return allCategories().barCategories
	end)
	local dropdownCategories = derive(function()
		return allCategories().dropdownCategories
	end)
	local showDropdown = cond.gt(cond.len(dropdownCategories), 0)
	local categoryWidth = derive(function()
		local barLen = #barCategories()
		return (1 / barLen) * px.raw(states.width) - (if showDropdown() then props.dropdownButtonWidth / barLen else 0)
	end)

	return {
		barCategories = barCategories,
		dropdownCategories = dropdownCategories,
		showDropdown = showDropdown,
		categoryWidth = categoryWidth,
	}
end

return useCategories
