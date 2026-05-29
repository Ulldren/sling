local states = require("../states")
local types = require("../types")

--[=[
	Creates a new category for the inventory.
	
	```lua
	createCategory("Weapons", function(item)
		return item:HasTag("Weapon")
	end)
    ```
]=]
local function createCategory(category: string, predicate: types.CategoryPredicate)
	local state = states.categories()
	local newCategory = { category = category, predicate = predicate }
	table.insert(state, newCategory)
	states.categories(state)
end

return createCategory
