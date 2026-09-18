-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Adds env, device, prefix, timezone, display.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local function verParts(v)
		local a, b = tostring(v or ""):match("^(%d+)%.(%d+)")
		return tonumber(a) or 0, tonumber(b) or 0
	end
	local ma, mb = verParts(currentVersion)
	if ma > 7 or (ma == 7 and mb >= 63) then
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
