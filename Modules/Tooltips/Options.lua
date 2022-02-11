local addonName, ns = ...
local R = _G.ReduxUI
local TT = R.Modules.Tooltips
local L = R.L

local TOOLTIP_ANCHORS = {
    "ANCHOR_NONE",
    "ANCHOR_CURSOR",
    "ANCHOR_TOP",
    "ANCHOR_TOPLEFT",
    "ANCHOR_TOPRIGHT",
    "ANCHOR_BOTTOM",
    "ANCHOR_BOTTOMLEFT",
    "ANCHOR_BOTTOMRIGHT",
    "ANCHOR_LEFT",
    "ANCHOR_RIGHT"
}

R:RegisterModuleOptions(TT, {
    type = "group",
    name = L["Tooltips"],
    args = {
        header = {type = "header", name = R.title .. " > Tooltips", order = 0},
        enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return TT.config.enabled end, function(value) TT.config.enabled = value end,
                                       function() (not TT.config.enabled and ReloadUI or C.Initialize)() end,
                                       function() return TT.config.enabled and L["Disabling this module requires a UI reload. Proceed?"] end),
        lineBreak = {type = "header", name = "", order = 2},
        showHealthValues = R:CreateToggleOption(L["Show Health Values"], nil, 10, "double", nil, function() return TT.config.showHealthValues end,
                                                function(value) TT.config.showHealthValues = value end),
        showGuildRank = R:CreateToggleOption(L["Show Guild Rank"], nil, 11, "double", nil, function() return TT.config.showGuildRank end, function(value) TT.config.showGuildRank = value end),
        showPvPRank = R:CreateToggleOption(L["Show PvP Rank"], nil, 12, "double", R.isRetail, function() return TT.config.showPvPRank end, function(value) TT.config.showPvPRank = value end),
        showVendorPrice = R:CreateToggleOption(L["Show Vendor Price"], nil, 13, "double", R.isRetail, function() return TT.config.showVendorPrice end,
                                               function(value) TT.config.showVendorPrice = value end),
        showItemLevel = R:CreateToggleOption(L["Show Item Level"], nil, 14, "double", R.isRetail, function() return TT.config.showItemLevel end, function(value) TT.config.showItemLevel = value end),
        showItemCount = R:CreateToggleOption(L["Show Item Count"], nil, 15, "double", nil, function() return TT.config.showItemCount end, function(value) TT.config.showItemCount = value end),
        showIcons = R:CreateToggleOption(L["Show Item/Spell Icons"], nil, 16, "double", nil, function() return TT.config.showIcons end, function(value) TT.config.showIcons = value end),
        showItemId = R:CreateToggleOption(L["Show Item IDs"], nil, 17, "double", nil, function() return TT.config.showItemId end, function(value) TT.config.showItemId = value end),
        showSpellId = R:CreateToggleOption(L["Show Spell IDs"], nil, 18, "double", nil, function() return TT.config.showSpellId end, function(value) TT.config.showSpellId = value end),
        font = {
            type = "group",
            name = L["Font"],
            inline = true,
            order = 20,
            args = {
                font = R:CreateFontOption(L["Font"], L["The font to use for tooltip text."], 1, nil, function() return TT.config.fontFamily end, function(value)
                    TT.config.fontFamily = value
                end, TT.UpdateFonts),
                size = R:CreateRangeOption(L["Font Size (Body)"], L["The size of tooltip body text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                    return TT.config.fontSize
                end, function(value) TT.config.fontSize = value end, TT.UpdateFonts),
                smallFontSize = R:CreateRangeOption(L["Font Size (Small)"], L["The size of small tooltip text."], 3, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1,
                                                    function() return TT.config.smallFontSize end, function(value) TT.config.smallFontSize = value end, TT.UpdateFonts),
                headerFontSize = R:CreateRangeOption(L["Font Size (Header)"], L["The size of tooltip header text."], 4, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1,
                                                     function() return TT.config.headerFontSize end, function(value) TT.config.headerFontSize = value end, TT.UpdateFonts),
                healthFontSize = R:CreateRangeOption(L["Font Size (Health)"], L["The size of tooltip health text."], 5, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1,
                                                     function() return TT.config.healthFontSize end, function(value) TT.config.healthFontSize = value end, TT.UpdateFonts)
            }
        },
        layout = {
            type = "group",
            name = L["Layout"],
            order = 21,
            inline = true,
            args = {
                scale = R:CreateRangeOption(L["Scale"], L["The scale of tooltips."], 1, nil, 0.1, 3, nil, 0.1, function() return TT.config.scale end, function(value)
                    TT.config.scale = value
                end, TT.UpdateAll),
                lineBreak = {type = "header", name = "", order = 2},
                anchor = R:CreateSelectOption(L["Anchor"], L["The default anchor point for  tooltips."], 3, nil, TOOLTIP_ANCHORS, function() return TT.config.anchor end,
                                              function(value) TT.config.anchor = value end, TT.UpdateAll),
                offsetX = R:CreateRangeOption(L["Offset X"], L["The horizontal offset from the anchor."], 4, nil, -100, 100, nil, 1, function() return TT.config.offsetX end,
                                              function(value) TT.config.offsetX = value end, TT.UpdateAll),
                offsetY = R:CreateRangeOption(L["Offset Y"], L["The vertical offset from the anchor."], 5, nil, -100, 100, nil, 1, function() return TT.config.offsetY end,
                                              function(value) TT.config.offsetY = value end, TT.UpdateAll)
            }
        }
    }
})
