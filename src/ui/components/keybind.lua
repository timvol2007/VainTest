--[[
    Keybind Component - Input field for capturing keybinds
]]

local UserInputService = game:GetService("UserInputService")
local Animations = require(script.Parent.Parent.ui.animations)
local Theme = require(script.Parent.Parent.ui.theme)
local Utilities = require(script.Parent.Parent.core.utilities)
local Signal = require(script.Parent.Parent.core.signal)

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(parent, currentKey, label, description)
    local self = setmetatable({}, Keybind)
    
    self.CurrentKey = currentKey or "Q"
    self.Label = label
    self.Description = description
    self.isListening = false
    
    self.KeyChanged = Signal.new()
    
    self:_CreateUI(parent)
    
    return self
end

function Keybind:_CreateUI(parent)
    -- Main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "KeybindContainer"
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
    
    -- Keybind input button
    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = "KeybindButton"
    keybindButton.Size = UDim2.new(0.35, 0, 0, 28)
    keybindButton.Position = UDim2.new(0.65, 0, 0, 8)
    keybindButton.BackgroundColor3 = Theme.Colors.ButtonDefault
    keybindButton.TextColor3 = Theme.Colors.TextPrimary
    keybindButton.TextSize = Theme.Sizes.TextSizeNormal
    keybindButton.Font = Theme.Fonts.Bold
    keybindButton.Text = self.CurrentKey
    keybindButton.BorderSizePixel = 0
    keybindButton.Parent = self.Container
    
    -- Button corners
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = keybindButton
    
    self.KeybindButton = keybindButton
    
    -- Click handling
    keybindButton.MouseButton1Click:Connect(function()
        self:StartListening()
    end)
    
    -- Hover effects
    keybindButton.MouseEnter:Connect(function()
        Animations.ColorTween(keybindButton, Theme.Colors.ButtonHover, 0.15)
    end)
    
    keybindButton.MouseLeave:Connect(function()
        if not self.isListening then
            Animations.ColorTween(keybindButton, Theme.Colors.ButtonDefault, 0.15)
        end
    end)
end

function Keybind:StartListening()
    if self.isListening then return end
    
    self.isListening = true
    self.KeybindButton.Text = "Press key..."
    Animations.ColorTween(self.KeybindButton, Theme.Colors.Primary, 0.1)
    
    local inputConnection
    inputConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Only listen for keyboard inputs
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local keyCode = input.KeyCode
            local keyName = Utilities.GetKeyName(keyCode)
            
            if keyName and keyName ~= "Unknown" then
                self.CurrentKey = keyName
                self:_StopListening()
                self.KeyChanged:Fire(self.CurrentKey)
            end
        end
    end)
    
    -- Timeout after 5 seconds
    task.wait(5)
    if self.isListening then
        self:_StopListening()
    end
end

function Keybind:_StopListening()
    self.isListening = false
    self.KeybindButton.Text = self.CurrentKey
    Animations.ColorTween(self.KeybindButton, Theme.Colors.ButtonDefault, 0.1)
end

function Keybind:SetValue(newKey)
    self.CurrentKey = newKey
    self.KeybindButton.Text = newKey
    self.KeyChanged:Fire(self.CurrentKey)
end

function Keybind:GetValue()
    return self.CurrentKey
end

function Keybind:Destroy()
    self.Container:Destroy()
    self.KeyChanged:Disconnect()
end

return Keybind
