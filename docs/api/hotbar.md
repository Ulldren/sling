# Hotbar

Here contains functions for controlling the Sling hotbar.

## Functions

### setHotbar()
Sets the hotbar to the specified items layout. If `force` is set to `true`, any existing items currently in the Hotbar that are not present in the new layout will be safely moved back to the inventory.

- **Type**

	```luau
	function sling.setHotbar(items: { BackpackItem }, force: boolean?)
	```
