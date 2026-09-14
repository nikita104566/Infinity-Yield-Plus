--[[
	Infinity Yield Plus 7.53 hotfix
	Apply after the main source loadstring if the panel still shows 7.50
	or if lastcommand errors on an empty history.
]]

pcall(function()
	currentVersion = "7.53"
end)

pcall(function()
	if VersionLabel and VersionLabel.Parent then
		VersionLabel.Text = "· 7.53"
	end
	if SubLabel and SubLabel.Parent then
		SubLabel.Text = "7.53"
	end
end)

pcall(function()
	if type(savedCmdHistory) ~= "table" then
		savedCmdHistory = {}
	end
	if type(cmdHistory) ~= "table" then
		cmdHistory = {}
	end
	if #cmdHistory == 0 and #savedCmdHistory > 0 then
		for _, entry in ipairs(savedCmdHistory) do
			if type(entry) == "string" and entry ~= "" then
				cmdHistory[#cmdHistory + 1] = entry
				if #cmdHistory >= 30 then
					break
				end
			end
		end
	end
end)

pcall(function()
	if type(findCmd) ~= "function" then
		return
	end
	local function safeLastCommand(args, speaker)
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
	if _G.__IYP_753_SAVEWRAP then
		return
	end
	_G.__IYP_753_SAVEWRAP = true
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
		local encode = (HttpService and HttpService.JSONEncode) and function(t)
			return HttpService:JSONEncode(t)
		end
		local decode = (HttpService and HttpService.JSONDecode) and function(t)
			return HttpService:JSONDecode(t)
		end
		if not encode or not decode then
			return
		end
		local data = {}
		if okFile and type(raw) == "string" and raw ~= "" then
			local ok, parsed = pcall(decode, raw)
			if ok and type(parsed) == "table" then
				data = parsed
			end
		end
		data.cmdHistory = hist
		local payload = encode(data)
		if type(writefileCooldown) == "function" then
			writefileCooldown("IY_FE.iy", payload)
		elseif type(IYP_SAFE_WRITEFILE) == "function" then
			IYP_SAFE_WRITEFILE("IY_FE.iy", payload)
		elseif type(writefile) == "function" then
			pcall(writefile, "IY_FE.iy", payload)
		end
	end
end)
