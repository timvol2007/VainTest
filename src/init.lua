--[[
    Init.lua - Bootstrap
    Loads core systems and then initializes the UI from main.lua
]]

print("[Framework] Bootstrapping...")

-- 1. Load Core Systems via your Global Loader
local Signal = LoadRemoteModule("core/signal")
local ModuleManager = LoadRemoteModule("modules/moduleManager")
local Theme = LoadRemoteModule("ui/theme")

-- 2. Store in Global for access by other modules
getgenv().ExploitFramework = {
    ModuleManager = ModuleManager,
    Signal = Signal,
    Theme = Theme
}

-- 3. Register your modules (Combat, Visuals, etc.)
-- You can load these from GitHub as well if they are separate files
ModuleManager:RegisterModule("aimAssist", "combat", {
    Name = "Aim Assist",
    Settings = {
        enabled = { type = "toggle", value = false },
        smoothness = { type = "slider", value = 50, min = 0, max = 100 }
    },
    _state = { isActive = false }
})

-- 4. Initialize the UI Controller
print("[Framework] Loading UI Controller...")
local UIMain = LoadRemoteModule("ui/main")

if UIMain then
    -- Since your main.lua returns a table with methods, 
    -- and you likely need an instance:
    local categories = ModuleManager:GetCategories()
    
    -- Check if your main.lua has a .new() or just use the table
    local uiInstance = (UIMain.new and UIMain.new()) or UIMain
    uiInstance:CreateUI(categories)
    
    print("[Framework] UI Ready!")
else
    warn("[Framework] Failed to load UI Controller!")
end
