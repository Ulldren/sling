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

### onBackpackItemEquipped()
Fires when the player equips an item on character.

- **Type**

	```luau
	function sling.onBackpackItemEquipped(callback: (item: BackpackItem) -> ()): () -> ()
	```

### onBackpackItemUnequipped()
Fires when the player unequips their currently active item.

- **Type**

	```luau
	function sling.onBackpackItemUnequipped(callback: (item: BackpackItem) -> ()): () -> ()
	```

### onBackpackItemAdded()
Fires when an item is added to the player's backpack.

- **Type**

	```luau
	function sling.onBackpackItemAdded(callback: (item: BackpackItem) -> ()): () -> ()
	```

### onBackpackItemRemoved()
Fires when an item is removed entirely from the player's backpack.

- **Type**

	```luau
	function sling.onBackpackItemRemoved(callback: (item: BackpackItem) -> ()): () -> ()
	```

### onBackpackEmpty()
Fires when the backpack becomes entirely empty (contains no items).

- **Type**

	```luau
	function sling.onBackpackEmpty(callback: () -> ()): () -> ()
	```