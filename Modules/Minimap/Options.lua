local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap
local L = R.L

R:RegisterModuleOptions(MM, {
    type = "group",
    name = L["Minimap"],
    args = {
        header = { type = "header", name = R.title .. " > Minimap", order = 0 },
        enabled = R:CreateModuleEnabledOption(1, nil, "Minimap"),
        lineBreak1 = { type = "header", name = "", order = 2 },
        styling = {
            type = "group",
            name = L["Styling"],
            order = 3,
            inline = true,
            args = {
                style = R:CreateSelectOption(L["Style"], L["The style preset for the minimap."], 1, nil, MM.Styles, function()
                    return MM.config.style
                end, function(value)
                    MM.config.style = value
                end, MM.UpdateMinimap)
            }
        },
        elements = {
            type = "group",
            name = L["Elements"],
            order = 4,
            inline = true,
            args = {
                showNorthTag = R:CreateToggleOption(L["Show North Tag"], nil, 1, nil, nil, function()
                    return MM.config.showNorthTag
                end, function(value)
                    MM.config.showNorthTag = value
                end, MM.UpdateMinimap),
                showWorldMap = R:CreateToggleOption(L["Show World Map Toggle"], nil, 2, nil, nil, function()
                    return MM.config.showWorldMap
                end, function(value)
                    MM.config.showWorldMap = value
                end, MM.UpdateMinimap)
            }
        },
        zonePanel = {
            type = "group",
            name = L["Zone Panel"],
            order = 5,
            inline = true,
            args = {
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function()
                    return MM.config.zonePanel.enabled
                end, function(value)
                    MM.config.zonePanel.enabled = value
                end, MM.UpdateMinimap),
                lineBreak1 = { type = "description", name = "", order = 10 },
                font = {
                    type = "group",
                    name = L["Zone Font"],
                    inline = true,
                    order = 21,
                    args = {
                        font = R:CreateFontOption(L["Font"], L["The font to use for zone text."], 1, nil, function()
                            return MM.config.zonePanel.zoneText.font
                        end, function(value)
                            MM.config.zonePanel.zoneText.font = value
                        end, MM.UpdateMinimap),
                        size = R:CreateRangeOption(L["Font Size"], L["The size of zone text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                            return MM.config.zonePanel.zoneText.fontSize
                        end, function(value)
                            MM.config.zonePanel.zoneText.fontSize = value
                        end, MM.UpdateMinimap),
                        outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of zone text."], 3, nil, R.FONT_OUTLINES, function()
                            return MM.config.zonePanel.zoneText.fontOutline
                        end, function(value)
                            MM.config.zonePanel.zoneText.fontOutline = value
                        end, MM.UpdateMinimap),
                        justifyH = R:CreateSelectOption(L["Horizontal Justification"], L["The horizontal alignment of zone text."], 4, nil, R.JUSTIFY_H, function()
                            return MM.config.zonePanel.zoneText.justifyH
                        end, function(value)
                            MM.config.zonePanel.zoneText.justifyH = value
                        end, MM.UpdateMinimap),
                        shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for zone text."], 5, nil, nil, function()
                            return MM.config.zonePanel.zoneText.fontShadow
                        end, function(value)
                            MM.config.zonePanel.zoneText.fontShadow = value
                        end, MM.UpdateMinimap),
                        lineBreak1 = { type = "description", name = "", order = 10 }
                    }
                },
                showBorder = R:CreateToggleOption(L["Show Border"], L["Whether to show the zone panel's border."], 31, nil, nil, function()
                    return MM.config.zonePanel.showBorder
                end, function(value)
                    MM.config.zonePanel.showBorder = value
                end, MM.UpdateMinimap)
            }
        },
        buttonFrame = {
            type = "group",
            name = L["Button Frame"],
            order = 6,
            inline = true,
            args = {
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function()
                    return MM.config.buttonFrame.enabled
                end, function(value)
                    MM.config.buttonFrame.enabled = value
                end, MM.UpdateMinimap),
                lineBreak1 = { type = "description", name = "", order = 2 },
                iconSize = R:CreateRangeOption(L["Button Size"], L["The size of the minimap buttons."], 3, nil, 10, nil, 50, 1, function()
                    return MM.config.buttonFrame.iconSize
                end, function(value)
                    MM.config.buttonFrame.iconSize = value
                end, MM.UpdateMinimap),
                buttonSpacing = R:CreateRangeOption(L["Button Spacing"], L["The spacing between minimap buttons."], 4, nil, 0, nil, 50, 1, function()
                    return MM.config.buttonFrame.buttonSpacing
                end, function(value)
                    MM.config.buttonFrame.buttonSpacing = value
                end, MM.UpdateMinimap),
                showBorder = R:CreateToggleOption(L["Show Border"], L["Whether to show the button frame's border."], 5, nil, nil, function()
                    return MM.config.buttonFrame.showBorder
                end, function(value)
                    MM.config.buttonFrame.showBorder = value
                end, MM.UpdateMinimap)
            }
        }
    }
})
