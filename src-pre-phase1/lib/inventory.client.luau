const GuiService = game:GetService("GuiService")
const Players = game:GetService("Players")
const StarterGui = game:GetService("StarterGui")
const UserInputService = game:GetService("UserInputService")

const vide = require("../../vide")
const types = require("../types")
const close_inventory = require("../api/close-inventory")
const app = require("../components/app")
const inventory_closed = require("../hooks/inventory-closed")
const inventory_openned = require("../hooks/inventory-openned")
const item_added = require("../hooks/item-added")
const item_removed = require("../hooks/item-removed")
const item_equipped = require("../hooks/item-equipped")
const item_unequipped = require("../hooks/item-unequipped")
const find_lowest_empty_slot = require("../internal/find-lowest-empty-slot")
const equip = require("../lib/equip")
const parse_search = require("../internal/parse-search")
const gamepad_controller = require("../lib/gamepad-controller")

const mount = vide.mount
const source = vide.source
const cleanup = vide.cleanup
const effect = vide.effect

const player = Players.LocalPlayer
const player_gui = player:WaitForChild("PlayerGui") :: PlayerGui

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

const function inventory_plus()
    const opened = source(false)
    const slots_count = source(10)
    const rows_count = source(4)
    const backpack_items = source({} :: { types.BackpackEntry })
    const equipped_tool = source(nil :: types.InventoryItem?)
    const humanoid = source(nil :: Humanoid?)
    const character = source(nil :: Model?)
    const backpack_inst = source(nil :: Backpack?)
    const dragging_slot_index = source(nil :: number?)
    const hotbar_frame = source(nil :: Frame?)
    const inventory_frame = source(nil :: ScrollingFrame?)
    const search_query = source("")
    const text_box_focused = source(false)
    const last_input_type = source(Enum.UserInputType.None)
    const gamepad_enabled = source(UserInputService.GamepadEnabled)
    const gamepad_swap_slot_index = source(nil :: number?)

    const hotbar_view = vide.derive(function(): { types.BackpackEntry? }
        const items = backpack_items()
        const effective_slots = slots_count()
        const arr: { types.BackpackEntry? } = {}
        for i = 1, effective_slots do
            arr[i] = nil
        end
        for _, entry in items do
            if entry.slot_index <= effective_slots and entry.visible then
                arr[entry.slot_index] = entry
            end
        end
        return arr
    end)

    const inventory_view = vide.derive(function(): { [number]: types.BackpackEntry }
        const items = backpack_items()
        const effective_slots = slots_count()
        const query = (search_query :: () -> string)()
        const result: { [number]: types.BackpackEntry } = {}
        if query == "" then
            for _, entry in items do
                if entry.slot_index > effective_slots then
                    result[entry.slot_index] = entry
                end
            end
        else
            const tokens = parse_search.parse_tokens(query)
            for _, entry in items do
                if entry.slot_index > effective_slots then
                    const hits = parse_search.count_hits(entry.tool, tokens)
                    if hits > 0 then
                        result[entry.slot_index] = entry
                    end
                end
            end
        end
        return result
    end)

    const lowest_empty_hotbar_slot = vide.derive(function(): number?
        const arr = hotbar_view()
        const effective_slots = slots_count()
        for i = 1, effective_slots do
            if not arr[i] then
                return i
            end
        end
        return nil
    end)

    const state: types.State = table.freeze({
        opened = opened,
        slots_count = slots_count,
        rows_count = rows_count,
        backpack_items = backpack_items,
        equipped_tool = equipped_tool,
        humanoid = humanoid,
        character = character,
        backpack_inst = backpack_inst,
        dragging_slot_index = dragging_slot_index,
        hotbar_view = hotbar_view,
        inventory_view = inventory_view,
        lowest_empty_hotbar_slot = lowest_empty_hotbar_slot,
        hotbar_frame = hotbar_frame,
        inventory_frame = inventory_frame,
        search_query = search_query,
        text_box_focused = text_box_focused,
        last_input_type = last_input_type,
        gamepad_enabled = gamepad_enabled,
        gamepad_swap_slot_index = gamepad_swap_slot_index,
    })

    const function read_character(): Model?
        return (character :: any)()
    end

    const function read_backpack(): Backpack?
        return (backpack_inst :: any)()
    end

    const function read_equipped(): types.InventoryItem?
        return (equipped_tool :: any)()
    end

    cleanup(inventory_openned.add_callback(function()
        opened(true)
    end))

    cleanup(inventory_closed.add_callback(function()
        opened(false)
    end))

    cleanup(GuiService.MenuOpened:Connect(function()
        close_inventory()
    end))


    cleanup(UserInputService.TextBoxFocused:Connect(function()
        text_box_focused(true)
    end))

    cleanup(UserInputService.TextBoxFocusReleased:Connect(function()
        text_box_focused(false)
    end))

    cleanup(UserInputService.LastInputTypeChanged:Connect(function(input_type)
        last_input_type(input_type)
    end))

    cleanup(UserInputService.GamepadConnected:Connect(function()
        gamepad_enabled(true)
    end))

    cleanup(UserInputService.GamepadDisconnected:Connect(function()
        gamepad_enabled(UserInputService.GamepadEnabled)
    end))

    cleanup(gamepad_controller.bind_actions(state))

    const hotkey_map: { [Enum.KeyCode]: number } = {
        [Enum.KeyCode.One] = 1,
        [Enum.KeyCode.Two] = 2,
        [Enum.KeyCode.Three] = 3,
        [Enum.KeyCode.Four] = 4,
        [Enum.KeyCode.Five] = 5,
        [Enum.KeyCode.Six] = 6,
        [Enum.KeyCode.Seven] = 7,
        [Enum.KeyCode.Eight] = 8,
        [Enum.KeyCode.Nine] = 9,
        [Enum.KeyCode.Zero] = 10,
    }

    cleanup(UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        const inputType = input.UserInputType
        if not gameProcessedEvent then
            if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
                close_inventory()
            end

            if inputType == Enum.UserInputType.Keyboard and not (text_box_focused :: () -> boolean)() then
                const keycode = input.KeyCode
                const slot_idx = hotkey_map[keycode]
                if slot_idx then
                    const items = backpack_items()
                    for _, entry in items do
                        if entry.slot_index == slot_idx then
                            equip.select(state, entry.tool)
                            break
                        end
                    end
                elseif keycode == Enum.KeyCode.Backspace then
                    equip.drop_equipped(state)
                end
            end

            if inputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
                search_query("")
            end
        end
    end))

    const function update_backpack_size()
        const screen_orientation = player_gui.CurrentScreenOrientation
        const viewport_size = GuiService.ViewportDisplaySize

        if screen_orientation == Enum.ScreenOrientation.Portrait then
            slots_count(3)
            rows_count(3)
        elseif viewport_size == Enum.DisplaySize.Small then
            slots_count(5)
            rows_count(2)
        else
            slots_count(10)
            rows_count(4)
        end
    end

    update_backpack_size()
    cleanup(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(update_backpack_size))
    cleanup(player_gui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(update_backpack_size))

    const function is_inventory_item(child: Instance): boolean
        return child:IsA("Tool") or child:IsA("HopperBin")
    end

    const function add_tool(tool: types.InventoryItem)
        const items = backpack_items()
        for _, entry in items do
            if entry.tool == tool then
                return
            end
        end

        const hotbar_count = slots_count()
        const empty_slot = find_lowest_empty_slot(items, hotbar_count)

        local new_index: number
        if empty_slot then
            new_index = empty_slot
        else
            local max_index = hotbar_count
            for _, entry in items do
                if entry.slot_index > max_index then
                    max_index = entry.slot_index
                end
            end
            new_index = max_index + 1
        end

        const new_entry: types.BackpackEntry = {
            tool = tool,
            slot_index = new_index,
            layout_order = new_index,
            visible = true,
        }

        const new_items = table.clone(items)
        table.insert(new_items, new_entry)
        backpack_items(new_items)
    end

    const function remove_tool(tool: types.InventoryItem)
        const items = backpack_items()
        local found = false
        const new_items: { types.BackpackEntry } = {}
        for _, entry in items do
            if entry.tool == tool then
                found = true
            else
                table.insert(new_items, entry)
            end
        end
        if found then
            backpack_items(new_items)
        end
    end

    local char_conns: { RBXScriptConnection } = {}

    const function disconnect_char_conns()
        for _, c in char_conns do
            c:Disconnect()
        end
        table.clear(char_conns)
    end

    cleanup(disconnect_char_conns)

    const function connect_backpack(backpack: Backpack)
        backpack_inst(backpack)

        for _, child in backpack:GetChildren() do
            if is_inventory_item(child) then
                add_tool((child :: any) :: types.InventoryItem)
            end
        end

        table.insert(char_conns, backpack.ChildAdded:Connect(function(child)
            if is_inventory_item(child) then
                add_tool((child :: any) :: types.InventoryItem)
            end
        end))

        table.insert(char_conns, backpack.ChildRemoved:Connect(function(child)
            if is_inventory_item(child) then
                task.defer(function()
                    const parent = child.Parent
                    if parent ~= read_character() and parent ~= read_backpack() then
                        remove_tool((child :: any) :: types.InventoryItem)
                    end
                end)
            end
        end))
    end

    const function connect_character(new_character: Model)
        disconnect_char_conns()

        const items = backpack_items()
        local sweep_changed = false
        const swept_items: { types.BackpackEntry } = {}
        for _, entry in items do
            if entry.tool.Parent then
                table.insert(swept_items, entry)
            else
                sweep_changed = true
            end
        end
        if sweep_changed then
            backpack_items(swept_items)
        end

        character(new_character)
        equipped_tool(nil)

        const found_humanoid = new_character:FindFirstChildOfClass("Humanoid")
        humanoid(found_humanoid)
        if not found_humanoid then
            task.spawn(function()
                const h = new_character:WaitForChild("Humanoid", 10) :: Humanoid?
                if h and read_character() == new_character then
                    humanoid(h)
                end
            end)
        end

        for _, child in new_character:GetChildren() do
            if is_inventory_item(child) then
                const tool = (child :: any) :: types.InventoryItem
                add_tool(tool)
                equipped_tool(tool)
            end
        end

        table.insert(char_conns, new_character.ChildAdded:Connect(function(child)
            if is_inventory_item(child) then
                const tool = (child :: any) :: types.InventoryItem
                add_tool(tool)
                equipped_tool(tool)
            end
        end))

        table.insert(char_conns, new_character.ChildRemoved:Connect(function(child)
            if is_inventory_item(child) then
                const tool = (child :: any) :: types.InventoryItem
                if read_equipped() == tool then
                    equipped_tool(nil)
                end
                task.defer(function()
                    const parent = child.Parent
                    if parent ~= read_character() and parent ~= read_backpack() then
                        remove_tool(tool)
                    end
                end)
            end
        end))

        const new_backpack = player:FindFirstChildOfClass("Backpack")
        if new_backpack and new_backpack ~= read_backpack() then
            connect_backpack(new_backpack)
        end
    end

    const initial_backpack = player:FindFirstChildOfClass("Backpack")
    if initial_backpack then
        connect_backpack(initial_backpack)
    end

    if player.Character then
        connect_character(player.Character)
    end

    cleanup(player.CharacterAdded:Connect(connect_character))

    local prev_items: { types.BackpackEntry } = {}
    effect(function()
        const current = backpack_items()

        for _, entry in current do
            local was_present = false
            for _, prev in prev_items do
                if prev.tool == entry.tool then
                    was_present = true
                    break
                end
            end
            if not was_present then
                for _, listener in item_added.callbacks do
                    task.spawn(listener, entry.tool)
                end
            end
        end

        for _, prev in prev_items do
            local still_present = false
            for _, entry in current do
                if entry.tool == prev.tool then
                    still_present = true
                    break
                end
            end
            if not still_present then
                for _, listener in item_removed.callbacks do
                    task.spawn(listener, prev.tool)
                end
            end
        end

        prev_items = current
    end)

    local prev_equipped: types.InventoryItem? = nil
    effect(function()
        const current = read_equipped()
        if current ~= prev_equipped then
            if prev_equipped then
                for _, listener in item_unequipped.callbacks do
                    task.spawn(listener, prev_equipped)
                end
            end
            if current then
                for _, listener in item_equipped.callbacks do
                    task.spawn(listener, current)
                end
            end
            prev_equipped = current
        end
    end)

    return app({ state = state })
end

mount(inventory_plus, player_gui)
