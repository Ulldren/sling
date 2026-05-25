const vide = require("../../vide")
const types = require("../types")

const create: any = vide.create
const derive = vide.derive

local GAMEPAD_TYPES = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
}

type Props = {
    state: types.State,
}

const function searchbar(props: Props)
    const state = props.state

    const visible_src = derive(function(): boolean
        if GAMEPAD_TYPES[state.last_input_type()] and not state.is_vr() then
            return false
        end
        return true
    end)

    const text_transparency_src = derive(function(): number
        return state.search_query() == "" and 0.5 or 0
    end)

    const x_visible_src = derive(function(): boolean
        return state.search_query() ~= ""
    end)

    const textbox_props: { [any]: any } = {
        Name = "TextBox",
        Size = UDim2.fromOffset(154, 14),
        Position = UDim2.new(0, 8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        PlaceholderText = "Search",
        Text = state.search_query,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextStrokeTransparency = 0.5,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        TextTransparency = text_transparency_src,
        FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Medium),
        TextSize = 16,
        ClearTextOnFocus = false,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 2,
    }

    textbox_props[#textbox_props + 1] = vide.action(function(ref)
        const tb = ref :: TextBox
        vide.cleanup(tb:GetPropertyChangedSignal("Text"):Connect(function()
            state.search_query(tb.Text)
        end))
    end)

    return create("Frame")({
        Name = "Search",
        Position = UDim2.new(1, -195, 0, 5),
        Size = UDim2.fromOffset(190, 30),
        BackgroundColor3 = Color3.fromRGB(25, 27, 29),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Visible = visible_src,

        create("UICorner")({
            CornerRadius = UDim.new(0, 3),
        }),

        create("UIStroke")({
            Color = Color3.new(1, 1, 1),
            Thickness = 1,
            Transparency = 0.8,
        }),

        create("TextBox")(textbox_props),

        create("TextButton")({
            Name = "X",
            Text = "",
            Size = UDim2.fromOffset(30, 30),
            Position = UDim2.new(1, -30, 0.5, -15),
            ZIndex = 4,
            Visible = x_visible_src,
            BackgroundTransparency = 1,

            Activated = function()
                state.search_query("")
            end,

            create("ImageLabel")({
                Name = "XImage",
                Image = "rbxasset://textures/ui/InspectMenu/x.png",
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(10, 10),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                ZIndex = 1,
                BorderSizePixel = 0,
            }),
        }),
    })
end

return searchbar
