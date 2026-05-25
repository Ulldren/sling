const vide = require("../../vide")
const types = require("../types")

const create: any = vide.create
const derive = vide.derive

type Props = {
    entry: () -> types.BackpackEntry?,
    hovered: () -> boolean,
    state: types.State,
}

const function tooltip(props: Props)
    const state = props.state

    const text_src = derive(function(): string
        const entry = props.entry()
        if not entry then return "" end
        if entry.tool:IsA("Tool") then
            return (entry.tool :: Tool).ToolTip
        end
        return ""
    end)

    const visible_src = derive(function(): boolean
        return props.hovered() and text_src() ~= ""
    end)

    return create("TextLabel")({
        Name = "Tooltip",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 0, -5),
        Size = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = derive(function(): Color3 return state.attributes().bg_color end),
        BackgroundTransparency = derive(function(): number return state.attributes().bg_transparency end),
        BorderSizePixel = 0,
        Text = text_src,
        TextColor3 = derive(function(): Color3 return state.attributes().text_color end),
        TextStrokeTransparency = derive(function(): number return state.attributes().text_stroke_transparency end),
        TextStrokeColor3 = derive(function(): Color3 return state.attributes().text_stroke_color end),
        FontFace = derive(function(): Font return state.attributes().font_face end),
        TextSize = derive(function(): number return state.attributes().text_size end),
        Visible = visible_src,
        ZIndex = 100,

        create("UICorner")({
            CornerRadius = UDim.new(0, 3),
        }),

        create("UIPadding")({
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
        }),
    })
end

return tooltip
