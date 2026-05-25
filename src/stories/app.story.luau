local vide = require("../../vide")
local app = require("../components/app")
local attributesController = require("../lib/attributesController")
local types = require("../types")

local source = vide.source
local derive = vide.derive

local controls = {
	keyboardHint = true,
	gamepadHint = true,
	opened = true,
	slots = 10,
	rows = 4,
	categories = 4,
}

type Props = {
	controls: typeof(controls),
}

return {
	vide = vide,
	controls = controls,
	story = function(props: Props)
		local function createSword()
			local tool = Instance.new("Tool")
			tool.Name = "Sword"
			tool.TextureId = "rbxasset://Textures/Sword128.png"
			tool.ToolTip = "A cool sword"
			return tool
		end

		local function category(name: string): types.Category
			return {
				category = name,
				predicate = function(item)
					return true
				end,
			}
		end

		local getCategories = derive(function()
			local count = (props.controls.categories :: any)()
			local categories = {}
			if count < 1 then
				return categories
			end
			for i = 1, count do
				local category = category("category " .. i)
				table.insert(categories, category)
			end
			return categories
		end)

		return app({
			opened = props.controls.opened :: any,
			slots = props.controls.slots :: any,
			rows = props.controls.rows :: any,
			items = source({ [1] = createSword(), [11] = createSword(), [12] = createSword() }),
			equippedItem = source(nil),
			keyboardHint = props.controls.keyboardHint :: any,
			gamepadHint = props.controls.gamepadHint :: any,
			categories = getCategories,
			selectedCategory = source(""),
			attributes = attributesController.generateAttributes(),
		})
	end,
}
