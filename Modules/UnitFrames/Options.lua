local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateStatusBarTextureOption(name, desc, option, order)
    return {
        type = "select",
        name = name,
        desc = desc,
        order = order,
        dialogControl = "LSM30_Statusbar",
        values = R.Libs.SharedMedia:HashTable("statusbar"),
        get = function()
            for key, texture in pairs(R.Libs.SharedMedia:HashTable("statusbar")) do if UF.config.statusbars[option] == texture then return key end end
        end,
        set = function(_, key)
            UF.config.statusbars[option] = R.Libs.SharedMedia:Fetch("statusbar", key)
            UF:UpdateAll()
        end
    }
end

function UF:CreateStatusBarColorOption(name, option, order)
    return {
        type = "color",
        name = name,
        order = order,
        hasAlpha = false,
        get = function()
            local color = UF.config.colors[option]
            return color[1], color[2], color[3], 1
        end,
        set = function(_, r, g, b, a)
            local color = UF.config.colors[option]
            color[1] = r
            color[2] = g
            color[3] = b
            UF:UpdateAll()
        end
    }
end

function UF:CreateClassColorOption(class, name, order, hidden)
    return {
        type = "color",
        name = name,
        order = order,
        hidden = hidden,
        hasAlpha = false,
        get = function()
            local color = UF.config.colors.class[class]
            return color[1], color[2], color[3], 1
        end,
        set = function(_, r, g, b, a)
            local color = UF.config.colors.class[class]
            color[1] = r
            color[2] = g
            color[3] = b
            UF:UpdateAll()
        end
    }
end

R:RegisterModuleOptions(UF, {
    type = "group",
    name = "Unit Frames",
    args = {
        header = {type = "header", name = R.title .. " > Unit Frames", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if UF.config.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return UF.config.enabled
            end,
            set = function(_, val)
                UF.config.enabled = val
                if not val then
                    ReloadUI()
                else
                    UF:Initialize()
                end
            end
        },
        lineBreak1 = {type = "header", name = "", order = 2},
        fonts = {
            type = "group",
            name = "Fonts",
            order = 5,
            inline = true,
            args = {
                font = {
                    name = "Default Font Family",
                    type = "select",
                    desc = "The default font family for unit frame texts.",
                    order = 1,
                    dialogControl = "LSM30_Font",
                    values = R.Libs.SharedMedia:HashTable("font"),
                    get = function()
                        for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do if UF.config.font == font then return key end end
                    end,
                    set = function(_, key)
                        UF.config.font = R.Libs.SharedMedia:Fetch("font", key)
                        UF:UpdateAll()
                    end
                }
            }
        },
        statusbarTextures = {
            type = "group",
            name = "Status Bar Textures",
            order = 6,
            inline = true,
            args = {
                health = UF:CreateStatusBarTextureOption("Health", "Set the texture to use for health bars.", "health", 1),
                healthPrediction = UF:CreateStatusBarTextureOption("Health Prediction (Healing)", "Set the texture to use for health prediction bars.", "healthPrediction", 2),
                power = UF:CreateStatusBarTextureOption("Power", "Set the texture to use for power bars.", "power", 11),
                powerPrediction = UF:CreateStatusBarTextureOption("Power Prediction (Power Cost)", "Set the texture to use for power prediction bars.", "powerPrediction", 12),
                additionalPower = UF:CreateStatusBarTextureOption("Additional Power", "Set the texture to use for power bars.", "additionalPower", 21),
                additionalPowerPrediction = UF:CreateStatusBarTextureOption("Additional Power Prediction (Power Cost)", "Set the texture to use for additional power prediction bars.",
                                                                            "additionalPowerPrediction", 22),
                classPower = UF:CreateStatusBarTextureOption("Class Power", "Set the texture to use for class power bars (combo points etc).", "classPower", 25),
                castbar = UF:CreateStatusBarTextureOption("Cast Bars", "Set the texture to use for cast bars.", "castbar", 31)
            }
        },
        statusBarColors = {
            type = "group",
            name = "Status Bar Colors",
            order = 7,
            inline = true,
            args = {
                health = UF:CreateStatusBarColorOption("Health", "health", 2),
                mana = UF:CreateStatusBarColorOption("Mana", "mana", 3),
                rage = UF:CreateStatusBarColorOption("Rage", "rage", 4),
                energy = UF:CreateStatusBarColorOption("Energy", "energy", 5),
                focus = UF:CreateStatusBarColorOption("Focus", "focus", 6),
                comboPoints = UF:CreateStatusBarColorOption("Combo Points", "comboPoints", 7),
                castbar = UF:CreateStatusBarColorOption("Castbar", "castbar", 8),
                castbar_Shielded = UF:CreateStatusBarColorOption("Castbar (Shielded)", "castbar_Shielded", 9),
                lineBreak1 = {type = "header", name = "", order = 15},
                colorHealthClass = {
                    type = "toggle",
                    name = "Color Health by Class",
                    order = 20,
                    get = function()
                        return UF.config.colors.colorHealthClass
                    end,
                    set = function(_, val)
                        UF.config.colors.colorHealthClass = val
                        UF:UpdateAll()
                    end
                },
                colorHealthSmooth = {
                    type = "toggle",
                    name = "Color Health by Value",
                    order = 21,
                    get = function()
                        return UF.config.colors.colorHealthSmooth
                    end,
                    set = function(_, val)
                        UF.config.colors.colorHealthSmooth = val
                        UF:UpdateAll()
                    end
                },
                colorHealthDisconnected = {
                    type = "toggle",
                    name = "Color Health when Disconnected",
                    order = 22,
                    get = function()
                        return UF.config.colors.colorHealthDisconnected
                    end,
                    set = function(_, val)
                        UF.config.colors.colorHealthDisconnected = val
                        UF:UpdateAll()
                    end
                },
                colorPowerClass = {
                    type = "toggle",
                    name = "Color Power by Class",
                    order = 30,
                    get = function()
                        return UF.config.colors.colorPowerClass
                    end,
                    set = function(_, val)
                        UF.config.colors.colorPowerClass = val
                        UF:UpdateAll()
                    end
                },
                colorPowerSmooth = {
                    type = "toggle",
                    name = "Color Power by Value",
                    order = 31,
                    get = function()
                        return UF.config.colors.colorPowerSmooth
                    end,
                    set = function(_, val)
                        UF.config.colors.colorPowerSmooth = val
                        UF:UpdateAll()
                    end
                },
                colorPowerDisconnected = {
                    type = "toggle",
                    name = "Color Power when Disconnected",
                    order = 32,
                    get = function()
                        return UF.config.colors.colorPowerDisconnected
                    end,
                    set = function(_, val)
                        UF.config.colors.colorPowerDisconnected = val
                        UF:UpdateAll()
                    end
                }
            }
        },
        classcolors = {
            type = "group",
            name = "Class Colors",
            order = 8,
            inline = true,
            args = {
                deathKnight = UF:CreateClassColorOption("DEATHKNIGHT", R:LocalizedClassName("Death Knight"), 10, R.isClassic),
                demonHunter = UF:CreateClassColorOption("DEMONHUNTER", R:LocalizedClassName("Demon Hunter"), 11, R.isClassic),
                druid = UF:CreateClassColorOption("DRUID", R:LocalizedClassName("Druid"), 12),
                hunter = UF:CreateClassColorOption("HUNTER", R:LocalizedClassName("Hunter"), 13),
                mage = UF:CreateClassColorOption("MAGE", R:LocalizedClassName("Mage"), 14),
                monk = UF:CreateClassColorOption("MONK", R:LocalizedClassName("Monk"), 15, R.isClassic),
                paladin = UF:CreateClassColorOption("PALADIN", R:LocalizedClassName("Paladin"), 16),
                priest = UF:CreateClassColorOption("PRIEST", R:LocalizedClassName("Priest"), 17),
                rogue = UF:CreateClassColorOption("ROGUE", R:LocalizedClassName("Rogue"), 18),
                shaman = UF:CreateClassColorOption("SHAMAN", R:LocalizedClassName("Shaman"), 19),
                warlock = UF:CreateClassColorOption("WARLOCK", R:LocalizedClassName("Warlock"), 20),
                warrior = UF:CreateClassColorOption("WARRIOR", R:LocalizedClassName("Warrior"), 21)
            }
        }
    }
})
