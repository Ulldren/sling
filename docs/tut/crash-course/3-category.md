# Creating Category

Categories are created using `createCategory()`.

Sling allows you to group inventory items into distinct tabs using simple declarative predicate functions. A predicate receives a `BackpackItem` (a `Tool` or `HopperBin`) and returns `true` if it belongs to that category.

```luau
-- Category for items tagged as "Consumable"
sling.createCategory("Consumable", function(item)
    return item:HasTag("Consumable")
end)

-- Category for tools whose name includes "Sword"
sling.createCategory("Swords", function(item)
    return string.find(item.Name, "Sword") ~= nil
end)