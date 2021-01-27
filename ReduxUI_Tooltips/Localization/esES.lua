local AddonName, AddonTable = ...
local R = _G.ReduxUI

local L = R.GetLocales("esES") or R.GetLocales("esMX")
if not L then
    return
end
