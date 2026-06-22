type Listener<Args... = ...any> = (Args...) -> ()
type Event<Args... = ...any> = {
	on: (listener: Listener<Args...>) -> () -> (),
	fire: (Args...) -> (),
}

local freeThreads: { thread } = {}

local function run<T...>(f: (T...) -> (), thread: thread, ...)
	f(...)
	table.insert(freeThreads, thread)
end

local function yielder()
	while true do
		run(coroutine.yield())
	end
end

local function spawn<T...>(f: (T...) -> (), ...: T...)
	local thread
	if #freeThreads > 0 then
		thread = freeThreads[#freeThreads]
		freeThreads[#freeThreads] = nil
	else
		thread = coroutine.create(yielder)
		coroutine.resume(thread)
	end

	task.spawn(thread, f, thread, ...)
end

local function spawnCallbacks<Args...>(callbacks: { (Args...) -> () }, ...: Args...)
	for _, callback in callbacks do
		spawn(callback, ...)
	end
end

local function createEvent<Args...>(): Event<Args...>
	local callbacks: { Listener<Args...> } = {}

	return {
		on = function(listener: Listener<Args...>)
			table.insert(callbacks, listener)
			return function()
				local index = table.find(callbacks, listener)
				if index then
					table.remove(callbacks, index)
				end
			end
		end,
		fire = function(...: Args...)
			spawnCallbacks(callbacks, ...)
		end,
	}
end

return {
	inventoryOpened = createEvent(),
	inventoryClosed = createEvent(),
	backpackLoaded = createEvent() :: Event<{ BackpackItem }>,
	backpackItemEquipped = createEvent() :: Event<BackpackItem>,
	backpackItemUnequipped = createEvent() :: Event<BackpackItem>,
	backpackItemAdded = createEvent() :: Event<BackpackItem>,
	backpackItemRemoved = createEvent() :: Event<BackpackItem>,
	backpackEmpty = createEvent(),
	hotbarChanged = createEvent() :: Event<{ BackpackItem }>,
}
