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
        events = {count = 0, head = 1,
        tail = 1},
        consumes = consumes,
        maxSize = size,
        
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
        self.events[self.events.head] = event
        self.events.head = self.events.head + 1

        if self.events.head > size then
            self.events.head = 1
        end
        
        self.events.count = self.events.count + 1

        if self.events.count > size and self.consumes then
            error(debug.traceback("ran out of space in the event buffer of size" .. self.maxSize, 2))
        end
        
        return self
    end

    function queue.processEvent(self)
        --make sure there's actually events to handle
        if self.events.count == 0 then
            return self
        end

        local eventToProcess = self.events[self.events.tail]
        utils.assertTable(eventToProcess)

        --make sure the listener exists
        local listner = self.listeners[eventToProcess["listener"]] 
        assert(listner ~= nil, debug.traceback("the listener: " .. eventToProcess["listener"] 
        .. " is not a listener of this queue.\nThe currently registered listeners are: " .. utils.tableToString(self.listeners), 2))
        
        --make sure the listener can actually handle the event
        assert(listner.eventTypes[eventToProcess.eventType] ~= nil,
        debug.traceback("listener: ".. listner.name ..
        " does not have the registered eventType: "
        .. eventToProcess.eventType .. ". Available eventTypes are: " .. utils.tableToString(listner.eventTypes), 2))
        
        --actually call the OnRecieve for the current event
        listner.eventTypes[eventToProcess.eventType](eventToProcess)

        if self.consumes then
            self.events[self.events.tail] = nil
        end

        self.events.count = self.events.count -1
        self.events.tail = self.events.tail + 1
        
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
        name = name,
        eventTypes = {}
    }

    function listener.addEventType(self, eventType, onRecieve)
        --guard clauses
        utils.assertTable(self)
        utils.assertString(eventType)
        utils.assertFunction(onRecieve)

        --function body
        self.eventTypes[eventType] = onRecieve
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
function xEventQueue.newEvent(listener, eventType, data)
    utils.assertString(eventType)
    local event = {
        listener = listener,
        eventType = eventType,
        data = data
    }

    return utils.constant(event)
end

return xEventQueue
