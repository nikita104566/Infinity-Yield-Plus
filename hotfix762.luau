-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Adds env, device, prefix, timezone, display.
-- Safe to run more than once. Does not replace main source.
-- Skips the version stamp when source currentVersion is already newer than 7.62.

pcall(function()
	local cur = tostring(currentVersion or "")
	local n = tonumber((cur:match("(%d+%.%d+)") or "0")) or 0
	if n > 7.62 then
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
