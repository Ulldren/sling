const function getClosestFrame(pos: Vector2, parent: Instance, maxDistance: number?): (GuiObject?, number?)
	local closestFrame: GuiObject? = nil
	local minDistance: number = maxDistance or math.huge

	for _, frame in parent:GetChildren() do
		if not frame:IsA("GuiObject") then
			continue
		end

		const center = frame.AbsolutePosition + frame.AbsoluteSize / 2
		const distance = (pos - center).Magnitude

		if distance < minDistance then
			minDistance = distance
			closestFrame = frame
		end
	end

	if closestFrame then
		return closestFrame, minDistance
	else
		return nil, nil
	end
end

return getClosestFrame
