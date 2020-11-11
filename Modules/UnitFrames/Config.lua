local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.themes = {
    Blizzard = "Blizzard",
    Custom = "Custom"
}

Addon.config.defaults.profile.modules.unitFrames = {
    enabled = true,
    font = Addon.Libs.SharedMedia:Fetch("font", "Expressway Free"),
    statusbar = Addon.Libs.SharedMedia:Fetch("statusbar", "Redux"),
    theme = UF.themes.Blizzard,
    colors = {
        health = {49 / 255, 207 / 255, 37 / 255},
        mana = {0 / 255, 140 / 255, 255 / 255},
        castbar = {255 / 255, 175 / 255, 0 / 255},
        castbar_Shielded = {175 / 255, 175 / 255, 175 / 255},
        overrideShamanColor = true
    },
    player = {
        enabled = true,
        size = {175, 42},
        point = {"TOPRIGHT", "UIParent", "BOTTOM", -150, 300},
        largerHealth = true,
        auras = {enabled = false, showDuration = true, numBuffs = 16, onlyShowPlayerBuffs = false, numDebuffs = 16, onlyShowPlayerDebuffs = false, showDebuffsOnTop = true},
        castbar = {enabled = true, size = {250, 25}, showIcon = true, showIconOutside = false, showSafeZone = true, borderSize = 6, fontSize = 12},
        combatfeedback = {enabled = true, showOnPortrait = false, showFloating = true},
        fader = Addon.config.faders.onShow
    },
    target = {
        enabled = true,
        size = {175, 42},
        point = {"TOPLEFT", "UIParent", "BOTTOM", 150, 300},
        largerHealth = true,
        auras = {enabled = true, showDuration = true, numBuffs = 16, onlyShowPlayerBuffs = false, numDebuffs = 16, onlyShowPlayerDebuffs = false, showDebuffsOnTop = true},
        castbar = {enabled = true, size = {113, 15}, showIcon = true, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {enabled = true, showOnPortrait = false, showFloating = true},
        fader = Addon.config.faders.onShow
    },
    targettarget = {enabled = true, size = {93, 45}, point = {"TOPRIGHT", AddonName .. "Target", "BOTTOMRIGHT", 15, 0}, fader = Addon.config.faders.onShow},
    pet = {
        enabled = true,
        size = {175, 42},
        point = {"TOPRIGHT", AddonName .. "Player", "BOTTOMRIGHT", 34, 5},
        auras = {enabled = true, showDuration = false, numBuffs = 16, onlyShowPlayerBuffs = false, numDebuffs = 16, onlyShowPlayerDebuffs = false, showDebuffsOnTop = true},
        castbar = {enabled = true, size = {89, 15}, showIcon = false, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {enabled = true, showOnPortrait = false, showFloating = true},
        fader = Addon.config.faders.onShow
    },
    focus = {enabled = false},
    focustarget = {enabled = false},
    mouseover = {enabled = false},
    party = {
        enabled = true,
        size = {105, 30},
        point = {"BOTTOM", "UIParent", "BOTTOM", -550, 320},
        xOffset = 0,
        yOffset = 50,
        showPlayer = false,
        showSolo = false,
        showInRaid = false,
        auras = {
            enabled = true,
            showDuration = true,
            numBuffs = 16,
            onlyShowPlayerBuffs = true,
            numDebuffs = 16,
            onlyShowPlayerDebuffs = false,
            showDebuffsOnTop = true,
            iconSize = 16
        },
        castbar = {enabled = true, size = {89, 15}, showIcon = true, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {enabled = true, showOnPortrait = false, showFloating = true, fontSize = 14},
        fader = Addon.config.faders.onShow
    },
    raid = {
        enabled = true,
        size = {80, 22},
        point = "TOP",
        xOffset = 0,
        yOffset = -5,
        visibility = "[group:raid] show",
        showPlayer = false,
        showSolo = false,
        showParty = false,
        showRaid = true,
        points = { -- list of 8 points, one for each raid group
            {"TOPLEFT", 20, -20},
            {"TOP", AddonName .. "RaidHeader1", "BOTTOM", 0, -10},
            {"TOP", AddonName .. "RaidHeader2", "BOTTOM", 0, -10},
            {"TOP", AddonName .. "RaidHeader3", "BOTTOM", 0, -10},
            {"TOPLEFT", AddonName .. "RaidHeader1", "TOPRIGHT", 10, 0},
            {"TOP", AddonName .. "RaidHeader5", "BOTTOM", 0, -10},
            {"TOP", AddonName .. "RaidHeader6", "BOTTOM", 0, -10},
            {"TOP", AddonName .. "RaidHeader7", "BOTTOM", 0, -10}
        },
        border = {
            enabled = true,
            size = 6
        },
        power = {
            enabled = true,
            height = 6
        },
        scale = 1
    },
    boss = {enabled = false},
    nameplates = {
        enabled = true,
        size = {150, 16},
        showBorder = true,
        borderSize = 6,
        showPower = false,
        showComboPoints = false,
        targetGlow = true,
        targetArrows = true,
        auras = {enabled = true, showDuration = true, numBuffs = 0, onlyShowPlayerBuffs = true, numDebuffs = 16, onlyShowPlayerDebuffs = true, showDebuffsOnTop = false},
        castbar = {enabled = true, size = {150, 12}, showIcon = false, showIconOutside = false, showSafeZone = false, borderSize = 6},
        combatfeedback = {
            enabled = false,
            showOnPortrait = false,
            showFloating = true,
            ignoreImmune = true,
            ignoreDamage = true,
            ignoreHeal = false,
            ignoreEnergize = true,
            ignoreOther = true
        },
        cvars = {
            nameplateMinScale = 1,
            nameplateMaxScale = 1,
            nameplateMinScaleDistance = 0,
            nameplateMaxScaleDistance = 80,
            nameplateGlobalScale = 1,
            NamePlateHorizontalScale = 1,
            NamePlateVerticalScale = 1,
            nameplateSelfScale = 1,
            nameplateSelectedScale = 1.2,
            nameplateLargerScale = 1.2,
            nameplateMinAlpha = 0.8,
            nameplateMaxAlpha = 1,
            nameplateMinAlphaDistance = 0,
            nameplateMaxAlphaDistance = 80,
            nameplateSelectedAlpha = 1,
            nameplateShowAll = 1,
            nameplateShowEnemyMinions = 0,
            nameplateShowEnemyGuardians = 0,
            nameplateShowEnemyMinus = 0,
            nameplateShowEnemyPets = 0,
            nameplateShowFriendlyMinions = 0,
            nameplateShowFriendlyGuardians = 0,
            nameplateShowFriendlyNPCs = 1,
            nameplateShowFriendlyPets = 0,
            nameplateShowFriendlyTotems = 0
        }
    }
}

Addon.config.options.args.unitFrames = {
    type = "group",
    name = "Unit Frames",
    order = 15,
    args = {
        header = {type = "header", name = Addon.title .. " > Unit Frames", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                return "Disabling this module requires a UI reload. Proceed?"
            end,
            get = function()
                return UF.config.db.profile.enabled
            end,
            set = function(_, val)
                UF.config.db.profile.enabled = val
                ReloadUI()
            end
        },
        lineBreak = {type = "header", name = "", order = 2},
        theme = {
            type = "select",
            name = "Theme",
            order = 3,
            values = UF.themes,
            get = function()
                for key, val in pairs(UF.themes) do
                    if UF.config.db.profile.theme == val then
                        return val
                    end
                end
            end,
            set = function(_, key)
                UF.config.db.profile.theme = UF.themes[key]
                UF:OnUpdate()
            end
        },
        statusbar = {
            type = "select",
            name = "Status Bars",
            desc = "Set the texture to use for status bars.",
            order = 4,
            dialogControl = "LSM30_Statusbar",
            values = Addon.Libs.SharedMedia:HashTable("statusbar"),
            get = function()
                for key, texture in pairs(Addon.Libs.SharedMedia:HashTable("statusbar")) do
                    if UF.config.db.profile.statusbar == texture then
                        return key
                    end
                end
            end,
            set = function(_, key)
                UF.config.db.profile.statusbar = Addon.Libs.SharedMedia:Fetch("statusbar", key)
            end
        },
        colors = {
            type = "group",
            name = "Colors",
            order = 5,
            inline = true,
            args = {
                health = {
                    type = "color",
                    name = "Health",
                    order = 1,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.health
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.health
                        color[1] = r
                        color[2] = g
                        color[3] = b
                    end
                },
                mana = {
                    type = "color",
                    name = "Mana",
                    order = 2,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.mana
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.mana
                        color[1] = r
                        color[2] = g
                        color[3] = b
                    end
                },
                castbar = {
                    type = "color",
                    name = "Castbar",
                    order = 3,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.castbar
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.castbar
                        color[1] = r
                        color[2] = g
                        color[3] = b
                    end
                },
                castbar_Shielded = {
                    type = "color",
                    name = "Castbar (Shielded)",
                    order = 4,
                    hasAlpha = false,
                    get = function()
                        local color = UF.config.db.profile.colors.castbar_Shielded
                        return color[1], color[2], color[3], 1
                    end,
                    set = function(_, r, g, b, a)
                        local color = UF.config.db.profile.colors.castbar_Shielded
                        color[1] = r
                        color[2] = g
                        color[3] = b
                    end
                },
                overrideShamanColor = {
                    type = "toggle",
                    name = "Use Blue Shaman Color",
                    order = 10,
                    confirm = function()
                        return "Disabling this module requires a UI reload. Proceed?"
                    end,
                    get = function()
                        return UF.config.db.profile.colors.overrideShamanColor
                    end,
                    set = function(_, val)
                        UF.config.db.profile.colors.overrideShamanColor = val
                        ReloadUI()
                    end
                }
            }
        },
        player = {
            type = "group",
            name = "Player",
            order = 12,
            args = {
                theme = {
                    type = "toggle",
                    name = "Use Large Health Bar",
                    order = 0,
                    get = function()
                        return UF.config.db.profile.player.largerHealth
                    end,
                    set = function(_, val)
                        UF.config.db.profile.player.largerHealth = val
                        -- TODO: apply without reloading
                        ReloadUI()
                    end
                }
            }
        },
        target = {
            type = "group",
            name = "Target",
            order = 13,
            args = {
                theme = {
                    type = "toggle",
                    name = "Use Large Health Bar",
                    order = 0,
                    get = function()
                        return UF.config.db.profile.target.largerHealth
                    end,
                    set = function(_, val)
                        UF.config.db.profile.target.largerHealth = val
                        -- TODO: apply without reloading
                        ReloadUI()
                    end
                }
            }
        },
        targettarget = {
            type = "group",
            name = "Target's Target",
            order = 14,
            args = {
                theme = {
                    type = "toggle",
                    name = "Enabled",
                    order = 0,
                    get = function()
                        return UF.config.db.profile.targettarget.enabled
                    end,
                    set = function(_, val)
                        UF.config.db.profile.targettarget.enabled = val
                        -- TODO: apply without reloading
                        ReloadUI()
                    end
                }
            }
        }
    }
}
