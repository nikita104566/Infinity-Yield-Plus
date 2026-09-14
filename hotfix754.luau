-- Infinity Yield Plus 7.54 hotfix
-- Safe lastcommand, persist cmdHistory in IY_FE.iy, bump panel version.
-- Load after source. Safe to run more than once.

pcall(function()
	currentVersion = "7.54"
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· 7.54"
	end
	if SubLabel then
		SubLabel.Text = "7.54"
	end
end)

pcall(function()
	if type(I18N) == "table" then
		if type(I18N.en) == "table" then
			I18N.en.lastCmdEmpty = I18N.en.lastCmdEmpty or "History"
			I18N.en.lastCmdEmptyText = I18N.en.lastCmdEmptyText or "No previous command yet"
		end
		if type(I18N.ru) == "table" then
			I18N.ru.lastCmdEmpty = I18N.ru.lastCmdEmpty or "История"
			I18N.ru.lastCmdEmptyText = I18N.ru.lastCmdEmptyText or "Пока нет предыдущей команды"
		end
	end
end)

pcall(function()
	if type(cmdHistory) ~= "table" then
		cmdHistory = {}
	end
	if type(IYP_SAFE_READFILE) ~= "function" and type(readfile) ~= "function" then
		return
	end
	local ok, raw
	if type(IYP_SAFE_READFILE) == "function" then
		ok, raw = IYP_SAFE_READFILE("IY_FE.iy")
	else
		ok, raw = pcall(readfile, "IY_FE.iy")
	end
	if not ok or type(raw) ~= "string" or raw == "" then
		return
	end
	if not HttpService then
		return
	end
	local parsedOk, parsed = pcall(function()
		return HttpService:JSONDecode(raw)
	end)
	if not parsedOk or type(parsed) ~= "table" or type(parsed.cmdHistory) ~= "table" then
		return
	end
	if #cmdHistory > 0 then
		return
	end
	local hist = {}
	for _, entry in ipairs(parsed.cmdHistory) do
		if type(entry) == "string" and entry ~= "" then
			hist[#hist + 1] = entry
			if #hist >= 30 then
				break
			end
		end
	end
	cmdHistory = hist
end)

pcall(function()
	if type(findCmd) ~= "function" then
		return
	end
	local function safeLastCommand()
		local prev = (type(cmdHistory) == "table" and cmdHistory[1]) or nil
		if type(prev) ~= "string" or prev == "" then
			local title = (type(T) == "function" and T("lastCmdEmpty")) or "History"
			local body = (type(T) == "function" and T("lastCmdEmptyText")) or "No previous command yet"
			if type(notify) == "function" then
				notify(title, body)
			end
			return
		end
		if prev:sub(1, 11) ~= "lastcommand" and prev:sub(1, 7) ~= "lastcmd" then
			execCmd(prev)
		end
	end
	local cmd = findCmd("lastcommand") or findCmd("lastcmd")
	if cmd then
		cmd.FUNC = safeLastCommand
	elseif type(addcmd) == "function" then
		addcmd("lastcommand", {"lastcmd"}, safeLastCommand)
	end
end)

pcall(function()
	if type(updatesaves) ~= "function" then
		return
	end
	if _G.__IYP_754_SAVEWRAP then
		return
	end
	_G.__IYP_754_SAVEWRAP = true
	local prev = updatesaves
	updatesaves = function()
		local okFile, raw = false, nil
		if type(IYP_SAFE_READFILE) == "function" then
			okFile, raw = IYP_SAFE_READFILE("IY_FE.iy")
		elseif type(readfile) == "function" then
			okFile, raw = pcall(readfile, "IY_FE.iy")
		end
		prev()
		local hist = {}
		if type(cmdHistory) == "table" then
			for _, entry in ipairs(cmdHistory) do
				if type(entry) == "string" and entry ~= "" then
					hist[#hist + 1] = entry
					if #hist >= 30 then
						break
					end
				end
			end
		end
		if #hist == 0 then
			return
		end
		if not HttpService then
			return
		end
		local data = {}
		if okFile and type(raw) == "string" and raw ~= "" then
			local ok, parsed = pcall(function()
				return HttpService:JSONDecode(raw)
			end)
			if ok and type(parsed) == "table" then
				data = parsed
			end
		end
		data.cmdHistory = hist
		local payloadOk, payload = pcall(function()
			return HttpService:JSONEncode(data)
		end)
		if not payloadOk or type(payload) ~= "string" then
			return
		end
		if type(writefileCooldown) == "function" then
			writefileCooldown("IY_FE.iy", payload)
		elseif type(IYP_SAFE_WRITEFILE) == "function" then
			IYP_SAFE_WRITEFILE("IY_FE.iy", payload)
		elseif type(writefile) == "function" then
			pcall(writefile, "IY_FE.iy", payload)
		end
	end
end)

pcall(function()
	if type(execCmd) ~= "function" then
		return
	end
	if _G.__IYP_754_EXECWRAP then
		return
	end
	_G.__IYP_754_EXECWRAP = true
	local prev = execCmd
	execCmd = function(...)
		local result = prev(...)
		if type(updatesaves) == "function" then
			pcall(updatesaves)
		end
		return result
	end
end)
