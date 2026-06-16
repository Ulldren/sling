# Categories

Here contains functions for configuring Sling inventory categories.

## Functions

### createCategory()
Registers a new category filter for the inventory. When a player selects this category, the `predicate` function will determine which items are shown.

- **Type**

	```luau
	function sling.createCategory(category: string, predicate: (item: BackpackItem) -> boolean)
	```
