-- IYP 7.63 command-row formatter (replace formatCmdRich in source)
function formatCmdRich(text)
	if not text or text == "" then
		return ""
	end
	local escaped = tostring(text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	local argAt = escaped:find("%[")
	local names = escaped
	local args = ""
	if argAt then
		names = escaped:sub(1, argAt - 1):gsub("%s+$", "")
		args = escaped:sub(argAt)
	end
	local primary, aliases = names:match("^([^/]+)%s*(.*)$")
	primary = (primary or names):gsub("%s+$", "")
	aliases = aliases or ""
	local compact = ""
	if aliases ~= "" then
		local parts = {}
		for part in aliases:gmatch("[^/]+") do
			part = part:gsub("^%s+", ""):gsub("%s+$", "")
			if part ~= "" then
				parts[#parts + 1] = part
			end
		end
		if #parts > 0 then
			compact = " / " .. parts[1]
			if #parts > 1 then
				compact = compact .. " +" .. tostring(#parts - 1)
			end
		end
	end
	local html = "<font color=\"#B8B4CC\">·</font> <font color=\"#F4F4F8\">" .. primary .. "</font>"
	if args ~= "" then
		html = html .. " <font color=\"#C4B5FD\">" .. args .. "</font>"
	end
	if compact ~= "" then
		html = html .. "<font color=\"#7A778C\">" .. compact .. "</font>"
	end
	return html
end
