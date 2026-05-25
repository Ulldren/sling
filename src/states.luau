local vide = require("../vide")
local settings = require("./settings")
local types = require("./types")

local source = vide.source

return {
	enabled = source(true),
	opened = source(false),

	slots = source(settings.hotbarSlotsFull),
	rows = source(settings.inventoryRowsFull),

	categories = source({} :: { types.Category }),
	selectedCategory = source(""),

	items = source({} :: { types.InventoryItem }),
	equippedItem = source(nil :: types.InventoryItem?),

	attributes = {
		BackgroundColor3 = source(Color3.fromRGB(25, 27, 29)),
		BackgroundTransparency = source(0.3),
		CornerRadius = source(UDim.new(0, 8)),
		SmallCornerRadius = source(UDim.new(0, 4)),
		EquipBorderColor3 = source(Color3.fromRGB(51, 95, 255)),
		EquipBorderSizePixel = source(5),
		SelectionColor3 = source(Color3.fromRGB(255, 255, 255)),
		FontFace = source(Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium)),
		TextColor3 = source(Color3.fromRGB(255, 255, 255)),
		TextSize = source(16),
		TextStrokeColor3 = source(Color3.fromRGB(0, 0, 0)),
		TextStrokeTransparency = source(0.5),
	},
}
