--[[
    Init.lua - Initializes the entire exploit framework
    Sets up all systems and creates the UI
]]

print("[Framework] Initializing...")

-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Load core systems
print("[Framework] Loading core systems...")
local Signal = script.parent.core.signal.lua
--local Signal = require(game:GetService("ServerScriptService"):FindFirstChild("signal") or error("signal module not found"))

-- Note: In a real setup, you'd be loading from actual ModuleScripts in the game
-- For this framework, we'll create the necessary modules in memory

-- Create in-memory modules table
local Modules = {}

-- Signal module (fallback if not found)
if not Signal then
    Signal = {}
    Signal.__index = Signal
    
    function Signal.new()
        local self = setmetatable({}, Signal)
        self._connections = {}
        return self
    end
    
    function Signal:Connect(callback)
        local connection = {
            _callback = callback,
            _signal = self,
            Connected = true
        }
        
        function connection:Disconnect()
            self.Connected = false
            for i, conn in ipairs(self._signal._connections) do
                if conn == self then
                    table.remove(self._signal._connections, i)
                    break
                end
            end
        end
        
        table.insert(self._connections, connection)
        return connection
    end
    
    function Signal:Fire(...)
        for _, connection in ipairs(self._connections) do
            if connection.Connected then
                task.spawn(connection._callback, ...)
            end
        end
    end
    
    function Signal:Wait()
        local thread = coroutine.running()
        local connection
        connection = self:Connect(function(...)
            connection:Disconnect()
            task.spawn(thread, ...)
        end)
        return coroutine.yield()
    end
end

-- Utilities module (inline)
local Utilities = {}

function Utilities.TableClone(t)
    local clone = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            clone[k] = Utilities.TableClone(v)
        else
            clone[k] = v
        end
    end
    return clone
end

function Utilities.Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

function Utilities.GetKeyName(keyCode)
    local keyNames = {
        [Enum.KeyCode.Q] = "Q",
        [Enum.KeyCode.W] = "W",
        [Enum.KeyCode.E] = "E",
        [Enum.KeyCode.R] = "R",
        [Enum.KeyCode.Space] = "Space",
        [Enum.KeyCode.Tab] = "Tab",
    }
    return keyNames[keyCode] or tostring(keyCode):split(".")[3] or "Unknown"
end

function Utilities.DetectExecutor()
    if syn then return "Synapse" end
    if secure_call then return "Script-Ware" end
    if KRNL_LOADED then return "Krnl" end
    return "Unknown"
end

function Utilities.ReadFile(path)
    if readfile then
        return pcall(readfile, path)
    end
    return false, "readfile not available"
end

function Utilities.WriteFile(path, content)
    if writefile then
        return pcall(writefile, path, content)
    end
    return false, "writefile not available"
end

function Utilities.FileExists(path)
    if isfile then
        return isfile(path)
    end
    return false
end

-- Theme module (inline)
local Theme = {
    Colors = {
        Background = Color3.fromRGB(15, 15, 20),
        Surface = Color3.fromRGB(25, 25, 35),
        Elevated = Color3.fromRGB(35, 35, 50),
        Primary = Color3.fromRGB(66, 135, 245),
        Secondary = Color3.fromRGB(100, 100, 120),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(160, 160, 180),
        TextMuted = Color3.fromRGB(100, 100, 120),
        ButtonDefault = Color3.fromRGB(35, 35, 50),
        ButtonHover = Color3.fromRGB(45, 45, 65),
        ButtonActive = Color3.fromRGB(66, 135, 245),
        SliderTrack = Color3.fromRGB(45, 45, 65),
        SliderThumb = Color3.fromRGB(66, 135, 245),
        ToggleOff = Color3.fromRGB(45, 45, 65),
        ToggleOn = Color3.fromRGB(66, 135, 245),
    },
    Sizes = {
        WindowWidth = 450,
        WindowHeight = 600,
        WindowCornerRadius = 12,
        TitleBarHeight = 40,
        SidebarWidth = 120,
        ContentPadding = 15,
        ModuleHeight = 50,
        SettingItemHeight = 45,
        ButtonHeight = 35,
        SliderHeight = 25,
        ToggleSize = 24,
        TextSizeTitle = 18,
        TextSizeHeader = 14,
        TextSizeNormal = 12,
        TextSizeSmall = 11,
        ItemSpacing = 8,
        SectionSpacing = 15,
    },
    Transparency = {
        Opaque = 0,
        Slight = 0.05,
        Light = 0.1,
        Medium = 0.2,
        Heavy = 0.3,
    },
    AnimationSpeeds = {
        Instant = 0.1,
        Fast = 0.2,
        Normal = 0.3,
        Slow = 0.5,
    },
    Fonts = {
        Default = Enum.Font.GothamSSm,
        Bold = Enum.Font.GothamBold,
        Mono = Enum.Font.RobotoMono,
    },
}

-- Module Manager (inline for now)
local ModuleManager = {}
ModuleManager.modules = {}
ModuleManager.categories = {}
ModuleManager.ModuleEnabled = Signal.new()
ModuleManager.ModuleDisabled = Signal.new()
ModuleManager.SettingChanged = Signal.new()

function ModuleManager:RegisterModule(moduleName, categoryName, moduleData)
    moduleData._categoryName = categoryName
    self.modules[moduleName] = moduleData
    
    if not self.categories[categoryName] then
        self.categories[categoryName] = {}
    end
    
    table.insert(self.categories[categoryName], {
        Name = moduleData.Name,
        Key = moduleName,
        Module = moduleData,
    })
    
    if moduleData.Initialize then
        moduleData:Initialize()
    end
    
    print("[ModuleManager] Registered: " .. moduleName .. " (" .. categoryName .. ")")
end

function ModuleManager:GetCategories()
    return self.categories
end

function ModuleManager:EnableModule(moduleName)
    local module = self.modules[moduleName]
    if not module or module._state.isActive then return false end
    
    module._state.isActive = true
    if module.Enable then module:Enable() end
    
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

function ModuleManager:DisableModule(moduleName)
    local module = self.modules[moduleName]
    if not module or not module._state.isActive then return false end
    
    module._state.isActive = false
    if module.Disable then module:Disable() end
    
    if module._state.updateConnection then
        module._state.updateConnection:Disconnect()
        module._state.updateConnection = nil
    end
    
    self.ModuleDisabled:Fire(moduleName)
    return true
end

function ModuleManager:ToggleModule(moduleName)
    local module = self.modules[moduleName]
    if not module then return false end
    
    if module._state.isActive then
        return self:DisableModule(moduleName)
    else
        return self:EnableModule(moduleName)
    end
end

function ModuleManager:UpdateModuleSetting(moduleName, settingName, newValue)
    local module = self.modules[moduleName]
    if not module or not module.Settings[settingName] then return false end
    
    module.Settings[settingName].value = newValue
    
    if module.OnSettingChanged then
        module:OnSettingChanged(settingName, newValue)
    end
    
    self.SettingChanged:Fire(moduleName, settingName, newValue)
    return true
end

function ModuleManager:IsModuleEnabled(moduleName)
    local module = self.modules[moduleName]
    return module and module._state.isActive or false
end

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

print("[Framework] Executor: " .. Utilities.DetectExecutor())

-- Register sample modules
print("[Framework] Registering modules...")

-- Aim Assist module
ModuleManager:RegisterModule("aimAssist", "combat", {
    Name = "Aim Assist",
    Category = "combat",
    Description = "Smoothly assist your aim",
    Settings = {
        enabled = { type = "toggle", value = false, description = "Enable/disable" },
        smoothness = { type = "slider", value = 50, min = 0, max = 100, description = "How smooth" },
        range = { type = "slider", value = 100, min = 10, max = 500, description = "Range" },
        keybind = { type = "keybind", value = "Q", description = "Toggle key" },
        angle = { type = "slider", value = 30, min = 0, max = 90, description = "Max angle" },
    },
    _state = { isActive = false },
    Initialize = function(self) print("[Aim Assist] Initialized") end,
    Enable = function(self) print("[Aim Assist] Enabled") end,
    Disable = function(self) print("[Aim Assist] Disabled") end,
    Destroy = function(self) end,
    Update = function(self) end,
    OnSettingChanged = function(self, settingName, newValue) print("[Aim Assist] " .. settingName .. " = " .. tostring(newValue)) end,
})

-- Player ESP module
ModuleManager:RegisterModule("playerEsp", "visuals", {
    Name = "Player ESP",
    Category = "visuals",
    Description = "Display player information",
    Settings = {
        enabled = { type = "toggle", value = false, description = "Enable/disable" },
        teamatesIncluded = { type = "toggle", value = false, description = "Include teammates" },
        range = { type = "slider", value = 500, min = 50, max = 2000, description = "Range" },
        highlight = { type = "toggle", value = true, description = "Highlight boxes" },
        tracers = { type = "toggle", value = false, description = "Draw tracers" },
        distanceDisplay = { type = "toggle", value = true, description = "Show distance" },
        teamColors = { type = "toggle", value = true, description = "Team colors" },
    },
    _state = { isActive = false },
    Initialize = function(self) print("[Player ESP] Initialized") end,
    Enable = function(self) print("[Player ESP] Enabled") end,
    Disable = function(self) print("[Player ESP] Disabled") end,
    Destroy = function(self) end,
    Update = function(self) end,
    OnSettingChanged = function(self, settingName, newValue) print("[Player ESP] " .. settingName .. " = " .. tostring(newValue)) end,
})

print("[Framework] Creating UI...")

-- Create UI inline (simplified version)
local UIMain = {}

function UIMain:CreateUI(moduleCategories)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ExploitUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local parent = game:GetService("CoreGui")
    screenGui.Parent = parent
    
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, Theme.Sizes.WindowWidth, 0, Theme.Sizes.WindowHeight)
    mainWindow.Position = UDim2.new(0.5, -Theme.Sizes.WindowWidth / 2, 0.5, -Theme.Sizes.WindowHeight / 2)
    mainWindow.BackgroundColor3 = Theme.Colors.Surface
    mainWindow.BorderSizePixel = 0
    mainWindow.Parent = screenGui
    
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, Theme.Sizes.WindowCornerRadius)
    windowCorner.Parent = mainWindow
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, Theme.Sizes.TitleBarHeight)
    titleBar.BackgroundColor3 = Theme.Colors.Elevated
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainWindow
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Exploit Framework"
    titleText.TextColor3 = Theme.Colors.TextPrimary
    titleText.TextSize = Theme.Sizes.TextSizeTitle
    titleText.Font = Theme.Fonts.Bold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.TextYAlignment = Enum.TextYAlignment.Center
    titleText.Parent = titleBar
    
    -- Container
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 1, -Theme.Sizes.TitleBarHeight)
    container.Position = UDim2.new(0, 0, 0, Theme.Sizes.TitleBarHeight)
    container.BackgroundTransparency = 1
    container.Parent = mainWindow
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, Theme.Sizes.SidebarWidth, 1, 0)
    sidebar.BackgroundColor3 = Theme.Colors.Background
    sidebar.BorderSizePixel = 0
    sidebar.Parent = container
    
    local sidebarList = Instance.new("UIListLayout")
    sidebarList.Padding = UDim.new(0, Theme.Sizes.ItemSpacing)
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarList.Parent = sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, Theme.Sizes.ContentPadding)
    sidebarPadding.PaddingLeft = UDim.new(0, Theme.Sizes.ContentPadding)
    sidebarPadding.Parent = sidebar
    
    -- Content Panel
    local contentPanel = Instance.new("Frame")
    contentPanel.Name = "ContentPanel"
    contentPanel.Size = UDim2.new(1, -Theme.Sizes.SidebarWidth, 1, 0)
    contentPanel.Position = UDim2.new(0, Theme.Sizes.SidebarWidth, 0, 0)
    contentPanel.BackgroundColor3 = Theme.Colors.Surface
    contentPanel.BorderSizePixel = 0
    contentPanel.Parent = container
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Theme.Colors.Secondary
    scrollFrame.Parent = contentPanel
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, Theme.Sizes.ItemSpacing)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = scrollFrame
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, Theme.Sizes.ContentPadding)
    contentPadding.PaddingLeft = UDim.new(0, Theme.Sizes.ContentPadding)
    contentPadding.PaddingRight = UDim.new(0, Theme.Sizes.ContentPadding)
    contentPadding.Parent = scrollFrame
    
    self.screenGui = screenGui
    self.mainWindow = mainWindow
    self.sidebar = sidebar
    self.contentPanel = contentPanel
    self.scrollFrame = scrollFrame
    self.contentList = contentList
    self.activeCategory = nil
    self.categoryButtons = {}
    self.contentFrames = {}
    
    -- Create categories
    self:CreateCategoriesSimple(moduleCategories)
    
    print("[Framework] UI Created successfully!")
    return screenGui
end

function UIMain:CreateCategoriesSimple(moduleCategories)
    local layoutOrder = 0
    
    for categoryName, modules in pairs(moduleCategories) do
        layoutOrder = layoutOrder + 1
        
        local categoryBtn = Instance.new("TextButton")
        categoryBtn.Name = categoryName
        categoryBtn.Size = UDim2.new(1, 0, 0, Theme.Sizes.ButtonHeight)
        categoryBtn.LayoutOrder = layoutOrder
        categoryBtn.BackgroundColor3 = Theme.Colors.ButtonDefault
        categoryBtn.TextColor3 = Theme.Colors.TextPrimary
        categoryBtn.TextSize = Theme.Sizes.TextSizeNormal
        categoryBtn.Font = Theme.Fonts.Default
        categoryBtn.Text = string.upper(categoryName:sub(1, 1)) .. categoryName:sub(2)
        categoryBtn.BorderSizePixel = 0
        categoryBtn.Parent = self.sidebar
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = categoryBtn
        
        self.categoryButtons[categoryName] = categoryBtn
        
        categoryBtn.MouseButton1Click:Connect(function()
            self:SelectCategorySimple(categoryName)
        end)
    end
end

function UIMain:SelectCategorySimple(categoryName)
    for catName, btn in pairs(self.categoryButtons) do
        if catName == categoryName then
            btn.BackgroundColor3 = Theme.Colors.Primary
        else
            btn.BackgroundColor3 = Theme.Colors.ButtonDefault
        end
    end
    
    self.activeCategory = categoryName
    print("[UI] Selected category: " .. categoryName)
end

-- Create and show UI
local uiMain = UIMain:new()
local categories = ModuleManager:GetCategories()
local screenGui = UIMain:CreateUI(categories)

print("[Framework] Framework loaded successfully!")
print("[Framework] Type 'print(_G.ExploitFramework)' to access the framework")

-- Store in global for access
_G.ExploitFramework = {
    ModuleManager = ModuleManager,
    Theme = Theme,
    Utilities = Utilities,
}

print("[Framework] Ready!")
