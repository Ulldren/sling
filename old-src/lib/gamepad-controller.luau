const ContextActionService = game:GetService("ContextActionService")
const types = require("../types")
const equip = require("./equip")
const close_inventory = require("../api/close-inventory")
const move_to_inventory = require("../internal/move-to-inventory")
const move_to_hotbar = require("../internal/move-to-hotbar")

local ACTION_CYCLE_LEFT = "InventoryPlus_CycleLeft"
local ACTION_CYCLE_RIGHT = "InventoryPlus_CycleRight"
local ACTION_SELECT = "InventoryPlus_Select"
local ACTION_MOVE = "InventoryPlus_Move"
local ACTION_CLOSE = "InventoryPlus_Close"

local last_cycle_time = 0
local CYCLE_DEBOUNCE = 0.06

local function get_next_hotbar_slot(state: types.State, direction: number): number?
    const items = state.backpack_items()
    const slots = state.slots_count()
    const equipped = state.equipped_tool()

    local current_slot = 0
    for _, entry in items do
        if entry.tool == equipped then
            current_slot = entry.slot_index
            break
        end
    end

    local slots_with_tools: { number } = {}
    for _, entry in items do
        if entry.slot_index <= slots then
            table.insert(slots_with_tools, entry.slot_index)
        end
    end
    table.sort(slots_with_tools)

    if #slots_with_tools == 0 then return nil end

    if current_slot == 0 then
        return direction > 0 and slots_with_tools[1] or slots_with_tools[#slots_with_tools]
    end

    local current_pos = 0
    for i, s in slots_with_tools do
        if s == current_slot then
            current_pos = i
            break
        end
    end

    const next_pos = ((current_pos - 1 + direction) % #slots_with_tools) + 1
    return slots_with_tools[next_pos]
end

local function cycle(state: types.State, direction: number)
    const now = tick()
    if now - last_cycle_time < CYCLE_DEBOUNCE then return end
    last_cycle_time = now

    const target_slot = get_next_hotbar_slot(state, direction)
    if not target_slot then return end

    const items = state.backpack_items()
    for _, entry in items do
        if entry.slot_index == target_slot then
            equip.select(state, entry.tool)
            return
        end
    end
end

local function handle_select(state: types.State)
    const swap_index = state.gamepad_swap_slot_index()
    if swap_index then
        const equipped = state.equipped_tool()
        if equipped then
            const items = state.backpack_items()
            const slots = state.slots_count()

            local equipped_slot: number? = nil
            for _, entry in items do
                if entry.tool == equipped then
                    equipped_slot = entry.slot_index
                    break
                end
            end

            if equipped_slot then
                const new_items = table.clone(items)
                for k, entry in new_items do
                    if entry.slot_index == equipped_slot then
                        new_items[k] = table.clone(entry)
                        new_items[k].slot_index = swap_index
                        new_items[k].layout_order = swap_index
                    elseif entry.slot_index == swap_index then
                        new_items[k] = table.clone(entry)
                        new_items[k].slot_index = equipped_slot
                        new_items[k].layout_order = equipped_slot
                    end
                end
                state.backpack_items(new_items)
            end
        end
        state.gamepad_swap_slot_index(nil)
    else
        const equipped = state.equipped_tool()
        if equipped then
            equip.select(state, equipped)
        end
    end
end

local function handle_move(state: types.State)
    const equipped = state.equipped_tool()
    if not equipped then return end

    const items = state.backpack_items()
    const slots = state.slots_count()
    for _, entry in items do
        if entry.tool == equipped then
            if entry.slot_index <= slots then
                move_to_inventory(state, entry.slot_index)
            else
                move_to_hotbar(state, entry.slot_index)
            end
            return
        end
    end
end

local function bind_actions(state: types.State): () -> ()
    ContextActionService:BindAction(ACTION_CYCLE_LEFT, function(_name, input_state)
        if input_state == Enum.UserInputState.Begin then
            cycle(state, -1)
        end
        return Enum.ContextActionResult.Sink
    end, false, Enum.KeyCode.ButtonL1)

    ContextActionService:BindAction(ACTION_CYCLE_RIGHT, function(_name, input_state)
        if input_state == Enum.UserInputState.Begin then
            cycle(state, 1)
        end
        return Enum.ContextActionResult.Sink
    end, false, Enum.KeyCode.ButtonR1)

    ContextActionService:BindAction(ACTION_SELECT, function(_name, input_state)
        if input_state == Enum.UserInputState.Begin then
            handle_select(state)
        end
        return Enum.ContextActionResult.Sink
    end, false, Enum.KeyCode.ButtonA)

    ContextActionService:BindAction(ACTION_MOVE, function(_name, input_state)
        if input_state == Enum.UserInputState.Begin then
            handle_move(state)
        end
        return Enum.ContextActionResult.Sink
    end, false, Enum.KeyCode.ButtonX)

    ContextActionService:BindAction(ACTION_CLOSE, function(_name, input_state)
        if input_state == Enum.UserInputState.Begin then
            close_inventory()
        end
        return Enum.ContextActionResult.Sink
    end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)

    return function()
        ContextActionService:UnbindAction(ACTION_CYCLE_LEFT)
        ContextActionService:UnbindAction(ACTION_CYCLE_RIGHT)
        ContextActionService:UnbindAction(ACTION_SELECT)
        ContextActionService:UnbindAction(ACTION_MOVE)
        ContextActionService:UnbindAction(ACTION_CLOSE)
    end
end

return table.freeze({
    bind_actions = bind_actions,
})
