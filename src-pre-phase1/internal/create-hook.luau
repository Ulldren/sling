export type Listener<Args...> = (Args...) -> ()

const function create_hook<Args...>()
	local callbacks: { Listener<Args...> } = {}

	return table.freeze({
		callbacks = callbacks,
		add_callback = function(listener: Listener<Args...>)
			table.insert(callbacks, listener)
			return function()
				table.remove(callbacks, table.find(callbacks, listener))
			end
		end,
	})
end

return create_hook
