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
	customSlotCornerRadius = nil :: UDim?, -- Only used for the invisible button hitbox on slot buttons
	customHotbarSlotPadding = nil :: CustomSlotPadding?, -- Padding between slots
	customHotbarPadding = nil :: CustomSlotPadding?, -- Padding above & below hotbar
}
