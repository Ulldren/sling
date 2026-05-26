const events = require("../events")
const states = require("../states")
const types = require("../types")

--[=[
	Creates a new category for the inventory.
	
	```lua
	createCategory("Weapons", function(item)
		return item:HasTag("Weapon")
	end)
    ```
]=]
const function createCategory(category: string, predicate: types.CategoryPredicate)
	const state = states.categories()
	const newCategory = { category = category, predicate = predicate }
	table.insert(state, newCategory)
	states.categories(state)

	for _, listener in events.categoryAdded.callbacks do
		task.spawn(listener, newCategory)
	end
end

return createCategory
