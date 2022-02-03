local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

R:RegisterModuleConfig(B, {
    enabled = true,
    inventory = {slotSize = 40, columns = 10},
    bank = {slotSize = 40, columns = 12},
    colors = {questItem = {1, 1, 0}}
})
