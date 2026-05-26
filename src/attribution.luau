--[[
	Copyright 2026 EncodedLux

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]

--[[
	By using VideBackpack, you agree to provide attribution in one of the following ways:
		1. Keep the attribution unmodified and enabled
		2. Provide credit in your experience description by name (VideBackpack) and creator (@EncodedLux)
		3. Have a DevForum topic linked in your experience description, crediting with the above

	Thank you for supporting VideBackpack.
]]

const RunService = game:GetService("RunService")

const VERSION = "1.0.0"

-- Print attribution. Do not modify without reading above
if not RunService:IsStudio() and RunService:IsClient() then
	print(`🎒 Running VideBackpack v{VERSION} by @EncodedLux`)
end

return nil
