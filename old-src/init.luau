const close_inventory = require("@self/api/close-inventory")
const is_enabled = require("@self/api/is-enabled")
const set_enabled = require("@self/api/set-enabled")
const get_topbar_icon = require("@self/api/get-topbar-icon")
const is_inventory_open = require("@self/api/is-inventory-open")
const open_inventory = require("@self/api/open-inventory")
const inventory_closed = require("@self/hooks/inventory-closed")
const inventory_opened = require("@self/hooks/inventory-opened")
const item_added = require("@self/hooks/item-added")
const item_equipped = require("@self/hooks/item-equipped")
const item_removed = require("@self/hooks/item-removed")
const item_unequipped = require("@self/hooks/item-unequipped")
const backpack_empty = require("@self/hooks/backpack-empty")

return table.freeze({
	-- API
	is_enabled = is_enabled,
	set_enabled = set_enabled,
	open_inventory = open_inventory,
	close_inventory = close_inventory,
	is_inventory_open = is_inventory_open,
	get_topbar_icon = get_topbar_icon,

	-- Hooks
	inventory_opened = inventory_opened.add_callback,
	inventory_closed = inventory_closed.add_callback,
	item_added = item_added.add_callback,
	item_removed = item_removed.add_callback,
	item_equipped = item_equipped.add_callback,
	item_unequipped = item_unequipped.add_callback,
	backpack_empty = backpack_empty.add_callback,
})
