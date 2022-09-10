local utils = require("xLuaUtils")

local xEventQueue = {}


-- returns a new event queue
--if consumes is set to true then messages will be deleted from the queue 
--after they're handled by a listener. If it's set to false messages will 
--only be overwritten once the queue reaches it's size limit
--size describes the maximum number of messages the queue will hold. 
function xEventQueue.newQueue(consumes, size)
    local queue = {
        listeners = {},
        listenerGroups = {},
        events = {},
    }

    queue.addListener = function (listener)
        
    end

    return utils.constant(queue)
end


--creates a new listener
function xEventQueue.newListener(name)
    assert(type(name) == string, "the type of name has to be string but was: " .. type(name))

    local listener = {
        name = name
    }
end


return xEventQueue
