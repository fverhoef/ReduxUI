local addonName, ns = ...
local R = _G.ReduxUI
local C = R.Modules.Chat

R:RegisterModuleConfig(C, {
    enabled = true,
    size = { 488, 210 },
    point = { "BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 20, 20 },
    font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
    fontSize = 12,
    fontOutline = "OUTLINE",
    fontShadow = false,
    maxMessageCount = 1500,
    maxHistoryCount = 500,
    fade = true,
    showClassColors = true,
    hideMenuButton = true,
    hideChannelButton = true,
    hideSocialButton = true
}, { chatMessages = {} })
