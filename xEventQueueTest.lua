local EventQueue = require("xEventQueue")

local queue = EventQueue.newQueue(true, 1000)



print(queue["listeners"])