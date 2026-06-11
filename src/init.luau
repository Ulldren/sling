--[[
	MIT License

	Copyright (c) 2026 EncodedLux

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

--[[
	By using Sling, you agree to provide attribution in one of the following ways:
		1. Keep the attribution unmodified and enabled
		2. Provide credit in your experience description by name (Sling) and creator (@EncodedLux)
		3. Have a DevForum topic linked in your experience description, crediting with the above

	Thank you for supporting Sling.
]]
local RunService = game:GetService("RunService")

local VERSION = "0.1.1"

-- Print attribution. Do not modify without reading above
if not RunService:IsStudio() and RunService:IsClient() then
	print(`🎒 Running Sling v{VERSION} by @EncodedLux`)
end

local closeInventory = require("@self/api/closeInventory")
local createCategory = require("@self/api/createCategory")
local events = require("@self/events")
local getTopbarIcon = require("@self/api/getTopbarIcon")
local isEnabled = require("@self/api/isEnabled")
local isInventoryOpen = require("@self/api/isInventoryOpen")
local openInventory = require("@self/api/openInventory")
local render = require("@self/components/render")
local setEnabled = require("@self/api/setEnabled")
local setHotbar = require("@self/api/setHotbar")
local setTheme = require("@self/api/setTheme")
local themes = require("@self/constants/themes")
local toggleInventory = require("@self/api/toggleInventory")
local types = require("@self/types")

export type ThemeConfig = types.ThemeConfig

require("@self/topbarIcon")

render()

return table.freeze({
	-- API
	openInventory = openInventory,
	closeInventory = closeInventory,
	toggleInventory = toggleInventory,
	isInventoryOpen = isInventoryOpen,
	isEnabled = isEnabled,
	setEnabled = setEnabled,
	createCategory = createCategory,
	setTheme = setTheme,
	setHotbar = setHotbar,
	getTopbarIcon = getTopbarIcon,

	-- Themes
	themes = themes,

	-- Hooks
	--- Fires whenever the player's inventory interface is opened.
	onInventoryOpened = events.inventoryOpened.on,
	--- Fires whenever the player's inventory interface is closed.
	onInventoryClosed = events.inventoryClosed.on,
	--- Fires whenever the backpack is initially loaded.
	onBackpackLoaded = events.backpackLoaded.on,
	--- Fires when the player equips an item on character.
	onBackpackItemEquipped = events.backpackItemEquipped.on,
	--- Fires when the player unequips their currently active item.
	onBackpackItemUnequipped = events.backpackItemUnequipped.on,
	--- Fires when an item is added to the player's backpack.
	onBackpackItemAdded = events.backpackItemAdded.on,
	--- Fires when an item is removed entirely from the player's backpack.
	onBackpackItemRemoved = events.backpackItemRemoved.on,
	--- Fires when the backpack becomes entirely empty (contains no items).
	onBackpackEmpty = events.backpackEmpty.on,
	--- Fires whenever the hotbar layout changes manually.
	onHotbarChanged = events.hotbarChanged.on,
})
