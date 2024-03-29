local addonName, ns = ...
local R = _G.ReduxUI
local TT = R.Modules.Tooltips
local L = R.L

local TOOLTIP_ANCHORS = { "ANCHOR_NONE", "ANCHOR_CURSOR", "ANCHOR_TOP", "ANCHOR_TOPLEFT", "ANCHOR_TOPRIGHT", "ANCHOR_BOTTOM", "ANCHOR_BOTTOMLEFT", "ANCHOR_BOTTOMRIGHT", "ANCHOR_LEFT", "ANCHOR_RIGHT" }

R:RegisterModuleOptions(TT, {
    type = "group",
    name = L["Tooltips"],
    args = {
        header = { type = "header", name = R.title .. " > Tooltips", order = 0 },
        enabled = R:CreateModuleEnabledOption(1, nil, "Tooltips"),
        itemsAndSpells = {
            type = "group",
            name = L["Items & Spells"],
            inline = true,
            order = 10,
            args = {
                showVendorPrice = R:CreateToggleOption(L["Show Vendor Price"], nil, 1, "double", R.isRetail, function()
                    return TT.config.showVendorPrice
                end, function(value)
                    TT.config.showVendorPrice = value
                end),
                showItemLevel = R:CreateToggleOption(L["Show Item Level"], nil, 2, "double", R.isRetail, function()
                    return TT.config.showItemLevel
                end, function(value)
                    TT.config.showItemLevel = value
                end),
                showItemCount = R:CreateToggleOption(L["Show Item Count"], nil, 3, "double", nil, function()
                    return TT.config.showItemCount
                end, function(value)
                    TT.config.showItemCount = value
                end),
                showIcons = R:CreateToggleOption(L["Show Item/Spell Icons"], nil, 4, "double", nil, function()
                    return TT.config.showIcons
                end, function(value)
                    TT.config.showIcons = value
                end),
                showItemId = R:CreateToggleOption(L["Show Item IDs"], nil, 5, "double", nil, function()
                    return TT.config.showItemId
                end, function(value)
                    TT.config.showItemId = value
                end),
                showSpellId = R:CreateToggleOption(L["Show Spell IDs"], nil, 6, "double", nil, function()
                    return TT.config.showSpellId
                end, function(value)
                    TT.config.showSpellId = value
                end)
            }
        },
        players = {
            type = "group",
            name = L["Players & NPCs"],
            inline = true,
            order = 20,
            args = {
                showTitle = R:CreateToggleOption(L["Show Title"], nil, 1, "double", nil, function()
                    return TT.config.showTitle
                end, function(value)
                    TT.config.showTitle = value
                end),
                showGuildRank = R:CreateToggleOption(L["Show Guild Rank"], nil, 2, "double", nil, function()
                    return TT.config.showGuildRank
                end, function(value)
                    TT.config.showGuildRank = value
                end),
                showHealthValues = R:CreateToggleOption(L["Show Health Values"], nil, 3, "double", nil, function()
                    return TT.config.showHealthValues
                end, function(value)
                    TT.config.showHealthValues = value
                end),
                showMount = R:CreateToggleOption(L["Show Mount Info"], nil, 4, "double", nil, function()
                    return TT.config.showMount
                end, function(value)
                    TT.config.showMount = value
                end),
                showGearScore = R:CreateToggleOption(L["Show Gear Score"], nil, 5, "double", nil, function()
                    return TT.config.showGearScore
                end, function(value)
                    TT.config.showGearScore = value
                end),
                showPlayerItemLevel = R:CreateToggleOption(L["Show Average Item Level"], nil, 6, "double", nil, function()
                    return TT.config.showPlayerItemLevel
                end, function(value)
                    TT.config.showPlayerItemLevel = value
                end),
                showPlayerTalents = R:CreateToggleOption(L["Show Talents"], nil, 7, "double", nil, function()
                    return TT.config.showPlayerTalents
                end, function(value)
                    TT.config.showPlayerTalents = value
                end),
                showPlayerDetailsModifier = R:CreateToggleOption(L["Hold Shift to Show Player Details (Gear Score, Item Level, Talents)"], nil, 8, "full", nil, function()
                    return TT.config.showPlayerDetailsModifier
                end, function(value)
                    TT.config.showPlayerDetailsModifier = value
                end)
            }
        },
        font = {
            type = "group",
            name = L["Font"],
            inline = true,
            order = 30,
            args = {
                font = R:CreateFontOption(L["Font"], L["The font to use for tooltip text."], 1, nil, function()
                    return TT.config.fontFamily
                end, function(value)
                    TT.config.fontFamily = value
                end, TT.UpdateFonts),
                size = R:CreateRangeOption(L["Font Size (Body)"], L["The size of tooltip body text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                    return TT.config.fontSize
                end, function(value)
                    TT.config.fontSize = value
                end, TT.UpdateFonts),
                smallFontSize = R:CreateRangeOption(L["Font Size (Small)"], L["The size of small tooltip text."], 3, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                    return TT.config.smallFontSize
                end, function(value)
                    TT.config.smallFontSize = value
                end, TT.UpdateFonts),
                headerFontSize = R:CreateRangeOption(L["Font Size (Header)"], L["The size of tooltip header text."], 4, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                    return TT.config.headerFontSize
                end, function(value)
                    TT.config.headerFontSize = value
                end, TT.UpdateFonts),
                healthFontSize = R:CreateRangeOption(L["Font Size (Health)"], L["The size of tooltip health text."], 5, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                    return TT.config.healthFontSize
                end, function(value)
                    TT.config.healthFontSize = value
                end, TT.UpdateFonts)
            }
        },
        layout = {
            type = "group",
            name = L["Layout"],
            order = 31,
            inline = true,
            args = {
                scale = R:CreateRangeOption(L["Scale"], L["The scale of tooltips."], 1, nil, 0.1, 3, nil, 0.1, function()
                    return TT.config.scale
                end, function(value)
                    TT.config.scale = value
                end, TT.UpdateAll),
                lineBreak = { type = "header", name = "", order = 2 },
                anchor = R:CreateSelectOption(L["Anchor"], L["The default anchor point for  tooltips."], 3, nil, TOOLTIP_ANCHORS, function()
                    return TT.config.anchor
                end, function(value)
                    TT.config.anchor = value
                end, TT.UpdateAll),
                offsetX = R:CreateRangeOption(L["Offset X"], L["The horizontal offset from the anchor."], 4, nil, -100, 100, nil, 1, function()
                    return TT.config.offsetX
                end, function(value)
                    TT.config.offsetX = value
                end, TT.UpdateAll),
                offsetY = R:CreateRangeOption(L["Offset Y"], L["The vertical offset from the anchor."], 5, nil, -100, 100, nil, 1, function()
                    return TT.config.offsetY
                end, function(value)
                    TT.config.offsetY = value
                end, TT.UpdateAll)
            }
        }
    }
})
