local ui = require("xUIUtils")

local screen = ui.newScreen("main", colors.black)

local container = ui.newContainer("list", 3, 5, 7, 10, 3)
local container2 = ui.newContainer("list2", 1, 1, 10, 15, 2)


container.appendItem(container,
    ui.newItem(
        "test1",
        function()
            print("Clicked!")
        end,
        colors.red,
        colors.gray,
        {
            newline = true,
            padded = true
        }
    )).appendItem(container,
    ui.newItem(
        "test2",
        nil,
        colors.green,
        colors.gray,
        {
        }
    )).insertItem(container,
    ui.newItem(
        "test3sfdsdfsdfsdfsdsdsdsdsdsdsdf",
        function()
            print("Clicked3!")
        end,
        colors.green,
        colors.black,
        {
            newline = true,
        }
    ), 2)

container2.appendItem(container2,
    ui.newItem(
        "test4",
        function()
            print("Clicked!")
        end,
        colors.cyan,
        colors.gray,
        {

        }
    ))
    .appendItem(container2,
    ui.newItem(
        "test5",
        nil,
        colors.black,
        colors.white,
        {

        }
    ))
    .insertItem(container2,
    ui.newItem(
        "test6sfdsdfsdfsdfsdsdsdsdsdsdsdf",
        function()
            print("Clicked3!")
        end,
        colors.green,
        colors.black,
        {

        }
    ), 2)

screen.addContainer(screen, container).addContainer(screen, container2)

screen.draw(screen)
