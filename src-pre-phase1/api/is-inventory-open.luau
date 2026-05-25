const inventory_openned = require("../hooks/inventory-openned")
const inventory_closed = require("../hooks/inventory-closed")

local is_open = false

inventory_openned.add_callback(function()
    is_open = true
end)

inventory_closed.add_callback(function()
    is_open = false
end)

const function is_inventory_open()
    return is_open
end

return is_inventory_open