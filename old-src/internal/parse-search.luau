const types = require("../types")

local function parse_tokens(text: string): { string }
    const tokens: { string } = {}
    for token in text:lower():gmatch("%S+") do
        table.insert(tokens, token)
    end
    return tokens
end

local function count_hits(tool: types.InventoryItem, tokens: { string }): number
    const name = tool.Name:lower()
    local tooltip_text = ""
    if tool:IsA("Tool") then
        tooltip_text = (tool :: Tool).ToolTip:lower()
    end
    local hits = 0
    for _, token in tokens do
        if name:find(token, 1, true) or tooltip_text:find(token, 1, true) then
            hits += 1
        end
    end
    return hits
end

local function apply_search(items: { types.BackpackEntry }, query: string, hotbar_count: number): { types.BackpackEntry }
    const new_items = table.clone(items)

    if query == "" then
        for k, entry in new_items do
            if entry.slot_index > hotbar_count then
                new_items[k] = table.clone(entry)
                new_items[k].visible = true
                new_items[k].layout_order = entry.slot_index
            end
        end
        return new_items
    end

    const tokens = parse_tokens(query)
    local inv_entries: { { entry: types.BackpackEntry, key: number, hits: number } } = {}

    for k, entry in new_items do
        if entry.slot_index > hotbar_count then
            const hits = count_hits(entry.tool, tokens)
            table.insert(inv_entries, { entry = entry, key = k, hits = hits })
        end
    end

    table.sort(inv_entries, function(a, b)
        return a.hits > b.hits
    end)

    for order, item in inv_entries do
        const cloned = table.clone(item.entry)
        cloned.visible = item.hits > 0
        cloned.layout_order = hotbar_count + order
        new_items[item.key] = cloned
    end

    return new_items
end

return table.freeze({
    parse_tokens = parse_tokens,
    count_hits = count_hits,
    apply_search = apply_search,
})
