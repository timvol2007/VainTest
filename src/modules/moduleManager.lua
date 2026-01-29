--[[
    Module Manager - Auto-discovers and manages all modules
]]

local Signal = require(script.Parent.Parent.core.signal)
local Utilities = require(script.Parent.Parent.core.utilities)

local ModuleManager = {}
ModuleManager.modules = {}
ModuleManager.categories = {}
ModuleManager.ModuleEnabled = Signal.new()
ModuleManager.ModuleDisabled = Signal.new()
ModuleManager.SettingChanged = Signal.new()

-- Load all modules from the modules folder
function ModuleManager:LoadAllModules(modulesFolder)
    self.modules = {}
    self.categories = {}
    
    -- Get all category folders
    for _, categoryFolder in ipairs(modulesFolder:GetChildren()) do
        if categoryFolder:IsA("Folder") then
            local categoryName = categoryFolder.Name
            self.categories[categoryName] = {}
            
            -- Get all module files in this category
            for _, moduleFile in ipairs(categoryFolder:GetChildren()) do
                if moduleFile:IsA("ModuleScript") then
                    local moduleName = moduleFile.Name
                    local success, moduleData = pcall(require, moduleFile)
                    
                    if success and moduleData then
                        -- Store module with full context
                        moduleData._scriptRef = moduleFile
                        moduleData._categoryName = categoryName
                        
                        -- Initialize the module
                        if moduleData.Initialize then
                            moduleData:Initialize()
                        end
                        
                        self.modules[moduleName] = moduleData
                        table.insert(self.categories[categoryName], {
                            Name = moduleData.Name or moduleName,
                            Key = moduleName,
                            Module = moduleData,
                        })
                        
                        print("[ModuleManager] Loaded module: " .. moduleName .. " (" .. categoryName .. ")")
                    else
                        warn("[ModuleManager] Failed to load module: " .. moduleName)
                    end
                end
            end
        end
    end
    
    return self.categories
end

-- Get all categories
function ModuleManager:GetCategories()
    return self.categories
end

-- Get modules in a specific category
function ModuleManager:GetCategoryModules(categoryName)
    return self.categories[categoryName] or {}
end

-- Enable a module
function ModuleManager:EnableModule(moduleName)
    local module = self.modules[moduleName]
    if not module then
        warn("[ModuleManager] Module not found: " .. moduleName)
        return false
    end
    
    if module._state.isActive then
        return true -- Already enabled
    end
    
    module._state.isActive = true
    
    if module.Enable then
        module:Enable()
    end
    
    -- Start update loop
    if module.Update then
        local RunService = game:GetService("RunService")
        module._state.updateConnection = RunService.Heartbeat:Connect(function()
            if module._state.isActive and module.Update then
                module:Update()
            end
        end)
    end
    
    self.ModuleEnabled:Fire(moduleName)
    return true
end

-- Disable a module
function ModuleManager:DisableModule(moduleName)
    local module = self.modules[moduleName]
    if not module then
        warn("[ModuleManager] Module not found: " .. moduleName)
        return false
    end
    
    if not module._state.isActive then
        return true -- Already disabled
    end
    
    module._state.isActive = false
    
    if module.Disable then
        module:Disable()
    end
    
    -- Stop update loop
    if module._state.updateConnection then
        module._state.updateConnection:Disconnect()
        module._state.updateConnection = nil
    end
    
    self.ModuleDisabled:Fire(moduleName)
    return true
end

-- Toggle a module
function ModuleManager:ToggleModule(moduleName)
    local module = self.modules[moduleName]
    if not module then return false end
    
    if module._state.isActive then
        return self:DisableModule(moduleName)
    else
        return self:EnableModule(moduleName)
    end
end

-- Update a module setting
function ModuleManager:UpdateModuleSetting(moduleName, settingName, newValue)
    local module = self.modules[moduleName]
    if not module then
        warn("[ModuleManager] Module not found: " .. moduleName)
        return false
    end
    
    if not module.Settings[settingName] then
        warn("[ModuleManager] Setting not found: " .. settingName)
        return false
    end
    
    -- Update the setting value
    module.Settings[settingName].value = newValue
    
    -- Call the callback
    if module.OnSettingChanged then
        module:OnSettingChanged(settingName, newValue)
    end
    
    self.SettingChanged:Fire(moduleName, settingName, newValue)
    return true
end

-- Get module settings
function ModuleManager:GetModuleSettings(moduleName)
    local module = self.modules[moduleName]
    if not module then return nil end
    return module.Settings
end

-- Get specific setting
function ModuleManager:GetSetting(moduleName, settingName)
    local module = self.modules[moduleName]
    if not module or not module.Settings[settingName] then
        return nil
    end
    return module.Settings[settingName].value
end

-- Check if module is enabled
function ModuleManager:IsModuleEnabled(moduleName)
    local module = self.modules[moduleName]
    if not module then return false end
    return module._state.isActive
end

-- Cleanup all modules
function ModuleManager:DestroyAll()
    for moduleName, module in pairs(self.modules) do
        if module._state.updateConnection then
            module._state.updateConnection:Disconnect()
        end
        if module.Destroy then
            module:Destroy()
        end
    end
    self.modules = {}
    self.categories = {}
end

return ModuleManager
