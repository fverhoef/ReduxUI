local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

R:RegisterModuleConfig(B, {
    enabled = true,
    inventory = {
        point = { "BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -100, 100 },
        slotSize = 40,
        columns = 10,
        buttonStyle = { font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"), fontSize = 11, fontOutline = "OUTLINE" },
        slotStyle = { font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"), fontSize = 11, fontOutline = "OUTLINE" },
        sorting = {}
    },
    bank = {
        point = { "BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 100, 100 },
        slotSize = 40,
        columns = 12,
        buttonStyle = { font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"), fontSize = 11, fontOutline = "OUTLINE" },
        slotStyle = { font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"), fontSize = 11, fontOutline = "OUTLINE" },
        sorting = {}
    },
    colors = { questItem = { 1, 1, 0 } }
})
