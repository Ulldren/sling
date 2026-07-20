export type CategoryPredicate = (item: BackpackItem) -> boolean
export type Category = {
	category: string,
	predicate: CategoryPredicate,
}

export type SlotContext = {
	item: BackpackItem,
	inHotbar: boolean?,
	order: number,
}

export type SlotProperties = {
	BackgroundColor: Color3?,
	BackgroundTransparency: number?,
	Children: { Instance }?,
	ItemNameText: string?,
	ItemNameChildren: { Instance }?,
}

export type Can<T> = (() -> T) | T

export type ThemeConfig = {
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

type function NonNilableProps(props: type): type
	local config = types.newtable()
	for property, value in props:properties() do
		local read = value.read :: type
		local result = read
		for _, component in read:components() do
			if not component:is("nil") then
				result = component
				break
			end
		end
		config:setproperty(property, result)
	end
	return config
end

type function GetterProps(props: type): type
	local config = types.newtable()
	for property, value in props:properties() do
		config:setproperty(property, types.newfunction({}, { head = { value.read :: type } }))
	end
	return config
end

export type ThemeProps = NonNilableProps<ThemeConfig>
export type ThemeGetters = GetterProps<ThemeProps>

return nil
