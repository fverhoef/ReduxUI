local addonName, ns = ...
local R = _G.ReduxUI

local L = R.GetLocales("zhCN")
if not L then
    return
end

L["+"] = "+"
L["D"] = "地城"
L["R"] = "团本"
L["Chained Spirit"] = "被禁锢的灵魂"
