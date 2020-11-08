local AddonName, AddonTable = ...
local Addon = AddonTable[1]
Addon.L = {}

local localeSave = {}

function Addon.GetLocales(locale)
    return GetLocale() == locale and Addon.L or nil
end

setmetatable(Addon.L, {
    __index = function(self, key)
        return localeSave[key] or key
    end,
    __newindex = function(self, key, value)
        rawset(localeSave, key, value == true and key or value)
    end
})
