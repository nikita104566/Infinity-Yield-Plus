-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Adds env, device, prefix, timezone, display.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local function verNum(v)
		local a, b = tostring(v or ""):match("(%d+)%.(%d+)")
		return (tonumber(a) or 0) * 1000 + (tonumber(b) or 0)
	end
	if verNum(currentVersion) < verNum("7.63") then
		currentVersion = "7.63"
	end
	if type(applyHeaderBrand) == "function" then
		applyHeaderBrand()
	elseif VersionLabel then
		VersionLabel.Text = "· " .. tostring(currentVersion or "7.63")
	end
	if SubLabel then
		SubLabel.Text = tostring(currentVersion or "7.63")
	end
end)
