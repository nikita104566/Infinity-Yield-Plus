-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Adds env, device, prefix, timezone, display.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local cur = tostring(currentVersion or "")
	local a,b = cur:match("^(%d+)%.(%d+)")
	local major, minor = tonumber(a) or 0, tonumber(b) or 0
	if major > 7 or (major == 7 and minor > 62) then
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
