# Themes

## Types

### ThemeConfig
Configuration for a theme. Any property not defined in a theme will be ignored, meaning it will use the default theme's property.

- **Type**

	```luau
	type ThemeConfig = {
		backgroundColor: Color3?,
		backgroundTransparency: number?,
		cornerRadius: UDim?,
		smallCornerRadius: UDim?,
		fontFace: Font?,
		textColor: Color3?,
		textSize: number?,
		smallTextSize: number?,
		textStrokeColor: Color3?,
		textStrokeTransparency: number?,

		searchBackgroundColor: Color3?,
		searchBackgroundTransparency: number?,
		searchCornerRadius: UDim?,
		searchStrokeColor: Color3?,
		searchStrokeTransparency: number?,
		searchFontFace: Font?,
		searchTextColor: Color3?,
		searchTextSize: number?,

		categoryTabsBackgroundColor: Color3?,
		categoryTabsFontFace: Font?,
		categoryTabsTextColor: Color3?,
		categoryTabsTextSize: number?,
		categoryTabsIndicatorColor: Color3?,
		categoryTabsDividerColor: Color3?,

		hintFontFace: Font?,
		hintTextColor: Color3?,
		hintTextSize: number?,

		slotBackgroundColor: Color3?,
		slotBackgroundTransparency: number?,
		slotCornerRadius: UDim?,
		slotEquipStrokeColor: Color3?,
		slotEquipStrokeThickness: number?,
		slotEquipStrokeOutline: boolean?,
		slotDragStrokeColor: Color3?,
		slotDragStrokeThickness: number?,
		slotFontFace: Font?,
		slotTextColor: Color3?,
		slotTextSize: number?,
		slotNumberFontFace: Font?,
		slotNumberTextColor: Color3?,
		slotNumberTextSize: number?,

		tooltipBackgroundColor: Color3?,
		tooltipBackgroundTransparency: number?,
		tooltipCornerRadius: UDim?,
		tooltipFontFace: Font?,
		tooltipTextColor: Color3?,
		tooltipTextSize: number?,
	}
	```

## Functions

### setTheme()
Sets the active theme configuration.

- **Type**

	```luau
	function sling.setTheme(config: ThemeConfig)
	```