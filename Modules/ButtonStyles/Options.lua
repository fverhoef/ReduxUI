local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles
local L = R.L

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

function BS:CreateFontFamilyOption(parent, order)
    return {
        name = L["Font Family"],
        type = "select",
        desc = L["The font family of button text."],
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

function BS:CreateFontSizeOption(parent, order)
    return {
        name = L["Font Size"],
        type = "range",
        desc = L["The size of button text."],
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

function BS:CreateFontOutlineOption(parent, order)
    return {
        name = L["Font Outline"],
        type = "select",
        desc = L["The outline style of name text."],
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

function BS:CreateGlowOption(parent, option, order)
    return {
        type = "toggle",
        name = L["Gloss"],
        order = order,
        get = function()
            return BS.config[parent][option]
        end,
        set = function(_, val)
            BS.config[parent][option] = val
            BS:UpdateAll()
        end
    }
end

R:RegisterModuleOptions(BS, {
    type = "group",
    name = L["Button Styles"],
    args = {
        header = {type = "header", name = R.title .. " > Button Styles", order = 0},
        enabled = {
            type = "toggle",
            name = L["Enabled"],
            order = 1,
            confirm = function()
                if BS.config.enabled then
                    return L["Disabling this module requires a UI reload. Proceed?"]
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
                border = BS:CreateColorOption(L["Normal Border"], "border", 1),
                pushed = BS:CreateColorOption(L["Pushed Border"], "pushed", 1),
                lineBreak = {type = "description", name = "", order = 3},
                usable = BS:CreateColorOption(L["Usable"], "usable", 4),
                notUsable = BS:CreateColorOption(L["Not Usable"], "notUsable", 5),
                notEnoughMana = BS:CreateColorOption(L["Not Enough Mana"], "notEnoughMana", 6),
                lineBreak = {type = "description", name = "", order = 7},
                outOfRange = BS:CreateColorOption(L["Out of Range"], "outOfRange", 8),
                outOfRangeColoring = {
                    type = "select",
                    name = L["Out of Range Mode"],
                    order = 9,
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
        actions = {
            type = "group",
            name = L["Actions"],
            order = 30,
            inline = true,
            args = {
                fontFamily = BS:CreateFontFamilyOption("actions", 1),
                fontSize = BS:CreateFontSizeOption("actions", 2),
                fontOutline = BS:CreateFontOutlineOption("actions", 3),
                hideKeybindText = {
                    name = L["Hide Keybind Text"],
                    type = "toggle",
                    desc = L["Whether to hide keybind text."],
                    order = 5,
                    get = function()
                        return BS.config.actions.hideKeybindText
                    end,
                    set = function(_, val)
                        BS.config.actions.hideKeybindText = val
                        BS:UpdateAll()
                    end
                },
                hideMacroText = {
                    name = L["Hide Macro Text"],
                    type = "toggle",
                    desc = L["Whether to hide macro text."],
                    order = 6,
                    get = function()
                        return BS.config.actions.hideMacroText
                    end,
                    set = function(_, val)
                        BS.config.actions.hideMacroText = val
                        BS:UpdateAll()
                    end
                },
                gloss = BS:CreateGlowOption("actions", "gloss", 10)
            }
        },
        auras = {
            type = "group",
            name = L["Buffs & Debuffs"],
            order = 40,
            inline = true,
            args = {
                fontFamily = BS:CreateFontFamilyOption("auras", 1),
                fontSize = BS:CreateFontSizeOption("auras", 2),
                fontOutline = BS:CreateFontOutlineOption("auras", 3),
                gloss = BS:CreateGlowOption("auras", "gloss", 4)
            }
        },
        items = {
            type = "group",
            name = L["Items"],
            order = 50,
            inline = true,
            args = {
                fontFamily = BS:CreateFontFamilyOption("items", 1),
                fontSize = BS:CreateFontSizeOption("items", 2),
                fontOutline = BS:CreateFontOutlineOption("items", 3),
                gloss = BS:CreateGlowOption("items", "gloss", 4)
            }
        }
    }
})
