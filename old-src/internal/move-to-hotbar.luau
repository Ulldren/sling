const types = require("../types")
const find_lowest_empty_slot = require("./find-lowest-empty-slot")

const function move_to_hotbar(state: types.State, from_slot_index: number)
    const items = state.backpack_items()
    const hotbar_count = state.slots_count()
    const empty = find_lowest_empty_slot(items, hotbar_count)
    if not empty then return end

    const new_items = table.clone(items)
    for k, entry in new_items do
        if entry.slot_index == from_slot_index then
            new_items[k] = table.clone(entry)
            new_items[k].slot_index = empty
            new_items[k].layout_order = empty
            break
        end
    end
    state.backpack_items(new_items)
end

return move_to_hotbar
