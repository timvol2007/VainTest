--[[
    Theme.lua - Centralized theme configuration
    Dark theme with modern Roblox UI standards
]]

local Theme = {
    -- Primary Colors
    Colors = {
        -- Dark Background
        Background = Color3.fromRGB(15, 15, 20),          -- Very dark background
        Surface = Color3.fromRGB(25, 25, 35),             -- Slightly lighter surface
        Elevated = Color3.fromRGB(35, 35, 50),            -- Even lighter elevated surfaces
        
        -- Accents
        Primary = Color3.fromRGB(66, 135, 245),           -- Blue accent
        Secondary = Color3.fromRGB(100, 100, 120),        -- Gray accent
        
        -- Text
        TextPrimary = Color3.fromRGB(255, 255, 255),      -- Main text (white)
        TextSecondary = Color3.fromRGB(160, 160, 180),    -- Secondary text (light gray)
        TextMuted = Color3.fromRGB(100, 100, 120),        -- Muted text (darker gray)
        
        -- Interactive
        ButtonDefault = Color3.fromRGB(35, 35, 50),       -- Default button
        ButtonHover = Color3.fromRGB(45, 45, 65),         -- Hover state
        ButtonActive = Color3.fromRGB(66, 135, 245),      -- Active/pressed state
        
        -- Status Colors
        Success = Color3.fromRGB(52, 211, 153),           -- Green
        Warning = Color3.fromRGB(251, 146, 60),           -- Orange
        Error = Color3.fromRGB(239, 68, 68),              -- Red
        
        -- Slider & Toggle
        SliderTrack = Color3.fromRGB(45, 45, 65),         -- Slider background
        SliderThumb = Color3.fromRGB(66, 135, 245),       -- Slider handle
        ToggleOff = Color3.fromRGB(45, 45, 65),           -- Toggle off
        ToggleOn = Color3.fromRGB(66, 135, 245),          -- Toggle on
    },
    
    -- Sizes
    Sizes = {
        -- Window
        WindowWidth = 450,
        WindowHeight = 600,
        WindowCornerRadius = 12,
        
        -- Title Bar
        TitleBarHeight = 40,
        
        -- Sidebar
        SidebarWidth = 120,
        
        -- Content
        ContentPadding = 15,
        
        -- Module Item
        ModuleHeight = 50,
        SettingItemHeight = 45,
        
        -- UI Elements
        ButtonHeight = 35,
        SliderHeight = 25,
        ToggleSize = 24,
        
        -- Text
        TextSizeTitle = 18,
        TextSizeHeader = 14,
        TextSizeNormal = 12,
        TextSizeSmall = 11,
        
        -- Gaps
        ItemSpacing = 8,
        SectionSpacing = 15,
    },
    
    -- Transparency/Alpha Values
    Transparency = {
        Opaque = 0,
        Slight = 0.05,
        Light = 0.1,
        Medium = 0.2,
        Heavy = 0.3,
    },
    
    -- Animation Speeds
    AnimationSpeeds = {
        Instant = 0.1,
        Fast = 0.2,
        Normal = 0.3,
        Slow = 0.5,
    },
    
    -- Fonts
    Fonts = {
        Default = Enum.Font.GothamSSm,
        Bold = Enum.Font.GothamBold,
        Mono = Enum.Font.RobotoMono,
    },
    
    -- Shadows/Strokes
    BorderColor = Color3.fromRGB(50, 50, 70),
    BorderSize = 1,
}

return Theme
