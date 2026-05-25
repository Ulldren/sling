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
    
    -- Atualizar a posição do mouse enquanto estiver arrastando
    vide.effect(function()
        if state.dragging_slot_index() ~= nil then
            const conn = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    mouse_pos(Vector2.new(input.Position.X, input.Position.Y))
                end
            end)
            vide.cleanup(conn)
        end
    end)

    const pos_src = derive(function()
        const pos = mouse_pos()
        return UDim2.fromOffset(pos.X, pos.Y)
    end)

    const icon_src = derive(function()
        const entry = dragged_entry_src()
        if entry and entry.tool:IsA("Tool") then
            return entry.tool.TextureId
        end
        return ""
    end)

    const visible_src = derive(function()
        return dragged_entry_src() ~= nil
    end)

    return create("ImageLabel")({
        Name = "FakeSlot",
        Size = UDim2.fromOffset(64, 64),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 0.5,
        BackgroundColor3 = Color3.fromRGB(25, 27, 29),
        Image = icon_src,
        Position = pos_src,
        Visible = visible_src,
        ZIndex = 10000,
        
        create("UICorner")({
            CornerRadius = UDim.new(0, 8),
        }),
    })
end

return fakeslot
