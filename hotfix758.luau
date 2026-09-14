-- Infinity Yield Plus 7.58 hotfix
-- Load after source (and after 756/757 if you still use them).
-- Adds repeatlast, ping, fps, cmdcount. Enhances checkupdate with announcement.
-- Safe to run more than once. Does not replace main source.
-- No-op on 7.59+ (these commands are baked into source).

do
	local a, b = string.match(tostring(currentVersion or ""), "^(%d+)%.(%d+)")
	if (tonumber(a) or 0) > 7 or ((tonumber(a) or 0) == 7 and (tonumber(b) or 0) >= 59) then
		return
	end
end

pcall(function()
	currentVersion = "7.58"
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· 7.58"
	end
	if SubLabel then
		SubLabel.Text = "7.58"
	end
end)

pcall(function()
	if type(I18N) ~= "table" then
		return
	end
	if type(I18N.en) == "table" then
		I18N.en.repTitle = I18N.en.repTitle or "Repeat"
		I18N.en.repEmpty = I18N.en.repEmpty or "Nothing to repeat"
		I18N.en.repOk = I18N.en.repOk or "Re-running last command"
		I18N.en.pingTitle = I18N.en.pingTitle or "Network"
		I18N.en.fpsTitle = I18N.en.fpsTitle or "Performance"
		I18N.en.cntTitle = I18N.en.cntTitle or "Commands"
	end
	if type(I18N.ru) == "table" then
		I18N.ru.repTitle = I18N.ru.repTitle or "Повтор"
		I18N.ru.repEmpty = I18N.ru.repEmpty or "Нечего повторять"
		I18N.ru.repOk = I18N.ru.repOk or "Повтор последней команды"
		I18N.ru.pingTitle = I18N.ru.pingTitle or "Сеть"
		I18N.ru.fpsTitle = I18N.ru.fpsTitle or "Производительность"
		I18N.ru.cntTitle = I18N.ru.cntTitle or "Команды"
	end
end)

local VERSION_URL = "https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/version"
local LOCAL_VER = "7.58"

local META = {
	lastcommand = true, lastcmd = true,
	clearhistory = true, clrhist = true, wipehistory = true,
	showhistory = true, hist = true, cmdhistory = true,
	copyhistory = true, copyhist = true, copycmd = true,
	starlast = true, favlast = true, pinlast = true,
	checkupdate = true, upd = true, vercheck = true,
	repeatlast = true, again = true, rerun = true,
	ping = true, latency = true, fps = true, cmdcount = true, cmdn = true,
}

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

local function firstWord(s)
	return string.lower((string.match(tostring(s or ""), "^%s*(%S+)") or ""))
end

local function pickHistory()
	if type(cmdHistory) ~= "table" then
		return nil
	end
	for i = #cmdHistory, 1, -1 do
		local line = cmdHistory[i]
		if type(line) == "string" and line ~= "" and not META[firstWord(line)] then
			return line
		end
	end
	for i = 1, #cmdHistory do
		local line = cmdHistory[i]
		if type(line) == "string" and line ~= "" and not META[firstWord(line)] then
			return line
		end
	end
	return nil
end

local function parseRemote(body)
	if type(body) ~= "string" then
		return nil, nil
	end
	local ver = string.match(body, '"Version"%s*:%s*"([^"]+)"')
	local ann = string.match(body, '"Announcement"%s*:%s*"([^"]*)"')
	return ver, ann
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
	local remote, ann = parseRemote(body)
	if not remote then
		say(t("updTitle", "Updates"), t("updFail", "Could not check for updates"))
		return
	end
	local msg
	if isNewer(remote, currentVersion or LOCAL_VER) then
		msg = t("updNewer", "A newer version is available") .. " (" .. remote .. ")"
	else
		msg = t("updLatest", "You are on the latest version") .. " (" .. tostring(currentVersion or LOCAL_VER) .. ")"
	end
	if type(ann) == "string" and ann ~= "" then
		msg = msg .. "\n" .. ann
	end
	say(t("updTitle", "Updates"), msg)
end

local function repeatLast()
	local cmd = pickHistory()
	if not cmd then
		say(t("repTitle", "Repeat"), t("repEmpty", "Nothing to repeat"))
		return
	end
	say(t("repTitle", "Repeat"), t("repOk", "Re-running last command") .. ": " .. cmd)
	if type(execCmd) == "function" then
		pcall(execCmd, cmd)
	end
end

local function showPing()
	local ms = nil
	pcall(function()
		local Stats = game:GetService("Stats")
		local item = Stats.Network.ServerStatsItem["Data Ping"]
		ms = item:GetValue()
	end)
	if type(ms) == "number" then
		say(t("pingTitle", "Network"), string.format("%.0f ms", ms))
	else
		say(t("pingTitle", "Network"), "n/a")
	end
end

local function showFps()
	local fps = nil
	pcall(function()
		fps = workspace:GetRealPhysicsFPS()
	end)
	if type(fps) ~= "number" then
		pcall(function()
			local RunService = game:GetService("RunService")
			local t0 = os.clock()
			RunService.Heartbeat:Wait()
			local dt = os.clock() - t0
			if dt > 0 then
				fps = 1 / dt
			end
		end)
	end
	if type(fps) == "number" then
		say(t("fpsTitle", "Performance"), string.format("%.0f FPS", fps))
	else
		say(t("fpsTitle", "Performance"), "n/a")
	end
end

local function showCount()
	local n = 0
	if type(CMDs) == "table" then
		n = #CMDs
	elseif type(cmds) == "table" then
		n = #cmds
	end
	say(t("cntTitle", "Commands"), tostring(n))
end

pcall(function()
	if _G.__IYP_758_CMDS then
		return
	end
	_G.__IYP_758_CMDS = true

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

	register("repeatlast", { "again", "rerun" }, function()
		repeatLast()
	end)
	register("ping", { "latency" }, function()
		showPing()
	end)
	register("fps", {}, function()
		showFps()
	end)
	register("cmdcount", { "cmdn" }, function()
		showCount()
	end)

	if type(findCmd) == "function" then
		local existing = findCmd("checkupdate") or findCmd("upd")
		if existing then
			existing.FUNC = function()
				checkUpdate()
			end
		end
	end
end)
