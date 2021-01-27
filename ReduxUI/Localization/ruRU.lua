local AddonName, AddonTable = ...
local R = _G.ReduxUI

local L = R.GetLocales("ruRU")
if not L then
    return
end

L["+"] = "+"
L["D"] = "П"
L["R"] = "Р"
