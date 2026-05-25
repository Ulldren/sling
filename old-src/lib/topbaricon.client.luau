const vide = require("../../vide")
const topbarplus = require("../../topbarplus")
const close_inventory = require("../api/close-inventory")
const open_inventory = require("../api/open-inventory")
const inventory_closed = require("../hooks/inventory-closed")
const inventory_opened = require("../hooks/inventory-opened")
const whole_enabled = require("../internal/whole-enabled-source")
const drag_active = require("../internal/drag-active-source")

const arrow_image_open = "rbxasset://textures/ui/TopBar/inventoryOn.png"
const arrow_image_close = "rbxasset://textures/ui/TopBar/inventoryOff.png"

const icon: any = topbarplus.new()
icon:setName("InventoryPlus")
icon:setImage(arrow_image_open, "Selected")
icon:setImage(arrow_image_close, "Deselected")
icon:setImageScale(1)
icon:setCaption("Inventory")
icon:bindToggleKey(Enum.KeyCode.Backquote)
icon:autoDeselect(false)
icon:setOrder(-1)

icon.toggled:Connect(function(isSelected, fromSource)
	if fromSource == "User" then
		if isSelected then
			open_inventory()
		else
			close_inventory()
		end
	end
end)

inventory_opened.add_callback(function()
	icon:select()
end)

inventory_closed.add_callback(function()
	icon:deselect()
end)

vide.root(function()
	vide.effect(function()
		if drag_active() then
			icon:lock()
		else
			icon:unlock()
		end
	end)

	vide.effect(function()
		icon:setEnabled(whole_enabled())
	end)
end)

return icon
