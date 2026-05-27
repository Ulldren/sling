const vide = require("../../vide")

const read = vide.read

type Can<T> = vide.Source<T> | T

const function ifelse<T>(fn: Can<unknown>, a: Can<T>, b: Can<T>)
	return function()
		return if read(fn) then read(a) else read(b)
	end
end

const function nott(fn)
	return function()
		return not read(fn)
	end
end

const function all(...)
	const count = select("#", ...)
	const args = { ... }
	return function()
		for i = 1, count do
			if not read(args[i]) then
				return false
			end
		end
		return true
	end
end

const function any(...)
	const count = select("#", ...)
	const args = { ... }
	return function()
		for i = 1, count do
			if read(args[i]) then
				return true
			end
		end
		return false
	end
end

const function len<T>(a: Can<{ T }>)
	return function()
		return #read(a)
	end
end

const function eq<T>(a: Can<T>, b: Can<T>)
	return function()
		return read(a) == read(b)
	end
end

const function neq<T>(a: Can<T>, b: Can<T>)
	return function()
		return read(a) ~= read(b)
	end
end

const function gt(a: Can<number>, b: Can<number>)
	return function()
		return read(a) > read(b) :: any
	end
end

const function lt(a: Can<number>, b: Can<number>)
	return function()
		return read(a) < read(b) :: any
	end
end

const function gte(a: Can<number>, b: Can<number>)
	return function()
		return read(a) >= read(b) :: any
	end
end

const function lte(a: Can<number>, b: Can<number>)
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
