--[[
    Utilities.lua - Helper functions for UI, math, and general utilities
]]

local Utilities = {}

-- Table Utilities
function Utilities.TableMerge(t1, t2)
    local result = {}
    for k, v in pairs(t1) do
        result[k] = v
    end
    for k, v in pairs(t2) do
        result[k] = v
    end
    return result
end

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

function Utilities.TableFind(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

-- String Utilities
function Utilities.StringCapitalize(str)
    return str:sub(1, 1):upper() .. str:sub(2):lower()
end

function Utilities.StringSplit(str, delimiter)
    local result = {}
    local start = 1
    while true do
        local pos = str:find(delimiter, start, true)
        if not pos then
            table.insert(result, str:sub(start))
            break
        end
        table.insert(result, str:sub(start, pos - 1))
        start = pos + #delimiter
    end
    return result
end

-- Math Utilities
function Utilities.Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

function Utilities.Lerp(a, b, t)
    return a + (b - a) * t
end

function Utilities.Distance(p1, p2)
    local dx = p1.X - p2.X
    local dy = p1.Y - p2.Y
    return math.sqrt(dx * dx + dy * dy)
end

-- UI Utilities
function Utilities.CreateRoundCornerFrame(parent, cornerRadius)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    
    -- Create corner objects
    local topLeft = Instance.new("Frame")
    topLeft.Size = UDim2.new(0, cornerRadius, 0, cornerRadius)
    topLeft.Position = UDim2.new(0, 0, 0, 0)
    topLeft.BackgroundColor3 = frame.BackgroundColor3
    topLeft.BorderSizePixel = 0
    topLeft.Parent = frame
    
    local topRight = Instance.new("Frame")
    topRight.Size = UDim2.new(0, cornerRadius, 0, cornerRadius)
    topRight.Position = UDim2.new(1, -cornerRadius, 0, 0)
    topRight.BackgroundColor3 = frame.BackgroundColor3
    topRight.BorderSizePixel = 0
    topRight.Parent = frame
    
    local bottomLeft = Instance.new("Frame")
    bottomLeft.Size = UDim2.new(0, cornerRadius, 0, cornerRadius)
    bottomLeft.Position = UDim2.new(0, 0, 1, -cornerRadius)
    bottomLeft.BackgroundColor3 = frame.BackgroundColor3
    bottomLeft.BorderSizePixel = 0
    bottomLeft.Parent = frame
    
    local bottomRight = Instance.new("Frame")
    bottomRight.Size = UDim2.new(0, cornerRadius, 0, cornerRadius)
    bottomRight.Position = UDim2.new(1, -cornerRadius, 1, -cornerRadius)
    bottomRight.BackgroundColor3 = frame.BackgroundColor3
    bottomRight.BorderSizePixel = 0
    bottomRight.Parent = frame
    
    return frame
end

function Utilities.HexToRGB(hex)
    hex = hex:gsub("#", "")
    return Color3.fromHex(hex)
end

-- Executor Detection
function Utilities.DetectExecutor()
    if syn then return "Synapse" end
    if secure_call then return "Script-Ware" end
    if KRNL_LOADED then return "Krnl" end
    if _G.COREGUI then return "Coregui" end
    if game:GetService("CoreGui"):FindFirstChild("RobloxGui") then return "Roblox" end
    return "Unknown"
end

-- File I/O (Compatible with multiple executors)
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

-- Input Utilities
function Utilities.GetKeyName(keyCode)
    local keyNames = {
        [Enum.KeyCode.Q] = "Q",
        [Enum.KeyCode.W] = "W",
        [Enum.KeyCode.E] = "E",
        [Enum.KeyCode.R] = "R",
        [Enum.KeyCode.T] = "T",
        [Enum.KeyCode.Y] = "Y",
        [Enum.KeyCode.U] = "U",
        [Enum.KeyCode.I] = "I",
        [Enum.KeyCode.O] = "O",
        [Enum.KeyCode.P] = "P",
        [Enum.KeyCode.A] = "A",
        [Enum.KeyCode.S] = "S",
        [Enum.KeyCode.D] = "D",
        [Enum.KeyCode.F] = "F",
        [Enum.KeyCode.G] = "G",
        [Enum.KeyCode.H] = "H",
        [Enum.KeyCode.J] = "J",
        [Enum.KeyCode.K] = "K",
        [Enum.KeyCode.L] = "L",
        [Enum.KeyCode.Z] = "Z",
        [Enum.KeyCode.X] = "X",
        [Enum.KeyCode.C] = "C",
        [Enum.KeyCode.V] = "V",
        [Enum.KeyCode.B] = "B",
        [Enum.KeyCode.N] = "N",
        [Enum.KeyCode.M] = "M",
        [Enum.KeyCode.Space] = "Space",
        [Enum.KeyCode.Tab] = "Tab",
        [Enum.KeyCode.Caps] = "Caps",
        [Enum.KeyCode.Backspace] = "Backspace",
    }
    return keyNames[keyCode] or tostring(keyCode):split(".")[3] or "Unknown"
end

return Utilities
