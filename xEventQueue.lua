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

    function queue.addListner(self, listener)
        utils.assertTable(listener)
        utils.assertTable(self)
        utils.assertTable(self.listeners)
        assert(self.listeners[listener.name] == nil, debug.traceback(listener.name .. " is already a listener to this event queue", 2))
        assert(listener.constant == true, debug.traceback("Listner needs to be constant. Did you forget to call finalize() on your listner?", 2))
        
        self.listeners[listener.name] = listener
    end
    return utils.protect(queue)
end


--creates a new listener
function xEventQueue.newListener(name)
    utils.assertString(name)

    local listener = {
        name = name
    }

    function listener.addMessageType(self, messageType, onRecieve)
        utils.assertTable(self)
        utils.assertString(messageType)
        utils.assertFunction(onRecieve)

        self[messageType] = onRecieve
        return self
    end

    function listener.finalize(self)
        utils.assertTable(self)
        self.addMessageType = nil
        return utils.constant(self)
    end

    return listener
end


return xEventQueue
