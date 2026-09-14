-- Infinity Yield Plus patch loader
-- Load AFTER source. Pulls 756–762 in order. Idempotent per hotfix file.
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
	"hotfix762.luau",
}

local bakedVer = currentVersion

local function fetch(url)
	local lastErr = "no HttpGet"
	for attempt = 1, 2 do
		local ok, src = pcall(function()
			return game:HttpGet(url)
		end)
		if ok and type(src) == "string" and #src > 0 then
			return src
		end
		lastErr = tostring(src)
	end
	error(lastErr)
end

for i = 1, #files do
	local name = files[i]
	local ok, err = pcall(function()
		local src = fetch(BASE .. name)
		local fn, loadErr = loadstring(src)
		assert(fn, loadErr or ("bad " .. name))
		fn()
	end)
	if not ok then
		warn("[IYP patches] " .. name .. ": " .. tostring(err))
	end
end

pcall(function()
	local function verKey(s)
		local maj, min = tostring(s or ""):match("^(%d+)%.(%d+)")
		return (tonumber(maj) or 0) * 1000 + (tonumber(min) or 0)
	end
	if verKey(bakedVer) <= verKey(currentVersion) then
		return
	end
	currentVersion = bakedVer
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· " .. tostring(bakedVer)
	end
	if SubLabel then
		SubLabel.Text = tostring(bakedVer)
	end
end)
