-- Infinity Yield Plus 7.56 hotfix
-- Load after source (and after hotfix755 if you still use it).
-- Dedup consecutive history, skip meta-commands, showhistory, version badge.
-- Safe to run more than once.

pcall(function()
	local a, b = string.match(tostring(currentVersion or ""), "^(%d+)%.(%d+)")
	local major, minor = tonumber(a) or 0, tonumber(b) or 0
	if major > 7 or (major == 7 and minor >= 56) then
		return
	end
	currentVersion = "7.56"
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· 7.56"
	end
	if SubLabel then
		SubLabel.Text = "7.56"
	end
end)

pcall(function()
	if type(I18N) ~= "table" then
		return
	end
	if type(I18N.en) == "table" then
		I18N.en.lastCmdEmpty = I18N.en.lastCmdEmpty or "History"
		I18N.en.lastCmdEmptyText = I18N.en.lastCmdEmptyText or "No previous command yet"
		I18N.en.histCleared = I18N.en.histCleared or "History"
		I18N.en.histClearedText = I18N.en.histClearedText or "Command history cleared"
		I18N.en.histTitle = I18N.en.histTitle or "History"
		I18N.en.histEmpty = I18N.en.histEmpty or "History is empty"
	end
	if type(I18N.ru) == "table" then
		I18N.ru.lastCmdEmpty = I18N.ru.lastCmdEmpty or "История"
		I18N.ru.lastCmdEmptyText = I18N.ru.lastCmdEmptyText or "Пока нет предыдущей команды"
		I18N.ru.histCleared = I18N.ru.histCleared or "История"
		I18N.ru.histClearedText = I18N.ru.histClearedText or "История команд очищена"
		I18N.ru.histTitle = I18N.ru.histTitle or "История"
		I18N.ru.histEmpty = I18N.ru.histEmpty or "История пуста"
	end
end)

local META = {
	clearhistory = true,
	clrhist = true,
	wipehistory = true,
	showhistory = true,
	hist = true,
	cmdhistory = true,
	lastcommand = true,
	lastcmd = true,
}

local function firstToken(s)
	if type(s) ~= "string" then
		return ""
	end
	local tok = string.match(s, "^%s*;?%s*(%S+)")
	return tok and string.lower(tok) or ""
end

local function sanitizeHistory()
	if type(cmdHistory) ~= "table" then
		cmdHistory = {}
		return
	end
	local out = {}
	local last = nil
	for i = 1, #cmdHistory do
		local item = cmdHistory[i]
		if type(item) == "string" then
			local trimmed = string.match(item, "^%s*(.-)%s*$") or item
			if trimmed ~= "" and not META[firstToken(trimmed)] and trimmed ~= last then
				out[#out + 1] = trimmed
				last = trimmed
			end
		end
	end
	while #out > 30 do
		table.remove(out, 1)
	end
	cmdHistory = out
end

pcall(sanitizeHistory)

-- Keep 7.55 debounce; wrap once more to sanitize after each exec.
pcall(function()
	if type(execCmd) ~= "function" then
		return
	end
	if _G.__IYP_756_EXECWRAP then
		return
	end
	_G.__IYP_756_EXECWRAP = true
	local prev = execCmd
	local token = 0
	execCmd = function(...)
		local result = prev(...)
		pcall(sanitizeHistory)
		if type(updatesaves) ~= "function" then
			return result
		end
		token += 1
		local my = token
		local delayFn = (typeof(task) == "table" and task.delay) or delay
		if type(delayFn) ~= "function" then
			pcall(updatesaves)
			return result
		end
		delayFn(0.35, function()
			if my == token then
				pcall(sanitizeHistory)
				pcall(updatesaves)
			end
		end)
		return result
	end
end)

pcall(function()
	local function clearHistory()
		if type(cmdHistory) == "table" then
			table.clear(cmdHistory)
		else
			cmdHistory = {}
		end
		if type(updatesaves) == "function" then
			pcall(updatesaves)
		end
		local title = (type(T) == "function" and T("histCleared")) or "History"
		local body = (type(T) == "function" and T("histClearedText")) or "Command history cleared"
		if type(notify) == "function" then
			notify(title, body)
		end
	end

	local function showHistory()
		sanitizeHistory()
		local title = (type(T) == "function" and T("histTitle")) or "History"
		if type(cmdHistory) ~= "table" or #cmdHistory == 0 then
			local empty = (type(T) == "function" and T("histEmpty")) or "History is empty"
			if type(notify) == "function" then
				notify(title, empty)
			end
			return
		end
		local start = math.max(1, #cmdHistory - 7)
		local lines = {}
		for i = start, #cmdHistory do
			lines[#lines + 1] = tostring(i) .. ". " .. cmdHistory[i]
		end
		if type(notify) == "function" then
			notify(title, table.concat(lines, "\n"))
		end
	end

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

	register("clearhistory", {"clrhist", "wipehistory"}, clearHistory)
	register("showhistory", {"hist", "cmdhistory"}, showHistory)
end)
