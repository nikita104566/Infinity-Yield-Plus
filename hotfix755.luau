-- Infinity Yield Plus 7.55 hotfix
-- Load after source (and after hotfix754 if you still use it).
-- Debounces save-on-exec from 7.54, adds clearhistory, syncs version badge.
-- Safe to run more than once.

pcall(function()
	local a, b = string.match(tostring(currentVersion or ""), "^(%d+)%.(%d+)")
	local major, minor = tonumber(a) or 0, tonumber(b) or 0
	if major > 7 or (major == 7 and minor >= 55) then
		return
	end
	currentVersion = "7.55"
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· 7.55"
	end
	if SubLabel then
		SubLabel.Text = "7.55"
	end
end)

pcall(function()
	if type(I18N) == "table" then
		if type(I18N.en) == "table" then
			I18N.en.lastCmdEmpty = I18N.en.lastCmdEmpty or "History"
			I18N.en.lastCmdEmptyText = I18N.en.lastCmdEmptyText or "No previous command yet"
			I18N.en.histCleared = I18N.en.histCleared or "History"
			I18N.en.histClearedText = I18N.en.histClearedText or "Command history cleared"
		end
		if type(I18N.ru) == "table" then
			I18N.ru.lastCmdEmpty = I18N.ru.lastCmdEmpty or "История"
			I18N.ru.lastCmdEmptyText = I18N.ru.lastCmdEmptyText or "Пока нет предыдущей команды"
			I18N.ru.histCleared = I18N.ru.histCleared or "История"
			I18N.ru.histClearedText = I18N.ru.histClearedText or "История команд очищена"
		end
	end
end)

-- Replace the 7.54 save-on-every-exec wrap with a 0.35s debounce.
pcall(function()
	if type(execCmd) ~= "function" then
		return
	end
	if _G.__IYP_755_EXECWRAP then
		return
	end
	_G.__IYP_755_EXECWRAP = true
	local prev = execCmd
	local token = 0
	execCmd = function(...)
		local result = prev(...)
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
	if type(findCmd) == "function" then
		local existing = findCmd("clearhistory") or findCmd("clrhist")
		if existing then
			existing.FUNC = clearHistory
			return
		end
	end
	if type(addcmd) == "function" then
		addcmd("clearhistory", {"clrhist", "wipehistory"}, clearHistory)
	end
end)
