const Players = game:GetService("Players")

const Icon = require("@game/ReplicatedStorage/VideBackpackLoader/VideBackpack/Packages/topbarplus")

const player = Players.LocalPlayer

const toolIcon = Icon.new()
toolIcon:setLabel("Tool Options")
toolIcon:align("Right")
toolIcon:setDropdown({
	Icon.new()
		:setLabel("Add Tool")
		:bindEvent("deselected", function()
			const backpack = player:FindFirstChildOfClass("Backpack") :: Backpack
			const tool = Instance.new("Tool")
			tool.Parent = backpack
		end)
		:oneClick(),
	Icon.new()
		:setLabel("Add HopperBin")
		:bindEvent("deselected", function()
			const backpack = player:FindFirstChildOfClass("Backpack") :: Backpack
			const hopperBin = Instance.new("HopperBin")
			hopperBin.Parent = backpack
		end)
		:oneClick(),
	Icon.new()
		:setLabel("Clear Backpack")
		:bindEvent("deselected", function()
			const backpack = player:FindFirstChildOfClass("Backpack") :: Backpack
			backpack:ClearAllChildren()
		end)
		:oneClick(),
})
