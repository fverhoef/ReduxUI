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
    return R:CreateFontOption(L["Font Family"], L["The font to use for button text."], order, nil, function()
        return BS.config[parent].font
    end, function(value)
        BS.config[parent].font = value
    end, BS.UpdateAll)
end

function BS:CreateFontSizeOption(parent, order)
    return R:CreateRangeOption(L["Font Size"], L["The size of chat text."], order, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
        return BS.config[parent].fontSize
    end, function(value)
        BS.config[parent].fontSize = value
    end, BS.UpdateAll)
end

function BS:CreateFontOutlineOption(parent, order)
    return R:CreateSelectOption(L["Font Outline"], L["The outline style of this button type."], order, nil, R.FONT_OUTLINES, function()
        return BS.config[parent].fontOutline
    end, function(value)
        BS.config[parent].fontOutline = value
    end, BS.UpdateAll)
end

function BS:CreateGlowOption(parent, option, order)
    return R:CreateToggleOption(L["Gloss"], L["Whether to show a gloss inlay for this button type."], 4, nil, nil, function()
        return BS.config[parent][option]
    end, function(value)
        BS.config[parent][option] = val
    end, BS.UpdateAll)
end

R:RegisterModuleOptions(BS, {
    type = "group",
    name = L["Button Styles"],
    args = {
        header = { type = "header", name = R.title .. " > Button Styles", order = 0 },
        enabled = R:CreateModuleEnabledOption(1, nil, "ButtonStyles"),
        lineBreak = { type = "header", name = "", order = 2 },
        colors = {
            type = "group",
            name = "Colors",
            order = 10,
            inline = true,
            args = {
                border = BS:CreateColorOption(L["Normal Border"], "border", 1),
                pushed = BS:CreateColorOption(L["Pushed Border"], "pushed", 2),
                equipped = BS:CreateColorOption(L["Equipped Border"], "equipped", 3),
                lineBreak = { type = "description", name = "", order = 4 },
                usable = BS:CreateColorOption(L["Usable"], "usable", 5),
                notUsable = BS:CreateColorOption(L["Not Usable"], "notUsable", 6),
                notEnoughMana = BS:CreateColorOption(L["Not Enough Mana"], "notEnoughMana", 7),
                lineBreak = { type = "description", name = "", order = 8 },
                outOfRange = BS:CreateColorOption(L["Out of Range"], "outOfRange", 9),
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
                }
            }
        },
        auras = {
            type = "group",
            name = L["Buffs & Debuffs"],
            order = 40,
            inline = true,
            args = { fontFamily = BS:CreateFontFamilyOption("auras", 1), fontSize = BS:CreateFontSizeOption("auras", 2), fontOutline = BS:CreateFontOutlineOption("auras", 3) }
        },
        items = {
            type = "group",
            name = L["Items"],
            order = 50,
            inline = true,
            args = { fontFamily = BS:CreateFontFamilyOption("items", 1), fontSize = BS:CreateFontSizeOption("items", 2), fontOutline = BS:CreateFontOutlineOption("items", 3) }
        }
    }
})
