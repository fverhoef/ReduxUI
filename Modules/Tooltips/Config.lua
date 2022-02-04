local addonName, ns = ...
local R = _G.ReduxUI
local TT = R.Modules.Tooltips

R:RegisterModuleConfig(TT, {
    enabled = true,
    colors = {
        text = {100 / 255, 100 / 255, 100 / 255},
        boss = {255 / 255, 0 / 255, 0 / 255},
        elite = {255 / 255, 0 / 255, 125 / 255},
        rareElite = {255 / 255, 125 / 255, 0 / 255},
        rare = {255 / 255, 125 / 255, 0 / 255},
        level = {200 / 255, 200 / 255, 125 / 255},
        dead = {125 / 255, 125 / 255, 125 / 255},
        target = {255 / 255, 125 / 255, 125 / 255},
        guild = {0 / 255, 230 / 255, 0 / 255},
        afk = {0 / 255, 255 / 255, 255 / 255},
        pvp = {220 / 255, 120 / 255, 30 / 255},
        itemLevel = {220 / 255, 195 / 255, 30 / 255}
    },
    scale = 1,
    fontFamily = R.config.defaults.profile.fonts.normal,
    fontSize = 12,
    headerFontSize = 14,
    smallFontSize = 11,
    healthFontSize = 12,
    anchor = "ANCHOR_CURSOR",
    offsetX = 20,
    offsetY = 20,
    statusbar = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
    colorBorderByRarity = true,
    showHealthValues = true,
    showPvPRank = true,
    showIcons = true,
    showSpellId = false,
    showItemId = false,
    showItemLevel = true,
    showItemCount = true,
    showVendorPrice = true
})
