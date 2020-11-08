local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local L = Addon.GetLocales("deDE")
if not L then
    return
end

L["Chained Spirit"] = "Espíritu encadenado"
L["+"] = "+"
L["D"] = locale == "esMX" and "C" or "M"
L["R"] = "B"
