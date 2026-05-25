const inventory_opened = require("../hooks/inventory-opened")

const function open_inventory()
    for _, listener in inventory_opened.callbacks do
        task.spawn(listener)
    end
end

return open_inventory