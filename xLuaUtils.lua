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

return xLuaUtils