local config = require("./config")
local types = require("./types")
local vide = require("../../vide")

local source = vide.source

return {
	enabled = source(true),
	opened = source(false),

	slots = source(config.hotbarSlotsFull),
	rows = source(config.inventoryRowsFull),
	width = source(655),

	items = source({} :: { BackpackItem }),
	equippedItem = source(nil :: BackpackItem?),

	keyboardHint = source(false),
	gamepadHint = source(false),

	gamepadSwapIndex = source(nil :: number?),

	inputs = {
		slotLeft = source(false),
		slotRight = source(false),

		closeInventory = source(false),
		removeFromHotbar = source(false),
		selectSwap = source(false),
	},

	categories = source({ {
		category = "All",
		predicate = function()
			return true
		end,
	} } :: { types.Category }),
	selectedCategory = source(""),

	selectedTheme = source({} :: types.ThemeConfig),

	isBackpackLoaded = source(false),

	appRef = source(nil :: GuiObject?),
	hotbarRef = source(nil :: Frame?),

	onSlotRender = source({ callback = nil :: ((context: types.SlotContext) -> types.SlotProperties)? }),
}
