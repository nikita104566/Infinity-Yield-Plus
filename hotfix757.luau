-- Infinity Yield Plus 7.57 hotfix
-- Load after source (and after hotfix756 if you still use it).
-- Adds checkupdate, copyhistory, starlast. Safe to run more than once.
-- Does not replace main source.
-- No-op on 7.59+ (these commands are baked into source).

do
	local a, b = string.match(tostring(currentVersion or ""), "^(%d+)%.(%d+)")
	if (tonumber(a) or 0) > 7 or ((tonumber(a) or 0) == 7 and (tonumber(b) or 0) >= 59) then
		return
	end
end

pcall(function()
	currentVersion = "7.57"
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· 7.57"
	end
	if SubLabel then
		SubLabel.Text = "7.57"
	end
end)

pcall(function()
	if type(I18N) ~= "table" then
		return
	end
	if type(I18N.en) == "table" then
		I18N.en.updTitle = I18N.en.updTitle or "Updates"
		I18N.en.updLatest = I18N.en.updLatest or "You are on the latest version"
		I18N.en.updNewer = I18N.en.updNewer or "A newer version is available"
		I18N.en.updFail = I18N.en.updFail or "Could not check for updates"
		I18N.en.copyTitle = I18N.en.copyTitle or "History"
		I18N.en.copyOk = I18N.en.copyOk or "Copied to clipboard"
		I18N.en.copyFail = I18N.en.copyFail or "Clipboard is not available"
		I18N.en.copyEmpty = I18N.en.copyEmpty or "Nothing to copy"
		I18N.en.starTitle = I18N.en.starTitle or "Favorites"
		I18N.en.starOk = I18N.en.starOk or "Last command added to favorites"
		I18N.en.starEmpty = I18N.en.starEmpty or "No command to favorite"
		I18N.en.starFail = I18N.en.starFail or "Favorites API not found"
	end
	if type(I18N.ru) == "table" then
		I18N.ru.updTitle = I18N.ru.updTitle or "Обновления"
		I18N.ru.updLatest = I18N.ru.updLatest or "У вас последняя версия"
		I18N.ru.updNewer = I18N.ru.updNewer or "Доступна новая версия"
		I18N.ru.updFail = I18N.ru.updFail or "Не удалось проверить обновления"
		I18N.ru.copyTitle = I18N.ru.copyTitle or "История"
		I18N.ru.copyOk = I18N.ru.copyOk or "Скопировано в буфер"
		I18N.ru.copyFail = I18N.ru.copyFail or "Буфер обмена недоступен"
		I18N.ru.copyEmpty = I18N.ru.copyEmpty or "Нечего копировать"
		I18N.ru.starTitle = I18N.ru.starTitle or "Избранное"
		I18N.ru.starOk = I18N.ru.starOk or "Последняя команда добавлена в избранное"
		I18N.ru.starEmpty = I18N.ru.starEmpty or "Нет команды для избранного"
		I18N.ru.starFail = I18N.ru.starFail or "API избранного не найден"
	end
end)

local VERSION_URL = "https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/version"
local LOCAL_VER = "7.57"

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

local function lastHistory()
	if type(cmdHistory) ~= "table" or #cmdHistory == 0 then
		return nil
	end
	return cmdHistory[#cmdHistory]
end

local function parseRemoteVersion(body)
	if type(body) ~= "string" then
		return nil
	end
	local ver = string.match(body, '"Version"%s*:%s*"([^"]+)"')
	return ver
end

local function verTuple(s)
	local a, b, c = string.match(tostring(s or ""), "^(%d+)%.(%d+)%.(%d+)")
	if not a then
		a, b = string.match(tostring(s or ""), "^(%d+)%.(%d+)")
		c = "0"
	end
	return tonumber(a) or 0, tonumber(b) or 0, tonumber(c) or 0
end

local function isNewer(remote, localv)
	local ra, rb, rc = verTuple(remote)
	local la, lb, lc = verTuple(localv)
	if ra ~= la then
		return ra > la
	end
	if rb ~= lb then
		return rb > lb
	end
	return rc > lc
end

local function checkUpdate()
	local getter
	if game and game.HttpGet then
		getter = function(url)
			return game:HttpGet(url)
		end
	elseif type(httpget) == "function" then
		getter = httpget
	end
	if type(getter) ~= "function" then
		say(t("updTitle", "Updates"), t("updFail", "Could not check for updates"))
		return
	end
	local ok, body = pcall(getter, VERSION_URL)
	if not ok then
		say(t("updTitle", "Updates"), t("updFail", "Could not check for updates"))
		return
	end
	local remote = parseRemoteVersion(body)
	if not remote then
		say(t("updTitle", "Updates"), t("updFail", "Could not check for updates"))
		return
	end
	if isNewer(remote, currentVersion or LOCAL_VER) then
		say(t("updTitle", "Updates"), t("updNewer", "A newer version is available") .. " (" .. remote .. ")")
	else
		say(t("updTitle", "Updates"), t("updLatest", "You are on the latest version") .. " (" .. tostring(currentVersion or LOCAL_VER) .. ")")
	end
end

local function copyHistory(args)
	local clip = setclipboard or toclipboard or set_clipboard
	if type(clip) ~= "function" then
		say(t("copyTitle", "History"), t("copyFail", "Clipboard is not available"))
		return
	end
	local text
	local mode = type(args) == "table" and tostring(args[1] or "") or ""
	mode = string.lower(mode)
	if mode == "all" or mode == "full" then
		if type(cmdHistory) ~= "table" or #cmdHistory == 0 then
			say(t("copyTitle", "History"), t("copyEmpty", "Nothing to copy"))
			return
		end
		text = table.concat(cmdHistory, "\n")
	else
		text = lastHistory()
		if not text then
			say(t("copyTitle", "History"), t("copyEmpty", "Nothing to copy"))
			return
		end
	end
	local ok = pcall(clip, text)
	if ok then
		say(t("copyTitle", "History"), t("copyOk", "Copied to clipboard"))
	else
		say(t("copyTitle", "History"), t("copyFail", "Clipboard is not available"))
	end
end

local function starLast()
	local cmd = lastHistory()
	if not cmd or cmd == "" then
		say(t("starTitle", "Favorites"), t("starEmpty", "No command to favorite"))
		return
	end
	local added = false
	if type(addFavorite) == "function" then
		added = pcall(addFavorite, cmd)
	elseif type(toggleFavorite) == "function" then
		added = pcall(toggleFavorite, cmd, true)
	elseif type(favorites) == "table" then
		local exists = false
		for i = 1, #favorites do
			if favorites[i] == cmd then
				exists = true
				break
			end
		end
		if not exists then
			favorites[#favorites + 1] = cmd
		end
		added = true
		if type(updatesaves) == "function" then
			pcall(updatesaves)
		end
		if type(refreshFavorites) == "function" then
			pcall(refreshFavorites)
		elseif type(refreshCmdList) == "function" then
			pcall(refreshCmdList)
		end
	end
	if added then
		say(t("starTitle", "Favorites"), t("starOk", "Last command added to favorites"))
	else
		say(t("starTitle", "Favorites"), t("starFail", "Favorites API not found"))
	end
end

pcall(function()
	if _G.__IYP_757_CMDS then
		return
	end
	_G.__IYP_757_CMDS = true

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

	register("checkupdate", { "upd", "vercheck" }, function()
		checkUpdate()
	end)
	register("copyhistory", { "copyhist", "copycmd" }, function(_, args)
		copyHistory(args)
	end)
	register("starlast", { "favlast", "pinlast" }, function()
		starLast()
	end)
end)
