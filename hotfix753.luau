-- Infinity Yield Plus 7.57
-- History persist and safe lastcommand now live in `source`.
-- This file is a compatibility stub for old two-line loadstrings.
pcall(function()
	currentVersion = "7.57"
	if type(setBrandTitle) == "function" then
		setBrandTitle(BRAND_NAME)
	elseif VersionLabel then
		VersionLabel.Text = "· 7.57"
	end
	if SubLabel then
		SubLabel.Text = "7.57"
	end
end)
