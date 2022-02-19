local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

R:RegisterModuleConfig(B, {
    enabled = true,
    inventory = {point = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -100, 100}, slotSize = 40, columns = 10},
    bank = {point = {"BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 100, 100}, slotSize = 40, columns = 12},
    colors = {questItem = {1, 1, 0}}
})
