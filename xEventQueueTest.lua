local EventQueue = require("xEventQueue")

local queue = EventQueue.newQueue(true, 1000)

local listener = EventQueue.newListener("reciever")

listener.addEventType(listener, "testMessage", function (message)
    print(message.data)
end)
.addEventType(listener, "otherTestMessage", function (message)
    print("other message type recieved with data: " .. message.data)
end)
.finalize(listener)


queue.addListner(queue, listener)

queue.addEvent(queue, EventQueue.newEvent("reciever", "testMessage", "Hello, world!"))
.addEvent(queue, EventQueue.newEvent("reciever", "testMessage", "Bye, world"))
.addEvent(queue, EventQueue.newEvent("reciever", "otherTestMessage", "yep, it works"))