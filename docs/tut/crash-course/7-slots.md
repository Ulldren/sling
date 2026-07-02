# Customizing Slots

`onSlotRender` lets you customize the appearance of individual slots in the hotbar and inventory based on the item they contain.

![Slots Preview](/slots-preview.png)

## Changing the Background Color

Use `BackgroundColor` to color a slot based on the item's tag or name.

```luau
Sling.onSlotRender(function(context)
    local properties = {} :: Sling.SlotProperties

    if context.item:HasTag("Sword") then
        properties.BackgroundColor = Color3.fromHex("#142442")
    elseif context.item:HasTag("Explosive") then
        properties.BackgroundColor = Color3.fromHex("#344214")
    elseif context.item:HasTag("Food") then
        properties.BackgroundColor = Color3.fromHex("#463300")
    end

    return properties
end)
```

## Adding UI Objects to a Slot

Use `Children` to parent any `Instance` directly into the slot frame. This is useful for adding gradients, strokes, or other decorators.

```luau
Sling.onSlotRender(function(context)
    local properties = {} :: Sling.SlotProperties
    local children = {}

    if context.item:HasTag("Knife") then
        properties.BackgroundColor = Color3.fromHex("#414141ff")

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new(Color3.fromHex("#b62f2fff"), Color3.fromHex("#421414"))
        gradient.Rotation = 90
        table.insert(children, gradient)
    end

    properties.Children = children
    return properties
end)
```

## Customizing the Item Name Label

Use `ItemNameText` to override the text shown below the item icon. Supports Roblox rich text tags. Use `ItemNameChildren` to inject UI objects into the label itself.

```luau
Sling.onSlotRender(function(context)
    local properties = {} :: Sling.SlotProperties
    local itemNameChildren = {}

    if context.item:HasTag("Rare") then
        properties.ItemNameText = `<font color='#ffd700'>{context.item.Name}</font>`

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new(Color3.fromHex("#ffffffff"), Color3.fromHex("#919191ff"))
        gradient.Rotation = 45
        table.insert(itemNameChildren, gradient)
    end

    properties.ItemNameChildren = itemNameChildren
    return properties
end)
```

## Targeting Hotbar vs Inventory Slots

Use `context.inHotbar` to apply different styling depending on whether the slot is in the hotbar or in the inventory panel.

```luau
Sling.onSlotRender(function(context)
    local properties = {} :: Sling.SlotProperties

    if context.inHotbar then
        properties.BackgroundTransparency = 0
    else
        properties.BackgroundTransparency = 0.4
    end

    return properties
end)
```
