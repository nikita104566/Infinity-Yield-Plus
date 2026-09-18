-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Adds env, device, prefix, timezone, display.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local cur = tostring(currentVersion or "")
	local function olderThan763(v)
		local a,b = tostring(v or ""):match("^(%d+)%.(%d+)")
		if not a then return true end
		a, b = tonumber(a), tonumber(b)
		if a ~= 7 then return a < 7 end
		return b < 63
	end
	if olderThan763(cur) then
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
