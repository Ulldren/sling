const Players = game:GetService("Players")

const get_topbar_icon = require("./get-topbar-icon")

const player = Players.LocalPlayer :: Player
const playerGui = player:WaitForChild("PlayerGui")
const screenGui = playerGui:WaitForChild("BackpackGui") :: ScreenGui

const function set_enabled(enabled: boolean)
    screenGui.Enabled = enabled

    const icon = get_topbar_icon()
    if icon then
        icon:setEnabled(enabled)
    end
end

return set_enabled