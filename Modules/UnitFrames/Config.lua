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
    classPower = {
        enabled = true,
        size = {226, 12},
        point = {"BOTTOM", "TOP", 0, 5},
        smooth = true
    },
    name = {
        enabled = true,
        size = {170, 10},
        point = {"BOTTOMLEFT", "TOPLEFT", 2, 0},
        font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        fontSize = 13,
        fontOutline = "OUTLINE",
        fontShadow = true,
        justifyH = "LEFT",
        tag = "[name:sub(20)] [difficultycolor][level][shortclassification]|r"
    },
    level = {
        enabled = true,
        point = {"BOTTOMLEFT", "TOPLEFT", 0, 0},
        font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        fontSize = 13,
        fontOutline = "OUTLINE",
        fontShadow = true,
        justifyH = "LEFT",
        tag = "[difficultycolor][level][shortclassification]|r"
    },
    portrait = {
        enabled = true,
        point = "LEFT",
        size = {32, 32},
        class = true,
        model = false
    },
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
        showIcon = true,
        showIconOutside = false,
        showSafeZone = false,
        showSpark = true,
        font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        fontSize = 10,
        fontOutline = "NONE",
        fontShadow = true
    },
    highlight = {
        enabled = true,
        colorShadow = true,
        colorBorder = true,
        debuffs = true,
        onlyDispellableDebuffs = false,
        threat = true,
        target = true,
        targetClassColor = true
    },
    assistantIndicator = {
        enabled = true,
        size = {16, 16},
        point = {"CENTER", "TOPLEFT", 0, 0}
    },
    combatIndicator = {
        enabled = true,
        size = {24, 24},
        point = {"CENTER", "LEFT", 0, 0}
    },
    groupRoleIndicator = {
        enabled = true,
        size = {20, 20},
        point = {"CENTER", "TOPRIGHT", 0, 0}
    },
    masterLooterIndicator = {
        enabled = true,
        size = {14, 14},
        point = {"CENTER", "TOPLEFT", 16, 0}
    },
    leaderIndicator = {
        enabled = true,
        size = {14, 14},
        point = {"CENTER", "TOPLEFT", 0, 0}
    },
    phaseIndicator = {
        enabled = true,
        size = {16, 16},
        point = {"CENTER", "TOP", 0, 0}
    },
    pvpIndicator = {
        enabled = false,
        size = {24, 24},
        point = {"CENTER", "LEFT", 0, 0}
    },
    pvpClassificationIndicator = {
        enabled = true,
        size = {24, 24},
        point = {"CENTER", "LEFT", 0, 0}
    },
    questIndicator = {
        enabled = true,
        size = {32, 32},
        point = {"CENTER", "LEFT", 0, 0}
    },
    raidRoleIndicator = {
        enabled = true,
        size = {14, 14},
        point = {"CENTER", "TOPRIGHT", 0, 0}
    },
    readyCheckIndicator = {
        enabled = true,
        size = {24, 24},
        point = {"CENTER", "RIGHT", 0, 0}
    },
    raidTargetIndicator = {
        enabled = true,
        size = {20, 20},
        point = {"CENTER", "TOP", 0, 0}
    },
    restingIndicator = {
        enabled = true,
        size = {24, 24},
        point = {"CENTER", "RIGHT", 0, 0}
    },
    resurrectIndicator = {
        enabled = true,
        size = {32, 32},
        point = {"CENTER", "TOP", 0, 0}
    },
    summonIndicator = {
        enabled = true,
        size = {32, 32},
        point = {"CENTER", "CENTER", 0, 0}
    }
}

local player = R:CopyTable(DEFAULT_UNIT_CONFIG)
player.power.energyManaRegen = true
player.castbar.size = {250, 24}
player.castbar.point = {"BOTTOM", "UIParent", "BOTTOM", 0, 150}

local target = R:CopyTable(DEFAULT_UNIT_CONFIG)
target.point = {"TOPLEFT", "UIParent", "BOTTOM", 150, 350}
target.health.value.point = {"LEFT", "LEFT", 5, 0}
target.health.percent.point = {"BOTTOMLEFT", "TOPLEFT", 2, 0}
target.name.point = {"BOTTOMRIGHT", "TOPRIGHT", -2, 0}
target.name.justifyH = "RIGHT"
target.portrait.point = "RIGHT"
target.pvpIndicator.point = {"CENTER", "RIGHT", 0, 0}
target.restingIndicator.enabled = false

local targetTarget = R:CopyTable(DEFAULT_UNIT_CONFIG)

R:RegisterModuleConfig(UF, {
    enabled = true,
    font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
    statusbars = {
        health = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        healthPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        power = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        powerPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        additionalPower = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        additionalPowerPrediction = R.Libs.SharedMedia:Fetch("statusbar",
                                                             "Redux"),
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
        auraHighlight = {
            Magic = {0.2, 0.6, 1, 0.45},
            Curse = {0.6, 0, 1, 0.45},
            Disease = {0.6, 0.4, 0, 0.45},
            Poison = {0, 0.6, 0, 0.45},
            blendMode = "ADD"
        },
        targetHighlight = {1, 1, 1, 1},
        colorHealthClass = true,
        colorHealthSmooth = false,
        colorHealthDisconnected = true,
        colorPowerClass = false,
        colorPowerSmooth = false,
        colorPowerDisconnected = true
    },
    buffFrame = {point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -215, -13}},
    player = player,
    target = target,
    targettarget = targetTarget
})
