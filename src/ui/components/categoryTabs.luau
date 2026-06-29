local category = require("./category")
local colorSpring = require("../../core/utils/colorSpring")
local cond = require("../../core/utils/cond")
local px = require("../../core/utils/px")
local states = require("../../core/states")
local theme = require("../theme")
local useCategories = require("../hooks/backpack/useCategories")
local vide = require("../../../vide")

local create = vide.create
local indexes = vide.indexes
local derive = vide.derive
local show = vide.show
local source = vide.source

local MAX_CATEGORY_WIDTH = 100
local CATEGORY_HEIGHT = 35
local DROPDOWN_BUTTON_WIDTH = 35
local DROPDOWN_WIDTH = 120
local DROPDOWN_SCROLLBAR_THICKNESS = 5

local function categoryTabs()
	local categories = useCategories({
		maxCategoryWidth = MAX_CATEGORY_WIDTH,
		dropdownButtonWidth = DROPDOWN_BUTTON_WIDTH,
	})

	local barCategories = categories.barCategories
	local dropdownCategories = categories.dropdownCategories
	local showDropdown = categories.showDropdown
	local categoryWidth = categories.categoryWidth

	return create("Frame")({
		Name = "CategoryTabs",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = colorSpring(theme.categoryTabsBackgroundColor),
		Size = px.udim2(1, 0, 0, CATEGORY_HEIGHT),

		create("UICorner")({
			TopLeftRadius = theme.cornerRadius,
			TopRightRadius = theme.cornerRadius,
			BottomLeftRadius = UDim.new(0, 0),
			BottomRightRadius = UDim.new(0, 0),
		}),

		create("Frame")({
			Name = "Divider",
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = colorSpring(theme.categoryTabsDividerColor),
			BackgroundTransparency = 0.8,
			Position = UDim2.fromScale(0.5, 1),
			Size = px.udim2(1, 0, 0, 1),
		}),

		create("Frame")({
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),

			create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			indexes(barCategories, function(categorySrc)
				return category({
					category = categorySrc,
					size = px.offset(categoryWidth, CATEGORY_HEIGHT),
					inBar = true,
				})
			end),

			show(showDropdown, function()
				local dropdownOpen = source(false)

				return create("TextButton")({
					Name = "DropdownButton",
					BackgroundTransparency = 1,
					Size = cond.ifelse(
						cond.gt(cond.len(barCategories), 0),
						px.udim2(0, DROPDOWN_BUTTON_WIDTH, 0, CATEGORY_HEIGHT),
						px.udim2(1, 0, 0, CATEGORY_HEIGHT)
					),
					Text = "chevron-small-down",
					FontFace = Font.new(
						"rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json",
						Enum.FontWeight.Regular,
						Enum.FontStyle.Normal
					),
					TextSize = px.scale(24),
					TextColor3 = colorSpring(theme.categoryTabsTextColor),
					LayoutOrder = function()
						return #barCategories() + 1
					end,

					Activated = function()
						dropdownOpen(not dropdownOpen())
					end,

					show(dropdownOpen, function()
						local height = derive(function()
							return math.min(
								#dropdownCategories() * CATEGORY_HEIGHT,
								(states.rows() + 1) * CATEGORY_HEIGHT
							)
						end)

						return create("Frame")({
							Name = "Dropdown",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundColor3 = colorSpring(theme.categoryTabsBackgroundColor),
							Position = UDim2.fromScale(1, 1),
							Size = px.offset(function()
								return math.min(DROPDOWN_WIDTH, states.width())
							end, height),
							ZIndex = 2,

							create("UIStroke")({
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								BorderStrokePosition = Enum.BorderStrokePosition.Inner,
								Color = colorSpring(theme.categoryTabsTextColor),
								Thickness = px.scale(1),
								Transparency = 0.8,
							}),

							create("ScrollingFrame")({
								AutomaticCanvasSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								CanvasSize = UDim2.new(0, 0, 0, 0),
								ElasticBehavior = Enum.ElasticBehavior.Always,
								ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
								ScrollBarThickness = px.scale(DROPDOWN_SCROLLBAR_THICKNESS),
								ScrollingDirection = Enum.ScrollingDirection.Y,
								Selectable = false,
								Size = px.udim2(1, DROPDOWN_SCROLLBAR_THICKNESS, 0, height),

								create("UIListLayout")({
									FillDirection = Enum.FillDirection.Vertical,
									SortOrder = Enum.SortOrder.LayoutOrder,
								}),

								indexes(dropdownCategories, function(categorySrc)
									return category({
										category = categorySrc,
										size = px.udim2(1, -5, 0, CATEGORY_HEIGHT),
									})
								end),
							}),
						})
					end),
				})
			end),
		}),
	})
end

return categoryTabs
