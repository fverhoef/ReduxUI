local addonName, ns = ...
local R = _G.ReduxUI
R.L = {}

local localeSave = {}

function R.GetLocales(locale)
    return GetLocale() == locale and R.L or nil
end

setmetatable(R.L, {
    __index = function(self, key)
        return localeSave[key] or key
    end,
    __newindex = function(self, key, value)
        rawset(localeSave, key, value == true and key or value)
    end
})
