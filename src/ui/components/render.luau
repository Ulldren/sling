local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local backpack = require("./backpack")
local px = require("../../core/utils/px")
local states = require("../../core/states")
local useBackpack = require("../hooks/backpack/useBackpack")
local vide = require("../../../vide")

local mount = vide.mount
local create = vide.create
local action = vide.action
local show = vide.show

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local function render()
	mount(function()
		return show(states.enabled, function()
			useBackpack()

			px.usePx()

			return create("ScreenGui")({
				Name = "BackpackGui",
				DisplayOrder = 120,
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Global,

				action(states.appRef :: any),

				backpack(),
			})
		end)
	end, playerGui)
end

return render
