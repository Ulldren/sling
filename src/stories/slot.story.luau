const slot = require("../components/slot")
const vide = require("../../vide")

const source = vide.source
const cleanup = vide.cleanup

return {
	vide = vide,
	story = function()
		const item = Instance.new("Tool")
		item.Name = "Tool"
		item.ToolTip = "Tooltip"

		cleanup(item)

		return vide.apply(slot({
			entry = source({ item = item }),
			equipped = source(nil),
			order = 1,
			unlocked = source(true),
		}))({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
