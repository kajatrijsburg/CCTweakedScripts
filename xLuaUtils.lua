local xLuaUtils = {}

--makes it so new fields cannot be added to a table
function xLuaUtils.protect(tab)
    local _meta = {
        __newindex = function (self, key)
            if self[key] == nil then
                local fields = ""
                for key, value in pairs(self) do
                    fields = fields .. key .. ", "
                end
        
                error("Attempted to acces a non existant field: " .. key
                .. "\nAvailable fields are: " .. fields)
        
            else
                return self[key]
            end
        end
    }

    return setmetatable(tab, _meta)
end

--makes it so a table and it's values cannot be modified 
function xLuaUtils.constant(tab)
    return setmetatable({}, {
        __index = tab,
        __newindex = function (t, key, value)
            error("Attempted to change constant: " .. tostring(key) .. " to " .. tostring(value))           
        end
    })
end

--assert that a variable is of type n, throw an error message if it isn't
function xLuaUtils.assertNil(arg)
    assert(type(arg) == "nil", "parameter should be of type nil but was of type " .. type(arg))
end

function xLuaUtils.assertNumber(arg)
    assert(type(arg) == "number", "parameter should be of type number but was of type " .. type(arg))
end

function xLuaUtils.assertString(arg)
    assert(type(arg) == "string", "parameter should be of type string but was of type " .. type(arg))
end

function xLuaUtils.assertBoolean(arg)
    assert(type(arg) == "boolean", "parameter should be of type boolean but was of type " .. type(arg))
end

function xLuaUtils.assertTable(arg)
    assert(type(arg) == "table", "parameter should be of type table but was of type " .. type(arg))
end

function xLuaUtils.assertFunction(arg)
    assert(type(arg) == "function", "parameter should be of type function but was of type " .. type(arg))
end

function xLuaUtils.assertUserdata(arg)
    assert(type(arg) == "userdata", "parameter should be of type userdata but was of type " .. type(arg))
end

return xLuaUtils