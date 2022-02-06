local addonName, ns = ...
local R = _G.ReduxUI

local L = R.GetLocales("deDE")
if not L then
    return
end

L["+"] = "+"
L["D"] = "D"
L["R"] = "S"
L["Chained Spirit"] = "Angeketteter Geist"
