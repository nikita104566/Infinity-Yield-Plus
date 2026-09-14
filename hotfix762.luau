-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Bumps the version badge. Palette RU/EN lives in source (7.62).
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local cur = tostring(currentVersion or "0")
	local function verNum(s)
		local n = tonumber((tostring(s):match("(%d+%.%d+)") or "0"))
		return n or 0
	end
	if verNum(cur) > 7.62 then
		return
	end
	currentVersion = "7.62"
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· 7.62"
	end
	if SubLabel then
		SubLabel.Text = "7.62"
	end
end)

pcall(function()
	if scoreCache and scoreCache.palette and type(scoreCache.palette.ApplyLang) == "function" then
		scoreCache.palette.ApplyLang()
	end
end)

local function t(key, fallback)
	if type(T) == "function" then
		local ok, val = pcall(T, key)
		if ok and type(val) == "string" and val ~= "" and val ~= key then
			return val
		end
	end
	return fallback
end

local function say(title, body)
	if type(notify) == "function" then
		notify(title, body)
	end
end

pcall(function()
	if _G.__IYP_762_CMDS then
		return
	end
	_G.__IYP_762_CMDS = true

	local function showHotfixes()
		local flags = {
			{ "754", _G.__IYP_754_CMDS or _G.__IYP_754 },
			{ "755", _G.__IYP_755_CMDS or _G.__IYP_755 },
			{ "756", _G.__IYP_756_CMDS or _G.__IYP_756 },
			{ "757", _G.__IYP_757_CMDS },
			{ "758", _G.__IYP_758_CMDS },
			{ "759", _G.__IYP_759_CMDS },
			{ "760", _G.__IYP_760_CMDS },
			{ "761", _G.__IYP_761_CMDS },
			{ "762", _G.__IYP_762_CMDS },
		}
		local parts = {}
		for i = 1, #flags do
			parts[#parts + 1] = flags[i][1] .. (flags[i][2] and "+" or "-")
		end
		say(t("hfTitle", "Hotfixes"), table.concat(parts, " "))
	end

	if type(findCmd) == "function" then
		local existing = findCmd("hotfixes")
		if existing then
			existing.FUNC = showHotfixes
			return
		end
	end
	if type(addcmd) == "function" then
		addcmd("hotfixes", { "hf", "patches" }, showHotfixes)
	end
end)
