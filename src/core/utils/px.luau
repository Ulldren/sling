local GuiService = game:GetService("GuiService")

local vide = require("../../../vide")

type Can<T> = (() -> T) | T

local read = vide.read :: any
local cleanup = vide.cleanup
local effect = vide.effect
local source = vide.source

local SCALE_POINTS = {
	[Enum.DisplaySize.Large] = 1.66, -- TVs or larger
	[Enum.DisplaySize.Medium] = 1, -- laptops and monitors
	[Enum.DisplaySize.Small] = 1, -- tablet/mobile/handheld devices
}

local currentScale = source(1)

local function usePx()
	local displaySize = source(GuiService.ViewportDisplaySize)

	effect(function()
		currentScale(SCALE_POINTS[displaySize()])
	end)

	cleanup(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(function()
		displaySize(GuiService.ViewportDisplaySize)
	end))
end

local function setScale(scale: number)
	currentScale(scale)
end

local function px(x: Can<number>): () -> number
	return function()
		return math.round(read(x) * currentScale())
	end
end

local function raw(scaled: Can<number>): number
	return math.round(read(scaled) / currentScale())
end

local function scale(x: Can<number>): () -> number
	return function()
		return read(x) * currentScale()
	end
end

local function offset(x: Can<number>, y: Can<number>): () -> UDim2
	return function()
		return UDim2.fromOffset(px(read(x))(), px(read(y))())
	end
end

local function udim2(xScale: Can<number>, xOffset: Can<number>, yScale: Can<number>, yOffset: Can<number>): () -> UDim2
	return function()
		return UDim2.new(read(xScale), px(read(xOffset))(), read(yScale), px(read(yOffset))())
	end
end

local function udim(scale: Can<number>, offset: Can<number>): () -> UDim
	return function()
		return UDim.new(read(scale), px(read(offset))())
	end
end

return setmetatable({
	usePx = usePx,
	setScale = setScale,
	raw = raw,
	scale = scale,
	offset = offset,
	udim2 = udim2,
	udim = udim,
}, {
	__call = function(_, value: Can<number>): () -> number
		return px(value)
	end,
})
