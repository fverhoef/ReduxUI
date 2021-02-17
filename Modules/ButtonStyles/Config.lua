local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.OUT_OF_RANGE_MODES = {Button = "Button", Hotkey = "Hotkey"}

function BS:CreateColorOption(name, option, order)
    return {
        type = "color",
        name = name,
        order = order,
        hasAlpha = false,
        get = function()
            local color = BS.config.colors[option]
            return color[1], color[2], color[3], 1
        end,
        set = function(_, r, g, b, a)
            local color = BS.config.colors[option]
            color[1] = r
            color[2] = g
            color[3] = b
            BS:UpdateAll()
        end
    }
end

function BS:CreateFontFamilyOption(name, parent, order)
    return {
        name = name or "Font Family",
        type = "select",
        desc = "The font family of button text.",
        order = order,
        dialogControl = "LSM30_Font",
        values = R.Libs.SharedMedia:HashTable("font"),
        get = function()
            for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                if BS.config[parent].font == font then
                    return key
                end
            end
        end,
        set = function(_, key)
            BS.config[parent].font = R.Libs.SharedMedia:Fetch("font", key)
            BS:UpdateAll()
        end
    }
end

function BS:CreateFontSizeOption(name, parent, order)
    return {
        name = name or "Font Size",
        type = "range",
        desc = "The size of button text.",
        order = order,
        min = R.FONT_MIN_SIZE,
        max = R.FONT_MAX_SIZE,
        step = 1,
        get = function()
            return BS.config[parent].fontSize
        end,
        set = function(_, val)
            BS.config[parent].fontSize = val
            BS:UpdateAll()
        end
    }
end

function BS:CreateFontOutlineOption(name, parent, order)
    return {
        name = name or "Font Outline",
        type = "select",
        desc = "The outline style of name text.",
        order = order,
        values = R.FONT_OUTLINES,
        get = function()
            return BS.config[parent].fontOutline
        end,
        set = function(_, key)
            BS.config[parent].fontOutline = key
            BS:UpdateAll()
        end
    }
end

R:RegisterModuleConfig(BS, {
    enabled = true,
    borders = {
        texture = R.media.textures.borders.beautycase,
        color = {89 / 255, 89 / 255, 89 / 255, 1},
        pushedColor = {1, 200 / 255, 0, 1}
    },
    outOfRangeColoring = BS.OUT_OF_RANGE_MODES.Button,
    colors = {
        outOfRange = {0.8, 0.1, 0.1},
        usable = {1.0, 1.0, 1.0},
        notEnoughMana = {0.5, 0.5, 1.0},
        notUsable = {0.4, 0.4, 0.4}
    },
    actionBars = {
        font = R.config.defaults.profile.fonts.normal,
        fontSize = 11,
        fontOutline = "OUTLINE",
        borderSize = 4,
        hideKeybindText = false,
        hideMacroText = true
    },
    auras = {font = R.config.defaults.profile.fonts.normal, fontSize = 10, fontOutline = "OUTLINE", borderSize = 4},
    items = {font = R.config.defaults.profile.fonts.normal, fontSize = 12, fontOutline = "OUTLINE", borderSize = 4},
    microMenu = {font = R.config.defaults.profile.fonts.normal, fontSize = 10, fontOutline = "OUTLINE", borderSize = 4}
})

R:RegisterModuleOptions(BS, {
    type = "group",
    name = "Button Styles",
    args = {
        header = {type = "header", name = R.title .. " > Button Styles", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if BS.config.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return BS.config.enabled
            end,
            set = function(_, val)
                BS.config.enabled = val
                if not val then
                    ReloadUI()
                else
                    BS:Initialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2},
        colors = {
            type = "group",
            name = "Colors",
            order = 10,
            inline = true,
            args = {
                usable = BS:CreateColorOption("Usable", "usable", 1),
                notUsable = BS:CreateColorOption("Not Usable", "notUsable", 2),
                notEnoughMana = BS:CreateColorOption("Not Enough Mana", "notEnoughMana", 3),
                lineBreak = {type = "description", name = "", order = 4},
                outOfRange = BS:CreateColorOption("Out of Range", "outOfRange", 5),
                outOfRangeColoring = {
                    type = "select",
                    name = "Out of Range Mode",
                    order = 10,
                    values = BS.OUT_OF_RANGE_MODES,
                    get = function()
                        for key, value in pairs(BS.OUT_OF_RANGE_MODES) do
                            if value == BS.config.outOfRangeColoring then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        BS.config.outOfRangeColoring = BS.OUT_OF_RANGE_MODES[key]
                        BS:UpdateAll()
                    end
                }
            }
        },
        borders = {
            type = "group",
            name = "Borders",
            order = 20,
            inline = true,
            args = {
                texture = {
                    type = "select",
                    name = "Style",
                    desc = "The style of button borders.",
                    order = 1,
                    values = R.BORDER_STYLES,
                    get = function()
                        return BS.config.borders.texture
                    end,
                    set = function(_, key)
                        BS.config.borders.texture = key
                        BS:UpdateAll()
                    end
                },
                color = {
                    type = "color",
                    name = "Normal Color",
                    order = 2,
                    hasAlpha = true,
                    get = function()
                        local color = BS.config.borders.color
                        return color[1], color[2], color[3], color[4] or 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = BS.config.borders.color
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        color[4] = a or 1
                        BS:UpdateAll()
                    end
                },
                pushedColor = {
                    type = "color",
                    name = "Pushed Color",
                    order = 3,
                    hasAlpha = true,
                    get = function()
                        local color = BS.config.borders.pushedColor
                        return color[1], color[2], color[3], color[4] or 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = BS.config.borders.pushedColor
                        color[1] = r
                        color[2] = g
                        color[3] = b
                        color[4] = a or 1
                        BS:UpdateAll()
                    end
                }
            }
        },
        actionBars = {
            type = "group",
            name = "Action Bars",
            order = 30,
            inline = true,
            args = {
                fontFamily = BS:CreateFontFamilyOption(nil, "actionBars", 1),
                fontSize = BS:CreateFontSizeOption(nil, "actionBars", 2),
                fontOutline = BS:CreateFontOutlineOption(nil, "actionBars", 3),
                hideKeybindText = {
                    name = "Hide Keybind Text",
                    type = "toggle",
                    desc = "Whether to hide keybind text.",
                    order = 5,
                    get = function()
                        return BS.config.actionBars.hideKeybindText
                    end,
                    set = function(_, val)
                        BS.config.actionBars.hideKeybindText = val
                        BS:UpdateAll()
                    end
                },
                hideMacroText = {
                    name = "Hide Macro Text",
                    type = "toggle",
                    desc = "Whether to hide macro text.",
                    order = 6,
                    get = function()
                        return BS.config.actionBars.hideMacroText
                    end,
                    set = function(_, val)
                        BS.config.actionBars.hideMacroText = val
                        BS:UpdateAll()
                    end
                }
            }
        },
        auras = {
            type = "group",
            name = "Buffs & Debuffs",
            order = 40,
            inline = true,
            args = {
                fontFamily = BS:CreateFontFamilyOption(nil, "auras", 1),
                fontSize = BS:CreateFontSizeOption(nil, "auras", 2),
                fontOutline = BS:CreateFontOutlineOption(nil, "auras", 3)
            }
        },
        items = {
            type = "group",
            name = "Items",
            order = 50,
            inline = true,
            args = {
                fontFamily = BS:CreateFontFamilyOption(nil, "items", 1),
                fontSize = BS:CreateFontSizeOption(nil, "items", 2),
                fontOutline = BS:CreateFontOutlineOption(nil, "items", 3)
            }
        }
    }
})
