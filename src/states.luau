const settings = require("./settings")
const types = require("./types")
const vide = require("../vide")

const source = vide.source

return {
	enabled = source(true),
	opened = source(false),

	slots = source(settings.hotbarSlotsFull),
	rows = source(settings.inventoryRowsFull),
	width = source(655),

	keyboardHint = source(false),
	gamepadHint = source(false),
	gamepadSwapIdx = source(nil :: number?),

	categories = source({} :: { types.Category }),
	selectedCategory = source(""),

	items = source({} :: { types.ItemEntry }),
	equippedItem = source(nil :: types.InventoryItem?),

	appRef = source(nil :: Frame?),
	hotbarRef = source(nil :: Frame?),
	inventoryGridRef = source(nil :: ScrollingFrame?),
}
