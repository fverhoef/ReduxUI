local addonName, ns = ...
local R = _G.ReduxUI

local L = R.GetLocales("esES") or R.GetLocales("esMX")
if not L then
    return
end

L["+"] = "+"
L["D"] = locale == "esMX" and "C" or "M"
L["R"] = "B"
L["Chained Spirit"] = "Espíritu encadenado"
