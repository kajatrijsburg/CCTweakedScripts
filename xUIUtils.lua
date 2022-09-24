local utils = require("xLuaUtils")

local xUIUtils = {}


-- creates a new screen
-- a screen contains a number of containers which are lists of drawable items
-- a screen can be drawn

function xUIUtils.newScreen(name, backgroundColor)
    utils.assertString(name)
    utils.assertNumber(backgroundColor)

    local screen = {
        backgroundColor = backgroundColor,
        name = name,
        containers = {
            count = 0
        }
    }

    --adds a new container to the screen
    function screen.addContainer(self, container)
        utils.assertTable(container)

        self.containers[container.name] = container

        table.sort(self.containers, function (k1, k2)
            if type(k1) == "number" then
                return true
            end
            if type(k2) == "number" then 
                return false
            end
            return k1.depth < k2.depth
        end)

        self.containers.count = self.containers.count + 1
        return self
    end

    --loops over every container and draws it
    function screen.draw(self)
        term.setBackgroundColor(self.backgroundColor)
        term.clear()
        for index, value in pairs(self.containers) do
            if index ~= "count" then
                value.draw(value)
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

function xUIUtils.newContainer(name, topLeftCornerX, topLeftCornerY, width, height, depth)
    utils.assertString(name)
    utils.assertNumber(topLeftCornerX)
    utils.assertNumber(topLeftCornerY)
    utils.assertNumber(width)
    utils.assertNumber(height)
    utils.assertNumber(depth)

    local container = {
        name = name,
        topLeftCornerX = topLeftCornerX,
        topLeftCornerY = topLeftCornerY,
        width = width,
        height = height,
        depth = depth,
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

    --draw all the items in the container
    function  container.draw(self)
        --check if the container contains anythign to draw
        --if there's nothing to render we don't have to draw
        if self.items.count == 0 then
            return self
        end

        --set the cursor to the topleft corner of the container to start drawing all the items
        term.setCursorPos(self.topLeftCornerX, self.topLeftCornerY)

        --loop over all the items in the container
        for i = 1, self.items.count, 1 do
            --get the item we're drawing
            local item = self.items[i]
            local textToDraw = item.text

            --set the correct colors for this item
            term.setBackgroundColor(item.backgroundColor)
            term.setTextColor(item.foregroundColor)

            --draw the items, moving to the next line if we ran out of space on this line of the container
            while string.len(textToDraw) ~= 0 do
                --figure out how many characters we can still draw on this line,. If we're out of space, move to the next line
                local x, y = term.getCursorPos()
                local spaceLeft = self.width - (x - self.topLeftCornerX)
                if spaceLeft == 0 then
                    term.setCursorPos(self.topLeftCornerX, y+1)
                    spaceLeft = self.width
                end
                
                --get the updated cursor position after that
                x, y = term.getCursorPos()

                --if we're out of vertical space in the container we can stop drawing this item
                if y >= self.height + self.topLeftCornerY then
                    break
                end

                --write as much text as we can fit in the remaining space
                term.write(string.sub(textToDraw, 1, spaceLeft))
                --remove the stuff we've drawn to the screen already from the stuff we still need to draw
                textToDraw = string.sub(textToDraw, spaceLeft, string.len(textToDraw))
            end

            --if the item is supposed to be padded then fill the remaining space on the line with empty paces with the correct background color
            if item.renderType.padded == true then
                local x, y = term.getCursorPos()
                local padding = ""
                for i = 1, self.width - (x - self.topLeftCornerX), 1 do
                    padding = padding .. " "
                end
                term.write(padding)
            end

            --if the item is supposed to have a new line after it, then move the cursor to a new line
            if item.renderType.newline == true then
                local x, y = term.getCursorPos()
                term.setCursorPos(self.topLeftCornerX, y+1)
            end
        end

        return self
    end
    return container
end

function xUIUtils.newItem(text, onClick, foregroundColor, backgroundColor, renderType)
    utils.assertString(text)
    utils.assertNumber(foregroundColor)
    utils.assertNumber(backgroundColor)
    utils.assertTable(renderType)

    local item = {
        text = text,
        onClick = onClick,
        foregroundColor = foregroundColor,
        backgroundColor = backgroundColor,
        renderType = renderType
    }

    return item
end

return xUIUtils
