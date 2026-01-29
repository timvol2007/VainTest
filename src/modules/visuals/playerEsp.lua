--[[
    Player ESP Module - Visuals feature for seeing player information
]]

return {
    Name = "Player ESP",
    Category = "visuals",
    Description = "Display player information, positions, and highlights",
    
    Settings = {
        enabled = {
            type = "toggle",
            value = false,
            description = "Enable/disable Player ESP"
        },
        teamatesIncluded = {
            type = "toggle",
            value = false,
            description = "Include teammates in ESP display"
        },
        range = {
            type = "slider",
            value = 500,
            min = 50,
            max = 2000,
            description = "Maximum range to display ESP for"
        },
        highlight = {
            type = "toggle",
            value = true,
            description = "Highlight player boxes/outlines"
        },
        tracers = {
            type = "toggle",
            value = false,
            description = "Draw lines from players to center of screen"
        },
        distanceDisplay = {
            type = "toggle",
            value = true,
            description = "Show distance to each player"
        },
        teamColors = {
            type = "toggle",
            value = true,
            description = "Color ESP based on team affiliation"
        },
    },
    
    _state = {
        isActive = false,
        updateConnection = nil,
        espDrawings = {},  -- Store drawing objects
    },
    
    Initialize = function(self)
        print("[Player ESP] Module initialized")
    end,
    
    Enable = function(self)
        print("[Player ESP] Enabled")
        self._state.isActive = true
        print("[Player ESP] Range: " .. self.Settings.range.value)
        print("[Player ESP] Highlight: " .. tostring(self.Settings.highlight.value))
        print("[Player ESP] Tracers: " .. tostring(self.Settings.tracers.value))
        print("[Player ESP] Distance Display: " .. tostring(self.Settings.distanceDisplay.value))
        print("[Player ESP] Team Colors: " .. tostring(self.Settings.teamColors.value))
    end,
    
    Disable = function(self)
        print("[Player ESP] Disabled")
        self._state.isActive = false
        
        -- Clear all ESP drawings
        for _, drawing in ipairs(self._state.espDrawings) do
            if drawing and drawing.Remove then
                drawing:Remove()
            end
        end
        self._state.espDrawings = {}
    end,
    
    Destroy = function(self)
        print("[Player ESP] Destroyed")
        self._state.isActive = false
        
        -- Cleanup drawings
        for _, drawing in ipairs(self._state.espDrawings) do
            if drawing and drawing.Remove then
                drawing:Remove()
            end
        end
        self._state.espDrawings = {}
    end,
    
    Update = function(self)
        -- Placeholder update logic
        -- In actual implementation:
        -- 1. Get all players
        -- 2. Filter by range
        -- 3. Filter by team if needed
        -- 4. Draw ESP boxes, lines, text based on settings
        -- 5. Update positions each frame
    end,
    
    OnSettingChanged = function(self, settingName, newValue)
        if settingName == "teamatesIncluded" then
            self.Settings.teamatesIncluded.value = newValue
            print("[Player ESP] Teammates included: " .. tostring(newValue))
        elseif settingName == "range" then
            self.Settings.range.value = newValue
            print("[Player ESP] Range changed to: " .. newValue)
        elseif settingName == "highlight" then
            self.Settings.highlight.value = newValue
            print("[Player ESP] Highlight: " .. tostring(newValue))
        elseif settingName == "tracers" then
            self.Settings.tracers.value = newValue
            print("[Player ESP] Tracers: " .. tostring(newValue))
        elseif settingName == "distanceDisplay" then
            self.Settings.distanceDisplay.value = newValue
            print("[Player ESP] Distance display: " .. tostring(newValue))
        elseif settingName == "teamColors" then
            self.Settings.teamColors.value = newValue
            print("[Player ESP] Team colors: " .. tostring(newValue))
        end
    end,
}
