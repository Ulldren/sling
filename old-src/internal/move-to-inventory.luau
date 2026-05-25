const types = require("../types")

const function move_to_inventory(state: types.State, from_slot_index: number)
    const items = state.backpack_items()
    const hotbar_count = state.slots_count()

    local max_index = hotbar_count
    for _, entry in items do
        if entry.slot_index > max_index then
            max_index = entry.slot_index
        end
    end
    const new_slot = max_index + 1

    const new_items = table.clone(items)
    for k, entry in new_items do
        if entry.slot_index == from_slot_index then
            new_items[k] = table.clone(entry)
            new_items[k].slot_index = new_slot
            new_items[k].layout_order = new_slot
            break
        end
    end
    state.backpack_items(new_items)
end

return move_to_inventory
