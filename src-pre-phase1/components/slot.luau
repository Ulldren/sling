const UserInputService = game:GetService("UserInputService")
const vide = require("../../vide")
const types = require("../types")
const equip = require("../lib/equip")
const move_to_hotbar = require("../internal/move-to-hotbar")
const move_to_inventory = require("../internal/move-to-inventory")
const drag_controller = require("../lib/drag-controller")
const tooltip = require("./tooltip")

const create: any = vide.create
const derive = vide.derive

type Props = {
    state: types.State,
    slot_index: number,
    entry: () -> types.BackpackEntry?,
    kind: "hotbar" | "inventory",
}

const function number_label(slot_index: number): string
    if slot_index == 10 then
        return "0"
    end
    return tostring(slot_index)
end

const function slot(props: Props)
    const state = props.state
    const slot_index = props.slot_index
    const entry_src = props.entry

    const tool_src = derive(function(): types.InventoryItem?
        const entry = entry_src()
        if entry then
            return entry.tool
        end
        return nil
    end)

    const visible_src = derive(function(): boolean
        if props.kind == "inventory" then
            const entry = entry_src()
            return entry ~= nil and entry.visible
        end
        return slot_index <= state.slots_count()
    end)

    const equipped_src = derive(function(): boolean
        const tool = tool_src()
        if not tool then
            return false
        end
        return tool == (state.equipped_tool :: () -> types.InventoryItem?)()
    end)

    const has_icon_src = derive(function(): boolean
        const tool = tool_src()
        if tool and tool:IsA("Tool") then
            return tool.TextureId ~= ""
        end
        return false
    end)

    const icon_src = derive(function(): string
        const tool = tool_src()
        if tool and tool:IsA("Tool") then
            return tool.TextureId
        end
        return ""
    end)

    const tool_name_src = derive(function(): string
        const tool = tool_src()
        if tool then
            return tool.Name
        end
        return ""
    end)

    const fallback_visible_src = derive(function(): boolean
        return tool_src() ~= nil and not has_icon_src()
    end)

    const is_dragging_this_src = derive(function(): boolean
        return state.dragging_slot_index() == slot_index
    end)

    const hovered = vide.source(false)

    local last_click_time = 0
    local drag_started = false

    const button_props: { [any]: any } = {
        Name = "Slot_" .. tostring(slot_index),
        Size = UDim2.fromOffset(64, 64),
        BackgroundColor3 = Color3.fromRGB(25, 27, 29),
        BackgroundTransparency = derive(function()
            return is_dragging_this_src() and 0.8 or 0.3
        end),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = slot_index,
        Visible = visible_src,

        MouseEnter = function()
            hovered(true)
        end,

        MouseLeave = function()
            hovered(false)
        end,

        Activated = function()
            if drag_started then return end
            const now = tick()
            if now - last_click_time < 0.3 then
                const entry = entry_src()
                if entry then
                    if entry.slot_index <= state.slots_count() then
                        move_to_inventory(state, entry.slot_index)
                    else
                        move_to_hotbar(state, entry.slot_index)
                    end
                end
                last_click_time = 0
                return
            end
            last_click_time = now

            const tool = tool_src()
            if tool then
                equip.select(state, tool)
            end
        end,

        InputBegan = function(input: InputObject)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                const entry = entry_src()
                if not entry then return end

                const initial_pos = Vector2.new(input.Position.X, input.Position.Y)
                drag_started = false
                
                local conn: RBXScriptConnection? = nil
                local release_conn: RBXScriptConnection? = nil

                conn = UserInputService.InputChanged:Connect(function(move_input)
                    if move_input.UserInputType == Enum.UserInputType.MouseMovement or move_input.UserInputType == Enum.UserInputType.Touch then
                        const current_pos = Vector2.new(move_input.Position.X, move_input.Position.Y)
                        if (current_pos - initial_pos).Magnitude > 5 and not drag_started then
                            drag_started = true
                            drag_controller.start_drag(state, slot_index)
                        end
                    end
                end)
                
                release_conn = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if conn then conn:Disconnect() end
                        if release_conn then release_conn:Disconnect() end
                        
                        if drag_started then
                            const pos = UserInputService:GetMouseLocation()
                            -- Subtrai 36 do Y pois GetMouseLocation inclui o gui inset (Topbar de 36px) e AbsolutePosition não.
                            -- Ou podemos usar input.Position, mas input pode ser InputEnded que às vezes não tem Position atualizada.
                            drag_controller.stop_drag(state, input.Position.X, input.Position.Y, state.hotbar_frame(), state.inventory_frame())
                            drag_started = false
                        end
                    end
                end)
            end
        end,
    }

    const function add_child(child: any)
        button_props[#button_props + 1] = child
    end

    add_child(create("UICorner")({
        CornerRadius = UDim.new(0, 8),
    }))

    add_child(create("UIStroke", {
        Color = Color3.fromRGB(0, 162, 255),
        Thickness = 5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Enabled = equipped_src,
    }))

    add_child(create("ImageLabel")({
        Name = "Icon",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = icon_src,
        ScaleType = Enum.ScaleType.Fit,
        Visible = has_icon_src,
    }))

    add_child(create("TextLabel")({
        Name = "ToolName",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = tool_name_src,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextStrokeTransparency = 0.5,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        FontFace = Font.fromName("BuilderSans"),
        TextSize = 14,
        TextWrapped = true,
        Visible = fallback_visible_src,
    }))

    if props.kind == "hotbar" then
        add_child(create("TextLabel")({
            Name = "SlotNumber",
            Size = UDim2.fromOffset(20, 14),
            Position = UDim2.fromOffset(4, 4),
            BackgroundTransparency = 1,
            Text = number_label(slot_index),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextStrokeTransparency = 0.5,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            FontFace = Font.fromName("BuilderSans"),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
        }))
    end

    add_child(tooltip({
        entry = entry_src,
        hovered = hovered,
    }))

    return create("TextButton")(button_props)
end

return slot
