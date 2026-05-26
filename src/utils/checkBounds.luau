local function checkBounds(pos: Vector2, target: GuiObject): boolean
	local absPos = target.AbsolutePosition
	local absSize = target.AbsoluteSize
	return pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
end

return checkBounds
