--[[
    Module Manager - Manages all framework modules
]]

local ModuleManager = {}
ModuleManager.__index = ModuleManager

local registeredModules = {}
local moduleInstances = {}

function ModuleManager.new()
    local self = setmetatable({}, ModuleManager)
    self.modules = {}
    self.categories = {}
    return self
end

function ModuleManager:RegisterModule(moduleName, category, moduleConfig)
    if not self.modules[moduleName] then
        self.modules[moduleName] = {
            Name = moduleConfig.Name or moduleName,
            Category = category,
            Settings = moduleConfig.Settings or {},
            _state = moduleConfig._state or { isActive = false },
            Initialize = moduleConfig.Initialize or function() end,
            Enable = moduleConfig.Enable or function() end,
            Disable = moduleConfig.Disable or function() end,
            Destroy = moduleConfig.Destroy or function() end,
            Update = moduleConfig.Update or function() end,
            OnSettingChanged = moduleConfig.OnSettingChanged or function() end,
        }
        
        -- Initialize category if it doesn't exist
        if not self.categories[category] then
            self.categories[category] = {}
        end
        
        -- Add to category
        table.insert(self.categories[category], moduleName)
        
        -- Call initialize
        if self.modules[moduleName].Initialize then
            self.modules[moduleName]:Initialize()
        end
        
        print("[ModuleManager] Registered module: " .. moduleName .. " in category: " .. category)
    else
        warn("[ModuleManager] Module " .. moduleName .. " already registered!")
    end
end

function ModuleManager:GetCategories()
    local result = {}
    for category, modules in pairs(self.categories) do
        result[category] = {}
        for _, moduleName in ipairs(modules) do
            result[category][moduleName] = self.modules[moduleName]
        end
    end
    return result
end

function ModuleManager:GetModule(moduleName)
    return self.modules[moduleName]
end

function ModuleManager:EnableModule(moduleName)
    local module = self.modules[moduleName]
    if module then
        module._state.isActive = true
        if module.Enable then
            module:Enable()
        end
        print("[ModuleManager] Enabled: " .. moduleName)
    else
        warn("[ModuleManager] Module not found: " .. moduleName)
    end
end

function ModuleManager:DisableModule(moduleName)
    local module = self.modules[moduleName]
    if module then
        module._state.isActive = false
        if module.Disable then
            module:Disable()
        end
        print("[ModuleManager] Disabled: " .. moduleName)
    else
        warn("[ModuleManager] Module not found: " .. moduleName)
    end
end

function ModuleManager:UpdateModuleSetting(moduleName, settingName, newValue)
    local module = self.modules[moduleName]
    if module and module.Settings[settingName] then
        module.Settings[settingName].value = newValue
        if module.OnSettingChanged then
            module:OnSettingChanged(settingName, newValue)
        end
        print("[ModuleManager] Updated " .. moduleName .. "." .. settingName .. " = " .. tostring(newValue))
    end
end

function ModuleManager:GetSetting(moduleName, settingName)
    local module = self.modules[moduleName]
    if module and module.Settings[settingName] then
        return module.Settings[settingName].value
    end
    return nil
end

function ModuleManager:DestroyAll()
    for moduleName, module in pairs(self.modules) do
        if module.Destroy then
            module:Destroy()
        end
    end
end

return ModuleManager
