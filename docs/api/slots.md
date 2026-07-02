# Slots

## Types

### SlotContext
Info about the slot being rendered. Passed as the argument to the `onSlotRender` callback.

- **Type**

	```luau
	type SlotContext = {
		item: BackpackItem,
		inHotbar: boolean?,
		order: number,
	}
	```

- **Properties**

	| Property | Type | Description |
	| --- | --- | --- |
	| `item` | `BackpackItem` | The item occupying this slot. |
	| `inHotbar` | `boolean?` | Whether the slot is in the hotbar. `nil` if in the inventory. |
	| `order` | `number` | The visual position of the slot (1-based). |

---

### SlotProperties
The return value of the `onSlotRender` callback. All properties are optional — any property not returned will use its default value.

- **Type**

	```luau
	type SlotProperties = {
		BackgroundColor: Color3?,
		BackgroundTransparency: number?,
		Children: { Instance }?,
		ItemNameText: string?,
		ItemNameChildren: { Instance }?,
	}
	```

- **Properties**

	| Property | Type | Description |
	| --- | --- | --- |
	| `BackgroundColor` | `Color3?` | Overrides the slot's background color. |
	| `BackgroundTransparency` | `number?` | Overrides the slot's background transparency. |
	| `Children` | `{ Instance }?` | Instances parented into the slot frame (e.g. `UIGradient`). |
	| `ItemNameText` | `string?` | Overrides the item name label text. Supports rich text. |
	| `ItemNameChildren` | `{ Instance }?` | Instances parented into the item name label (e.g. `UIGradient`). |

## Functions

### onSlotRender()
Registers a callback that runs whenever a slot is rendered. Use it to customize individual slots based on their item.

This function can only be called **once**. Calling it more than once will throw an error.

- **Type**

	```luau
	function sling.onSlotRender(callback: (context: SlotContext) -> SlotProperties)
	```
