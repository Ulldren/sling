const vide = require("../../vide")
const types = require("../types")

const create: any = vide.create

type Props = {
    state: types.State,
}

const function searchbar(props: Props)
    const state = props.state

    const textbox_props: { [any]: any } = {
        Name = "Input",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(40, 42, 44),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        PlaceholderText = "Search",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        Text = state.search_query,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = Font.fromName("BuilderSans"),
        TextSize = 14,
        ClearTextOnFocus = false,
    }

    textbox_props[#textbox_props + 1] = vide.action(function(ref)
        const tb = ref :: TextBox
        vide.cleanup(tb:GetPropertyChangedSignal("Text"):Connect(function()
            state.search_query(tb.Text)
        end))
    end)

    textbox_props[#textbox_props + 1] = create("UICorner")({
        CornerRadius = UDim.new(0, 6),
    })

    textbox_props[#textbox_props + 1] = create("UIPadding")({
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    })

    return create("Frame")({
        Name = "Searchbar",
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,

        create("TextBox")(textbox_props),
    })
end

return searchbar
