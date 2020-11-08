local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local L = Addon.GetLocales("deDE")
if not L then
    return
end

L["Chained Spirit"] = "Esprit enchaîné"
L["+"] = "+"
L["D"] = "D"
L["R"] = "R"
