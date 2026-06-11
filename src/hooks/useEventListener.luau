local vide = require("../../vide")

local cleanup = vide.cleanup

local function useEventListener<T...>(event: RBXScriptSignal<T...>, callback: (T...) -> ()): ()
	cleanup(event:Connect(callback))
end

return useEventListener
