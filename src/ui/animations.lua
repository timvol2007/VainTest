--[[
    Animations.lua - Smooth animation utilities
    Provides tweening, fading, and other UI animations
]]

local Animations = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Tween a UI element
function Animations.Tween(object, properties, duration, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.InOut
    
    local tweenInfo = TweenInfo.new(
        duration,
        easingStyle,
        easingDirection
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    
    return tween
end

-- Fade in
function Animations.FadeIn(object, duration)
    duration = duration or 0.3
    return Animations.Tween(object, {BackgroundTransparency = 0}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

-- Fade out
function Animations.FadeOut(object, duration)
    duration = duration or 0.3
    return Animations.Tween(object, {BackgroundTransparency = 1}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

-- Slide down with expand
function Animations.SlideDown(object, startSize, endSize, duration)
    duration = duration or 0.3
    object.Size = startSize
    object.ClipsDescendants = true
    return Animations.Tween(object, {Size = endSize}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

-- Slide up with collapse
function Animations.SlideUp(object, startSize, endSize, duration)
    duration = duration or 0.3
    return Animations.Tween(object, {Size = endSize}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
end

-- Scale animation
function Animations.Scale(object, startScale, endScale, duration)
    duration = duration or 0.2
    object.Size = UDim2.new(startScale, 0, startScale, 0)
    return Animations.Tween(object, {Size = UDim2.new(endScale, 0, endScale, 0)}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

-- Smooth color transition
function Animations.ColorTween(object, targetColor, duration)
    duration = duration or 0.2
    return Animations.Tween(object, {BackgroundColor3 = targetColor}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

-- Position animation
function Animations.Move(object, targetPosition, duration)
    duration = duration or 0.3
    return Animations.Tween(object, {Position = targetPosition}, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

-- Bounce animation (scale)
function Animations.Bounce(object, scale, duration)
    duration = duration or 0.4
    return Animations.Tween(object, {Size = UDim2.new(scale, 0, scale, 0)}, duration, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
end

-- Pulse animation
function Animations.Pulse(object, times, duration)
    times = times or 2
    duration = duration or 0.5
    
    local originalColor = object.BackgroundColor3
    local pulseColor = Color3.fromRGB(100, 100, 120)
    
    for i = 1, times do
        Animations.ColorTween(object, pulseColor, duration / (times * 2))
        task.wait(duration / (times * 2))
        Animations.ColorTween(object, originalColor, duration / (times * 2))
        task.wait(duration / (times * 2))
    end
end

return Animations
