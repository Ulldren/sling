const function point_in_rect(x: number, y: number, frame: GuiObject): boolean
    const pos = frame.AbsolutePosition
    const size = frame.AbsoluteSize
    return x >= pos.X and x <= pos.X + size.X and y >= pos.Y and y <= pos.Y + size.Y
end

const function closest_hotbar_slot(x: number, y: number, hotbar_frame: Frame?, slots_count: number): number?
    if not hotbar_frame then return nil end

    -- Se não estiver dentro do hotbar, aborta
    if not point_in_rect(x, y, hotbar_frame) then
        return nil
    end

    -- Encontra o slot filho mais próximo
    local closest_dist = math.huge
    local closest_idx = nil

    for _, child in hotbar_frame:GetChildren() do
        if child:IsA("GuiObject") and child.Name:match("^Slot_(%d+)$") then
            const idx = tonumber(child.Name:match("^Slot_(%d+)$"))
            if idx then
                const center = child.AbsolutePosition + (child.AbsoluteSize / 2)
                const dist = (Vector2.new(x, y) - center).Magnitude
                if dist < closest_dist then
                    closest_dist = dist
                    closest_idx = idx
                end
            end
        end
    end

    return closest_idx
end

return table.freeze({
    point_in_rect = point_in_rect,
    closest_hotbar_slot = closest_hotbar_slot,
})
