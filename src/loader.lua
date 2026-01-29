--[[
    Loader.lua - Entry point for the exploit framework
    Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/user/repo/main/src/loader.lua"))()
]]

-- GitHub repository base URL (change this to your repo)
local REPO_URL = "https://raw.githubusercontent.com/[USER]/[REPO]/main/src"

-- Function to safely load remote modules
local function LoadRemoteModule(modulePath)
    local url = REPO_URL .. "/" .. modulePath .. ".lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        local chunk, loadErr = loadstring(result)
        if not chunk then
            warn("[Loader] Failed to load " .. modulePath .. ": " .. loadErr)
            return nil
        end
        return chunk
    else
        warn("[Loader] Failed to fetch " .. modulePath .. ": " .. result)
        return nil
    end
end

-- Load and execute init.lua
print("[Loader] Loading exploit framework...")
local initModule = LoadRemoteModule("init")

if initModule then
    local success, err = pcall(initModule)
    if success then
        print("[Loader] Framework loaded successfully!")
    else
        warn("[Loader] Error executing framework: " .. err)
    end
else
    warn("[Loader] Failed to load init module!")
end
