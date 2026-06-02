local Players = game:GetService("Players")

local app = require("./app")
local px = require("../utils/px")
local states = require("../states")
local useBackpack = require("../hooks/backpack/useBackpack")
local vide = require("../../vide")

local mount = vide.mount
local create = vide.create

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function render()
	return mount(function()
		useBackpack()

		px.usePx()

		return create("ScreenGui")({
			Name = "BackpackGui",
			DisplayOrder = 120,
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			Enabled = states.enabled,

			app(),
		})
	end, playerGui)
end

return render
