local utils = require("xLuaUtils")

local xEventQueue = {}


-- returns a new event queue
--if consumes is set to true then messages will be deleted from the queue 
--after they're handled by a listener. If it's set to false messages will 
--only be overwritten once the queue reaches it's size limit
--size describes the maximum number of messages the queue will hold. 
function xEventQueue.newQueue(consumes, size)
    utils.assertBoolean(consumes)
    utils.assertNumber(size)

    local queue = {
        listeners = {},
        listenerGroups = {},
        events = {},
        consumes = consumes,
        size = size,
    }

    return utils.constant(queue)
end


--creates a new listener
function xEventQueue.newListener(name)
    utils.assertString(name)

    local listener = {
        name = name
    }

    function listener.addMessageType(type, onRecieve)

    end
end


return xEventQueue
