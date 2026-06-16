# Subscribing to Events

You can track when the player interacts with their backpack, equips items, or when items are added/removed. All event listeners return a **disconnect function** to clean up the listener.

```luau
local disconnect = sling.onBackpackItemEquipped(function(item)
    print("Item equipped:", item.Name)
end)

-- Clean up subscriptions when no longer needed
disconnect()
```

See more about events [here](/api/events).