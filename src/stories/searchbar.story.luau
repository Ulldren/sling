--!nonstrict
const searchbar = require("../components/searchbar")
const vide = require("../../vide")

return {
	vide = vide,
	story = function()
		return vide.apply(searchbar({
			searchText = vide.source(""),
		}))({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
