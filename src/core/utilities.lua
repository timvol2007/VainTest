--[[
    Utilities.lua - Helper functions for the framework
]]

local Utilities = {}

-- Key name mapping for keycodes
local KeyMap = {
    [Enum.KeyCode.A] = "A",
    [Enum.KeyCode.B] = "B",
    [Enum.KeyCode.C] = "C",
    [Enum.KeyCode.D] = "D",
    [Enum.KeyCode.E] = "E",
    [Enum.KeyCode.F] = "F",
    [Enum.KeyCode.G] = "G",
    [Enum.KeyCode.H] = "H",
    [Enum.KeyCode.I] = "I",
    [Enum.KeyCode.J] = "J",
    [Enum.KeyCode.K] = "K",
    [Enum.KeyCode.L] = "L",
    [Enum.KeyCode.M] = "M",
    [Enum.KeyCode.N] = "N",
    [Enum.KeyCode.O] = "O",
    [Enum.KeyCode.P] = "P",
    [Enum.KeyCode.Q] = "Q",
    [Enum.KeyCode.R] = "R",
    [Enum.KeyCode.S] = "S",
    [Enum.KeyCode.T] = "T",
    [Enum.KeyCode.U] = "U",
    [Enum.KeyCode.V] = "V",
    [Enum.KeyCode.W] = "W",
    [Enum.KeyCode.X] = "X",
    [Enum.KeyCode.Y] = "Y",
    [Enum.KeyCode.Z] = "Z",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Space] = "Space",
    [Enum.KeyCode.Tab] = "Tab",
    [Enum.KeyCode.Return] = "Enter",
    [Enum.KeyCode.BackSpace] = "Backspace",
    [Enum.KeyCode.Escape] = "Escape",
    [Enum.KeyCode.LeftShift] = "Shift",
    [Enum.KeyCode.RightShift] = "Shift",
    [Enum.KeyCode.LeftControl] = "Ctrl",
    [Enum.KeyCode.RightControl] = "Ctrl",
    [Enum.KeyCode.LeftAlt] = "Alt",
    [Enum.KeyCode.RightAlt] = "Alt",
    [Enum.KeyCode.F1] = "F1",
    [Enum.KeyCode.F2] = "F2",
    [Enum.KeyCode.F3] = "F3",
    [Enum.KeyCode.F4] = "F4",
    [Enum.KeyCode.F5] = "F5",
    [Enum.KeyCode.F6] = "F6",
    [Enum.KeyCode.F7] = "F7",
    [Enum.KeyCode.F8] = "F8",
    [Enum.KeyCode.F9] = "F9",
    [Enum.KeyCode.F10] = "F10",
    [Enum.KeyCode.F11] = "F11",
    [Enum.KeyCode.F12] = "F12",
}

function Utilities.GetKeyName(keyCode)
    return KeyMap[keyCode] or "Unknown"
end

function Utilities.Lerp(a, b, t)
    return a + (b - a) * t
end

function Utilities.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function Utilities.Distance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

function Utilities.TableCopy(tbl)
    local copy = {}
    for key, value in pairs(tbl) do
        if type(value) == "table" then
            copy[key] = Utilities.TableCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function Utilities.Print(prefix, message)
    print("[" .. prefix .. "] " .. message)
end

return Utilities
