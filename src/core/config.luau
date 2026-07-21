export type CustomSlotComponent = (any) -> (any)
export type CustomSlotSize = () -> UDim2
export type CustomSlotPadding = () -> UDim

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

	customSlotSize = nil :: CustomSlotSize?,
	customSlotComponent = nil :: CustomSlotComponent?,
	-- Only used for the invisible button hitbox on slot buttons
	customSlotCornerRadius = nil :: UDim?,

	customHotbarPadding = nil :: CustomSlotPadding?,
}
