local addonName, ns = ...
local R = _G.ReduxUI

local L = R.GetLocales("koKR")
if not L then
    return
end

L["+"] = "+"
L["D"] = "D"
L["R"] = "R"
L["Chained Spirit"] = "구속된 영혼"
