local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local L = Addon.GetLocales("deDE")
if not L then
    return
end

L["Chained Spirit"] = "Скованный дух"
L["+"] = "+"
L["D"] = "П"
L["R"] = "Р"
