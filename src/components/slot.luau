local colorSpring = require("../utils/colorSpring")
local cond = require("../utils/cond")
local config = require("../constants/config")
local px = require("../utils/px")
local states = require("../states")
local theme = require("../theme")
local tooltip = require("./tooltip")
local usePreferredTransparency = require("../hooks/usePreferredTransparency")
local useSlot = require("../hooks/backpack/useSlot")
local vide = require("../../vide")

local create = vide.create
local show = vide.show
local action = vide.action
local derive = vide.derive
local source = vide.source
local spring = vide.spring

type Props = {
	item: vide.Source<BackpackItem?>,
	order: number,
	visible: vide.Source<boolean>?,
	unlocked: vide.Source<boolean>?,
	inHotbar: boolean?,
}

local function slot(props: Props): Frame
	local item = props.item
	local isHovering = source(false)
	local preferredTransparency = usePreferredTransparency()
	local backgroundTransparency = derive(function()
		return theme.theme.slotBackgroundTransparency() * preferredTransparency()
	end)
	local slot = useSlot({
		item = item,
		order = props.order,
		inHotbar = props.inHotbar,
	})

	return create("Frame")({
		Name = tostring(props.order),
		BackgroundTransparency = 1,
		Size = px.offset(config.slotSize, config.slotSize),
		LayoutOrder = props.order,
		Visible = props.visible,

		action(slot.slotFrameRef),

		create("TextButton")({
			AutoButtonColor = true,
			BackgroundColor3 = colorSpring(theme.theme.slotBackgroundColor),
			BackgroundTransparency = cond.ifelse(props.unlocked, 0, backgroundTransparency),
			Size = slot.slotSize,
			Text = cond.ifelse(cond.eq(slot.itemImage, ""), slot.itemName, ""),
			FontFace = theme.theme.slotFontFace,
			TextColor3 = colorSpring(theme.theme.slotTextColor),
			TextScaled = true,
			TextStrokeTransparency = theme.theme.textStrokeTransparency,
			TextTruncate = Enum.TextTruncate.SplitWord,
			Draggable = cond.all(states.opened, item),
			ZIndex = slot.zindex,

			action(slot.slotRef) :: any,

			MouseEnter = function()
				isHovering(true)
			end,
			MouseLeave = function()
				isHovering(false)
			end,
			MouseButton1Click = slot.onClick,
			DragBegin = slot.onDragBegin,
			DragStopped = slot.onDragStopped,

			create("UITextSizeConstraint")({
				MaxTextSize = px.scale(theme.theme.slotTextSize),
				MinTextSize = px.scale(12),
			}),

			create("UIPadding")({
				PaddingBottom = px.udim(0, 5),
				PaddingLeft = px.udim(0, 5),
				PaddingRight = px.udim(0, 5),
				PaddingTop = px.udim(0, 5),
			}),

			create("UICorner")({
				CornerRadius = theme.theme.slotCornerRadius,
			}),

			show(cond.all(props.inHotbar, states.keyboardHint), function()
				return create("TextLabel")({
					Name = "Number",
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = slot.slotNumber,
					TextColor3 = colorSpring(theme.theme.slotTextColor),
					TextSize = px.scale(theme.theme.slotTextSize),
					FontFace = function()
						return Font.new(theme.theme.slotFontFace().Family, Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
					end,
					TextStrokeColor3 = colorSpring(theme.theme.textStrokeColor),
					TextStrokeTransparency = theme.theme.textStrokeTransparency,
					ZIndex = slot.zindex,
				})
			end),
			create("ImageLabel")({
				Name = "Icon",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = slot.itemImage,
				Size = UDim2.fromScale(1, 1),
				ZIndex = slot.zindex,
				Visible = cond.neq(slot.itemImage, ""),

				create("UICorner")({
					CornerRadius = theme.theme.slotCornerRadius,
				}),
			}),
			show(cond.all(item, cond.eq(states.equippedItem, item)), function(_, present)
				return create("UIStroke")({
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = theme.theme.slotEquipStrokeColor,
					LineJoinMode = Enum.LineJoinMode.Round,
					Thickness = spring(px.scale(cond.ifelse(present, theme.theme.slotEquipStrokeThickness, 0)), 0.1),
				}),
					0.1
			end),
			show(
				cond.any(cond.all(item, slot.isDragging), cond.eq(states.gamepadSwapIndex, slot.getIndex)),
				function(_, present)
					return create("UIStroke")({
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						BorderStrokePosition = Enum.BorderStrokePosition.Inner,
						Color = Color3.fromRGB(255, 255, 255),
						Thickness = spring(px.scale(cond.ifelse(present, 2, 0)), 0.1),
						Transparency = cond.ifelse(item, 0, 0.5),
					}),
						0.1
				end
			),
			show(cond.all(props.inHotbar, cond.neq(slot.tooltipText, ""), isHovering), function(_, present)
				return tooltip({
					text = slot.tooltipText,
					visible = present,
				}), 0.2
			end),
		}),
	})
end

return slot
