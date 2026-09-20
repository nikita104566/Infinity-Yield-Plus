-- Insert immediately after: local CmdbarBox = ViewportTextBox.convert(Cmdbar)
-- Also set currentVersion = '7.63'
-- Add T keys: clearBar = "Clear" / "Очистить"

CmdClear = Instance.new("TextButton")
CmdClear.Name = "CmdClear"
CmdClear.Parent = CmdbarWrap
CmdClear.BackgroundTransparency = 1
CmdClear.BorderSizePixel = 0
CmdClear.AnchorPoint = Vector2.new(1, 0.5)
CmdClear.Position = UDim2.new(1, -4, 0.5, 0)
CmdClear.Size = UDim2.new(0, 22, 0, 22)
CmdClear.ZIndex = 12
CmdClear.Font = UI_FONT_MED
CmdClear.TextSize = 16
CmdClear.Text = "x"
CmdClear.TextColor3 = Color3.fromRGB(180, 176, 196)
CmdClear.AutoButtonColor = false
CmdClear.Visible = false

function syncCmdClear()
	local has = Cmdbar and type(Cmdbar.Text) == "string" and Cmdbar.Text ~= ""
	if CmdClear then
		CmdClear.Visible = has and true or false
		CmdClear.Text = "x"
		pcall(function()
			CmdClear:SetAttribute("Hint", T("clearBar"))
		end)
	end
	if CmdbarBox and CmdbarBox.View then
		if has then
			CmdbarBox.View.Size = UDim2.new(1, -26, 1, 0)
		else
			CmdbarBox.View.Size = UDim2.new(1, 0, 1, 0)
		end
	end
end
IYR_TRACK(Cmdbar:GetPropertyChangedSignal("Text"):Connect(syncCmdClear))
IYR_TRACK(CmdClear.MouseButton1Click:Connect(function()
	Cmdbar.Text = ""
	if CmdGhost then CmdGhost.Text = "" end
	pcall(function()
		scheduleIndexContents("", true, true)
	end)
	pcall(function()
		Cmdbar:CaptureFocus()
	end)
	syncCmdClear()
end))
syncCmdClear()
