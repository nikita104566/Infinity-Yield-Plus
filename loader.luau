--[[
    Infinity Yield Plus — Smart Universal Loader
    https://github.com/nikita104566/Infinity-Yield-Plus
    
    Tries local dev server first (instant load from disk),
    falls back to GitHub raw if local server is offline.
]]--

local LOCAL_URL = "http://127.0.0.1:8765/source"
local GITHUB_URL = "https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/source"

local function fetch(url)
    local getter = (game and game.HttpGet and function(u) return game:HttpGet(u) end) 
        or (type(httpget) == "function" and httpget)
        or (type(http_request) == "function" and function(u) return http_request({Url = u, Method = "GET"}).Body end)
        or (type(request) == "function" and function(u) return request({Url = u, Method = "GET"}).Body end)
    if not getter then return nil end
    local ok, res = pcall(getter, url)
    if ok and type(res) == "string" and #res > 5000 then
        return res
    end
    return nil
end

local code

-- 1. Try local workspace file if present
pcall(function()
    if isfile and isfile("source") then
        local ok, data = pcall(readfile, "source")
        if ok and type(data) == "string" and #data > 5000 then
            code = data
        end
    end
end)

-- 2. Try local dev HTTP server (http://127.0.0.1:8765/source)
if not code then
    code = fetch(LOCAL_URL)
end

-- 3. Fallback to GitHub raw
if not code then
    code = fetch(GITHUB_URL)
end

if code then
    local fn, err = loadstring(code)
    if fn then
        fn()
    else
        warn("[IYP Loader] Compilation error:", err)
    end
else
    warn("[IYP Loader] Failed to fetch source from local server and GitHub.")
end
