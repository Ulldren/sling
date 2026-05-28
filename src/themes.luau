local types = require("./types")

type ThemeConfig = types.ThemeConfig

return {
	default = {
		backgroundColor = Color3.fromHex("#191b1d"),
		backgroundTransparency = 0.3,
		cornerRadius = UDim.new(0, 8),
		smallCornerRadius = UDim.new(0, 4),
		fontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium),
		textColor = Color3.fromHex("#ffffff"),
		textSize = 16,
		smallTextSize = 16,
		textStrokeColor = Color3.fromRGB(0, 0, 0),
		textStrokeTransparency = 0.5,

		slotEquipStrokeColor = Color3.fromHex("#335fff"),
		slotEquipStrokeThickness = 4,

		searchBackgroundTransparency = 0.2,
		searchStrokeColor = Color3.fromHex("#ffffff"),
		searchStrokeTransparency = 0.8,
		searchPlaceholderColor = Color3.fromHex("#afafaf"),

		tooltipBackgroundTransparency = 0,
	} :: ThemeConfig,
	white = {
		backgroundColor = Color3.fromHex("#eff1f5"),
		textStrokeTransparency = 1,
		textColor = Color3.fromHex("#4c4f69"),
		slotEquipStrokeColor = Color3.fromHex("#9eb3ff"),
		searchStrokeColor = Color3.fromHex("#4c4f69"),
		hintTextColor = Color3.fromHex("#ffffff"),
	} :: ThemeConfig,
}
