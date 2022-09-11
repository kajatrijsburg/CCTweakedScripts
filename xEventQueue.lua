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
        events = {count = 0},
        consumes = consumes,
        size = size,
        head = 1,
        tail = 1
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

        return self
    end
    
    --adds event to the queue
    function queue.addEvent(self, event)
        --guard clauses
        utils.assertTable(self)
        utils.assertTable(event)
        assert(event.constant, debug.traceback("attempted to add an event to the queue that wasn't constant", 2))

        --function body
        
        self.head = self.head + 1

        if self.head > size then
            self.head = 1
        end
        
        self.events.count = self.events.count + 1

        if self.events.count > size and self.consumes then
            error(debug.traceback("ran out of space in the event buffer of size" .. self.size, 2))
        end
        table.insert(self.events, self.head, event)
        return self
    end

    function queue.processEvent(self)
        local eventToProcess = self.events[self.start]
        return self
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
function xEventQueue.newEvent(reciever, eventType, data)
    utils.assertString(eventType)
    local event = {
        reciever = reciever,
        eventType = eventType,
        data = data
    }

    return utils.constant(event)
end

return xEventQueue
