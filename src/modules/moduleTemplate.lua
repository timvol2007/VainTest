-- Universal template that all modules inherit from
return {
    -- Module metadata
    Name = "Module Name",
    Category = "Category",
    Description = "What this module does",
    
    -- Settings structure
    Settings = {
        enabled = { type = "toggle", value = false, description = "Enable this module" },
        keybind = { type = "keybind", value = "Q", description = "Activation key" },
        range = { type = "slider", value = 50, min = 10, max = 100, description = "Range" },
    },
    
    -- Module state (private)
    _state = {
        isActive = false,
        -- Custom state here
    },
    
    -- Lifecycle methods
    Initialize = function(self) end,
    Enable = function(self) end,
    Disable = function(self) end,
    Destroy = function(self) end,
    
    -- Placeholder main loop
    Update = function(self) end,
    
    -- Handle setting changes
    OnSettingChanged = function(self, settingName, newValue) end,
}
