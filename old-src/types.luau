const vide = require("../vide")

export type InventoryItem = Tool | HopperBin

export type BackpackEntry = {
    tool: InventoryItem,
    slot_index: number,
    layout_order: number,
    visible: boolean,
}

export type Attributes = {
    bg_color: Color3,
    bg_transparency: number,
    equip_color: Color3,
    equip_thickness: number,
    corner_radius: UDim,
    font_face: Font,
    text_size: number,
    text_color: Color3,
    text_stroke_transparency: number,
    text_stroke_color: Color3,
    outline_equip: boolean,
    inset_icon_padding: boolean,
}

export type State = {
    opened: vide.Source<boolean>,
    slots_count: vide.Source<number>,
    rows_count: vide.Source<number>,
    backpack_items: vide.Source<{ BackpackEntry }>,
    equipped_tool: vide.Source<InventoryItem?>,
    humanoid: vide.Source<Humanoid?>,
    character: vide.Source<Model?>,
    backpack_inst: vide.Source<Backpack?>,
    dragging_slot_index: vide.Source<number?>,
    hotbar_view: () -> { BackpackEntry? },
    inventory_view: () -> { [number]: BackpackEntry },
    lowest_empty_hotbar_slot: () -> number?,
    hotbar_frame: vide.Source<Frame?>,
    inventory_frame: vide.Source<ScrollingFrame?>,
    search_query: vide.Source<string>,
    text_box_focused: vide.Source<boolean>,
    last_input_type: vide.Source<Enum.UserInputType>,
    gamepad_enabled: vide.Source<boolean>,
    gamepad_swap_slot_index: vide.Source<number?>,
    is_vr: vide.Source<boolean>,
    vr_popup_visible: vide.Source<boolean>,
    active_hopper: vide.Source<HopperBin?>,
    attributes: vide.Source<Attributes>,
}

return nil
