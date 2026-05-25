const vide = require("../../vide")
const types = require("../types")

const create: any = vide.create
const derive = vide.derive

type Props = {
    state: types.State,
}

const function vrpopup(props: Props)
    const state = props.state

    const visible_src = derive(function(): boolean
        return state.is_vr() and state.vr_popup_visible()
    end)

    const tool_name_src = derive(function(): string
        const tool = state.equipped_tool()
        if tool then return tool.Name end
        return ""
    end)

    const icon_src = derive(function(): string
        const tool = state.equipped_tool()
        if tool and tool:IsA("Tool") then
            return (tool :: Tool).TextureId
        end
        return ""
    end)

    const has_icon_src = derive(function(): boolean
        return icon_src() ~= ""
    end)

    return create("Frame")({
        Name = "VRPopup",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -160),
        Size = UDim2.fromOffset(0, 72),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(25, 27, 29),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Visible = visible_src,
        ZIndex = 200,

        create("UICorner")({
            CornerRadius = UDim.new(0, 8),
        }),

        create("UIPadding")({
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
        }),

        create("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),

        create("ImageLabel")({
            Name = "Icon",
            Size = UDim2.fromOffset(56, 56),
            BackgroundColor3 = Color3.fromRGB(40, 42, 44),
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Image = icon_src,
            ScaleType = Enum.ScaleType.Fit,
            Visible = has_icon_src,
            LayoutOrder = 1,

            create("UICorner")({
                CornerRadius = UDim.new(0, 6),
            }),
        }),

        create("TextLabel")({
            Name = "ToolName",
            Size = UDim2.fromOffset(0, 56),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text = tool_name_src,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Medium),
            TextSize = 18,
            LayoutOrder = 2,
        }),
    })
end

return vrpopup
