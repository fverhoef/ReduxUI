local addonName, ns = ...
local R = _G.ReduxUI
local C = R.Modules.Chat

R:RegisterModuleConfig(C, {
    enabled = true,
    font = R.config.defaults.profile.fonts.normal,
    fontSize = 12,
    fontOutline = "OUTLINE",
    fontShadow = false,
    maxMessageCount = 1500,
    maxHistoryCount = 500,
    showClassColors = true,
    hideMenuButton = true,
    hideChannelButton = true
}, {chatMessages = {}})