const vide = require("../../vide")

const function useEventListener<T>(event: RBXScriptSignal<T>, callback: (T) -> ()): ()
	vide.cleanup(event:Connect(callback))
end

return useEventListener
