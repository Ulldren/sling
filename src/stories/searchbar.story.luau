--!nonstrict
local searchbar = require("../components/searchbar")
local vide = require("../../vide")

local apply = vide.apply
local source = vide.source

return {
	vide = vide,
	story = function()
		return apply(searchbar({
			searchText = source(""),
		}))({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
