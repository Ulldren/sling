const check_bounds = require("../internal/check-bounds")
const types = require("../types")

const function start_drag(state: types.State, slot_index: number)
    state.dragging_slot_index(slot_index)
end

const function stop_drag(state: types.State, x: number, y: number, hotbar_frame: Frame?, inventory_frame: ScrollingFrame?)
    const dragged_idx = state.dragging_slot_index()
    state.dragging_slot_index(nil)

    if not dragged_idx then return end

    local target_idx: number? = nil

    if hotbar_frame and check_bounds.point_in_rect(x, y, hotbar_frame) then
        target_idx = check_bounds.closest_hotbar_slot(x, y, hotbar_frame, state.slots_count())
    end

    -- Se não caiu no hotbar, vamos checar no inventory
    if not target_idx and inventory_frame and check_bounds.point_in_rect(x, y, inventory_frame) then
        local closest_dist = math.huge
        for _, child in inventory_frame:GetChildren() do
            if child:IsA("GuiObject") and child.Name:match("^Slot_(%d+)$") then
                const idx = tonumber(child.Name:match("^Slot_(%d+)$"))
                if idx then
                    const center = child.AbsolutePosition + (child.AbsoluteSize / 2)
                    const dist = (Vector2.new(x, y) - center).Magnitude
                    if dist < closest_dist then
                        closest_dist = dist
                        target_idx = idx
                    end
                end
            end
        end
    end

    if target_idx and target_idx ~= dragged_idx then
        -- Swap logic
        const items = state.backpack_items()
        const new_items = table.clone(items)

        local entry_a, entry_b
        local key_a, key_b

        for k, v in new_items do
            if v.slot_index == dragged_idx then
                entry_a = v
                key_a = k
            elseif v.slot_index == target_idx then
                entry_b = v
                key_b = k
            end
        end

        if entry_a then
            new_items[key_a] = table.clone(entry_a)
            new_items[key_a].slot_index = target_idx
            new_items[key_a].layout_order = target_idx
        end

        if entry_b then
            new_items[key_b] = table.clone(entry_b)
            new_items[key_b].slot_index = dragged_idx
            new_items[key_b].layout_order = dragged_idx
        end

        state.backpack_items(new_items)
    end
end

return table.freeze({
    start_drag = start_drag,
    stop_drag = stop_drag,
})
