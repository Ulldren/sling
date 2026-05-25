const check_bounds = require("../internal/check-bounds")
const types = require("../types")
const drag_active = require("../internal/drag-active-source")
const move_to_inventory = require("../internal/move-to-inventory")

const function swap_slots(state: types.State, idx_a: number, idx_b: number)
    const items = state.backpack_items()
    const new_items = table.clone(items)

    local entry_a, entry_b
    local key_a, key_b

    for k, v in new_items do
        if v.slot_index == idx_a then
            entry_a = v
            key_a = k
        elseif v.slot_index == idx_b then
            entry_b = v
            key_b = k
        end
    end

    if entry_a then
        new_items[key_a] = table.clone(entry_a)
        new_items[key_a].slot_index = idx_b
        new_items[key_a].layout_order = idx_b
    end

    if entry_b then
        new_items[key_b] = table.clone(entry_b)
        new_items[key_b].slot_index = idx_a
        new_items[key_b].layout_order = idx_a
    end

    state.backpack_items(new_items)
end

const function start_drag(state: types.State, slot_index: number)
    state.dragging_slot_index(slot_index)
    drag_active(true)
end

const function stop_drag(state: types.State, x: number, y: number, hotbar_frame: Frame?, inventory_frame: ScrollingFrame?)
    const dragged_idx = state.dragging_slot_index()
    state.dragging_slot_index(nil)
    drag_active(false)

    if not dragged_idx then return end

    const hotbar_count = state.slots_count()
    const is_hotbar_slot = dragged_idx <= hotbar_count

    if hotbar_frame and check_bounds.point_in_rect(x, y, hotbar_frame) then
        const target_idx = check_bounds.closest_hotbar_slot(x, y, hotbar_frame, hotbar_count)
        if target_idx and target_idx ~= dragged_idx then
            swap_slots(state, dragged_idx, target_idx)
        end
    elseif is_hotbar_slot then
        move_to_inventory(state, dragged_idx)
    end
end

return table.freeze({
    start_drag = start_drag,
    stop_drag = stop_drag,
})
