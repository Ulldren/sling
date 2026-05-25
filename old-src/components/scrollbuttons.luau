const vide = require("../../vide")
const types = require("../types")

const create: any = vide.create
const derive = vide.derive

local SCROLL_STEP = 65

type Props = {
    state: types.State,
}

const function scrollbuttons(props: Props)
    const state = props.state

    const visible_src = derive(function(): boolean
        return state.is_vr()
    end)

    const function scroll_up()
        const frame = state.inventory_frame()
        if not frame then return end
        frame.CanvasPosition = Vector2.new(
            frame.CanvasPosition.X,
            math.max(0, frame.CanvasPosition.Y - SCROLL_STEP)
        )
    end

    const function scroll_down()
        const frame = state.inventory_frame()
        if not frame then return end
        const max_y = math.max(0, frame.CanvasSize.Y.Offset - frame.AbsoluteSize.Y)
        frame.CanvasPosition = Vector2.new(
            frame.CanvasPosition.X,
            math.min(max_y, frame.CanvasPosition.Y + SCROLL_STEP)
        )
    end

    return create("Frame")({
        Name = "ScrollButtons",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Active = false,
        Visible = visible_src,

        create("ImageButton")({
            Name = "ScrollUpButton",
            Position = UDim2.new(0.5, -17, 0, 43),
            Size = UDim2.fromOffset(34, 34),
            BackgroundTransparency = 1,
            Image = "rbxasset://textures/ui/Keyboard/close_button_background.png",
            AutoButtonColor = false,
            Activated = scroll_up,

            create("ImageLabel")({
                Name = "Icon",
                Size = UDim2.fromScale(0.5, 0.5),
                Position = UDim2.fromScale(0.25, 0.23),
                BackgroundTransparency = 1,
                Image = "rbxasset://textures/ui/Backpack/ScrollUpArrow.png",
            }),
        }),

        create("ImageButton")({
            Name = "ScrollDownButton",
            Position = UDim2.new(0.5, -17, 1, -37),
            Size = UDim2.fromOffset(34, 34),
            Rotation = 180,
            BackgroundTransparency = 1,
            Image = "rbxasset://textures/ui/Keyboard/close_button_background.png",
            AutoButtonColor = false,
            Activated = scroll_down,

            create("ImageLabel")({
                Name = "Icon",
                Size = UDim2.fromScale(0.5, 0.5),
                Position = UDim2.fromScale(0.25, 0.23),
                BackgroundTransparency = 1,
                Image = "rbxasset://textures/ui/Backpack/ScrollUpArrow.png",
            }),
        }),
    })
end

return scrollbuttons
