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

local GAMEPAD_TYPES = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
}

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
        return tool_src() ~= nil or state.opened()
    end)

    const equipped_src = derive(function(): boolean
        const tool = tool_src()
        if not tool then
            return false
        end
        const equipped = state.equipped_tool()
        return equipped ~= nil and tool == equipped
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

    const hovered = vide.source(false)

    local last_click_time = 0
    local drag_started = false

    local layout_order_src: any
    if props.kind == "inventory" then
        layout_order_src = derive(function(): number
            const entry = entry_src()
            return entry and entry.layout_order or slot_index
        end)
    else
        layout_order_src = slot_index
    end

    const bg_transparency_src = derive(function(): number
        if state.dragging_slot_index() == slot_index then
            return 0.8
        end
        if props.kind == "inventory" then
            return state.attributes().bg_transparency
        end
        return state.opened() and state.attributes().bg_transparency or 0.3
    end)

    const button_props: { [any]: any } = {
        Name = "Slot_" .. tostring(slot_index),
        Size = UDim2.fromOffset(60, 60),
        BackgroundColor3 = derive(function(): Color3 return state.attributes().bg_color end),
        BackgroundTransparency = bg_transparency_src,
        BorderSizePixel = 0,
        Text = "",
        Active = true,
        LayoutOrder = layout_order_src,
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
            if now - last_click_time < 0.5 then
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
        CornerRadius = derive(function(): UDim return state.attributes().corner_radius end),
    }))

    add_child(create("UIStroke")({
        Color = derive(function(): Color3 return state.attributes().equip_color end),
        Thickness = derive(function(): number return state.attributes().equip_thickness end),
        ApplyStrokeMode = derive(function(): Enum.ApplyStrokeMode
            return state.attributes().outline_equip and Enum.ApplyStrokeMode.Border or Enum.ApplyStrokeMode.Border
        end),
        Enabled = equipped_src,
    }))

    add_child(create("ImageLabel")({
        Name = "Icon",
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = icon_src,
        Visible = has_icon_src,

        create("UICorner")({
            CornerRadius = derive(function(): UDim return state.attributes().corner_radius end),
        }),
    }))

    add_child(create("TextLabel")({
        Name = "ToolName",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = tool_name_src,
        TextColor3 = derive(function(): Color3 return state.attributes().text_color end),
        TextStrokeTransparency = derive(function(): number return state.attributes().text_stroke_transparency end),
        TextStrokeColor3 = derive(function(): Color3 return state.attributes().text_stroke_color end),
        FontFace = derive(function(): Font return state.attributes().font_face end),
        TextSize = derive(function(): number return state.attributes().text_size end),
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Visible = fallback_visible_src,
    }))

    if props.kind == "hotbar" then
        const slot_num_visible_src = derive(function(): boolean
            const input = state.last_input_type()
            if input == Enum.UserInputType.Touch then return false end
            if GAMEPAD_TYPES[input] then return false end
            return true
        end)

        add_child(create("TextLabel")({
            Name = "SlotNumber",
            Size = UDim2.fromScale(0.4, 0.4),
            BackgroundTransparency = 1,
            Text = number_label(slot_index),
            TextColor3 = derive(function(): Color3 return state.attributes().text_color end),
            TextStrokeTransparency = derive(function(): number return state.attributes().text_stroke_transparency end),
            TextStrokeColor3 = derive(function(): Color3 return state.attributes().text_stroke_color end),
            FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Heavy),
            TextSize = derive(function(): number return state.attributes().text_size end),
            Visible = slot_num_visible_src,
        }))

        add_child(tooltip({
            entry = entry_src,
            hovered = hovered,
            state = state,
        }))
    end

    return create("TextButton")(button_props)
end

return slot
