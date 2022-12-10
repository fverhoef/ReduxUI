local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

R:RegisterModuleConfig(B, {
    enabled = true,
    inventory = {
        point = { "BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -100, 100 },
        slotSize = 40,
        columns = 10,
        buttonStyle = {
            countFont = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            countFontSize = 11,
            countFontOutline = "OUTLINE",
            stockFont = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            stockFontSize = 11,
            stockFontOutline = "OUTLINE"
        }
    },
    bank = {
        point = { "BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 100, 100 },
        slotSize = 40,
        columns = 12,
        buttonStyle = {
            countFont = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            countFontSize = 11,
            countFontOutline = "OUTLINE",
            stockFont = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            stockFontSize = 11,
            stockFontOutline = "OUTLINE"
        }
    },
    colors = { questItem = { 1, 1, 0 } }
})
