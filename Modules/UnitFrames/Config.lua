local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

local DEFAULT_UNIT_CONFIG = {
    enabled = true,
    size = {200, 36},
    scale = 1,
    point = {"TOPRIGHT", "UIParent", "BOTTOM", -150, 350},
    fader = R.config.faders.onShow,
    inlay = {enabled = true},
    health = {
        enabled = true,
        size = {150, 12},
        value = {
            enabled = true,
            point = {"RIGHT", "RIGHT", -5, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 14,
            fontOutline = "OUTLINE",
            fontShadow = false,
            tag = "[curhp_status:shortvalue]"
        },
        percent = {
            enabled = true,
            point = {"BOTTOMRIGHT", "TOPRIGHT", -2, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "OUTLINE",
            fontShadow = false,
            tag = "[perhp]%"
        },
        smooth = true
    },
    power = {
        enabled = true,
        size = {150, 12},
        value = {
            enabled = true,
            point = {"CENTER", "CENTER", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "OUTLINE",
            fontShadow = false,
            tag = "[curpp]",
            frequentUpdates = true
        },
        percent = {
            enabled = true,
            point = {"BOTTOMLEFT", "TOPLEFT", 2, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "OUTLINE",
            fontShadow = false,
            tag = "[perhp]%"
        },
        smooth = true,
        energyManaRegen = false
    },
    additionalPower = {
        enabled = true,
        size = {150, 10},
        point = {"TOP", "BOTTOM", 0, -5},
        value = {
            enabled = true,
            point = {"CENTER", "CENTER", 0, 0},
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "NONE",
            fontShadow = true,
            tag = "[curmana]"
        },
        smooth = true
    },
    classPower = {enabled = true, size = {226, 12}, point = {"BOTTOM", "TOP", 0, 5}, smooth = true},
    name = {
        enabled = true,
        size = {170, 10},
        point = {"BOTTOMLEFT", "TOPLEFT", 2, 0},
        font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        fontSize = 13,
        fontOutline = "OUTLINE",
        fontShadow = true,
        justifyH = "LEFT",
        tag = "[difficultycolor][level][shortclassification]|r [name:sub(20)]"
    },
    level = {
        enabled = false,
        size = {30, 10},
        point = {"BOTTOMRIGHT", "TOPRIGHT", 2, 0},
        font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        fontSize = 13,
        fontOutline = "OUTLINE",
        fontShadow = true,
        justifyH = "RIGHT",
        tag = "[difficultycolor][level][shortclassification]|r"
    },
    portrait = {enabled = true, point = "LEFT", size = {32, 32}, class = true, model = false},
    auras = {
        enabled = true,
        buffs = {
            enabled = true,
            point = {"TOPLEFT", "BOTTOMLEFT", 0, -9},
            initialAnchor = "TOPLEFT",
            growthX = "RIGHT",
            growthY = "DOWN",
            iconSize = 32,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            num = 32
        },
        debuffs = {
            enabled = true,
            point = {"BOTTOMLEFT", "TOPLEFT", 0, 5},
            initialAnchor = "BOTTOMLEFT",
            growthX = "RIGHT",
            growthY = "UP",
            iconSize = 32,
            spacing = 2,
            numColumns = 5,
            showDuration = true,
            onlyShowPlayer = false,
            num = 16
        }
    },
    castbar = {
        enabled = true,
        size = {200, 16},
        point = {"TOPLEFT", "BOTTOMLEFT", 0, -5},
        showIcon = true,
        showIconOutside = false,
        showSpark = true,
        font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        fontSize = 10,
        fontOutline = "NONE",
        fontShadow = true
    },
    highlight = {enabled = true, colorShadow = true, colorBorder = true, debuffs = true, onlyDispellableDebuffs = false, threat = true, target = true, targetClassColor = false},
    assistantIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOPLEFT", 0, 0}},
    combatIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "LEFT", 0, 0}},
    groupRoleIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOPRIGHT", 0, 0}},
    masterLooterIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 16, 0}},
    leaderIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPLEFT", 0, 0}},
    phaseIndicator = {enabled = true, size = {16, 16}, point = {"CENTER", "TOP", 0, 0}},
    pvpIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "LEFT", 0, 0}},
    pvpClassificationIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "LEFT", 0, 0}},
    questIndicator = {enabled = true, size = {32, 32}, point = {"CENTER", "LEFT", 0, 0}},
    raidRoleIndicator = {enabled = true, size = {14, 14}, point = {"CENTER", "TOPRIGHT", 0, 0}},
    readyCheckIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
    raidTargetIndicator = {enabled = true, size = {20, 20}, point = {"CENTER", "TOP", 0, 0}},
    restingIndicator = {enabled = true, size = {24, 24}, point = {"CENTER", "RIGHT", 0, 0}},
    resurrectIndicator = {enabled = true, size = {32, 32}, point = {"CENTER", "TOP", 0, 0}},
    summonIndicator = {enabled = true, size = {32, 32}, point = {"CENTER", "CENTER", 0, 0}}
}

local DEFAULT_UNIT_CONFIG_NO_INDICATORS = R:CopyTable(DEFAULT_UNIT_CONFIG, {
    assistantIndicator = {enabled = false},
    combatIndicator = {enabled = false},
    groupRoleIndicator = {enabled = false},
    masterLooterIndicator = {enabled = false},
    leaderIndicator = {enabled = false},
    phaseIndicator = {enabled = false},
    pvpIndicator = {enabled = false},
    pvpClassificationIndicator = {enabled = false},
    questIndicator = {enabled = false},
    raidRoleIndicator = {enabled = false},
    readyCheckIndicator = {enabled = false},
    restingIndicator = {enabled = false},
    resurrectIndicator = {enabled = false},
    summonIndicator = {enabled = false}
})

local DEFAULT_GROUP_UNIT_CONFIG = R:CopyTable(DEFAULT_UNIT_CONFIG, {unitAnchorPoint = "TOP", unitSpacing = 50})

local DEFAULT_HEADER_UNIT_CONFIG = R:CopyTable(DEFAULT_UNIT_CONFIG, {
    raidWideSorting = false,
    unitAnchorPoint = "TOP",
    unitSpacing = 50,
    groupAnchorPoint = "TOP",
    groupSpacing = 10,
    groupBy = "GROUP", -- GROUP, CLASS, ROLE
    groupingOrder = "1,2,3,4,5,6,7,8",
    sortMethod = "INDEX", -- NAME, INDEX
    sortDir = "ASC", -- ASC, DESC
    showPlayer = false,
    showSolo = false,
    showParty = true,
    showRaid = false
})

R:RegisterModuleConfig(UF, {
    enabled = true,
    font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
    statusbars = {
        health = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        healthPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Kait1"),
        power = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        powerPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Kait1"),
        additionalPower = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        additionalPowerPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Kait1"),
        classPower = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        castbar = R.Libs.SharedMedia:Fetch("statusbar", "Redux")
    },
    colors = {
        health = {49 / 255, 207 / 255, 37 / 255},
        mana = {0 / 255, 140 / 255, 255 / 255},
        rage = oUF.colors.power["RAGE"],
        energy = oUF.colors.power["ENERGY"],
        focus = oUF.colors.power["FOCUS"],
        comboPoints = oUF.colors.power["COMBO_POINTS"],
        castbar = {255 / 255, 175 / 255, 0 / 255},
        castbar_Shielded = {175 / 255, 175 / 255, 175 / 255},
        class = {
            ["DEATHKNIGHT"] = oUF.colors.class["DEATHKNIGHT"],
            ["DEMONHUNTER"] = oUF.colors.class["DEMONHUNTER"],
            ["DRUID"] = oUF.colors.class["DRUID"],
            ["HUNTER"] = oUF.colors.class["HUNTER"],
            ["MAGE"] = oUF.colors.class["MAGE"],
            ["MONK"] = oUF.colors.class["MONK"],
            ["PALADIN"] = oUF.colors.class["PALADIN"],
            ["PRIEST"] = oUF.colors.class["PRIEST"],
            ["ROGUE"] = oUF.colors.class["ROGUE"],
            ["SHAMAN"] = {0.0, 0.44, 0.87},
            ["WARLOCK"] = oUF.colors.class["WARLOCK"],
            ["WARRIOR"] = oUF.colors.class["WARRIOR"]
        },
        auraHighlight = {Magic = {0.2, 0.6, 1, 0.45}, Curse = {0.6, 0, 1, 0.45}, Disease = {0.6, 0.4, 0, 0.45}, Poison = {0, 0.6, 0, 0.45}, blendMode = "ADD"},
        targetHighlight = {1, 1, 1, 1},
        colorHealthClass = true,
        colorHealthSmooth = false,
        colorHealthDisconnected = true,
        colorPowerClass = false,
        colorPowerSmooth = false,
        colorPowerDisconnected = true
    },
    buffFrame = {point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -215, -13}},
    player = R:CopyTable(DEFAULT_UNIT_CONFIG, {power = {energyManaRegen = true}, castbar = {size = {250, 24}, point = {"BOTTOM", "UIParent", "BOTTOM", 0, 150}, detached = true, showSafeZone = true}, highlight = {target = false}}),
    target = R:CopyTable(DEFAULT_UNIT_CONFIG, {
        point = {"TOPLEFT", "UIParent", "BOTTOM", 150, 350},
        health = {value = {point = {"LEFT", "LEFT", 5, 0}}, percent = {point = {"BOTTOMLEFT", "TOPLEFT", 2, 0}}},
        name = {point = {"BOTTOMRIGHT", "TOPRIGHT", -2, 0}, justifyH = "RIGHT", tag = "[name:sub(20)] [difficultycolor][level][shortclassification]|r"},
        portrait = {point = "RIGHT"},
        pvpIndicator = {point = {"CENTER", "RIGHT", 0, 0}},
        highlight = {target = false}
    }),
    targettarget = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
        size = {95, 24},
        point = {"TOPLEFT", addonName .. "Target", "TOPRIGHT", 10, 0},
        health = {value = {enabled = false}, percent = {enabled = false}},
        power = {enabled = false},
        name = {size = {95, 10}, point = {"CENTER", "CENTER", 0, 0}, fontShadow = false, justifyH = "CENTER", tag = "[name]"},
        portrait = {enabled = false},
        castbar = {enabled = false},
        pvpIndicator = {enabled = false},
    }),
    pet = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
        size = {120, 28},
        point = {"TOPLEFT", addonName .. "Player", "BOTTOMLEFT", 5, 0},
        health = {value = {point = {"CENTER", "CENTER", 0, 0}, fontSize = 12}, percent = {enabled = false}},
        power = {enabled = false},
        name = {size = {95, 10}, point = {"CENTER", "CENTER", 0, 0}, justifyH = "CENTER", tag = "[name]"},
        portrait = {enabled = false},
        pvpIndicator = {enabled = false},
    }),
    focus = R:CopyTable(DEFAULT_UNIT_CONFIG, {
        point = {"TOP", "UIParent", "TOP", 0, -300},
        health = {value = {point = {"LEFT", "LEFT", 5, 0}}, percent = {point = {"BOTTOMLEFT", "TOPLEFT", 2, 0}}},
        name = {point = {"BOTTOMRIGHT", "TOPRIGHT", -2, 0}, justifyH = "RIGHT", tag = "[name:sub(20)] [difficultycolor][level][shortclassification]|r"},
        portrait = {point = "RIGHT"},
        pvpIndicator = {point = {"CENTER", "RIGHT", 0, 0}},
        highlight = {target = false}
    }),
    focustarget = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
        size = {95, 24},
        point = {"TOPLEFT", addonName .. "Focus", "TOPRIGHT", 10, 0},
        health = {value = {enabled = false}, percent = {enabled = false}},
        power = {enabled = false},
        name = {size = {95, 10}, point = {"CENTER", "CENTER", 0, 0}, fontShadow = false, justifyH = "CENTER", tag = "[name]"},
        portrait = {enabled = false},
        castbar = {enabled = false},
        pvpIndicator = {enabled = false},
    }),
    party = R:CopyTable(DEFAULT_HEADER_UNIT_CONFIG, {size = {180, 30}, point = {"BOTTOMRIGHT", "UIParent", "BOTTOM", -350, 450}, pvpIndicator = {enabled = false}, unitAnchorPoint = "BOTTOM"}),
    raid = R:CopyTable(DEFAULT_HEADER_UNIT_CONFIG, {
        size = {90, 36},
        point = {"TOPLEFT", "UIParent", "TOPLEFT", 20, -20},
        health = {value = {enabled = false}, percent = {enabled = false}},
        power = {size = {70, 8}, value = {enabled = false}},
        name = {size = {80, 10}, point = {"TOP", "TOP", 0, -8}, fontSize = 12, fontShadow = false, justifyH = "CENTER", tag = "[name]"},
        portrait = {enabled = false},
        castbar = {enabled = false},
        pvpIndicator = {enabled = false},
        unitAnchorPoint = "LEFT",
        unitSpacing = 10,
        showParty = false,
        showRaid = true
    }),
    assist = R:CopyTable(DEFAULT_HEADER_UNIT_CONFIG, {
        size = {120, 30},
        point = {"LEFT", "UIParent", "LEFT", 20, -100},
        health = {value = {enabled = false}, percent = {enabled = false}},
        power = {size = {70, 8}, value = {enabled = false}},
        name = {size = {80, 10}, point = {"TOP", "TOP", 0, -8}, fontSize = 12, fontShadow = false, justifyH = "CENTER", tag = "[name]"},
        portrait = {enabled = false},
        castbar = {enabled = false},
        pvpIndicator = {enabled = false},
        unitAnchorPoint = "TOP",
        unitSpacing = 10,
        showParty = false,
        showRaid = true
    }),
    tank = R:CopyTable(DEFAULT_HEADER_UNIT_CONFIG, {
        size = {120, 30},
        point = {"LEFT", "UIParent", "LEFT", 20, 100},
        health = {value = {enabled = false}, percent = {enabled = false}},
        power = {size = {70, 8}, value = {enabled = false}},
        name = {size = {80, 10}, point = {"TOP", "TOP", 0, -8}, fontSize = 12, fontShadow = false, justifyH = "CENTER", tag = "[name]"},
        portrait = {enabled = false},
        castbar = {enabled = false},
        pvpIndicator = {enabled = false},
        unitAnchorPoint = "TOP",
        unitSpacing = 10,
        showParty = false,
        showRaid = true
    }),
    arena = R:CopyTable(DEFAULT_GROUP_UNIT_CONFIG, {
        size = {180, 30},
        point = {"BOTTOMLEFT", "UIParent", "BOTTOM", 350, 450},
        health = {value = {point = {"LEFT", "LEFT", 5, 0}}, percent = {point = {"BOTTOMLEFT", "TOPLEFT", 2, 0}}},
        name = {point = {"BOTTOMRIGHT", "TOPRIGHT", -2, 0}, justifyH = "RIGHT", tag = "[name:sub(20)] [difficultycolor][level][shortclassification]|r"},
        portrait = {point = "RIGHT"},
        pvpIndicator = {enabled = false},
        unitAnchorPoint = "BOTTOM"
    }),
    boss = R:CopyTable(DEFAULT_GROUP_UNIT_CONFIG, {
        size = {180, 30},
        point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -100, -300},
        health = {value = {point = {"LEFT", "LEFT", 5, 0}}, percent = {point = {"BOTTOMLEFT", "TOPLEFT", 2, 0}}},
        name = {point = {"BOTTOMRIGHT", "TOPRIGHT", -2, 0}, justifyH = "RIGHT", tag = "[name:sub(20)] [difficultycolor][level][shortclassification]|r"},
        portrait = {point = "RIGHT"},
        pvpIndicator = {enabled = false}
    }),
    nameplates = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
        size = {150, 16},
        point = {"CENTER"},
        health = {value = {point = {"CENTER", "CENTER", 0, 0}, fontSize = 12}, percent = {enabled = false}},
        power = {enabled = false},
        name = {size = {130, 10}, tag = "[name]", point = {"BOTTOMLEFT", "TOPLEFT", 2, 5}},
        level = {enabled = true, point = {"BOTTOMRIGHT", "TOPRIGHT", 2, 5}},
        portrait = {enabled = false},
        highlight = {targetArrows = true},
        pvpIndicator = {enabled = false},
        cvars = {
            nameplateMaxDistance = 41,
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
            nameplateMinAlpha = 0.5,
            nameplateMaxAlpha = 0.8,
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
    })
})
