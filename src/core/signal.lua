--[[
    Signal.lua - Simple event signal system
]]

local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self._connections = {}
    return self
end

function Signal:Connect(callback)
    local connection = {
        _signal = self,
        _callback = callback,
        Connected = true,
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

function Signal:Disconnect()
    for _, connection in ipairs(self._connections) do
        connection:Disconnect()
    end
end

return Signal
