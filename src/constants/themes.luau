local types = require("../types")

type ThemeConfig = types.ThemeConfig

return table.freeze({
	default = table.freeze({
		backgroundColor = Color3.fromHex("#191b1d"),
		backgroundTransparency = 0.3,
		cornerRadius = UDim.new(0, 8),
		smallCornerRadius = UDim.new(0, 4),
		fontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium),
		textColor = Color3.fromHex("#ffffff"),
		textSize = 16,
		smallTextSize = 14,
		textStrokeColor = Color3.fromHex("#000000"),
		textStrokeTransparency = 0.5,

		slotEquipStrokeColor = Color3.fromHex("#335fff"),
		slotEquipStrokeThickness = 5,
		slotEquipStrokeOutline = true,

		searchBackgroundTransparency = 0.2,
		searchStrokeColor = Color3.fromHex("#ffffff"),
		searchStrokeTransparency = 0.8,

		tooltipBackgroundTransparency = 0,
	}) :: ThemeConfig,
	light = table.freeze({
		backgroundColor = Color3.fromHex("#eff1f5"),
		textStrokeTransparency = 1,
		textColor = Color3.fromHex("#4c4f69"),
		slotEquipStrokeColor = Color3.fromHex("#9eb3ff"),
		searchStrokeColor = Color3.fromHex("#4c4f69"),
		hintTextColor = Color3.fromHex("#ffffff"),
	}) :: ThemeConfig,
})
