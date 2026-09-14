-- Infinity Yield Plus 7.57
-- Debounced history save and clearhistory now live in `source`.
-- This file is a compatibility stub. Do not wrap execCmd.
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
