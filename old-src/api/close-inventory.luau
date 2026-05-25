const inventory_closed = require("../hooks/inventory-closed")

const function close_inventory()
    for _, listener in inventory_closed.callbacks do
        task.spawn(listener)
    end
end

return close_inventory
