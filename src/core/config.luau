export type CustomSlotComponent = (any) -> (GuiObject)

return {
	slotSize = 60,

	hotbarSlotsFull = 9,
	hotbarSlotsMini = 6,
	hotbarSlotsPortrait = 3,

	inventoryRowsFull = 4,
	inventoryRowsMini = 2,
	inventoryRowsPortrait = 4,

	gamepadSwapKey = Enum.KeyCode.ButtonA,
	gamepadRemoveKey = Enum.KeyCode.ButtonX,
	gamepadCloseKey = Enum.KeyCode.ButtonB,


	customSlotComponent = nil :: CustomSlotComponent?,
}
