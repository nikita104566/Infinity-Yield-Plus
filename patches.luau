-- Infinity Yield Plus patch loader
-- Load AFTER source. Default queue is empty: 7.54–7.62 are baked into source 7.63.
-- Sidecar files are no-op stubs when currentVersion >= 7.62. Old two-line loadstrings stay safe.
--
-- Explicitly load a legacy stub (usually unnecessary):
--   _G.IYP_ONLY = 762
--   loadstring(game:HttpGet(BASE .. "patches.luau"))()
--
-- Several, in this order:
--   _G.IYP_ONLY = { 756, 759, 762 }
--
-- Skip ids from an explicit IYP_ONLY list:
--   _G.IYP_SKIP = { 761 }
--
-- Optional: _G.IYP_PATCH_BASE = "https://raw.githubusercontent.com/<owner>/<repo>/<ref>/"
-- Example (one loadstring is enough):
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/source'))()

local DEFAULT_BASE = "https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/"
local BASE = DEFAULT_BASE
if type(_G.IYP_PATCH_BASE) == "string" and #_G.IYP_PATCH_BASE > 0 then
	BASE = _G.IYP_PATCH_BASE
	if string.sub(BASE, -1) ~= "/" then
		BASE = BASE .. "/"
	end
end

-- Keep in sync with hotfix/catalog.json (tools/iyp.py check).
local PATCHES = {
	{ id = 753, file = "hotfix753.luau" },
	{ id = 754, file = "hotfix754.luau" },
	{ id = 755, file = "hotfix755.luau" },
	{ id = 756, file = "hotfix756.luau" },
	{ id = 757, file = "hotfix757.luau" },
	{ id = 758, file = "hotfix758.luau" },
	{ id = 759, file = "hotfix759.luau" },
	{ id = 760, file = "hotfix760.luau" },
	{ id = 761, file = "hotfix761.luau" },
	{ id = 762, file = "hotfix762.luau" },
}

local DEFAULT_IDS = {}

local function fileFor(id)
	for i = 1, #PATCHES do
		if PATCHES[i].id == id then
			return PATCHES[i].file
		end
	end
	return nil
end

local function parseId(value)
	if type(value) == "number" then
		return value
	end
	if type(value) ~= "string" then
		return nil
	end
	local cleaned = string.gsub(value, "^hotfix", "")
	cleaned = string.gsub(cleaned, "%.luau$", "")
	return tonumber(cleaned)
end

local function toIdList(value)
	if value == nil then
		return nil
	end
	if type(value) == "number" or type(value) == "string" then
		local id = parseId(value)
		if id then
			return { id }
		end
		return {}
	end
	if type(value) == "table" then
		local out = {}
		-- array part first (explicit order)
		for i = 1, #value do
			local id = parseId(value[i])
			if id then
				out[#out + 1] = id
			end
		end
		if #out > 0 then
			return out
		end
		-- { [762] = true } style
		for k, v in pairs(value) do
			if v and (type(k) == "number" or type(k) == "string") then
				local id = parseId(k)
				if id then
					out[#out + 1] = id
				end
			end
		end
		return out
	end
	return nil
end

local function contains(list, id)
	for i = 1, #list do
		if list[i] == id then
			return true
		end
	end
	return false
end

local only = toIdList(_G.IYP_ONLY)
local skip = toIdList(_G.IYP_SKIP) or {}

local queue = {}
if only then
	for i = 1, #only do
		local id = only[i]
		if not contains(skip, id) then
			local file = fileFor(id)
			if file then
				queue[#queue + 1] = { id = id, file = file }
			else
				warn("[IYP patches] unknown id " .. tostring(id))
			end
		end
	end
else
	for i = 1, #DEFAULT_IDS do
		local id = DEFAULT_IDS[i]
		if not contains(skip, id) then
			queue[#queue + 1] = { id = id, file = fileFor(id) }
		end
	end
end

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

if #queue == 0 then
	if only then
		warn("[IYP patches] nothing to load (check _G.IYP_ONLY / _G.IYP_SKIP)")
	else
		print("[IYP patches] baked into source 7.63; default chain is empty")
	end
	return
end

local loaded = {}
local failed = {}
for i = 1, #queue do
	local name = queue[i].file
	local ok, err = pcall(function()
		local src = fetch(BASE .. name)
		local fn, loadErr = loadstring(src)
		assert(fn, loadErr or ("bad " .. name))
		fn()
	end)
	if ok then
		loaded[#loaded + 1] = tostring(queue[i].id)
	else
		failed[#failed + 1] = name
		warn("[IYP patches] " .. name .. ": " .. tostring(err))
	end
end

local msg = "[IYP patches] loaded " .. table.concat(loaded, ", ")
if #failed > 0 then
	msg = msg .. " | failed " .. table.concat(failed, ", ")
end
if only then
	msg = msg .. " (IYP_ONLY)"
end
print(msg)
