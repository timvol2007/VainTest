--[[
    Slider Component - Interactive slider with real-time value display
]]

local UserInputService = game:GetService("UserInputService")
local Animations = LoadRemoteModule("ui/animations")
local Theme = LoadRemoteModule("ui/theme")
local Utilities = LoadRemoteModule("core/utilities")
local Signal = LoadRemoteModule("core/signal")

local Slider = {}
Slider.__index = Slider

function Slider.new(parent, minValue, maxValue, currentValue, label, description)
    local self = setmetatable({}, Slider)
    
    self.MinValue = minValue
    self.MaxValue = maxValue
    self.CurrentValue = currentValue
    self.Label = label
    self.Description = description
    
    self.ValueChanged = Signal.new()
    self.isDragging = false
    
    self:_CreateUI(parent)
    
    return self
end

function Slider:_CreateUI(parent)
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "SliderContainer"
    self.Container.Size = UDim2.new(1, -15, 0, Theme.Sizes.SettingItemHeight)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = parent
    
    -- Label
    local labelText = Instance.new("TextLabel")
    labelText.Name = "Label"
    labelText.Size = UDim2.new(0.6, 0, 0, 20)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = self.Label
    labelText.TextColor3 = Theme.Colors.TextPrimary
    labelText.TextSize = Theme.Sizes.TextSizeNormal
    labelText.Font = Theme.Fonts.Default
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = self.Container
    
    -- Value display
    local valueText = Instance.new("TextLabel")
    valueText.Name = "ValueText"
    valueText.Size = UDim2.new(0.4, 0, 0, 20)
    valueText.Position = UDim2.new(0.6, 0, 0, 0)
    valueText.BackgroundTransparency = 1
    valueText.Text = tostring(self.CurrentValue)
    valueText.TextColor3 = Theme.Colors.Primary
    valueText.TextSize = Theme.Sizes.TextSizeNormal
    valueText.Font = Theme.Fonts.Bold
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.Parent = self.Container
    
    -- Slider track background
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 25)
    track.BackgroundColor3 = Theme.Colors.SliderTrack
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.Parent = self.Container
    
    -- Make track corners rounded
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    -- Slider thumb/handle
    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 14, 0, 20)
    thumb.Position = UDim2.new(0, 0, 0.5, -10)
    thumb.BackgroundColor3 = Theme.Colors.SliderThumb
    thumb.BorderSizePixel = 0
    thumb.Parent = track
    
    -- Thumb corners
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 4)
    thumbCorner.Parent = thumb
    
    self.Track = track
    self.Thumb = thumb
    self.ValueLabel = valueText
    
    -- Position thumb based on value
    self:_UpdateThumbPosition()
    
    -- Input handling
    local inputConnection
    
    thumb.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.isDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if not self.isDragging or gameProcessed then return end
        
        local mousePos = game:GetService("Mouse").X
        local trackPos = track.AbsolutePosition.X
        local trackSize = track.AbsoluteSize.X
        
        local relativePos = mousePos - trackPos
        local percentage = math.clamp(relativePos / trackSize, 0, 1)
        
        local newValue = self.MinValue + (self.MaxValue - self.MinValue) * percentage
        newValue = math.floor(newValue + 0.5) -- Round to nearest integer
        
        if newValue ~= self.CurrentValue then
            self.CurrentValue = newValue
            self:_UpdateThumbPosition()
            self.ValueLabel.Text = tostring(self.CurrentValue)
            self.ValueChanged:Fire(self.CurrentValue)
        end
    end)
end

function Slider:_UpdateThumbPosition()
    local percentage = (self.CurrentValue - self.MinValue) / (self.MaxValue - self.MinValue)
    percentage = math.clamp(percentage, 0, 1)
    
    local trackWidth = self.Track.AbsoluteSize.X
    local thumbWidth = self.Thumb.AbsoluteSize.X
    local targetPos = (trackWidth - thumbWidth) * percentage
    
    self.Thumb.Position = UDim2.new(0, targetPos, 0.5, -10)
end

function Slider:SetValue(newValue)
    self.CurrentValue = math.clamp(newValue, self.MinValue, self.MaxValue)
    self:_UpdateThumbPosition()
    self.ValueLabel.Text = tostring(self.CurrentValue)
    self.ValueChanged:Fire(self.CurrentValue)
end

function Slider:GetValue()
    return self.CurrentValue
end

function Slider:Destroy()
    self.Container:Destroy()
    self.ValueChanged:Disconnect()
end

return Slider
