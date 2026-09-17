Apply inside `source` (`formatCmdRich`) and set `currentVersion = '7.63'`.

Replace `formatCmdRich` with:

```lua
function formatCmdRich(text)
	if not text or text == "" then
		return ""
	end
	local escaped = tostring(text):gsub("&", "&"):gsub("<", "<"):gsub(">", ">")
	local argAt = escaped:find("%[")
	local names = escaped
	local args = ""
	if argAt then
		names = escaped:sub(1, argAt - 1):gsub("%s+$", "")
		args = escaped:sub(argAt)
	end
	local primary, rest = names:match("^([^/]+)%s*(.*)$")
	primary = (primary or names):gsub("%s+$", "")
	rest = rest or ""
	local aliasCount = 0
	if rest ~= "" then
		for part in rest:gmatch("[^/]+") do
			local trimmed = part:gsub("^%s+", ""):gsub("%s+$", "")
			if trimmed ~= "" then
				aliasCount = aliasCount + 1
			end
		end
	end
	local html = "<font color=\"#B8B4CC\">·</font> <font color=\"#F4F4F8\">" .. primary .. "</font>"
	if aliasCount > 0 then
		html = html .. " <font color=\"#6E6A82\">+" .. tostring(aliasCount) .. "</font>"
	end
	if args ~= "" then
		html = html .. " <font color=\"#C4B5FD\">" .. args .. "</font>"
	end
	return html
end
```

Do not add this file to main. It is only the exact hunk because the 1MB `source` blob cannot be rewritten through this API session.
