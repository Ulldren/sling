local typesModule = require("../types")
local vide = require("../../../vide")

local read = vide.read

type Can<T> = typesModule.Can<T>

type function GetterUnwrapArgs(a: type, b: type): type
	local function unwrap(t: type): type
		if t:is("function") then
			local returns = t:returns()
			if returns and returns.head and returns.head[1] then
				return returns.head[1]
			end
		end
		return t
	end

	local t_a = unwrap(a)
	local t_b = unwrap(b)
	return types.newfunction({}, { head = { if t_a == t_b then t_a else types.unionof(t_a, t_b) } })
end

local function ifelse<T0, T1>(fn: Can<unknown>, a: T0, b: T1): GetterUnwrapArgs<T0, T1>
	return function()
		return if read(fn) then read(a) else read(b)
	end :: any
end

local function nott(fn)
	return function()
		return not read(fn)
	end
end

local function all(...)
	local count = select("#", ...)
	local args = { ... }
	return function()
		for i = 1, count do
			if not read(args[i]) then
				return false
			end
		end
		return true
	end
end

local function any(...)
	local count = select("#", ...)
	local args = { ... }
	return function()
		for i = 1, count do
			if read(args[i]) then
				return true
			end
		end
		return false
	end
end

local function len<T>(a: Can<{ T }>)
	return function(): number
		return #read(a) :: any
	end
end

local function eq<T>(a: Can<T>, b: Can<T>)
	return function()
		return read(a) == read(b)
	end
end

local function neq<T>(a: Can<T>, b: Can<T>)
	return function()
		return read(a) ~= read(b)
	end
end

local function gt(a: Can<number>, b: Can<number>)
	return function()
		return read(a) > read(b) :: any
	end
end

local function lt(a: Can<number>, b: Can<number>)
	return function()
		return read(a) < read(b) :: any
	end
end

local function gte(a: Can<number>, b: Can<number>)
	return function()
		return read(a) >= read(b) :: any
	end
end

local function lte(a: Can<number>, b: Can<number>)
	return function()
		return read(a) <= read(b) :: any
	end
end

return {
	ifelse = ifelse,
	nott = nott,
	all = all,
	any = any,
	len = len,
	eq = eq,
	neq = neq,
	gt = gt,
	lt = lt,
	gte = gte,
	lte = lte,
}
