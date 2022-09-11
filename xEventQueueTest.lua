local EventQueue = require("xEventQueue")

local queue = EventQueue.newQueue(true, 1000)

local listener = EventQueue.newListener("reciever")