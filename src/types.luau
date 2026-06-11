export type CategoryPredicate = (item: BackpackItem) -> boolean
export type Category = {
	category: string,
	predicate: CategoryPredicate,
}

export type ThemeProps = {
	backgroundColor: Color3,
	backgroundTransparency: number,
	cornerRadius: UDim,
	smallCornerRadius: UDim,
	fontFace: Font,
	textColor: Color3,
	textSize: number,
	smallTextSize: number,
	textStrokeColor: Color3,
	textStrokeTransparency: number,

	searchBackgroundColor: Color3,
	searchBackgroundTransparency: number,
	searchCornerRadius: UDim,
	searchStrokeColor: Color3,
	searchStrokeTransparency: number,
	searchFontFace: Font,
	searchTextColor: Color3,
	searchTextSize: number,

	hintFontFace: Font,
	hintTextColor: Color3,
	hintTextSize: number,

	slotBackgroundColor: Color3,
	slotBackgroundTransparency: number,
	slotCornerRadius: UDim,
	slotEquipStrokeColor: Color3,
	slotEquipStrokeThickness: number,
	slotEquipStrokeOutline: boolean,
	slotFontFace: Font,
	slotTextColor: Color3,
	slotTextSize: number,

	tooltipBackgroundColor: Color3,
	tooltipBackgroundTransparency: number,
	tooltipCornerRadius: UDim,
	tooltipFontFace: Font,
	tooltipTextColor: Color3,
	tooltipTextSize: number,
}

export type Can<T> = (() -> T) | T

type function CanProps(props: type): type
	local config = types.newtable()
	for property, value in props:properties() do
		local read = value.read :: type
		config:setproperty(property, types.optional(types.unionof(types.newfunction({}, { head = { read } }), read)))
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

export type ThemeConfig = CanProps<ThemeProps>
export type ThemeGetters = GetterProps<ThemeProps>

return nil
