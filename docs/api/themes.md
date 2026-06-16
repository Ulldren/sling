# Themes

## Types

### ThemeConfig
Configuration for a theme. Any property not defined in a theme will be ignored, meaning it will use the default theme's property.

- **Type**

	```luau
	-- Utility type for values that can be either a value or a function that returns a value
	type Can<T> = T | (() -> T)

	type ThemeConfig = {
		backgroundColor: Can<Color3>?,
		backgroundTransparency: Can<number>?,
		cornerRadius: Can<UDim>?,
		smallCornerRadius: Can<UDim>?,
		fontFace: Can<Font>?,
		textColor: Can<Color3>?,
		textSize: Can<number>?,
		smallTextSize: Can<number>?,
		textStrokeColor: Can<Color3>?,
		textStrokeTransparency: Can<number>?,

		searchBackgroundColor: Can<Color3>?,
		searchBackgroundTransparency: Can<number>?,
		searchCornerRadius: Can<UDim>?,
		searchStrokeColor: Can<Color3>?,
		searchStrokeTransparency: Can<number>?,
		searchFontFace: Can<Font>?,
		searchTextColor: Can<Color3>?,
		searchTextSize: Can<number>?,

		hintFontFace: Can<Font>?,
		hintTextColor: Can<Color3>?,
		hintTextSize: Can<number>?,

		slotBackgroundColor: Can<Color3>?,
		slotBackgroundTransparency: Can<number>?,
		slotCornerRadius: Can<UDim>?,
		slotEquipStrokeColor: Can<Color3>?,
		slotEquipStrokeThickness: Can<number>?,
		slotEquipStrokeOutline: Can<boolean>?,
		slotFontFace: Can<Font>?,
		slotTextColor: Can<Color3>?,
		slotTextSize: Can<number>?,

		tooltipBackgroundColor: Can<Color3>?,
		tooltipBackgroundTransparency: Can<number>?,
		tooltipCornerRadius: Can<UDim>?,
		tooltipFontFace: Can<Font>?,
		tooltipTextColor: Can<Color3>?,
		tooltipTextSize: Can<number>?,
	}
	```

## Functions

### setTheme()
Sets the active theme configuration.

- **Type**

	```luau
	function sling.setTheme(config: ThemeConfig)
	```