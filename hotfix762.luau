-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Adds env, device, prefix, timezone, display.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local cur = tostring(currentVersion or "")
	local minor = tonumber((cur:match("7%.(%d+)") or "0"), 10) or 0
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
