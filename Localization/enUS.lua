local AddonName, AddonTable = ...
local Addon = AddonTable[1]

if GetLocale() == "enUS" or GetLocale() == "enGB" then
    Addon.L = { }
    Addon.L["Chained Spirit"] = "Chained Spirit"
    Addon.L["+"] = "+"
    Addon.L["D"] = "D"
    Addon.L["R"] = "R"
end