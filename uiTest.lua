local ui = require("xUIUtils")

local screen = ui.newScreen("main")

local container = ui.newContainer("list", 1, 1, 10, 15, 1, "leftToRightTopToBottom", true)

container.appendItem(container,
    ui.newItem(
        "test1",
        function()
            print("Clicked!")
        end, colors.red, colors.gray
    )).appendItem(container,
    ui.newItem(
        "test2",
        nil, colors.green, colors.gray
    )).insertItem(container,
    ui.newItem(
        "test4sfdsdfsdfsdfsdsdsdsdsdsdsdf",
        function()
            print("Clicked3!")
        end, colors.green, colors.gray
    ), 2)

screen.addContainer(screen, container)

screen.draw(screen)
