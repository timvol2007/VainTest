--[[
    Main UI Controller - Complete rewrite
    - Uses Slider, Toggle, Keybind components
    - Proper module display with working dropdowns
    - Wider landscape layout
    - Smooth animations and clean design
]]

local Theme = require(script.Parent.theme)
local Animations = require(script.Parent.animations)
local Signal = require(script.Parent.Parent.core.signal)
local ModuleManager = require(script.Parent.Parent.modules.moduleManager)

local Slider = require(script.Parent.components.slider)
local Toggle = require(script.Parent.components.toggle)
local Keybind = require(script.Parent.components.keybind)

local UIMain = {}
UIMain.modules = {}
UIMain.expandedModules = {}

function UIMain:CreateUI(moduleCategories)
    -- Create main screen gui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ExploitUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Main window frame - WIDER LANDSCAPE
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 800, 0, 480)  -- Wider: 800x480 instead of 450x600
    mainWindow.Position = UDim2.new(0.5, -400, 0.5, -240)  -- Centered
    mainWindow.BackgroundColor3 = Theme.Colors.Surface
    mainWindow.BorderSizePixel = 0
    mainWindow.Parent = screenGui
    
    -- Window corners
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, Theme.Sizes.WindowCornerRadius)
    windowCorner.Parent = mainWindow
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, Theme.Sizes.TitleBarHeight)
    titleBar.BackgroundColor3 = Theme.Colors.Elevated
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainWindow
    
    -- Title text
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
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 32, 0, 32)
    closeButton.Position = UDim2.new(1, -40, 0.5, -16)
    closeButton.BackgroundColor3 = Theme.Colors.ButtonDefault
    closeButton.TextColor3 = Theme.Colors.TextPrimary
    closeButton.TextSize = Theme.Sizes.TextSizeHeader
    closeButton.Font = Theme.Fonts.Bold
    closeButton.Text = "×"
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        mainWindow.Visible = false
    end)
    
    closeButton.MouseEnter:Connect(function()
        Animations.ColorTween(closeButton, Theme.Colors.Error, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        Animations.ColorTween(closeButton, Theme.Colors.ButtonDefault, 0.2)
    end)
    
    -- Make window draggable
    self:MakeWindowDraggable(mainWindow)
    
    -- Container for sidebar and content
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 1, -Theme.Sizes.TitleBarHeight)
    container.Position = UDim2.new(0, 0, 0, Theme.Sizes.TitleBarHeight)
    container.BackgroundTransparency = 1
    container.Parent = mainWindow
    
    -- Sidebar (categories) - NARROWER NOW
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 140, 1, 0)  -- Narrower sidebar for wider layout
    sidebar.BackgroundColor3 = Theme.Colors.Background
    sidebar.BorderSizePixel = 0
    sidebar.Parent = container
    
    -- Sidebar list
    local sidebarList = Instance.new("UIListLayout")
    sidebarList.Padding = UDim.new(0, Theme.Sizes.ItemSpacing)
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarList.Parent = sidebar
    
    -- Add padding
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, Theme.Sizes.ContentPadding)
    sidebarPadding.PaddingLeft = UDim.new(0, Theme.Sizes.ContentPadding)
    sidebarPadding.PaddingRight = UDim.new(0, Theme.Sizes.ContentPadding)
    sidebarPadding.Parent = sidebar
    
    -- Content panel
    local contentPanel = Instance.new("Frame")
    contentPanel.Name = "ContentPanel"
    contentPanel.Size = UDim2.new(1, -140, 1, 0)
    contentPanel.Position = UDim2.new(0, 140, 0, 0)
    contentPanel.BackgroundColor3 = Theme.Colors.Surface
    contentPanel.BorderSizePixel = 0
    contentPanel.Parent = container
    
    -- Content scroll frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Theme.Colors.Secondary
    scrollFrame.BottomImage = ""
    scrollFrame.TopImage = ""
    scrollFrame.MidImage = ""
    scrollFrame.Parent = contentPanel
    
    -- Content list
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, Theme.Sizes.ItemSpacing)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = scrollFrame
    
    -- Content padding
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, Theme.Sizes.ContentPadding)
    contentPadding.PaddingLeft = UDim.new(0, Theme.Sizes.ContentPadding)
    contentPadding.PaddingRight = UDim.new(0, Theme.Sizes.ContentPadding)
    contentPadding.PaddingBottom = UDim.new(0, Theme.Sizes.ContentPadding)
    contentPadding.Parent = scrollFrame
    
    -- Store state
    self.screenGui = screenGui
    self.mainWindow = mainWindow
    self.sidebar = sidebar
    self.contentPanel = contentPanel
    self.scrollFrame = scrollFrame
    self.contentList = contentList
    self.activeCategory = nil
    self.categoryButtons = {}
    self.contentFrames = {}
    
    -- Create categories and modules
    self:CreateCategories(moduleCategories)
    
    -- Start with first category
    local firstCategory = next(moduleCategories)
    if firstCategory then
        self:SelectCategory(firstCategory)
    end
    
    return screenGui
end

function UIMain:CreateCategories(moduleCategories)
    local layoutOrder = 0
    
    -- Create category buttons
    for categoryName, modules in pairs(moduleCategories) do
        layoutOrder = layoutOrder + 1
        self:CreateCategoryButton(categoryName, modules, layoutOrder)
    end
    
    -- Add settings category
    layoutOrder = layoutOrder + 1
    self:CreateSettingsCategory(layoutOrder)
end

function UIMain:CreateCategoryButton(categoryName, modules, layoutOrder)
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
    
    -- Hover effects
    categoryBtn.MouseEnter:Connect(function()
        if self.activeCategory ~= categoryName then
            Animations.ColorTween(categoryBtn, Theme.Colors.ButtonHover, 0.15)
        end
    end)
    
    categoryBtn.MouseLeave:Connect(function()
        if self.activeCategory ~= categoryName then
            Animations.ColorTween(categoryBtn, Theme.Colors.ButtonDefault, 0.15)
        end
    end)
    
    categoryBtn.MouseButton1Click:Connect(function()
        self:SelectCategory(categoryName)
    end)
    
    self.categoryButtons[categoryName] = categoryBtn
    
    -- Create content frame for this category
    self:CreateCategoryContent(categoryName, modules)
end

function UIMain:CreateCategoryContent(categoryName, modules)
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content_" .. categoryName
    contentFrame.Size = UDim2.new(1, 0, 0, 100)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = self.scrollFrame
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, Theme.Sizes.ItemSpacing)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = contentFrame
    
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.Size = UDim2.new(1, 0, 0, contentList.AbsoluteContentSize.Y)
    end)
    
    -- Add modules to this category
    for index, moduleData in ipairs(modules) do
        self:CreateModuleUI(contentFrame, moduleData, index)
    end
    
    self.contentFrames[categoryName] = contentFrame
end

function UIMain:CreateModuleUI(parent, moduleData, layoutOrder)
    local moduleName = moduleData.Key
    local module = moduleData.Module
    
    -- Module container
    local moduleContainer = Instance.new("Frame")
    moduleContainer.Name = "Module_" .. moduleName
    moduleContainer.Size = UDim2.new(1, 0, 0, Theme.Sizes.ModuleHeight)
    moduleContainer.LayoutOrder = layoutOrder
    moduleContainer.BackgroundColor3 = Theme.Colors.Elevated
    moduleContainer.BorderSizePixel = 0
    moduleContainer.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = moduleContainer
    
    -- Module name button (togglable)
    local moduleBtn = Instance.new("TextButton")
    moduleBtn.Name = "ModuleButton"
    moduleBtn.Size = UDim2.new(0.85, 0, 1, 0)
    moduleBtn.BackgroundTransparency = 1
    moduleBtn.Text = moduleData.Name
    moduleBtn.TextColor3 = Theme.Colors.TextPrimary
    moduleBtn.TextSize = Theme.Sizes.TextSizeHeader
    moduleBtn.Font = Theme.Fonts.Bold
    moduleBtn.TextXAlignment = Enum.TextXAlignment.Left
    moduleBtn.Parent = moduleContainer
    
    -- Dropdown arrow button
    local arrowBtn = Instance.new("TextButton")
    arrowBtn.Name = "ArrowButton"
    arrowBtn.Size = UDim2.new(0.15, 0, 1, 0)
    arrowBtn.Position = UDim2.new(0.85, 0, 0, 0)
    arrowBtn.BackgroundTransparency = 1
    arrowBtn.Text = "▼"
    arrowBtn.TextColor3 = Theme.Colors.Primary
    arrowBtn.TextSize = Theme.Sizes.TextSizeNormal
    arrowBtn.Font = Theme.Fonts.Bold
    arrowBtn.Parent = moduleContainer
    
    -- Toggle state
    local isExpanded = false
    
    -- Module toggle (on module button click) - Toggle the module on/off
    moduleBtn.MouseButton1Click:Connect(function()
        ModuleManager:ToggleModule(moduleName)
        local isEnabled = ModuleManager:IsModuleEnabled(moduleName)
        
        -- Update visual feedback
        if isEnabled then
            Animations.ColorTween(moduleContainer, Theme.Colors.Primary, 0.2)
        else
            Animations.ColorTween(moduleContainer, Theme.Colors.Elevated, 0.2)
        end
    end)
    
    -- Hover effects
    moduleContainer.MouseEnter:Connect(function()
        if not ModuleManager:IsModuleEnabled(moduleName) then
            Animations.ColorTween(moduleContainer, Theme.Colors.ButtonHover, 0.15)
        end
    end)
    
    moduleContainer.MouseLeave:Connect(function()
        if not ModuleManager:IsModuleEnabled(moduleName) then
            Animations.ColorTween(moduleContainer, Theme.Colors.Elevated, 0.15)
        end
    end)
    
    -- Expand/collapse settings on arrow click
    arrowBtn.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        
        if isExpanded then
            self:CreateDropdownSettings(moduleContainer, module, moduleName)
            Animations.Tween(arrowBtn, {Rotation = 180}, 0.2)
        else
            -- Remove existing dropdown
            local dropdown = moduleContainer.Parent:FindFirstChild("Dropdown_" .. moduleName)
            if dropdown then
                dropdown:Destroy()
            end
            Animations.Tween(arrowBtn, {Rotation = 0}, 0.2)
        end
    end)
    
    -- Store for tracking
    self.modules[moduleName] = {
        container = moduleContainer,
        expanded = false
    }
end

function UIMain:CreateDropdownSettings(moduleContainer, module, moduleName)
    -- Get parent container for proper sizing
    local parentContainer = moduleContainer.Parent
    
    -- Create dropdown container below module
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = "Dropdown_" .. moduleName
    dropdownContainer.Size = UDim2.new(1, 0, 0, 50)  -- Start small, will expand
    dropdownContainer.Position = UDim2.new(0, 0, 1, Theme.Sizes.ItemSpacing)
    dropdownContainer.BackgroundColor3 = Theme.Colors.Background
    dropdownContainer.BorderSizePixel = 0
    dropdownContainer.ClipsDescendants = true
    dropdownContainer.Parent = parentContainer
    
    -- Dropdown content scroll
    local dropdownScroll = Instance.new("ScrollingFrame")
    dropdownScroll.Name = "DropdownScroll"
    dropdownScroll.Size = UDim2.new(1, 0, 1, 0)
    dropdownScroll.BackgroundTransparency = 1
    dropdownScroll.ScrollBarThickness = 4
    dropdownScroll.ScrollBarImageColor3 = Theme.Colors.Secondary
    dropdownScroll.BottomImage = ""
    dropdownScroll.TopImage = ""
    dropdownScroll.MidImage = ""
    dropdownScroll.Parent = dropdownContainer
    
    -- Settings list
    local settingsList = Instance.new("UIListLayout")
    settingsList.Padding = UDim.new(0, 8)
    settingsList.SortOrder = Enum.SortOrder.LayoutOrder
    settingsList.Parent = dropdownScroll
    
    -- Padding
    local settingsPadding = Instance.new("UIPadding")
    settingsPadding.PaddingTop = UDim.new(0, 10)
    settingsPadding.PaddingLeft = UDim.new(0, 15)
    settingsPadding.PaddingRight = UDim.new(0, 15)
    settingsPadding.PaddingBottom = UDim.new(0, 10)
    settingsPadding.Parent = dropdownScroll
    
    -- Create UI for each setting (SKIP "enabled" as that's the main toggle)
    local settingIndex = 0
    for settingName, settingConfig in pairs(module.Settings) do
        if settingName ~= "enabled" then
            settingIndex = settingIndex + 1
            self:CreateSettingComponent(dropdownScroll, moduleName, settingName, settingConfig, settingIndex)
        end
    end
    
    -- Update dropdown size based on content
    settingsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local newHeight = settingsList.AbsoluteContentSize.Y + 20
        dropdownContainer.Size = UDim2.new(1, 0, 0, newHeight)
    end)
end

function UIMain:CreateSettingComponent(parent, moduleName, settingName, settingConfig, layoutOrder)
    local settingType = settingConfig.type
    
    if settingType == "slider" then
        local slider = Slider.new(parent, settingConfig.min, settingConfig.max, settingConfig.value, settingName, settingConfig.description)
        slider.Container.LayoutOrder = layoutOrder
        slider.ValueChanged:Connect(function(newValue)
            ModuleManager:UpdateModuleSetting(moduleName, settingName, newValue)
        end)
    elseif settingType == "toggle" then
        local toggle = Toggle.new(parent, settingConfig.value, settingName, settingConfig.description)
        toggle.Container.LayoutOrder = layoutOrder
        toggle.ValueChanged:Connect(function(newValue)
            ModuleManager:UpdateModuleSetting(moduleName, settingName, newValue)
        end)
    elseif settingType == "keybind" then
        local keybind = Keybind.new(parent, settingConfig.value, settingName, settingConfig.description)
        keybind.Container.LayoutOrder = layoutOrder
        keybind.KeyChanged:Connect(function(newValue)
            ModuleManager:UpdateModuleSetting(moduleName, settingName, newValue)
        end)
    end
end

function UIMain:CreateSettingsCategory(layoutOrder)
    local settingsBtn = Instance.new("TextButton")
    settingsBtn.Name = "settings"
    settingsBtn.Size = UDim2.new(1, 0, 0, Theme.Sizes.ButtonHeight)
    settingsBtn.LayoutOrder = layoutOrder
    settingsBtn.BackgroundColor3 = Theme.Colors.ButtonDefault
    settingsBtn.TextColor3 = Theme.Colors.TextPrimary
    settingsBtn.TextSize = Theme.Sizes.TextSizeNormal
    settingsBtn.Font = Theme.Fonts.Default
    settingsBtn.Text = "⚙️ Settings"
    settingsBtn.BorderSizePixel = 0
    settingsBtn.Parent = self.sidebar
    
    local settingsCorner = Instance.new("UICorner")
    settingsCorner.CornerRadius = UDim.new(0, 6)
    settingsCorner.Parent = settingsBtn
    
    settingsBtn.MouseEnter:Connect(function()
        if self.activeCategory ~= "settings" then
            Animations.ColorTween(settingsBtn, Theme.Colors.ButtonHover, 0.15)
        end
    end)
    
    settingsBtn.MouseLeave:Connect(function()
        if self.activeCategory ~= "settings" then
            Animations.ColorTween(settingsBtn, Theme.Colors.ButtonDefault, 0.15)
        end
    end)
    
    settingsBtn.MouseButton1Click:Connect(function()
        self:SelectCategory("settings")
    end)
    
    self.categoryButtons["settings"] = settingsBtn
    
    -- Create settings content
    local settingsContent = Instance.new("Frame")
    settingsContent.Name = "Content_settings"
    settingsContent.Size = UDim2.new(1, 0, 0, 100)
    settingsContent.BackgroundTransparency = 1
    settingsContent.Visible = false
    settingsContent.Parent = self.scrollFrame
    
    local settingsContentList = Instance.new("UIListLayout")
    settingsContentList.Padding = UDim.new(0, Theme.Sizes.ItemSpacing)
    settingsContentList.SortOrder = Enum.SortOrder.LayoutOrder
    settingsContentList.Parent = settingsContent
    
    settingsContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        settingsContent.Size = UDim2.new(1, 0, 0, settingsContentList.AbsoluteContentSize.Y)
    end)
    
    -- Add settings options using components
    local uiScaleSlider = Slider.new(settingsContent, 0.5, 2, 1, "UI Scale", "Adjust the size of the UI")
    local animSpeedSlider = Slider.new(settingsContent, 0.1, 1, 0.3, "Animation Speed", "Adjust animation speed")
    
    self.contentFrames["settings"] = settingsContent
end

function UIMain:SelectCategory(categoryName)
    -- Hide all content frames
    for _, contentFrame in pairs(self.contentFrames) do
        contentFrame.Visible = false
    end
    
    -- Reset all buttons
    for catName, btn in pairs(self.categoryButtons) do
        if catName ~= categoryName then
            Animations.ColorTween(btn, Theme.Colors.ButtonDefault, 0.15)
        end
    end
    
    -- Show selected content
    if self.contentFrames[categoryName] then
        self.contentFrames[categoryName].Visible = true
    end
    
    -- Highlight selected button
    if self.categoryButtons[categoryName] then
        Animations.ColorTween(self.categoryButtons[categoryName], Theme.Colors.Primary, 0.15)
    end
    
    self.activeCategory = categoryName
end

function UIMain:MakeWindowDraggable(window)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    window.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = game:GetService("Mouse").X
            startPos = window.Position
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input, gameProcessed)
        if dragging and dragStart then
            local currentMouse = game:GetService("Mouse").X
            local delta = currentMouse - dragStart
            window.Position = startPos + UDim2.new(0, delta, 0, 0)
        end
    end)
end

return UIMain
