local addonName, ns = ...
local R = _G.ReduxUI

local L = R.GetLocales("ptBR")
if not L then
    return
end

L["+"] = "+"
L["D"] = "M"
L["R"] = "R"
L["Chained Spirit"] = "Espírito Acorrentado"
