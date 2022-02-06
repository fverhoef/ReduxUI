local addonName, ns = ...
local R = _G.ReduxUI

local L = R.GetLocales("zhTW")
if not L then
    return
end

L["+"] = "+"
L["D"] = "地城"
L["R"] = "團隊"
L["Chained Spirit"] = "禁錮之魂"
