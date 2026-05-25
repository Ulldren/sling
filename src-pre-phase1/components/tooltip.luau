const vide = require("../../vide")
const types = require("../types")

const create: any = vide.create
const derive = vide.derive

type Props = {
    entry: () -> types.BackpackEntry?,
    hovered: () -> boolean,
}

const function tooltip(props: Props)
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
        Position = UDim2.new(0.5, 0, 0, -4),
        Size = UDim2.fromOffset(0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(25, 27, 29),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Text = text_src,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = Font.fromName("BuilderSans"),
        TextSize = 14,
        Visible = visible_src,
        ZIndex = 100,

        create("UICorner")({
            CornerRadius = UDim.new(0, 4),
        }),

        create("UIPadding")({
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
        }),
    })
end

return tooltip
