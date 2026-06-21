local Sling = require("../Sling")

Sling.onSlotRender(function(context)
	local properties = {} :: Sling.SlotProperties

	if context.item:HasTag("Sword") then
		properties.BackgroundColor = Color3.fromHex("#142442")
	elseif context.item:HasTag("Knife") then
		properties.ItemName = `<font face='Arcade' color='#ff5252'>{context.item.Name}</font>`
		properties.BackgroundColor = Color3.fromHex("#421414")
	elseif context.item:HasTag("Gun") then
		properties.BackgroundColor = Color3.fromHex("#311442")
	elseif context.item:HasTag("Explosive") then
		properties.BackgroundColor = Color3.fromHex("#344214")
	elseif context.item:HasTag("Food") then
		properties.BackgroundColor = Color3.fromHex("#463300")
	elseif context.item:HasTag("Building") then
		properties.BackgroundColor = Color3.fromHex("#352b2b")
	end

	return properties
end)
