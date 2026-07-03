local Sling = require("../Sling")

Sling.onSlotRender(function(context)
	local item = context.item

	local properties = {} :: Sling.SlotProperties

	local children = {}
	local itemNameChildren = {}

	if item:HasTag("Knife") then
		properties.ItemNameText = `<font face='Arcade' color='#ff5252'>{item.Name}</font>`
		properties.BackgroundColor = Color3.fromHex("#421414")
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new(Color3.fromHex("#ffffff"), Color3.fromHex("#7c7c7c"))
		gradient.Rotation = 90
		table.insert(children, gradient)
	elseif item:HasTag("Rainbow") then
		properties.BackgroundColor = Color3.fromHex("#636363")
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#ff0000")),
			ColorSequenceKeypoint.new(0.2, Color3.fromHex("#ff00ff")),
			ColorSequenceKeypoint.new(0.4, Color3.fromHex("#0000ff")),
			ColorSequenceKeypoint.new(0.6, Color3.fromHex("#00ffff")),
			ColorSequenceKeypoint.new(0.8, Color3.fromHex("#00ff00")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#ffff00")),
		})
		gradient.Rotation = 15
		table.insert(children, gradient)
	elseif item:HasTag("Golden") then
		properties.ItemNameText = `<font face='FredokaOne' color='#ffffff'>{item.Name}</font>`
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#ffa600")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#ffef96")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#ffa600")),
		})
		gradient.Rotation = 45
		table.insert(itemNameChildren, gradient)
	end

	properties.Children = children
	properties.ItemNameChildren = itemNameChildren
	return properties
end)
