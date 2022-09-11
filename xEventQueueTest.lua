local EventQueue = require("xEventQueue")

local queue = EventQueue.newQueue(true, 1000)

local listener = EventQueue.newListener("reciever")

listener.addMessageType(listener, "testMessage", function (message)
    print(message.data)
end)
.addMessageType(listener, "otherTestMessage", function (message)
    print("other message type recieved with data: " .. message.data)
end)
.finalize(listener)


queue.addListner(queue, listener)
