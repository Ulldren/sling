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
	ItemName: string?,
	ItemImage: string?,
	TooltipText: string?,
}

export type Can<T> = (() -> T) | T

export type ThemeConfig = {
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

	categoryTabsBackgroundColor: Can<Color3>?,
	categoryTabsFontFace: Can<Font>?,
	categoryTabsTextColor: Can<Color3>?,
	categoryTabsTextSize: Can<number>?,
	categoryTabsIndicatorColor: Can<Color3>?,

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

type function UnwrapProps(props: type): type
	local config = types.newtable()
	local function unwrap(t: type): type
		if t:is("union") then
			for _, component in t:components() do
				local unwrapped = unwrap(component)
				if not unwrapped:is("nil") then
					return unwrapped
				end
			end
		elseif t:is("function") then
			local returns = t:returns()
			if returns and returns.head and returns.head[1] then
				return unwrap(returns.head[1])
			end
		end
		return t
	end
	for property, value in props:properties() do
		config:setproperty(property, unwrap(value.read :: type))
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

export type ThemeProps = UnwrapProps<ThemeConfig>
export type ThemeGetters = GetterProps<ThemeProps>

return nil
