--[[
    Toggle Component - Toggle switch with smooth animation
]]

local Animations = LoadRemoteModule("ui/animations")
local Theme = LoadRemoteModule("ui/theme")
local Utilities = LoadRemoteModule("core/utilities")
local Signal = LoadRemoteModule("core/signal")

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, isEnabled, label, description)
    local self = setmetatable({}, Toggle)
    
    self.IsEnabled = isEnabled
    self.Label = label
    self.Description = description
    
    self.ValueChanged = Signal.new()
    
    self:_CreateUI(parent)
    
    return self
end

function Toggle:_CreateUI(parent)
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "ToggleContainer"
    self.Container.Size = UDim2.new(1, -15, 0, Theme.Sizes.SettingItemHeight)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = parent
    
    -- Label
    local labelText = Instance.new("TextLabel")
    labelText.Name = "Label"
    labelText.Size = UDim2.new(0.7, 0, 0, 20)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = self.Label
    labelText.TextColor3 = Theme.Colors.TextPrimary
    labelText.TextSize = Theme.Sizes.TextSizeNormal
    labelText.Font = Theme.Fonts.Default
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = self.Container
    
    -- Toggle background
    local toggleBg = Instance.new("Frame")
    toggleBg.Name = "ToggleBG"
    toggleBg.Size = UDim2.new(0, 50, 0, 28)
    toggleBg.Position = UDim2.new(1, -60, 0, 8)
    toggleBg.BackgroundColor3 = self.IsEnabled and Theme.Colors.ToggleOn or Theme.Colors.ToggleOff
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = self.Container
    
    -- Toggle corners
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 14)
    toggleCorner.Parent = toggleBg
    
    -- Toggle thumb
    local toggleThumb = Instance.new("Frame")
    toggleThumb.Name = "ToggleThumb"
    toggleThumb.Size = UDim2.new(0, 22, 0, 22)
    toggleThumb.Position = self.IsEnabled and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
    toggleThumb.BackgroundColor3 = Theme.Colors.TextPrimary
    toggleThumb.BorderSizePixel = 0
    toggleThumb.Parent = toggleBg
    
    -- Thumb corners
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 11)
    thumbCorner.Parent = toggleThumb
    
    self.ToggleBG = toggleBg
    self.ToggleThumb = toggleThumb
    
    -- Click handling
    toggleBg.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Toggle()
        end
    end)
    
    -- Hover effects
    toggleBg.MouseEnter:Connect(function()
        Animations.Tween(toggleBg, {
            BackgroundColor3 = self.IsEnabled 
                and Color3.fromRGB(76, 145, 255)  -- Lighter blue
                or Color3.fromRGB(55, 55, 75)     -- Lighter gray
        }, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    end)
    
    toggleBg.MouseLeave:Connect(function()
        Animations.Tween(toggleBg, {
            BackgroundColor3 = self.IsEnabled and Theme.Colors.ToggleOn or Theme.Colors.ToggleOff
        }, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    end)
end

function Toggle:Toggle()
    self.IsEnabled = not self.IsEnabled
    self:_UpdateVisuals()
    self.ValueChanged:Fire(self.IsEnabled)
end

function Toggle:_UpdateVisuals()
    -- Animate background color
    Animations.Tween(self.ToggleBG, {
        BackgroundColor3 = self.IsEnabled and Theme.Colors.ToggleOn or Theme.Colors.ToggleOff
    }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Animate thumb position
    Animations.Tween(self.ToggleThumb, {
        Position = self.IsEnabled and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
    }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

function Toggle:SetValue(newValue)
    if newValue ~= self.IsEnabled then
        self.IsEnabled = newValue
        self:_UpdateVisuals()
        self.ValueChanged:Fire(self.IsEnabled)
    end
end

function Toggle:GetValue()
    return self.IsEnabled
end

function Toggle:Destroy()
    self.Container:Destroy()
    self.ValueChanged:Disconnect()
end

return Toggle
