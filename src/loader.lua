getgenv().REPO_URL = "https://raw.githubusercontent.com/timvol2007/VainTest/main/src"

getgenv().LoadRemoteModule = function(modulePath)
    local url = getgenv().REPO_URL .. "/" .. modulePath .. ".lua"
    local success, result = pcall(game.HttpGet, game, url)
    
    if success then
        local chunk, loadErr = loadstring(result)
        if not chunk then
            warn("[Loader] Syntax error in " .. modulePath .. ": " .. loadErr)
            return nil
        end
        -- Execute the chunk and return the result (usually a table)
        return chunk() 
    else
        warn("[Loader] Failed to fetch " .. modulePath)
        return nil
    end
end

print("[Loader] Loading exploit framework...")
-- Use the global function to start init.lua
LoadRemoteModule("init")
