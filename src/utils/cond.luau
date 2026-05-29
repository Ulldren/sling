local vide = require("../../vide")

local read = vide.read

type Can<T> = vide.Source<T> | T

local function ifelse<T>(fn: Can<unknown>, a: Can<T>, b: Can<T>)
	return function()
		return if read(fn) then read(a) else read(b)
	end
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
	return function()
		return #read(a)
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
