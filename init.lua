-- {{{ Setup environment
local setmetatable = setmetatable
local rawget  = rawget
local require = require

local dynamic_require = (function()
        -- hide function from module scope to avoid recursion.
        return function(table,  key)
                local mod = rawget(table,  key)
                return mod or require(table._NAME .. "." .. key)
        end
end)()
module("utils")
-- }}}

setmetatable(_M, { __index = dynamic_require })
