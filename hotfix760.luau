-- Infinity Yield Plus 7.60 hotfix
-- Load after source (and after 756–759 if you still use them).
-- Adds whoami, copyuserid, copyjob, serverage, memory.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local function parseVer(v)
		local a, b = tostring(v or ""):match("^(%d+)%.(%d+)")
		if not a then return 0 end
		return (tonumber(a) or 0) * 1000 + (tonumber(b) or 0)
	end
	if parseVer(currentVersion) > parseVer("7.60") then
		return
	end
	currentVersion = "7.60"
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· 7.60"
	end
	if SubLabel then
		SubLabel.Text = "7.60"
	end
end)

pcall(function()
	if type(I18N) ~= "table" then
		return
	end
	if type(I18N.en) == "table" then
		I18N.en.whoTitle = I18N.en.whoTitle or "You"
		I18N.en.uidCopied = I18N.en.uidCopied or "Copied user id"
		I18N.en.jobCopied = I18N.en.jobCopied or "Copied job id"
		I18N.en.ageTitle = I18N.en.ageTitle or "Server age"
		I18N.en.memTitle = I18N.en.memTitle or "Memory"
		I18N.en.hfTitle = I18N.en.hfTitle or "Hotfixes"
	end
	if type(I18N.ru) == "table" then
		I18N.ru.whoTitle = I18N.ru.whoTitle or "Ты"
		I18N.ru.uidCopied = I18N.ru.uidCopied or "UserId скопирован"
		I18N.ru.jobCopied = I18N.ru.jobCopied or "JobId скопирован"
		I18N.ru.ageTitle = I18N.ru.ageTitle or "Возраст сервера"
		I18N.ru.memTitle = I18N.ru.memTitle or "Память"
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

local function showWho()
	local lp = localPlr()
	if not lp then
		say(t("whoTitle", "You"), "n/a")
		return
	end
	local name, display, uid = "?", "?", "?"
	pcall(function()
		name = lp.Name
		display = lp.DisplayName
		uid = tostring(lp.UserId)
	end)
	local extra = ""
	if display ~= name then
		extra = "\n@" .. display
	end
	say(t("whoTitle", "You"), name .. extra .. "\n" .. uid)
end

local function copyUid()
	local lp = localPlr()
	local uid = "?"
	pcall(function()
		if lp then
			uid = tostring(lp.UserId)
		end
	end)
	if clip(uid) then
		say(t("whoTitle", "You"), t("uidCopied", "Copied user id") .. ": " .. uid)
	else
		say(t("whoTitle", "You"), uid)
	end
end

local function copyJob()
	local id = "?"
	pcall(function()
		id = tostring(game.JobId)
	end)
	if clip(id) then
		say(t("placeTitle", "Place"), t("jobCopied", "Copied job id") .. ": " .. id)
	else
		say(t("placeTitle", "Place"), id)
	end
end

local function showAge()
	local age = nil
	pcall(function()
		age = workspace.DistributedGameTime
	end)
	say(t("ageTitle", "Server age"), fmtDuration(age))
end

local function showMem()
	local mb = nil
	pcall(function()
		local Stats = game:GetService("Stats")
		mb = Stats:GetTotalMemoryUsageMb()
	end)
	local body = type(mb) == "number" and string.format("%.1f MB", mb) or "n/a"
	say(t("memTitle", "Memory"), body)
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
	}
	local parts = {}
	for i = 1, #flags do
		parts[#parts + 1] = flags[i][1] .. (flags[i][2] and "+" or "-")
	end
	say(t("hfTitle", "Hotfixes"), table.concat(parts, " "))
end

pcall(function()
	if _G.__IYP_760_CMDS then
		return
	end
	_G.__IYP_760_CMDS = true

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

	register("whoami", { "myinfo", "iypme" }, function()
		showWho()
	end)
	register("copyuserid", { "cpuid", "copyuid" }, function()
		copyUid()
	end)
	register("copyjob", { "cpjob", "copyjobid" }, function()
		copyJob()
	end)
	register("serverage", { "uptime", "srvage" }, function()
		showAge()
	end)
	register("memory", { "mem", "ram" }, function()
		showMem()
	end)
	register("hotfixes", { "hf", "patches" }, function()
		showHotfixes()
	end)
end)
