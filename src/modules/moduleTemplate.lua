--[[
    Module Template - Universal template for all modules
    Copy this structure for any new module you want to create
]]

return {
    -- ============================================
    -- METADATA (Change these for your module)
    -- ============================================
    Name = "Module Name",                    -- Display name in UI
    Category = "combat",                     -- Category folder (combat, visuals, movement, utility, other)
    Description = "What this module does",   -- Description shown in tooltips
    
    -- ============================================
    -- SETTINGS (Define your module's settings here)
    -- ============================================
    Settings = {
        enabled = {
            type = "toggle",
            value = false,
            description = "Enable/disable this module"
        },
        -- Add more settings below following this format:
        -- settingName = {
        --     type = "slider" | "toggle" | "keybind" | "textInput" | "dropdown",
        --     value = defaultValue,
        --     [other properties depending on type]
        --     description = "What this setting does"
        -- }
    },
    
    -- ============================================
    -- INTERNAL STATE (Don't modify structure)
    -- ============================================
    _state = {
        isActive = false,           -- Automatically managed by framework
        updateConnection = nil,     -- Automatically managed by framework
        -- Add your custom state variables here
    },
    
    -- ============================================
    -- LIFECYCLE METHODS (Implement these)
    -- ============================================
    
    -- Called when module is first loaded
    -- Use this to initialize connections, create objects, etc.
    Initialize = function(self)
        -- Your initialization code here
    end,
    
    -- Called when user enables the module (toggles on)
    Enable = function(self)
        -- Your enable logic here
        -- Start loops, connections, etc.
    end,
    
    -- Called when user disables the module (toggles off)
    Disable = function(self)
        -- Your disable logic here
        -- Stop loops, disconnect events, etc.
    end,
    
    -- Called when script terminates
    Destroy = function(self)
        -- Cleanup code here
        -- Disconnect all connections, destroy objects
    end,
    
    -- Called every frame if module is enabled
    -- Update rate: ~60 FPS (game.Heartbeat or RunService)
    Update = function(self)
        -- Your main loop logic here
    end,
    
    -- ============================================
    -- SETTING CALLBACKS (Implement if needed)
    -- ============================================
    
    -- Called when a setting is changed by the user
    -- Parameters: settingName (string), newValue (any)
    OnSettingChanged = function(self, settingName, newValue)
        -- Handle setting changes here
        -- Example:
        -- if settingName == "range" then
        --     self.Settings.range.value = newValue
        -- elseif settingName == "speed" then
        --     self.Settings.speed.value = newValue
        -- end
    end,
}

--[[
    ============================================
    EXAMPLE MODULE STRUCTURE
    ============================================
    
    return {
        Name = "Kill Aura",
        Category = "combat",
        Description = "Automatically attack nearby enemies",
        
        Settings = {
            enabled = { type = "toggle", value = false, description = "Enable Kill Aura" },
            range = { type = "slider", value = 50, min = 10, max = 100, description = "Attack range" },
            speed = { type = "slider", value = 100, min = 0, max = 200, description = "Attack speed %" },
            keybind = { type = "keybind", value = "Q", description = "Toggle keybind" },
            teamkill = { type = "toggle", value = false, description = "Can attack teammates" },
        },
        
        _state = {
            isActive = false,
            targetPlayer = nil,
            lastAttack = 0,
        },
        
        Initialize = function(self)
            print("Kill Aura initialized")
        end,
        
        Enable = function(self)
            print("Kill Aura enabled")
            self._state.isActive = true
        end,
        
        Disable = function(self)
            print("Kill Aura disabled")
            self._state.isActive = false
        end,
        
        Destroy = function(self)
            print("Kill Aura destroyed")
        end,
        
        Update = function(self)
            -- Attack logic here
            local players = game:GetService("Players"):GetPlayers()
            -- ... rest of update logic
        end,
        
        OnSettingChanged = function(self, settingName, newValue)
            if settingName == "range" then
                self.Settings.range.value = newValue
            elseif settingName == "speed" then
                self.Settings.speed.value = newValue
            end
        end,
    }
]]
