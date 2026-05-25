const vide = require("../../vide")
const types = require("../types")
const slot = require("./slot")
const searchbar = require("./searchbar")
const scrollbuttons = require("./scrollbuttons")

const create: any = vide.create
const indexes = vide.indexes
const derive = vide.derive

local ICON_BUFFER = 5
local ICON_SIZE = 60
local INVENTORY_HEADER_SIZE = 40
local INVENTORY_ARROWS_BUFFER_VR = 40

type Props = {
    state: types.State,
}

const function inventory(props: Props)
    const state = props.state

    const panel_size = derive(function(): UDim2
        const slots = state.slots_count()
        const rows = state.rows_count()
        const is_vr = state.is_vr()
        const width = ICON_BUFFER + slots * (ICON_SIZE + ICON_BUFFER)
        const vr_extra = is_vr and 2 * INVENTORY_ARROWS_BUFFER_VR or 0
        const height = rows * (ICON_BUFFER + ICON_SIZE + ICON_BUFFER) + INVENTORY_HEADER_SIZE + vr_extra
        return UDim2.fromOffset(width, height)
    end)

    const scroll_pos = derive(function(): UDim2
        const is_vr = state.is_vr()
        const vr_offset = is_vr and INVENTORY_ARROWS_BUFFER_VR or 0
        return UDim2.fromOffset(0, INVENTORY_HEADER_SIZE + vr_offset)
    end)

    const scroll_size = derive(function(): UDim2
        const rows = state.rows_count()
        const is_vr = state.is_vr()
        const vr_reduction = is_vr and 2 * INVENTORY_ARROWS_BUFFER_VR or 0
        return UDim2.new(1, 9, 0, rows * (ICON_BUFFER + ICON_SIZE + ICON_BUFFER) - vr_reduction)
    end)

    return create("Frame")({
        Name = "Inventory",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -(ICON_BUFFER + ICON_SIZE + ICON_BUFFER)),
        Size = panel_size,
        BackgroundColor3 = derive(function(): Color3 return state.attributes().bg_color end),
        BackgroundTransparency = derive(function(): number return state.attributes().bg_transparency end),
        Active = true,
        Visible = state.opened,

        create("UICorner")({
            CornerRadius = derive(function(): UDim return state.attributes().corner_radius end),
        }),

        searchbar({ state = state }),

        create("ScrollingFrame")({
            Name = "Grid",
            Position = scroll_pos,
            Size = scroll_size,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Selectable = false,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize = UDim2.fromScale(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 8,
            ScrollBarImageColor3 = Color3.new(1, 1, 1),
            VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,

            vide.action(function(ref)
                state.inventory_frame(ref :: ScrollingFrame)
            end),

            create("Frame")({
                Name = "UIGridFrame",
                Size = UDim2.new(1, -(ICON_BUFFER * 2), 1, 0),
                Position = UDim2.fromOffset(ICON_BUFFER, 0),
                BackgroundTransparency = 1,
                Selectable = false,

                create("UIGridLayout")({
                    CellSize = UDim2.fromOffset(ICON_SIZE, ICON_SIZE),
                    CellPadding = UDim2.fromOffset(ICON_BUFFER, ICON_BUFFER),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),

                indexes(state.inventory_view, function(entry_src: () -> types.BackpackEntry, slot_index_key: number)
                    return slot({
                        state = state,
                        slot_index = slot_index_key,
                        entry = entry_src,
                        kind = "inventory",
                    })
                end),
            }),
        }),

        scrollbuttons({ state = state }),
    })
end

return inventory
