const vide = require("../../vide")
const types = require("../types")
const slot = require("./slot")

const create: any = vide.create
const derive = vide.derive
const indexes = vide.indexes

type Props = {
    state: types.State,
}

const function hotbar(props: Props)
    const state = props.state

    const slot_indices_src = derive(function(): { number }
        const n = state.slots_count()
        const arr: { number } = {}
        for i = 1, n do
            arr[i] = i
        end
        return arr
    end)

    return create("Frame")({
        Name = "Hotbar",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, 0),
        Size = UDim2.fromOffset(0, 70),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,

        create("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),

        create("UIPadding")({
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
        }),

        vide.action(function(ref)
            state.hotbar_frame(ref :: Frame)
        end),

        indexes(slot_indices_src, function(_value_src: () -> number, key: number)
            const entry_src = derive(function(): types.BackpackEntry?
                return state.hotbar_view()[key]
            end)

            return slot({
                state = state,
                slot_index = key,
                entry = entry_src,
                kind = "hotbar",
            })
        end),
    })
end

return hotbar
