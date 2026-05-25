const GuiService = game:GetService("GuiService")
const Players = game:GetService("Players")
const StarterGui = game:GetService("StarterGui")
const UserInputService = game:GetService("UserInputService")
const VRService = game:GetService("VRService")

const vide = require("../../vide")
const types = require("../types")
const close_inventory = require("../api/close-inventory")
const app = require("../components/app")
const inventory_closed = require("../hooks/inventory-closed")
const inventory_opened = require("../hooks/inventory-opened")
const item_added = require("../hooks/item-added")
const item_removed = require("../hooks/item-removed")
const item_equipped = require("../hooks/item-equipped")
const item_unequipped = require("../hooks/item-unequipped")
const backpack_empty = require("../hooks/backpack-empty")
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

const is_phone = UserInputService.TouchEnabled and workspace.CurrentCamera.ViewportSize.X < 1024

const function inventory_plus()
    const opened = source(false)
    const slots_count = source(if is_phone then 6 else 10)
    const rows_count = source(if is_phone then 2 else 4)
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
    const is_vr = source(VRService.VREnabled)
    const vr_popup_visible = source(false)
    const active_hopper = source(nil :: HopperBin?)

    local function read_attribute<T>(name: string, default: T): T
        const v = script:GetAttribute(name)
        if v ~= nil then return v :: T end
        return default
    end

    local function build_attributes(): types.Attributes
        return {
            bg_color              = read_attribute("BackgroundColor3",       Color3.fromRGB(25, 27, 29)),
            bg_transparency       = read_attribute("BackgroundTransparency", 0.3),
            equip_color           = read_attribute("EquipBorderColor3",      Color3.fromRGB(0, 162, 255)),
            equip_thickness       = read_attribute("EquipBorderSizePixel",   5),
            corner_radius         = read_attribute("CornerRadius",           UDim.new(0, 8)),
            font_face             = read_attribute("FontFace",               Font.fromName("BuilderSans", Enum.FontWeight.Medium)),
            text_size             = read_attribute("TextSize",               16),
            text_color            = read_attribute("TextColor3",             Color3.new(1, 1, 1)),
            text_stroke_transparency = read_attribute("TextStrokeTransparency", 0.5),
            text_stroke_color     = read_attribute("TextStrokeColor3",       Color3.new(0, 0, 0)),
            outline_equip         = read_attribute("OutlineEquipBorder",     false),
            inset_icon_padding    = read_attribute("InsetIconPadding",       false),
        }
    end

    const attributes = source(build_attributes())

    const attribute_names = {
        "BackgroundColor3", "BackgroundTransparency", "EquipBorderColor3",
        "EquipBorderSizePixel", "CornerRadius", "FontFace", "TextSize",
        "TextColor3", "TextStrokeTransparency", "TextStrokeColor3",
        "OutlineEquipBorder", "InsetIconPadding",
    }
    for _, name in attribute_names do
        cleanup(script:GetAttributeChangedSignal(name):Connect(function()
            attributes(build_attributes())
        end))
    end

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
        const query = search_query()
        const result: { [number]: types.BackpackEntry } = {}
        if query == "" then
            for _, entry in items do
                if entry.slot_index > effective_slots then
                    result[entry.slot_index] = entry
                end
            end
        else
            const tokens = parse_search.parse_tokens(query)
            local with_hits: { { entry: types.BackpackEntry, hits: number } } = {}
            for _, entry in items do
                if entry.slot_index > effective_slots then
                    const hits = parse_search.count_hits(entry.tool, tokens)
                    if hits > 0 then
                        table.insert(with_hits, { entry = entry, hits = hits })
                    end
                end
            end
            table.sort(with_hits, function(a, b)
                return a.hits > b.hits
            end)
            for i, item in with_hits do
                const cloned = table.clone(item.entry)
                cloned.layout_order = effective_slots + i
                result[item.entry.slot_index] = cloned
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

    const is_inventory_empty = vide.derive(function(): boolean
        return #backpack_items() == 0
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
        is_vr = is_vr,
        vr_popup_visible = vr_popup_visible,
        active_hopper = active_hopper,
        attributes = attributes,
    })

    cleanup(inventory_opened.add_callback(function()
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

            if inputType == Enum.UserInputType.Keyboard and not text_box_focused() then
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
        if is_vr() then
            slots_count(6)
            rows_count(3)
            return
        end
        if is_phone then
            slots_count(6)
            rows_count(2)
            return
        end
        const screen_orientation = player_gui.CurrentScreenOrientation
        if screen_orientation == Enum.ScreenOrientation.Portrait then
            slots_count(6)
            rows_count(2)
        else
            slots_count(10)
            rows_count(4)
        end
    end

    update_backpack_size()
    cleanup(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(update_backpack_size))
    cleanup(player_gui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(update_backpack_size))
    cleanup(VRService:GetPropertyChangedSignal("VREnabled"):Connect(function()
        is_vr(VRService.VREnabled)
        update_backpack_size()
    end))

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
                add_tool(child :: types.InventoryItem)
            end
        end

        table.insert(char_conns, backpack.ChildAdded:Connect(function(child)
            if is_inventory_item(child) then
                add_tool(child :: types.InventoryItem)
            end
        end))

        table.insert(char_conns, backpack.ChildRemoved:Connect(function(child)
            if is_inventory_item(child) then
                task.defer(function()
                    const parent = child.Parent
                    if parent ~= character() and parent ~= backpack_inst() then
                        remove_tool(child :: types.InventoryItem)
                    end
                end)
            end
        end))
    end

    const function wire_hopper_active(hopper: HopperBin)
        table.insert(char_conns, hopper:GetPropertyChangedSignal("Active"):Connect(function()
            if hopper.Active then
                active_hopper(hopper)
            elseif active_hopper() == hopper then
                active_hopper(nil)
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
                if h and character() == new_character then
                    humanoid(h)
                end
            end)
        end

        for _, child in new_character:GetChildren() do
            if is_inventory_item(child) then
                const tool = child :: types.InventoryItem
                add_tool(tool)
                equipped_tool(tool)
                if child:IsA("HopperBin") then
                    wire_hopper_active(child :: HopperBin)
                end
            end
        end

        table.insert(char_conns, new_character.ChildAdded:Connect(function(child)
            if is_inventory_item(child) then
                const tool = child :: types.InventoryItem
                add_tool(tool)
                equipped_tool(tool)
                if child:IsA("HopperBin") then
                    wire_hopper_active(child :: HopperBin)
                end
            end
        end))

        table.insert(char_conns, new_character.ChildRemoved:Connect(function(child)
            if is_inventory_item(child) then
                const tool = child :: types.InventoryItem
                if equipped_tool() == tool then
                    equipped_tool(nil)
                end
                task.defer(function()
                    const parent = child.Parent
                    if parent ~= character() and parent ~= backpack_inst() then
                        remove_tool(tool)
                    end
                end)
            end
        end))

        const new_backpack = player:FindFirstChildOfClass("Backpack")
        if new_backpack and new_backpack ~= backpack_inst() then
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
        const current = equipped_tool()
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
                if is_vr() then
                    vr_popup_visible(true)
                    task.delay(2, function()
                        vr_popup_visible(false)
                    end)
                end
            end
            prev_equipped = current
        end
    end)

    local prev_empty = false
    effect(function()
        const empty = is_inventory_empty()
        if empty and not prev_empty then
            for _, listener in backpack_empty.callbacks do
                task.spawn(listener)
            end
        end
        prev_empty = empty
    end)

    return app({ state = state })
end

mount(inventory_plus, player_gui)
