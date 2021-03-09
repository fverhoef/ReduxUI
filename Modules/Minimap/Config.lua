local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap

R:RegisterModuleConfig(MM, {
    enabled = true,
    point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -13, -13},
    size = {190, 190},
    enableMailGlow = false,
    showNorthTag = true,
    zoneText = {
        enabled = true,
        showBackground = false,
        font = R.config.defaults.profile.fonts.normal,
        fontSize = 14,
        fontOutline = "OUTLINE",
        fontShadow = true,
        justifyH = "CENTER"
    },
    infoPanel = {enabled = true, showBackground = false, showTime = true},
    mask = R.media.textures.minimap.minimapMask3,
    border = {enabled = true, size = 4, texture = R.media.textures.borders.beautycase, color = {89 / 255, 89 / 255, 89 / 255, 1}},
    shadow = {enabled = true},
    gloss = {enabled = true, texture = R.media.textures.borders.gloss1},
    buttonFrame = {enabled = true, iconSize = 22, buttonSpacing = 2, collapsed = true}
})

R:RegisterModuleOptions(MM, {
    type = "group",
    name = "Minimap",
    args = {
        header = {type = "header", name = R.title .. " > Minimap", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if MM.config.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return MM.config.enabled
            end,
            set = function(_, val)
                MM.config.enabled = val
                if not val then
                    ReloadUI()
                else
                    MM:Initialize()
                end
            end
        },
        lineBreak1 = {type = "header", name = "", order = 2},
        border = {
            type = "group",
            name = "Border",
            order = 3,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return MM.config.border.enabled
                    end,
                    set = function(_, val)
                        MM.config.border.enabled = val
                        MM:UpdateMinimap()
                    end
                }
            }
        },
        zoneText = {
            type = "group",
            name = "Zone Text",
            order = 4,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return MM.config.zoneText.enabled
                    end,
                    set = function(_, val)
                        MM.config.zoneText.enabled = val
                        MM:UpdateMinimap()
                    end
                },
                lineBreak1 = {type = "description", name = "", order = 2},
                showBackground = {
                    type = "toggle",
                    name = "Show Background",
                    order = 10,
                    get = function()
                        return MM.config.zoneText.showBackground
                    end,
                    set = function(_, val)
                        MM.config.zoneText.showBackground = val
                        MM:UpdateMinimap()
                    end
                },
                lineBreak2 = {type = "description", name = "", order = 20},

                font = {
                    name = "Font Family",
                    type = "select",
                    desc = "The font family for zone text.",
                    order = 21,
                    dialogControl = "LSM30_Font",
                    values = R.Libs.SharedMedia:HashTable("font"),
                    get = function()
                        for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                            if MM.config.zoneText.font == font then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        MM.config.zoneText.font = R.Libs.SharedMedia:Fetch("font", key)
                        MM:UpdateMinimap()
                    end
                },
                fontSize = {
                    name = "Font Size",
                    type = "range",
                    desc = "The size of zone text.",
                    order = 22,
                    min = R.FONT_MIN_SIZE,
                    max = R.FONT_MAX_SIZE,
                    step = 1,
                    get = function()
                        return MM.config.zoneText.fontSize
                    end,
                    set = function(_, val)
                        MM.config.zoneText.fontSize = val
                        MM:UpdateMinimap()
                    end
                },
                fontOutline = {
                    name = "Font Outline",
                    type = "select",
                    desc = "The outline style of zone text.",
                    order = 23,
                    values = R.FONT_OUTLINES,
                    get = function()
                        return MM.config.zoneText.fontOutline
                    end,
                    set = function(_, key)
                        MM.config.zoneText.fontOutline = key
                        MM:UpdateMinimap()
                    end
                },
                justifyH = {
                    name = "Horizontal Justification",
                    type = "select",
                    desc = "The horizontal alignment of zone text.",
                    order = 24,
                    values = R.JUSTIFY_H,
                    get = function()
                        return MM.config.zoneText.justifyH
                    end,
                    set = function(_, key)
                        MM.config.zoneText.justifyH = key
                        MM:UpdateMinimap()
                    end
                },
                fontShadow = {
                    name = "Font Shadows",
                    type = "toggle",
                    desc = "Whether to show shadow for zone text.",
                    order = 25,
                    get = function()
                        return MM.config.zoneText.fontShadow
                    end,
                    set = function(_, val)
                        MM.config.zoneText.fontShadow = val
                        MM:UpdateMinimap()
                    end
                }
            }
        },
        infoPanel = {
            type = "group",
            name = "Information Panel",
            order = 5,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return MM.config.infoPanel.enabled
                    end,
                    set = function(_, val)
                        MM.config.infoPanel.enabled = val
                        MM:UpdateMinimap()
                    end
                },
                lineBreak1 = {type = "description", name = "", order = 2},
                showBackground = {
                    type = "toggle",
                    name = "Show Background",
                    order = 10,
                    get = function()
                        return MM.config.infoPanel.showBackground
                    end,
                    set = function(_, val)
                        MM.config.infoPanel.showBackground = val
                        MM:UpdateMinimap()
                    end
                }
            }
        },
        buttonFrame = {
            type = "group",
            name = "Button Frame",
            order = 6,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return MM.config.buttonFrame.enabled
                    end,
                    set = function(_, val)
                        MM.config.buttonFrame.enabled = val
                        MM:UpdateMinimap()
                    end
                },
                lineBreak1 = {type = "description", name = "", order = 2},
                iconSize = {
                    name = "Button Size",
                    type = "range",
                    desc = "The size of the minimap buttons.",
                    order = 11,
                    min = 10,
                    softMax = 50,
                    step = 1,
                    get = function()
                        return MM.config.buttonFrame.iconSize
                    end,
                    set = function(_, val)
                        MM.config.buttonFrame.iconSize = val
                        MM:UpdateMinimap()
                    end
                },
                buttonSpacing = {
                    name = "Button Spacing",
                    type = "range",
                    desc = "The spacing between minimap buttons.",
                    order = 12,
                    min = 0,
                    softMax = 50,
                    step = 1,
                    get = function()
                        return MM.config.buttonFrame.buttonSpacing
                    end,
                    set = function(_, val)
                        MM.config.buttonFrame.buttonSpacing = val
                        MM:UpdateMinimap()
                    end
                },
            }
        },
        border = {
            type = "group",
            name = "Border",
            order = 21,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return MM.config.border.enabled
                    end,
                    set = function(_, val)
                        MM.config.border.enabled = val
                        MM:UpdateMinimap()
                    end
                }
            }
        },
        shadow = {
            type = "group",
            name = "Shadow",
            order = 22,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return MM.config.shadow.enabled
                    end,
                    set = function(_, val)
                        MM.config.shadow.enabled = val
                        MM:UpdateMinimap()
                    end
                }
            }
        },
        gloss = {
            type = "group",
            name = "Gloss",
            order = 23,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return MM.config.gloss.enabled
                    end,
                    set = function(_, val)
                        MM.config.gloss.enabled = val
                        MM:UpdateMinimap()
                    end
                }
            }
        }
    }
})
