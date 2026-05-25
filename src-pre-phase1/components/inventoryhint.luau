const vide = require("../../vide")
const types = require("../types")

const create: any = vide.create
const derive = vide.derive

type Props = {
    state: types.State,
}

local GAMEPAD_TYPES = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
}

const function hint_label(key: string, action: string)
    return create("Frame")({
        Name = "Hint_" .. key,
        Size = UDim2.fromOffset(0, 20),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,

        create("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),

        create("TextLabel")({
            Name = "Key",
            Size = UDim2.fromOffset(20, 20),
            BackgroundColor3 = Color3.fromRGB(60, 62, 64),
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Text = key,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Bold),
            TextSize = 12,
            LayoutOrder = 1,

            create("UICorner")({
                CornerRadius = UDim.new(0, 4),
            }),
        }),

        create("TextLabel")({
            Name = "Action",
            Size = UDim2.fromOffset(0, 20),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = action,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            FontFace = Font.fromName("BuilderSans"),
            TextSize = 12,
            LayoutOrder = 2,
        }),
    })
end

const function inventoryhint(props: Props)
    const state = props.state

    const visible_src = derive(function(): boolean
        if not state.opened() then return false end
        if not (state.gamepad_enabled :: () -> boolean)() then return false end
        const input_type = (state.last_input_type :: () -> Enum.UserInputType)()
        return GAMEPAD_TYPES[input_type] == true
    end)

    return create("Frame")({
        Name = "InventoryHint",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 8),
        Size = UDim2.fromOffset(0, 20),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Visible = visible_src,

        create("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),

        hint_label("X", "Move"),
        hint_label("A", "Select / Swap"),
        hint_label("B", "Close"),
    })
end

return inventoryhint
