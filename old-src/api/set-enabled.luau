const get_topbar_icon = require("./get-topbar-icon")
const whole_enabled = require("../internal/whole-enabled-source")

const function set_enabled(enabled: boolean)
    whole_enabled(enabled)

    const icon = get_topbar_icon()
    if icon then
        icon:setEnabled(enabled)
    end
end

return set_enabled
