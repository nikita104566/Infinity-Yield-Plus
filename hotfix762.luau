-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Adds env, device, prefix, timezone, display.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local cur = tostring(currentVersion or "")
	local minor = tonumber(cur:match("^7%.(%d+)")) or 0
	if minor >= 63 then
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
	if type(I18N) ~= "table" then
		return
	end
	if type(I18N.en) == "table" then
		I18N.en.envTitle = I18N.en.envTitle or "Env"
		I18N.en.deviceTitle = I18N.en.deviceTitle or "Device"
		I18N.en.prefixTitle = I18N.en.prefixTitle or "Prefix"
		I18N.en.tzTitle = I18N.en.tzTitle or "Timezone"
		I18N.en.displayTitle = I18N.en.displayTitle or "Display"
		I18N.en.hfTitle = I18N.en.hfTitle or "Hotfixes"
	end
	if type(I18N.ru) == "table" then
		I18N.ru.envTitle = I18N.ru.envTitle or "Среда"
		I18N.ru.deviceTitle = I18N.ru.deviceTitle or "Устройство"
		I18N.ru.prefixTitle = I18N.ru.prefixTitle or "Префикс"
		I18N.ru.tzTitle = I18N.ru.tzTitle or "Пояс"
		I18N.ru.displayTitle = I18N.ru.displayTitle or "Экран"
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

local function safeGet(fn)
	local ok, val = pcall(fn)
	if ok then
		return val
	end
	return nil
end

local function detectExecutor()
	local name = safeGet(function()
		if type(identifyexecutor) == "function" then
			local a, b = identifyexecutor()
			if type(a) == "string" and a ~= "" then
				return b and (a .. " " .. tostring(b)) or a
			end
		end
		return nil
	end)
	if name then
		return name
	end
	local guesses = { "Synapse", "ScriptWare", "Krnl", "Fluxus", "Solara", "Wave", "Delta", "Codex", "Arceus", "Macsploit" }
	for i = 1, #guesses do
		if _G[guesses[i]] or getgenv and getgenv()[guesses[i]] then
			return guesses[i]
		end
	end
	return "unknown"
end

local function showEnv()
	local exec = detectExecutor()
	local http = type(game.HttpGet) == "function" and "http+" or "http-"
	local clip = (type(setclipboard) == "function" or type(toclipboard) == "function") and "clip+" or "clip-"
	local fs = (type(writefile) == "function" and type(readfile) == "function") and "fs+" or "fs-"
	local hook = (type(hookfunction) == "function" or type(hookfunc) == "function") and "hook+" or "hook-"
	local ver = tostring(currentVersion or "7.62")
	say(t("envTitle", "Env"), table.concat({
		ver,
		exec,
		http,
		clip,
		fs,
		hook,
	}, "\n"))
end

local function showDevice()
	local touch = safeGet(function()
		return game:GetService("UserInputService").TouchEnabled
	end)
	local kb = safeGet(function()
		return game:GetService("UserInputService").KeyboardEnabled
	end)
	local gp = safeGet(function()
		return game:GetService("UserInputService").GamepadEnabled
	end)
	local acc = safeGet(function()
		return game:GetService("UserInputService").AccelerometerEnabled
	end)
	local plat = safeGet(function()
		return tostring(game:GetService("UserInputService"):GetPlatform())
	end) or "?"
	local kind = touch and not kb and "mobile" or (kb and "desktop" or "mixed")
	say(t("deviceTitle", "Device"), table.concat({
		kind,
		"platform " .. plat,
		"touch " .. tostring(touch),
		"keyboard " .. tostring(kb),
		"gamepad " .. tostring(gp),
		"accel " .. tostring(acc),
	}, "\n"))
end

local function showPrefix()
	local p = "?"
	pcall(function()
		if type(prefix) == "string" and prefix ~= "" then
			p = prefix
		elseif type(getprefix) == "function" then
			p = tostring(getprefix())
		end
	end)
	say(t("prefixTitle", "Prefix"), p)
end

local function showTz()
	local off = safeGet(function()
		return os.date("%z")
	end) or "?"
	local name = safeGet(function()
		return os.date("%Z")
	end) or "?"
	local stamp = safeGet(function()
		return os.date("%Y-%m-%d %H:%M:%S")
	end) or "n/a"
	say(t("tzTitle", "Timezone"), name .. " " .. off .. "\n" .. stamp)
end

local function showDisplay()
	local cam = safeGet(function()
		return workspace.CurrentCamera
	end)
	local vs = cam and cam.ViewportSize
	local w = vs and math.floor(vs.X) or "?"
	local h = vs and math.floor(vs.Y) or "?"
	local gui = safeGet(function()
		return game:GetService("GuiService"):GetGuiInset()
	end)
	local inset = gui and string.format("%d,%d", gui.X, gui.Y) or "n/a"
	local scale = safeGet(function()
		local cam2 = workspace.CurrentCamera
		return cam2 and string.format("%.2f", cam2.ViewportSize.X / 1920)
	end) or "n/a"
	say(t("displayTitle", "Display"), tostring(w) .. "x" .. tostring(h) .. "\ninset " .. inset .. "\nscale ~" .. scale)
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
		{ "762", _G.__IYP_762_CMDS },
	}
	local parts = {}
	for i = 1, #flags do
		parts[#parts + 1] = flags[i][1] .. (flags[i][2] and "+" or "-")
	end
	say(t("hfTitle", "Hotfixes"), table.concat(parts, " "))
end

pcall(function()
	if _G.__IYP_762_CMDS then
		return
	end
	_G.__IYP_762_CMDS = true

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

	register("env", { "executor", "uncinfo" }, function()
		showEnv()
	end)
	register("device", { "platform", "input" }, function()
		showDevice()
	end)
	register("showprefix", { "getprefix", "pfx" }, function()
		showPrefix()
	end)
	register("timezone", { "tz", "zone" }, function()
		showTz()
	end)
	register("display", { "resolution", "viewport" }, function()
		showDisplay()
	end)
	register("hotfixes", { "hf", "patches" }, function()
		showHotfixes()
	end)
end)
