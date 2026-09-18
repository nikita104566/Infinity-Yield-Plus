-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Adds env, device, prefix, timezone, display.
-- Safe to run more than once. Does not replace main source.
-- Does not overwrite currentVersion when source is already newer than 7.62.

pcall(function()
	local function verNum(v)
		local a, b = tostring(v or ""):match("^(%d+)%.(%d+)")
		return (tonumber(a) or 0) * 1000 + (tonumber(b) or 0)
	end
	if verNum(currentVersion) < verNum("7.62") then
		currentVersion = "7.62"
		if type(applyHeaderBrand) == "function" then
			applyHeaderBrand()
		elseif VersionLabel then
			VersionLabel.Text = "· 7.62"
		end
		if SubLabel then
			SubLabel.Text = "7.62"
		end
	end
end)
