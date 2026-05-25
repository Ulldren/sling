const types = require("../types")

const function find_lowest_empty_slot(items: { types.BackpackEntry }, hotbar_count: number): number?
    local occupied: { [number]: boolean } = {}
    for _, entry in items do
        if entry.slot_index <= hotbar_count then
            occupied[entry.slot_index] = true
        end
    end
    for i = 1, hotbar_count do
        if not occupied[i] then
            return i
        end
    end
    return nil
end

return find_lowest_empty_slot
