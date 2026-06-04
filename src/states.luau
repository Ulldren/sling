local config = require("./constants/config")
local types = require("./types")
local vide = require("../vide")

local source = vide.source

return {
	enabled = source(true),
	opened = source(false),

	slots = source(config.hotbarSlotsFull),
	rows = source(config.inventoryRowsFull),
	width = source(655),

	keyboardHint = source(false),
	gamepadHint = source(false),
	gamepadSwapIndex = source(nil :: number?),

	categories = source({} :: { types.Category }),
	selectedCategory = source(""),

	items = source({} :: { BackpackItem }),
	equippedItem = source(nil :: BackpackItem?),

	appRef = source(nil :: GuiObject?),
	hotbarRef = source(nil :: Frame?),
	inventoryGridRef = source(nil :: ScrollingFrame?),
}
