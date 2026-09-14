-- Infinity Yield Plus 7.59 hotfix
-- Load after source (and after 756/757/758 if you still use them).
-- Adds placeinfo, copyplace, players, session, hotfixes.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	currentVersion = "7.59"
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· 7.59"
	end
	if SubLabel then
		SubLabel.Text = "7.59"
	end
end)

pcall(function()
	if type(I18N) ~= "table" then
		return
	end
	if type(I18N.en) == "table" then
		I18N.en.placeTitle = I18N.en.placeTitle or "Place"
		I18N.en.placeCopied = I18N.en.placeCopied or "Copied place id"
		I18N.en.plrTitle = I18N.en.plrTitle or "Players"
		I18N.en.sesTitle = I18N.en.sesTitle or "Session"
		I18N.en.hfTitle = I18N.en.hfTitle or "Hotfixes"
	end
	if type(I18N.ru) == "table" then
		I18N.ru.placeTitle = I18N.ru.placeTitle or "Плейс"
		I18N.ru.placeCopied = I18N.ru.placeCopied or "ID плейса скопирован"
		I18N.ru.plrTitle = I18N.ru.plrTitle or "Игроки"
		I18N.ru.sesTitle = I18N.ru.sesTitle or "Сессия"
		I18N.ru.hfTitle = I18N.ru.hfTitle or "Хотфиксы"
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

local function placeId()
	local id = "?"
	pcall(function()
		id = tostring(game.PlaceId)
	end)
	return id
end

local function gameId()
	local id = "?"
	pcall(function()
		id = tostring(game.GameId)
	end)
	return id
end

local function jobId()
	local id = "?"
	pcall(function()
		id = tostring(game.JobId)
	end)
	return id
end

local function playerCount()
	local n = 0
	pcall(function()
		n = #game:GetService("Players"):GetPlayers()
	end)
	return n
end

local function pingMs()
	local ms = nil
	pcall(function()
		local Stats = game:GetService("Stats")
		ms = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	return ms
end

local function fpsVal()
	local fps = nil
	pcall(function()
		fps = workspace:GetRealPhysicsFPS()
	end)
	return fps
end

local function showPlace()
	local line = string.format("Place %s\nGame %s\nJob %s", placeId(), gameId(), jobId())
	say(t("placeTitle", "Place"), line)
end

local function copyPlace()
	local id = placeId()
	if clip(id) then
		say(t("placeTitle", "Place"), t("placeCopied", "Copied place id") .. ": " .. id)
	else
		say(t("placeTitle", "Place"), id)
	end
end

local function showPlayers()
	local names = {}
	pcall(function()
		for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
			table.insert(names, plr.Name)
		end
	end)
	table.sort(names)
	local extra = ""
	if #names > 0 then
		local shown = {}
		for i = 1, math.min(8, #names) do
			shown[i] = names[i]
		end
		extra = "\n" .. table.concat(shown, ", ")
		if #names > 8 then
			extra = extra .. " …"
		end
	end
	say(t("plrTitle", "Players"), tostring(playerCount()) .. extra)
end

local function showSession()
	local ping = pingMs()
	local fps = fpsVal()
	local pingS = type(ping) == "number" and string.format("%.0f ms", ping) or "n/a"
	local fpsS = type(fps) == "number" and string.format("%.0f", fps) or "n/a"
	local ver = tostring(currentVersion or "7.59")
	local msg = string.format(
		"v%s\nPlace %s \u00b7 %s players\nPing %s \u00b7 FPS %s",
		ver,
		placeId(),
		tostring(playerCount()),
		pingS,
		fpsS
	)
	say(t("sesTitle", "Session"), msg)
end

local function showHotfixes()
	local flags = {
		{ "754", _G.__IYP_754_CMDS or _G.__IYP_754 },
		{ "755", _G.__IYP_755_CMDS or _G.__IYP_755 },
		{ "756", _G.__IYP_756_CMDS or _G.__IYP_756 },
		{ "757", _G.__IYP_757_CMDS },
		{ "758", _G.__IYP_758_CMDS },
		{ "759", _G.__IYP_759_CMDS },
	}
	local parts = {}
	for i = 1, #flags do
		parts[#parts + 1] = flags[i][1] .. (flags[i][2] and "+" or "-")
	end
	say(t("hfTitle", "Hotfixes"), table.concat(parts, " "))
end

pcall(function()
	if _G.__IYP_759_CMDS then
		return
	end
	_G.__IYP_759_CMDS = true

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

	register("placeinfo", { "gameinfo", "placeid" }, function()
		showPlace()
	end)
	register("copyplace", { "cpplace" }, function()
		copyPlace()
	end)
	register("players", { "plrs", "plrlist" }, function()
		showPlayers()
	end)
	register("session", { "ses", "status" }, function()
		showSession()
	end)
	register("hotfixes", { "hf", "patches" }, function()
		showHotfixes()
	end)
end)
