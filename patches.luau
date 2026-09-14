-- Infinity Yield Plus patch loader
-- Load AFTER source. Pulls 756–761 in order. Idempotent per hotfix file.
-- Example:
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/source'))()
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/patches.luau'))()

local BASE = "https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/"
local files = {
	"hotfix756.luau",
	"hotfix757.luau",
	"hotfix758.luau",
	"hotfix759.luau",
	"hotfix760.luau",
	"hotfix761.luau",
}

for i = 1, #files do
	local name = files[i]
	local ok, err = pcall(function()
		local src = game:HttpGet(BASE .. name)
		assert(type(src) == "string" and #src > 0, "empty " .. name)
		local fn, loadErr = loadstring(src)
		assert(fn, loadErr or ("bad " .. name))
		fn()
	end)
	if not ok then
		warn("[IYP patches] " .. name .. ": " .. tostring(err))
	end
end
