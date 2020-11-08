local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local L = Addon.GetLocales("deDE")
if not L then
    return
end

L["Chained Spirit"] = "被禁锢的灵魂"
L["+"] = "+"
L["D"] = "地城"
L["R"] = "团本"
