local vide = require("../../vide")
local types = require("../types")
local hotbar = require("./hotbar")
local inventory = require("./inventory")

local create = vide.create
local effect = vide.effect
local source = vide.source
local show = vide.show

type Props = {
	opened: vide.Source<boolean>,
	slots: vide.Source<number>,
	rows: vide.Source<number>,
	items: vide.Source<{ types.InventoryItem }>,
	equippedItem: vide.Source<types.InventoryItem?>,
	keyboardHint: vide.Source<boolean>,
	categories: vide.Source<{ types.Category }>,
	selectedCategory: vide.Source<string>,
	widthChanged: (number) -> (),
	attributes: types.Attributes,
}

local function backpack(props: Props)
	local hotbarItems = source({})
	local inventoryItems = source({})

	effect(function()
		local items = props.items()
		local slots = props.slots()

		local newHotbar = {}
		local newInventory = {}

		for index, item in items do
			if item and index > 0 and index <= slots then
				newHotbar[index] = item
			elseif item and index > slots then
				newInventory[index - slots] = item
			end
		end

		hotbarItems(newHotbar)
		inventoryItems(newInventory)
	end)

	effect(function()
		local categories = props.categories()
		props.selectedCategory(if #categories > 0 then categories[1].category else "")
	end)

	return create("Frame")({
		Name = "Backpack",
		Active = true,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,

		create("UIListLayout")({
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),

		show(props.opened, function()
			return inventory({
				opened = props.opened,
				rows = props.rows,
				items = inventoryItems,
				equippedItem = props.equippedItem,
				categories = props.categories,
				selectedCategory = props.selectedCategory,
				attributes = props.attributes,
			})
		end),
		hotbar({
			opened = props.opened,
			slots = props.slots,
			items = hotbarItems,
			equippedItem = props.equippedItem,
			keyboardHint = props.keyboardHint,
			widthChanged = props.widthChanged,
			attributes = props.attributes,
		}),
	})
end

return backpack
