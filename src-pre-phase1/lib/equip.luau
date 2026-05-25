const types = require("../types")

const function equip_tool(state: types.State, tool: Tool)
    const humanoid = (state.humanoid :: () -> Humanoid?)()
    if humanoid then
        humanoid:EquipTool(tool)
    end
end

const function unequip_all(state: types.State)
    const humanoid = (state.humanoid :: () -> Humanoid?)()
    if humanoid then
        humanoid:UnequipTools()
    end
end

const function is_equipped(state: types.State, tool: types.InventoryItem): boolean
    const equipped = (state.equipped_tool :: () -> types.InventoryItem?)()
    return equipped == tool
end

const function select(state: types.State, tool: types.InventoryItem)
    if is_equipped(state, tool) then
        unequip_all(state)
    elseif tool:IsA("Tool") then
        equip_tool(state, tool)
    end
end

const function drop_equipped(state: types.State)
    unequip_all(state)
end

return table.freeze({
    equip_tool = equip_tool,
    unequip_all = unequip_all,
    is_equipped = is_equipped,
    select = select,
    drop_equipped = drop_equipped,
})
