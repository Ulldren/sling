--!nonstrict
local GuiService = game:GetService("GuiService")

local vide = require("../../vide")

type Can<T> = vide.Source<T> | T

local read = vide.read
local cleanup = vide.cleanup
--local derive = vide.derive
local effect = vide.effect
local source = vide.source

local IsTenFootInterface = GuiService:IsTenFootInterface()

--local BASE_RESOLUTION = Vector2.new(1280, 720)
--local DOMINANT_AXIS = 0.5
--local SCALE_POINTS = { 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 3 }
local CONSOLE_SCALE_MULTIPLIER = 1.66

local currentScale = source(1)

--[[
	Apply additional modifications to the scale factor here if desired.
]]
local function modifyScale(scale: number): number
	if IsTenFootInterface then
		scale *= CONSOLE_SCALE_MULTIPLIER
	end
	return scale
	-- Downscale slower than upscale
	--scale ^= 0.5

	-- Snap to predefined scale points
	--[[for _, point in SCALE_POINTS do
		if scale < point then
			return point
		end
	end]]

	--return SCALE_POINTS[#SCALE_POINTS]
end

local function usePx()
	local viewportSize = source(Vector2.new(0, 0))

	--[[local getConstrainedViewportSize = derive(function()
		local viewport = viewportSize()
		local constrainedAspectRatio = math.min(viewport.X / viewport.Y, 16 / 9)

		return Vector2.new(viewport.Y * constrainedAspectRatio, viewport.Y)
	end)]]

	effect(function()
		--local viewport = getConstrainedViewportSize()
		--local scaleX = math.log(viewport.X / BASE_RESOLUTION.X, 2)
		--local scaleY = math.log(viewport.Y / BASE_RESOLUTION.Y, 2)

		--currentScale(modifyScale(2 ^ math.lerp(scaleX, scaleY, DOMINANT_AXIS)))
		viewportSize()
		currentScale(modifyScale(1))
	end)

	cleanup(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		viewportSize(workspace.CurrentCamera.ViewportSize)
	end))

	viewportSize(workspace.CurrentCamera.ViewportSize)
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
