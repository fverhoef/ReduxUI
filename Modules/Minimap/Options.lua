local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap
local L = R.L

R:RegisterModuleOptions(MM, {
    type = "group",
    name = "Minimap",
    args = {
        header = {type = "header", name = R.title .. " > Minimap", order = 0},
        enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return MM.config.enabled end, function(value) MM.config.enabled = value end,
                                       function() (not MM.config.enabled and ReloadUI or MM.Initialize)() end,
                                       function() return MM.config.enabled and L["Disabling this module requires a UI reload. Proceed?"] end),
        lineBreak1 = {type = "header", name = "", order = 2},
        zoneText = {
            type = "group",
            name = L["Zone Text"],
            order = 4,
            inline = true,
            args = {
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return MM.config.zoneText.enabled end, function(value) MM.config.zoneText.enabled = value end,
                                               MM.UpdateMinimap),
                lineBreak1 = {type = "description", name = "", order = 10},
                showBackground = R:CreateToggleOption(L["Show Background"], nil, 11, nil, nil, function() return MM.config.zoneText.showBackground end,
                                                      function(value) MM.config.zoneText.showBackground = value end, MM.UpdateMinimap),
                font = {
                    type = "group",
                    name = L["Font"],
                    inline = true,
                    order = 21,
                    args = {
                        font = R:CreateFontOption(L["Font"], L["The font to use for zone text."], 1, nil, function() return MM.config.zoneText.font end,
                                                  function(value) MM.config.zoneText.font = value end, MM.UpdateMinimap),
                        size = R:CreateRangeOption(L["Font Size"], L["The size of zone text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                            return MM.config.zoneText.fontSize
                        end, function(value) MM.config.zoneText.fontSize = value end, MM.UpdateMinimap),
                        outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of zone text."], 3, nil, R.FONT_OUTLINES, function()
                            return MM.config.zoneText.fontOutline
                        end, function(value) MM.config.zoneText.fontOutline = value end, MM.UpdateMinimap),
                        justifyH = R:CreateSelectOption(L["Horizontal Justification"], L["The horizontal alignment of zone text."], 4, nil, R.JUSTIFY_H,
                                                        function() return MM.config.zoneText.justifyH end, function(value) MM.config.zoneText.justifyH = value end, MM.UpdateMinimap),
                        shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for zone text."], 5, nil, nil, function() return MM.config.zoneText.fontShadow end,
                                                      function(value) MM.config.zoneText.fontShadow = value end, MM.UpdateMinimap)
                    }
                }
            }
        },
        infoPanel = {
            type = "group",
            name = L["Information Panel"],
            order = 5,
            inline = true,
            args = {
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return MM.config.infoPanel.enabled end, function(value) MM.config.infoPanel.enabled = value end,
                                               MM.UpdateMinimap),
                lineBreak1 = {type = "description", name = "", order = 2},
                showBackground = R:CreateToggleOption(L["Show Background"], nil, 11, nil, nil, function() return MM.config.infoPanel.showBackground end,
                                                      function(value) MM.config.infoPanel.showBackground = value end, MM.UpdateMinimap)
            }
        },
        buttonFrame = {
            type = "group",
            name = "Button Frame",
            order = 6,
            inline = true,
            args = {
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return MM.config.buttonFrame.enabled end, function(value) MM.config.buttonFrame.enabled = value end,
                                               MM.UpdateMinimap),
                lineBreak1 = {type = "description", name = "", order = 2},
                iconSize = R:CreateRangeOption(L["Button Size"], L["The size of the minimap buttons."], 11, nil, 10, nil, 50, 1, function() return MM.config.buttonFrame.iconSize end,
                                               function(value) MM.config.buttonFrame.iconSize = value end, MM.UpdateMinimap),
                buttonSpacing = R:CreateRangeOption(L["Button Spacing"], L["The spacing between minimap buttons."], 12, nil, 0, nil, 50, 1, function()
                    return MM.config.buttonFrame.buttonSpacing
                end, function(value) MM.config.buttonFrame.buttonSpacing = value end, MM.UpdateMinimap)
            }
        },
        border = {
            type = "group",
            name = "Border",
            order = 21,
            inline = true,
            args = {
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return MM.config.border.enabled end, function(value) MM.config.border.enabled = value end, MM.UpdateMinimap)
            }
        },
        shadow = {
            type = "group",
            name = "Shadow",
            order = 22,
            inline = true,
            args = {
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return MM.config.shadow.enabled end, function(value) MM.config.shadow.enabled = value end, MM.UpdateMinimap)
            }
        }
    }
})
