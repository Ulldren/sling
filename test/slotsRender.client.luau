local Sling = require("../Sling")

Sling.onSlotRender(function(context)
	local item = context.item

	local properties = {} :: Sling.SlotProperties

	local children = {}
	local itemNameChildren = {}

	if item:HasTag("Sword") then
		properties.BackgroundColor = Color3.fromHex("#142442")
	elseif item:HasTag("Knife") then
		properties.ItemNameText = `<font face='Arcade' color='#ff5252'>{item.Name}</font>`
		properties.BackgroundColor = Color3.fromHex("#421414")
		local bg_gradient = Instance.new("UIGradient")
		bg_gradient.Color = ColorSequence.new(Color3.fromHex("#ffffff"), Color3.fromHex("#7c7c7c"))
		bg_gradient.Rotation = 90
		table.insert(children, bg_gradient)
	elseif item:HasTag("Gun") then
		properties.BackgroundColor = Color3.fromHex("#311442")
	elseif item:HasTag("Explosive") then
		properties.BackgroundColor = Color3.fromHex("#344214")
	elseif item:HasTag("Food") then
		properties.BackgroundColor = Color3.fromHex("#463300")
	elseif item:HasTag("Building") then
		properties.BackgroundColor = Color3.fromHex("#352b2b")
	elseif item:HasTag("Rainbow") then
		properties.BackgroundColor = Color3.fromHex("#636363")
		local bg_gradient = Instance.new("UIGradient")
		bg_gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#ff0000")),
			ColorSequenceKeypoint.new(0.2, Color3.fromHex("#ff00ff")),
			ColorSequenceKeypoint.new(0.4, Color3.fromHex("#0000ff")),
			ColorSequenceKeypoint.new(0.6, Color3.fromHex("#00ffff")),
			ColorSequenceKeypoint.new(0.8, Color3.fromHex("#00ff00")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#ffff00")),
		})
		bg_gradient.Rotation = 15
		table.insert(children, bg_gradient)
	end

	properties.Children = children
	properties.ItemNameChildren = itemNameChildren
	return properties
end)
