const vide = require("../../vide")
const types = require("../types")

const create: any = vide.create
const derive = vide.derive

local ICON_BUFFER = 5
local ICON_SIZE = 60
local INVENTORY_HEADER_SIZE = 40
local HOTBAR_HEIGHT = ICON_BUFFER + ICON_SIZE + ICON_BUFFER
local HINT_OFFSET = 5

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
        if not state.gamepad_enabled() then return false end
        return GAMEPAD_TYPES[state.last_input_type()] == true
    end)

    const position_src = derive(function(): UDim2
        const rows = state.rows_count()
        const vr_extra = state.is_vr() and 2 * 40 or 0
        const panel_height = rows * (ICON_BUFFER + ICON_SIZE + ICON_BUFFER) + INVENTORY_HEADER_SIZE + vr_extra
        const offset = -(HOTBAR_HEIGHT + panel_height + HINT_OFFSET)
        return UDim2.new(0.5, 0, 1, offset)
    end)

    return create("Frame")({
        Name = "InventoryHint",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = position_src,
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
