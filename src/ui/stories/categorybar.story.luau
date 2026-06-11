--!nonstrict
local categorybar = require("../components/categorybar")
local px = require("../../core/utils/px")
local states = require("../../core/states")
local types = require("../../core/types")
local vide = require("../../../vide")

local apply = vide.apply
local derive = vide.derive
local effect = vide.effect

local controls = {
	categories = 3,
	width = 655,
}

type Props = {
	controls: typeof(controls),
}

return {
	vide = vide,
	controls = controls,
	story = function(props: Props)
		local function category(name: string): types.Category
			return {
				category = name,
				predicate = function()
					return true
				end,
			}
		end

		local getCategories = derive(function()
			local count = props.controls.categories()
			local categories = {}
			if count < 1 then
				return categories
			end
			for i = 1, count do
				local categoryVal = category("category " .. i)
				table.insert(categories, categoryVal)
			end
			return categories
		end)

		effect(function()
			states.categories(getCategories())
			states.width(props.controls.width())
		end)

		return apply(categorybar())({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = px.offset(states.width, 35),
		})
	end,
}
