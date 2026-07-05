--[[
	MIT License

	Copyright (c) 2026 EncodedLux

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

--[[
	By using Sling, you agree to provide attribution in one of the following ways:
		1. Keep the attribution unmodified and enabled
		2. Provide credit in your experience description by name (Sling) and creator (@EncodedLux)
		3. Have a DevForum topic linked in your experience description, crediting with the above

	Thank you for supporting Sling.
]]
local RunService = game:GetService("RunService")

local VERSION = "0.1.4"

-- Print attribution. Do not modify without reading above
if not RunService:IsStudio() and RunService:IsClient() then
	print(`🎒 Running Sling v{VERSION} by @EncodedLux`)
end

return nil
