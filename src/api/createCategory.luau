local states = require("../states")
local types = require("../types")

local function wasAlreadyCreated(category: string)
	local state = states.categories()
	for _, v in state do
		if v.category == category then
			return true
		end
	end
	return false
end

--[=[
	Creates a new category for the inventory.
	
	```lua
	createCategory("Weapons", function(item)
		return item:HasTag("Weapon")
	end)
    ```
]=]
local function createCategory(category: string, predicate: types.CategoryPredicate)
	assert(not wasAlreadyCreated(category), `Category {category} already exists`)
	local newCategory = { category = category, predicate = predicate }
	local state = states.categories()
	table.insert(state, newCategory)
	states.categories(state)
end

return createCategory
