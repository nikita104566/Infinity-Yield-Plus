-- Infinity Yield Plus hotfix760 compatibility stub (7.60).
-- 7.54–7.62 behavior is baked into source 7.63. Old two-line loadstrings stay safe.
-- If currentVersion is already 7.62 or newer, this file does nothing (never downgrades the badge).

local function iypStubAtLeast(wantMajor, wantMinor)
	local a, b = string.match(tostring(currentVersion or ""), "^(%d+)%.(%d+)")
	a, b = tonumber(a) or 0, tonumber(b) or 0
	return a > wantMajor or (a == wantMajor and b >= wantMinor)
end

if iypStubAtLeast(7, 62) then
	return
end
