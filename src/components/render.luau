local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local backpack = require("./backpack")
local px = require("../utils/px")
local states = require("../states")
local useBackpack = require("../hooks/backpack/useBackpack")
local vide = require("../../vide")

local mount = vide.mount
local create = vide.create
local action = vide.action

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

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

			action(states.appRef),

			backpack(),
		})
	end, playerGui)
end

return render
