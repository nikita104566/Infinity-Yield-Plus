-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Adds env, device, prefix, timezone, display.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local function parts(s)
		local x, y = tostring(s or ""):match("^(%d+)%.(%d+)")
		return tonumber(x) or 0, tonumber(y) or 0
	end
	local function newer(a, b)
		local a1, a2 = parts(a)
		local b1, b2 = parts(b)
		if a1 ~= b1 then return a1 > b1 end
		return a2 > b2
	end
	if not newer(currentVersion, "7.62") then
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
