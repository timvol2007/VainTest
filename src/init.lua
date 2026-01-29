--[[
    Init.lua - Bootstrap
    Loads core systems and then initializes the UI from main.lua
]]

print("[Framework] Bootstrapping...")

-- 1. Load Core Systems via your Global Loader
local Signal = LoadRemoteModule("core/signal")
local ModuleManager = LoadRemoteModule("modules/moduleManager")
local Theme = LoadRemoteModule("ui/theme")
local Animations = LoadRemoteModule("ui/animations")

-- 2. Create a new instance of ModuleManager
local moduleManagerInstance = ModuleManager.new()

-- 3. Store in Global for access by other modules
getgenv().ExploitFramework = {
    ModuleManager = moduleManagerInstance,
    Signal = Signal,
    Theme = Theme,
    Animations = Animations
}

-- 4. Register your modules (Combat, Visuals, etc.)
moduleManagerInstance:RegisterModule("aimAssist", "combat", {
    Name = "Aim Assist",
    Description = "Assists with aiming",
    Settings = {
        enabled = { type = "toggle", value = false, description = "Enable/disable" },
        smoothness = { type = "slider", value = 50, min = 0, max = 100, description = "How smooth the aim is" },
        range = { type = "slider", value = 100, min = 10, max = 500, description = "Max range in studs" },
        keybind = { type = "keybind", value = "Q", description = "Activation key" }
    },
    _state = { isActive = false },
    Initialize = function(self)
        print("[AimAssist] Initialized")
    end,
    Enable = function(self)
        print("[AimAssist] Enabled")
    end,
    Disable = function(self)
        print("[AimAssist] Disabled")
    end,
    Update = function(self)
        -- Update logic here
    end,
    OnSettingChanged = function(self, settingName, newValue)
        print("[AimAssist] " .. settingName .. " changed to " .. tostring(newValue))
    end
})

moduleManagerInstance:RegisterModule("playerESP", "visuals", {
    Name = "Player ESP",
    Description = "Display player information",
    Settings = {
        enabled = { type = "toggle", value = false, description = "Enable/disable" },
        range = { type = "slider", value = 500, min = 50, max = 2000, description = "Display range" },
        teamColor = { type = "toggle", value = true, description = "Color by team" }
    },
    _state = { isActive = false },
    Initialize = function(self)
        print("[PlayerESP] Initialized")
    end,
    Enable = function(self)
        print("[PlayerESP] Enabled")
    end,
    Disable = function(self)
        print("[PlayerESP] Disabled")
    end,
    Update = function(self)
        -- Update logic here
    end,
    OnSettingChanged = function(self, settingName, newValue)
        print("[PlayerESP] " .. settingName .. " changed to " .. tostring(newValue))
    end
})

-- 5. Initialize the UI Controller
print("[Framework] Loading UI Controller...")
local UIMain = LoadRemoteModule("ui/main")

if UIMain then
    -- Get categories from ModuleManager
    local categories = moduleManagerInstance:GetCategories()
    
    print("[Framework] Creating UI with categories:", tostring(pairs(categories)))
    
    -- Create UI instance and build the interface
    local uiInstance = UIMain
    uiInstance:CreateUI(categories)
    
    print("[Framework] UI Ready!")
else
    warn("[Framework] Failed to load UI Controller!")
end

print("[Framework] Bootstrap complete!")
