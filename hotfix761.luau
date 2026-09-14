-- Infinity Yield Plus 7.61 hotfix
-- Load after source (and after 756–760 if you still use them).
-- Adds info, copyjoin, creator, clock, maxplayers.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local cur = tonumber((tostring(currentVersion or "0"):match("(%d+%.%d+)") or "0")) or 0
	if cur > 7.61 then
		return
	end
	currentVersion = "7.61"
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· 7.61"
	end
	if SubLabel then
		SubLabel.Text = "7.61"
	end
end)

pcall(function()
	if type(I18N) ~= "table" then
		return
	end
	if type(I18N.en) == "table" then
		I18N.en.infoTitle = I18N.en.infoTitle or "Info"
		I18N.en.joinCopied = I18N.en.joinCopied or "Copied join line"
		I18N.en.creatorTitle = I18N.en.creatorTitle or "Creator"
		I18N.en.clockTitle = I18N.en.clockTitle or "Clock"
		I18N.en.slotsTitle = I18N.en.slotsTitle or "Slots"
		I18N.en.hfTitle = I18N.en.hfTitle or "Hotfixes"
		I18N.en.noClipboard = I18N.en.noClipboard or "No clipboard"
	end
	if type(I18N.ru) == "table" then
		I18N.ru.infoTitle = I18N.ru.infoTitle or "Инфо"
		I18N.ru.joinCopied = I18N.ru.joinCopied or "Строка входа скопирована"
		I18N.ru.creatorTitle = I18N.ru.creatorTitle or "Создатель"
		I18N.ru.clockTitle = I18N.ru.clockTitle or "Часы"
		I18N.ru.slotsTitle = I18N.ru.slotsTitle or "Слоты"
		I18N.ru.hfTitle = I18N.ru.hfTitle or "Хотфиксы"
		I18N.ru.noClipboard = I18N.ru.noClipboard or "Нет буфера"
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

local function clip(text)
	if type(setclipboard) == "function" then
		pcall(setclipboard, tostring(text))
		return true
	elseif type(toclipboard) == "function" then
		pcall(toclipboard, tostring(text))
		return true
	end
	return false
end

local function localPlr()
	local lp = nil
	pcall(function()
		lp = game:GetService("Players").LocalPlayer
	end)
	return lp
end

local function fmtDuration(sec)
	if type(sec) ~= "number" or sec ~= sec or sec < 0 then
		return "n/a"
	end
	sec = math.floor(sec)
	local h = math.floor(sec / 3600)
	local m = math.floor((sec % 3600) / 60)
	local s = sec % 60
	if h > 0 then
		return string.format("%dh %dm %ds", h, m, s)
	end
	if m > 0 then
		return string.format("%dm %ds", m, s)
	end
	return string.format("%ds", s)
end

local function safeGet(fn)
	local ok, val = pcall(fn)
	if ok then
		return val
	end
	return nil
end

local function showInfo()
	local lp = localPlr()
	local name = "?"
	local uid = "?"
	if lp then
		pcall(function()
			name = lp.Name
			uid = tostring(lp.UserId)
		end)
	end
	local placeId = safeGet(function()
		return tostring(game.PlaceId)
	end) or "?"
	local jobId = safeGet(function()
		return tostring(game.JobId)
	end) or "?"
	local nPlr, maxPlr = "?", "?"
	pcall(function()
		local Players = game:GetService("Players")
		nPlr = tostring(#Players:GetPlayers())
		maxPlr = tostring(Players.MaxPlayers)
	end)
	local age = fmtDuration(safeGet(function()
		return workspace.DistributedGameTime
	end))
	local ping = "n/a"
	pcall(function()
		local Stats = game:GetService("Stats")
		local item = Stats.Network.ServerStatsItem["Data Ping"]
		if item then
			ping = string.format("%.0f ms", item:GetValue())
		end
	end)
	local mem = "n/a"
	pcall(function()
		local Stats = game:GetService("Stats")
		mem = string.format("%.1f MB", Stats:GetTotalMemoryUsageMb())
	end)
	local ver = tostring(currentVersion or "7.61")
	local body = table.concat({
		ver,
		name .. " " .. uid,
		"place " .. placeId,
		"job " .. jobId,
		nPlr .. "/" .. maxPlr,
		"age " .. age,
		"ping " .. ping,
		"mem " .. mem,
	}, "\n")
	say(t("infoTitle", "Info"), body)
end

local function copyJoin()
	local placeId = safeGet(function()
		return tostring(game.PlaceId)
	end) or "?"
	local jobId = safeGet(function()
		return tostring(game.JobId)
	end) or "?"
	local line = placeId .. " | " .. jobId
	if clip(line) then
		say(t("infoTitle", "Info"), t("joinCopied", "Copied join line") .. "\n" .. line)
	else
		say(t("infoTitle", "Info"), t("noClipboard", "No clipboard") .. "\n" .. line)
	end
end

local function showCreator()
	local ctype = safeGet(function()
		return tostring(game.CreatorType)
	end) or "?"
	local cid = safeGet(function()
		return tostring(game.CreatorId)
	end) or "?"
	local gname = safeGet(function()
		return game.Name
	end) or "?"
	say(t("creatorTitle", "Creator"), gname .. "\n" .. ctype .. " " .. cid)
end

local function showClock()
	local stamp = safeGet(function()
		return os.date("%Y-%m-%d %H:%M:%S")
	end) or "n/a"
	say(t("clockTitle", "Clock"), stamp)
end

local function showSlots()
	local nPlr, maxPlr = "?", "?"
	pcall(function()
		local Players = game:GetService("Players")
		nPlr = tostring(#Players:GetPlayers())
		maxPlr = tostring(Players.MaxPlayers)
	end)
	say(t("slotsTitle", "Slots"), nPlr .. " / " .. maxPlr)
end

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
	}
	local parts = {}
	for i = 1, #flags do
		parts[#parts + 1] = flags[i][1] .. (flags[i][2] and "+" or "-")
	end
	say(t("hfTitle", "Hotfixes"), table.concat(parts, " "))
end

pcall(function()
	if _G.__IYP_761_CMDS then
		return
	end
	_G.__IYP_761_CMDS = true

	local function register(name, aliases, fn)
		if type(findCmd) == "function" then
			local existing = findCmd(name)
			if existing then
				existing.FUNC = fn
				return
			end
			for i = 1, #aliases do
				existing = findCmd(aliases[i])
				if existing then
					existing.FUNC = fn
					return
				end
			end
		end
		if type(addcmd) == "function" then
			addcmd(name, aliases, fn)
		end
	end

	register("info", { "dump", "fullinfo" }, function()
		showInfo()
	end)
	register("copyjoin", { "cpjoin", "joinline" }, function()
		copyJoin()
	end)
	register("creator", { "ownerid", "gameowner" }, function()
		showCreator()
	end)
	register("clock", { "datetime", "now" }, function()
		showClock()
	end)
	register("maxplayers", { "slots", "cap" }, function()
		showSlots()
	end)
	register("hotfixes", { "hf", "patches" }, function()
		showHotfixes()
	end)
end)
