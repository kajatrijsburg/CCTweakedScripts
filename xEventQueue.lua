local utils = require("xLuaUtils")

local xEventQueue = {}


--[[ 
    returns a new event queue
    if consumes is set to true then messages will be deleted from the queue 
    after they're handled by a listener. If it's set to false messages will 
    only be overwritten once the queue reaches it's size limit.
    A consuming queue will error if the max size is reached.
    Size describes the maximum number of messages the queue will hold. 
--]]
function xEventQueue.newQueue(consumes, size)
    utils.assertBoolean(consumes)
    utils.assertNumber(size)

    local queue = {
        listeners = {},
        listenerGroups = {},
        events = {},
        consumes = consumes,
        size = size,
        start = 1,
        index = 1
    }

    function queue.addListner(self, listener)
        --guard clauses
        utils.assertTable(listener)
        utils.assertTable(self)
        utils.assertTable(self.listeners)
        assert(self.listeners[listener.name] == nil, debug.traceback(listener.name .. " is already a listener to this event queue", 2))
        assert(listener.constant == true, debug.traceback("Listner needs to be constant. Did you forget to call finalize() on your listner?", 2))
        
        --function body
        self.listeners[listener.name] = listener
    end
    
    --adds event to the queue
    function queue.addEvent(self, event)
        --guard clauses
        utils.assertTable(self)
        utils.assertTable(event)
        assert(event.constant, debug.traceback("attempted to add an event to the queue that wasn't constant", 2))

        --function body
        table.insert(self.events, self.index, event)
        self.index = self.index + 1

        if self.index > size then
            if self.consumes then 
                error(debug.traceback("queue of size " .. self.size .. " ran out of space at index: " .. self.index), 2)
            end
            self.index = 1
        end
    end

    return utils.protect(queue)
end


--creates a new listener
function xEventQueue.newListener(name)
    --guard clauses
    utils.assertString(name)

    --function body
    local listener = {
        name = name
    }

    function listener.addEventType(self, eventType, onRecieve)
        --guard clauses
        utils.assertTable(self)
        utils.assertString(eventType)
        utils.assertFunction(onRecieve)

        --function body
        self[eventType] = onRecieve
        return self
    end

    function listener.finalize(self)
        --guard clauses
        utils.assertTable(self)

        self.addMessageType = nil
        return utils.constant(self)
    end

    return listener
end

--creates a new event
function xEventQueue.newEvent(reciever, data)
    local event = {
        reciever = reciever,
        data = data
    }

    return utils.constant(event)
end

return xEventQueue
