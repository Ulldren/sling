const Players = game:GetService("Players")

const player = Players.LocalPlayer :: Player
const playerGui = player:WaitForChild("PlayerGui")
const screenGui = playerGui:WaitForChild("BackpackGui") :: ScreenGui

const function is_enabled()
    return screenGui.Enabled
end

return is_enabled