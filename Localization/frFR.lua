local addonName, ns = ...
local R = _G.ReduxUI

local L = R.GetLocales("frFR")
if not L then
    return
end

L["+"] = "+"
L["D"] = "D"
L["R"] = "R"
L["Chained Spirit"] = "Esprit enchaîné"
