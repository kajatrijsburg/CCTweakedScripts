local xLuaUtils = {}

--makes it so new fields cannot be added to a table
function xLuaUtils.protect(tab)
    if tab.protected ~= nil then
        error(debug.traceback("Attempted to protect a table that's already protected"), 2)
    end
    tab.protected = true
    local _meta = {
        __newindex = function (self, key)
            if self[key] == nil then
                local fields = ""
                for key, value in pairs(self) do
                    fields = fields .. key .. ", "
                end
        
                error(debug.traceback("Attempted to acces a non existant field: " .. key
                .. "\nAvailable fields are: " .. fields), 2)
        
            else
                return self[key]
            end
        end
    }

    return setmetatable(tab, _meta)
end

--makes it so a table and it's values cannot be modified 
function xLuaUtils.constant(tab)
    if tab.constant ~= nil then
        error(debug.traceback("Attempted to turn a table into a constant table but the table was already constant"), 2)
    end
    tab.constant = true
    return setmetatable({}, {
        __index = tab,
        __newindex = function (t, key, value)
            error(debug.traceback("Attempted to change constant: " .. tostring(key) .. " to " .. tostring(value)), 2)
        end
    })
end

--assert that a variable is of type n, throw an error message if it isn't
function xLuaUtils.assertNil(arg)
    assert(type(arg) == "nil", debug.traceback("parameter should be of type nil but was of type " .. type(arg)), 2)
end

function xLuaUtils.assertNumber(arg)
    assert(type(arg) == "number", debug.traceback("parameter should be of type number but was of type " .. type(arg)), 2)
end

function xLuaUtils.assertString(arg)
    assert(type(arg) == "string", debug.traceback("parameter should be of type string but was of type " .. type(arg)), 2)
end

function xLuaUtils.assertBoolean(arg)
    assert(type(arg) == "boolean", debug.traceback("parameter should be of type boolean but was of type " .. type(arg)), 2)
end

function xLuaUtils.assertTable(arg)
    assert(type(arg) == "table", debug.traceback("parameter should be of type table but was of type " .. type(arg)), 2)
end

function xLuaUtils.assertFunction(arg)
    assert(type(arg) == "function", debug.traceback("parameter should be of type function but was of type " .. type(arg)), 2)
end

function xLuaUtils.assertUserdata(arg)
    assert(type(arg) == "userdata", debug.traceback("parameter should be of type userdata but was of type " .. type(arg)), 2)
end

return xLuaUtils