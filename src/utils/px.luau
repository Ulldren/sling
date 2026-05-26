--!nonstrict
const GuiService = game:GetService("GuiService")

const vide = require("../../vide")

type Can<T> = vide.Source<T> | T

const read = vide.read
const cleanup = vide.cleanup
--const derive = vide.derive
const effect = vide.effect
const source = vide.source

const IsTenFootInterface = GuiService:IsTenFootInterface()

--const BASE_RESOLUTION = Vector2.new(1280, 720)
--const DOMINANT_AXIS = 0.5
--const SCALE_POINTS = { 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 3 }
const CONSOLE_SCALE_MULTIPLIER = 1.66

const currentScale = source(1)

--[[
	Apply additional modifications to the scale factor here if desired.
]]
const function modifyScale(scale: number): number
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

const function usePx()
	const viewportSize = source(Vector2.new(0, 0))

	--[[const getConstrainedViewportSize = derive(function()
		const viewport = viewportSize()
		const constrainedAspectRatio = math.min(viewport.X / viewport.Y, 16 / 9)

		return Vector2.new(viewport.Y * constrainedAspectRatio, viewport.Y)
	end)]]

	effect(function()
		--const viewport = getConstrainedViewportSize()
		--const scaleX = math.log(viewport.X / BASE_RESOLUTION.X, 2)
		--const scaleY = math.log(viewport.Y / BASE_RESOLUTION.Y, 2)

		--currentScale(modifyScale(2 ^ math.lerp(scaleX, scaleY, DOMINANT_AXIS)))
		viewportSize()
		currentScale(modifyScale(1))
	end)

	cleanup(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		viewportSize(workspace.CurrentCamera.ViewportSize)
	end))

	viewportSize(workspace.CurrentCamera.ViewportSize)
end

const function setScale(scale: number)
	currentScale(scale)
end

const function px(x: Can<number>): () -> number
	return function()
		return math.round(read(x) * currentScale())
	end
end

const function raw(scaled: Can<number>): number
	return math.round(read(scaled) / currentScale())
end

const function scale(x: Can<number>): () -> number
	return function()
		return read(x) * currentScale()
	end
end

const function offset(x: Can<number>, y: Can<number>): () -> UDim2
	return function()
		return UDim2.fromOffset(px(read(x))(), px(read(y))())
	end
end

const function udim2(xScale: Can<number>, xOffset: Can<number>, yScale: Can<number>, yOffset: Can<number>): () -> UDim2
	return function()
		return UDim2.new(read(xScale), px(read(xOffset))(), read(yScale), px(read(yOffset))())
	end
end

const function udim(scale: Can<number>, offset: Can<number>): () -> UDim
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
