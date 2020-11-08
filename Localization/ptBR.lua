local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local L = Addon.GetLocales("deDE")
if not L then
    return
end

L["Chained Spirit"] = "Espírito Acorrentado"
L["+"] = "+"
L["D"] = "M"
L["R"] = "R"
