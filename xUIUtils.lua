local utils = require("xLuaUtils")

local xUIUtils = {}


-- creates a new screen
-- a screen contains a number of containers which are lists of drawable items
-- a screen can be drawn

function xUIUtils.newScreen(name)
    utils.assertString(name)
    local screen = {
        name = name,
        containers = {
            count = 0
        }
    }

    --adds a new container to the screen
    function screen.addContainer(self, container)
        utils.assertTable(container)

        self.containers[container.name] = container
        self.containers.count = self.containers.count + 1
        return self
    end

    --loops over every container and draws it in order of 
    function screen.draw(self)
        print("drawing this screen")

        --print(utils.tableToString(self.containers))
        for index, value in ipairs(self.containers) do
            print("test")
            if index ~= "count" then
                index.draw(index)
           end
        end
        return self
    end

    return screen
end

-- a container is a list of drawable items that will be drawn in order
-- a container is added to a screen by calling screen.addContainer
-- to draw the container, draw the screen that it's on
-- drawOrder dictates how the items in the container should be drawn
-- valid draw orders are listed in the following table
xUIUtils.drawStyles = {}
xUIUtils.drawStyles["leftToRight"] = true
xUIUtils.drawStyles["topToBottom"] = true
xUIUtils.drawStyles["leftToRightTopToBottom"] = true

function xUIUtils.newContainer(name, topLeftCornerX, topLeftCornerY, width, height, depth, drawOrder, wrap)
    utils.assertString(name)
    utils.assertNumber(topLeftCornerX)
    utils.assertNumber(topLeftCornerY)
    utils.assertNumber(width)
    utils.assertNumber(height)
    utils.assertNumber(depth)
    utils.assertBoolean(wrap)

    assert(xUIUtils.drawStyles[drawOrder],
        debug.traceback("the draw order:" ..
            drawOrder ..
            " provided to container: " ..
            name .. " is not a valid draw order. Valid draw orders are: " .. utils.tableToString(xUIUtils.drawStyles)), 2)

    local container = {
        name = name,
        topLeftCornerX = topLeftCornerX,
        topLeftCornerY = topLeftCornerY,
        width = width,
        height = height,
        depth = depth,
        drawOrder = drawOrder,
        wrap = wrap,
        items = {
            count = 0
        }
    }

    --adds an item to the end of the container, meaning that it will be drawn last
    function container.appendItem(self, item)
        utils.assertTable(item)

        self.items[self.items.count + 1] = item
        self.items.count = self.items.count + 1
        return self
    end

    function container.insertItem(self, item, position)
        utils.assertTable(item)
        utils.assertNumber(position)

        table.insert(self.items, position, item)
        self.items.count = self.items.count + 1

        return self
    end

    --removes all items in the container
    function container.clear(self)
        for i = 1, self.items.count + 1, 1 do
            self.items[i] = nil
        end
        self.items.count = 0
        return container
    end

    function  container.draw(self)
        print("drawing container: " .. self.name)
        return self
    end
    return container
end

function xUIUtils.newItem(text, onClick, foregroundColor, backgroundColor)
    local item = {
        text = text,
        onClick = onClick,
        foregroundColor = foregroundColor,
        backgroundColor = backgroundColor
    }

    return item
end

return xUIUtils
