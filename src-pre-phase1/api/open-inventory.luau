const inventory_openned = require("../hooks/inventory-openned")

const function open_inventory()
    for _, listener in inventory_openned.callbacks do
        task.spawn(listener)
    end
end

return open_inventory