const UserInputService = game:GetService("UserInputService")
const vide = require("../../vide")
const types = require("../types")

const create: any = vide.create
const derive = vide.derive

type Props = {
    state: types.State,
}

const function fakeslot(props: Props)
    const state = props.state

    const dragged_entry_src = derive(function(): types.BackpackEntry?
        const idx = state.dragging_slot_index()
        if not idx then return nil end
        for _, e in state.backpack_items() do
            if e.slot_index == idx then
                return e
            end
        end
        return nil
    end)

    const mouse_pos = vide.source(UserInputService:GetMouseLocation())

    vide.effect(function()
        if state.dragging_slot_index() ~= nil then
            mouse_pos(UserInputService:GetMouseLocation())
            const conn = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    mouse_pos(Vector2.new(input.Position.X, input.Position.Y))
                end
            end)
            vide.cleanup(conn)
        end
    end)

    const pos_src = derive(function(): UDim2
        const pos = mouse_pos()
        return UDim2.fromOffset(pos.X, pos.Y)
    end)

    const icon_src = derive(function(): string
        const entry = dragged_entry_src()
        if entry and entry.tool:IsA("Tool") then
            return (entry.tool :: Tool).TextureId
        end
        return ""
    end)

    const has_icon_src = derive(function(): boolean
        return icon_src() ~= ""
    end)

    const tool_name_src = derive(function(): string
        const entry = dragged_entry_src()
        if entry then return entry.tool.Name end
        return ""
    end)

    const visible_src = derive(function(): boolean
        return dragged_entry_src() ~= nil
    end)

    return create("Frame")({
        Name = "FakeSlot",
        Size = UDim2.fromOffset(60, 60),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(25, 27, 29),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = pos_src,
        Visible = visible_src,
        ZIndex = 10000,

        create("UICorner")({
            CornerRadius = UDim.new(0, 8),
        }),

        create("ImageLabel")({
            Name = "Icon",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Image = icon_src,
            Visible = has_icon_src,
        }),

        create("TextLabel")({
            Name = "ToolName",
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Text = tool_name_src,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextStrokeTransparency = 0.5,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Medium),
            TextSize = 16,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Visible = derive(function(): boolean
                return not has_icon_src()
            end),
        }),
    })
end

return fakeslot
