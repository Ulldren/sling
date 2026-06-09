# Events

All event listeners return a **disconnect function** when called, which can be executed to clean up and stop listening to the event.

## Functions

### onInventoryOpened()
Fires whenever the player's inventory interface is opened.

- **Type**

	```luau
	function sling.onInventoryOpened(callback: () -> ()): () -> ()
	```

### onInventoryClosed()
Fires whenever the player's inventory interface is closed.

- **Type**

	```luau
	function sling.onInventoryClosed(callback: () -> ()): () -> ()
	```

### onBackpackEquipped()
Fires when the player equips an item on character.

- **Type**

	```luau
	function sling.onBackpackEquipped(callback: (item: BackpackItem) -> ()): () -> ()
	```

### onBackpackUnequipped()
Fires when the player unequips their currently active item.

- **Type**

	```luau
	function sling.onBackpackUnequipped(callback: (item: BackpackItem) -> ()): () -> ()
	```

### onBackpackAdded()
Fires when an item is added to the player's backpack.

- **Type**

	```luau
	function sling.onBackpackAdded(callback: (item: BackpackItem) -> ()): () -> ()
	```

### onBackpackRemoved()
Fires when an item is removed entirely from the player's backpack.

- **Type**

	```luau
	function sling.onBackpackRemoved(callback: (item: BackpackItem) -> ()): () -> ()
	```

### onBackpackEmpty()
Fires when the backpack becomes entirely empty (contains no items).

- **Type**

	```luau
	function sling.onBackpackEmpty(callback: () -> ()): () -> ()
	```