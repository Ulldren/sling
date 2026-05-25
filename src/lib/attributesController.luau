local vide = require("../../vide")
local types = require("../types")

local targetScript = script.Parent.Parent
local BACKGROUND_COLOR = targetScript:GetAttribute("BackgroundColor3") or Color3.fromRGB(25, 27, 29)
local DEFAULT_BACKGROUND_TRANSPARENCY = targetScript:GetAttribute("BackgroundTransparency") or 0.3
local CORNER_RADIUS = targetScript:GetAttribute("CornerRadius") or UDim.new(0, 8)
local SMALL_CORNER_RADIUS = targetScript:GetAttribute("SmallCornerRadius") or UDim.new(0, 4)
local SLOT_EQUIP_COLOR = targetScript:GetAttribute("EquipBorderColor3") or Color3.fromRGB(51, 95, 255)
local SLOT_EQUIP_THICKNESS = targetScript:GetAttribute("EquipBorderSizePixel") or 5
local SELECTION_COLOR = targetScript:GetAttribute("SelectionColor3") or Color3.fromRGB(255, 255, 255)
local FONT_FACE = targetScript:GetAttribute("FontFace")
	or Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium)
local TEXT_COLOR = targetScript:GetAttribute("TextColor") or Color3.fromRGB(255, 255, 255)
local TEXT_SIZE = targetScript:GetAttribute("TextSize") or 16
local TEXT_STROKE_COLOR = targetScript:GetAttribute("TextStrokeColor3") or Color3.fromRGB(0, 0, 0)
local TEXT_STROKE_TRANSPARENCY = targetScript:GetAttribute("TextStrokeTransparency") or 0.5

local source = vide.source
local derive = vide.derive
local cleanup = vide.cleanup

local attributesController = {}

function attributesController.generateAttributes(preferredTransparency: vide.Source<number>?)
	local DefaultBackgroundTransparency = source(DEFAULT_BACKGROUND_TRANSPARENCY)
	local BackgroundTransparency = derive(function()
		return DefaultBackgroundTransparency() * (preferredTransparency and preferredTransparency() or 1)
	end)
	local attributes: types.Attributes = {
		BackgroundColor3 = source(BACKGROUND_COLOR),
		DefaultBackgroundTransparency = DefaultBackgroundTransparency,
		BackgroundTransparency = BackgroundTransparency,
		CornerRadius = source(CORNER_RADIUS),
		SmallCornerRadius = source(SMALL_CORNER_RADIUS),
		EquipBorderColor3 = source(SLOT_EQUIP_COLOR),
		EquipBorderSizePixel = source(SLOT_EQUIP_THICKNESS),
		SelectionColor3 = source(SELECTION_COLOR),
		FontFace = source(FONT_FACE),
		TextColor3 = source(TEXT_COLOR),
		TextSize = source(TEXT_SIZE),
		TextStrokeColor3 = source(TEXT_STROKE_COLOR),
		TextStrokeTransparency = source(TEXT_STROKE_TRANSPARENCY),
	}
	local attributeConnections: { RBXScriptConnection } = {}
	for attributeName, source in attributes :: { [string]: vide.Source<any> } do
		table.insert(
			attributeConnections,
			targetScript:GetAttributeChangedSignal(attributeName):Connect(function()
				if attributeName ~= "BackgroundTransparency" then
					source(targetScript:GetAttribute(attributeName))
				end
			end)
		)
	end
	cleanup(function()
		for _, conn in attributeConnections do
			conn:Disconnect()
		end
		table.clear(attributeConnections)
	end)
	return attributes
end

return attributesController
