--[[
    Infinity Yield Plus — Standalone Tactical Crosshair
    https://github.com/nikita104566/Infinity-Yield-Plus

    Usage:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/crosshair.luau"))()

    Features:
        - Exact 3D camera viewport center alignment (IgnoreGuiInset)
        - Fully customizable: color (presets/hex/rgb), size, gap, thickness, center dot
        - Seamless standalone operation or automatic Infinity Yield Plus integration
        - Global API: getgenv().Crosshair / _G.Crosshair
        - In-game chat command listener (;ch, ;noch, ;crosshair, ;uncrosshair)
]]--

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if type(_G.notify) == "function" then
        pcall(_G.notify, title, text)
        return
    end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Crosshair",
            Text = text or "",
            Duration = 3,
        })
    end)
end

local PRESETS = {
    green = Color3.fromRGB(0, 255, 136),
    lime = Color3.fromRGB(50, 255, 50),
    red = Color3.fromRGB(255, 60, 60),
    cyan = Color3.fromRGB(0, 230, 255),
    blue = Color3.fromRGB(60, 140, 255),
    white = Color3.fromRGB(255, 255, 255),
    yellow = Color3.fromRGB(255, 230, 0),
    purple = Color3.fromRGB(180, 80, 255),
    pink = Color3.fromRGB(255, 105, 180),
    orange = Color3.fromRGB(255, 140, 0),
    black = Color3.fromRGB(20, 20, 20),
}

local function parseColor(val)
    if not val or val == "" then return nil end
    if typeof(val) == "Color3" then return val end
    val = tostring(val):lower()
    if PRESETS[val] then return PRESETS[val] end
    local hex = val:gsub("^#", "")
    if #hex == 6 and hex:match("^[0-9a-fA-F]+$") then
        local r = tonumber(hex:sub(1, 2), 16)
        local g = tonumber(hex:sub(3, 4), 16)
        local b = tonumber(hex:sub(5, 6), 16)
        if r and g and b then return Color3.fromRGB(r, g, b) end
    end
    local r, g, b = val:match("^(%d+)%s*[, ]%s*(%d+)%s*[, ]%s*(%d+)$")
    if r and g and b then
        return Color3.fromRGB(tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255)
    end
    return nil
end

local crosshairGui = nil
local crosshairFrame = nil

local function isCrosshairActive()
    if crosshairGui and crosshairGui.Parent then return true end
    if crosshairFrame and crosshairFrame.Parent then return true end
    local genv = (getgenv and getgenv()) or _G
    if genv.__IYP_CROSSHAIR_GUI and typeof(genv.__IYP_CROSSHAIR_GUI) == "Instance" and genv.__IYP_CROSSHAIR_GUI.Parent then
        return true
    end
    local checkContainers = {
        CoreGui,
        (gethui and gethui()),
    }
    for _, c in ipairs(checkContainers) do
        if typeof(c) == "Instance" then
            if c:FindFirstChild("IYP_CrosshairGui", true) or c:FindFirstChild("IYP_Crosshair", true) then
                return true
            end
        end
    end
    return false
end

local function removeCrosshair()
    if crosshairGui and crosshairGui.Parent then
        pcall(function() crosshairGui:Destroy() end)
    end
    crosshairGui = nil
    if crosshairFrame and crosshairFrame.Parent then
        pcall(function() crosshairFrame:Destroy() end)
    end
    crosshairFrame = nil

    local checkContainers = {
        CoreGui,
        (gethui and gethui()),
    }
    for _, root in ipairs(checkContainers) do
        if typeof(root) == "Instance" then
            pcall(function()
                for _, ch in ipairs(root:GetDescendants()) do
                    if ch.Name == "IYP_CrosshairGui" or ch.Name == "IYP_Crosshair" then
                        pcall(function() ch:Destroy() end)
                    end
                end
            end)
        end
    end

    pcall(function()
        local genv = (getgenv and getgenv()) or _G
        if genv.__IYP_CROSSHAIR_GUI and typeof(genv.__IYP_CROSSHAIR_GUI) == "Instance" then
            pcall(function() genv.__IYP_CROSSHAIR_GUI:Destroy() end)
        end
        genv.__IYP_CROSSHAIR_GUI = nil
    end)
end

local function createCrosshair(color, size, gap, thickness, hasDot)
    removeCrosshair()

    color = parseColor(color) or Color3.fromRGB(0, 255, 136)
    size = tonumber(size) or 9
    gap = tonumber(gap) or 4
    thickness = tonumber(thickness) or 2
    if hasDot == nil then hasDot = true end

    local targetParent = (gethui and gethui()) or CoreGui
    local cGui = Instance.new("ScreenGui")
    cGui.Name = "IYP_CrosshairGui"
    cGui.ResetOnSpawn = false
    cGui.IgnoreGuiInset = true
    cGui.DisplayOrder = 2147483647
    pcall(function()
        if syn and syn.protect_gui and (not is_sirhurt_closure) then
            syn.protect_gui(cGui)
        end
    end)
    cGui.Parent = targetParent
    crosshairGui = cGui
    pcall(function()
        local genv = (getgenv and getgenv()) or _G
        genv.__IYP_CROSSHAIR_GUI = cGui
    end)

    local holder = Instance.new("Frame")
    holder.Name = "IYP_Crosshair"
    holder.BackgroundTransparency = 1
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Position = UDim2.new(0.5, 0, 0.5, 0)
    holder.Size = UDim2.new(0, (size + gap) * 2 + thickness, 0, (size + gap) * 2 + thickness)
    holder.ZIndex = 100

    local function mkBar(name, pos, sz)
        local bar = Instance.new("Frame")
        bar.Name = name
        bar.BackgroundColor3 = color
        bar.BorderSizePixel = 0
        bar.AnchorPoint = Vector2.new(0.5, 0.5)
        bar.Position = pos
        bar.Size = sz
        bar.ZIndex = 101
        bar.Parent = holder

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1
        stroke.Transparency = 0.25
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = bar
        return bar
    end

    if hasDot then
        local dot = mkBar("Dot", UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, thickness, 0, thickness))
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = dot
    end

    mkBar("Top", UDim2.new(0.5, 0, 0.5, -(gap + size / 2)), UDim2.new(0, thickness, 0, size))
    mkBar("Bottom", UDim2.new(0.5, 0, 0.5, gap + size / 2), UDim2.new(0, thickness, 0, size))
    mkBar("Left", UDim2.new(0.5, -(gap + size / 2), 0.5, 0), UDim2.new(0, size, 0, thickness))
    mkBar("Right", UDim2.new(0.5, gap + size / 2, 0.5, 0), UDim2.new(0, size, 0, thickness))

    holder.Parent = cGui
    crosshairFrame = holder
end

local function toggleCrosshair(color, size, gap, thickness, hasDot)
    if isCrosshairActive() and not (color or size or gap or thickness) then
        removeCrosshair()
        notify("Crosshair", "Crosshair toggled off")
    else
        createCrosshair(color, size, gap, thickness, hasDot)
        notify("Crosshair", "Crosshair enabled")
    end
end

-- Export global API
local CrosshairAPI = {
    create = createCrosshair,
    remove = removeCrosshair,
    toggle = toggleCrosshair,
    isActive = isCrosshairActive,
}

local genv = (getgenv and getgenv()) or _G
genv.Crosshair = CrosshairAPI
genv.IYP_Crosshair = CrosshairAPI
_G.Crosshair = CrosshairAPI
_G.IYP_Crosshair = CrosshairAPI

-- Hook chat commands (;ch, ;noch, ;crosshair, ;uncrosshair)
if LocalPlayer and not genv.__IYP_CROSSHAIR_CHAT_HOOKED then
    genv.__IYP_CROSSHAIR_CHAT_HOOKED = true
    LocalPlayer.Chatted:Connect(function(msg)
        local raw = tostring(msg):gsub("^%s+", ""):lower()
        if raw == ";noch" or raw == ";uncrosshair" or raw == "/noch" or raw == "/uncrosshair" then
            removeCrosshair()
            notify("Crosshair", "Crosshair disabled")
        elseif raw:match("^;ch%f[%s$]") or raw:match("^;crosshair%f[%s$]") or raw:match("^/ch%f[%s$]") or raw:match("^/crosshair%f[%s$]") then
            local parts = {}
            for w in raw:gmatch("%S+") do table.insert(parts, w) end
            table.remove(parts, 1)
            if #parts == 0 then
                toggleCrosshair()
            elseif parts[1] == "off" or parts[1] == "remove" or parts[1] == "disable" then
                removeCrosshair()
                notify("Crosshair", "Crosshair disabled")
            else
                local c, s, g, t = parts[1], parts[2], parts[3], parts[4]
                if tonumber(c) then
                    s, g, t = parts[1], parts[2], parts[3]
                    c = nil
                end
                createCrosshair(c, s, g, t, true)
                notify("Crosshair", "Crosshair enabled")
            end
        end
    end)
end

-- If executed directly without pre-existing active crosshair, toggle it on
if not isCrosshairActive() then
    createCrosshair()
    notify("Crosshair", "Crosshair enabled (center aligned)")
end

return CrosshairAPI
