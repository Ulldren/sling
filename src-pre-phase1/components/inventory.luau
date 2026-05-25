const vide = require("../../vide")
const types = require("../types")
const slot = require("./slot")
const searchbar = require("./searchbar")

const create: any = vide.create
const indexes = vide.indexes

type Props = {
    state: types.State,
}

const function inventory(props: Props)
    const state = props.state
    
    return create("Frame")({
        Name = "Inventory",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -90),
        Size = UDim2.fromOffset(0, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        Visible = state.opened,

        create("Frame")({
            Name = "Container",
            Size = UDim2.fromOffset(0, 0),
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,

            create("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),

            create("Frame")({
                Name = "SearchRow",
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                LayoutOrder = 1,

                searchbar({ state = state }),
            }),

            create("ScrollingFrame")({
                Name = "Grid",
                Size = UDim2.fromOffset(0, 260),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = Color3.fromRGB(25, 27, 29),
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                CanvasSize = UDim2.fromScale(0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 8,

                vide.action(function(ref)
                    state.inventory_frame(ref :: ScrollingFrame)
                end),

                create("UICorner")({
                    CornerRadius = UDim.new(0, 8),
                }),

                create("UIGridLayout")({
                    CellSize = UDim2.fromOffset(64, 64),
                    CellPadding = UDim2.fromOffset(5, 5),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),

                create("UIPadding")({
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
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
    })
end

return inventory
