-- Infinity Yield Plus 7.62 hotfix
-- Load after source (and after 756–761 if you still use them).
-- Adds env, device, prefix, timezone, display.
-- Safe to run more than once. Does not replace main source.

pcall(function()
	local cur = tostring(currentVersion or "")
	local function older(a, b)
		local function parts(s)
			local t = {}
			for n in tostring(s):gmatch("%d+") do t[#t+1] = tonumber(n) or 0 end
			return t
		end
		local pa, pb = parts(a), parts(b)
		local n = math.max(#pa, #pb)
		for i = 1, n do
			local x, y = pa[i] or 0, pb[i] or 0
			if x < y then return true end
			if x > y then return false end
		end
		return false
	end
	if cur == "" or older(cur, "7.62") then
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
