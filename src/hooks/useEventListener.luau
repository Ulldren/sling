local vide = require("../../vide")

local function useEventListener<T...>(event: RBXScriptSignal<T...>, callback: (T...) -> ()): ()
	vide.cleanup(event:Connect(callback))
end

return useEventListener
