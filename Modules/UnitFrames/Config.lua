local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

local AURA_FILTER_WHITELIST = {
    Boss = false,
    MyPet = false,
    OtherPet = false,
    Personal = false,
    NonPersonal = false,
    CastByUnit = false,
    NotCastByUnit = false,
    Dispellable = false,
    NotDispellable = false,
    CastByNPC = false,
    CastByPlayers = false,
    Nameplate = false,
    CrowdControl = false,
    PlayerBuffs = false,
    TurtleBuffs = false,
    RaidBuffs = false,
    RaidDebuffs = false
}

local AURA_FILTER_BLACKLIST = { BlockNonPersonal = false, BlockCastByPlayers = false, BlockNoDuration = false, BlockDispellable = false, BlockNotDispellable = false }

local DEFAULT_UNIT_CONFIG = {
    enabled = true,
    size = { 200, 36 },
    scale = 1,
    point = { "TOPRIGHT", "UIParent", "BOTTOM", -150, 350 },
    fader = R.config.faders.onShow,
    inlay = { enabled = true },
    health = {
        enabled = true,
        size = { 150, 12 },
        value = {
            enabled = true,
            point = { "RIGHT", "RIGHT", -5, 0 },
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 14,
            fontOutline = "OUTLINE",
            fontShadow = false,
            tag = "[curhp_status:shortvalue]"
        },
        percent = {
            enabled = true,
            point = { "BOTTOMRIGHT", "TOPRIGHT", -2, 0 },
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
        size = { 150, 10 },
        detached = false,
        point = { "BOTTOM", "UIParent", "BOTTOM", 0, 352 },
        value = {
            enabled = true,
            point = { "CENTER", "CENTER", 0, 0 },
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "OUTLINE",
            fontShadow = false,
            tag = "[curpp]",
            frequentUpdates = true
        },
        percent = {
            enabled = true,
            point = { "BOTTOMLEFT", "TOPLEFT", 2, 0 },
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 10,
            fontOutline = "OUTLINE",
            fontShadow = false,
            tag = "[perhp]%"
        },
        smooth = true,
        energyManaRegen = false,
        powerPrediction = false,
        showSeparator = false,
        inset = false,
        insetPoint = { "RIGHT", "BOTTOMRIGHT", -10, 0 }
    },
    additionalPower = {
        enabled = true,
        size = { 150, 10 },
        point = { "TOP", "BOTTOM", 0, -5 },
        value = {
            enabled = true,
            point = { "CENTER", "CENTER", 0, 0 },
            font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            fontSize = 11,
            fontOutline = "NONE",
            fontShadow = true,
            tag = "[curmana]"
        },
        smooth = true
    },
    classPower = { enabled = true, size = { 226, 12 }, point = { "BOTTOM", "TOP", 0, 5 }, spacing = 10, smooth = true },
    runes = { enabled = true, size = { 226, 12 }, point = { "BOTTOM", "TOP", 0, 5 }, spacing = 10, smooth = true },
    stagger = { enabled = true, size = { 226, 12 }, point = { "BOTTOM", "TOP", 0, 5 }, smooth = true },
    totems = { enabled = true, size = { 226, 32 }, point = { "BOTTOM", "TOP", 0, 5 }, spacing = 10, smooth = true },
    name = {
        enabled = true,
        size = { 170, 10 },
        point = { "BOTTOMLEFT", "TOPLEFT", 2, 0 },
        font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        fontSize = 13,
        fontOutline = "OUTLINE",
        fontShadow = true,
        justifyH = "LEFT",
        tag = "[difficultycolor][level][shortclassification]|r [name:sub(20)]"
    },
    level = {
        enabled = false,
        size = { 30, 10 },
        point = { "BOTTOMRIGHT", "TOPRIGHT", 2, 0 },
        font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        fontSize = 13,
        fontOutline = "OUTLINE",
        fontShadow = true,
        justifyH = "RIGHT",
        tag = "[difficultycolor][level][shortclassification]|r"
    },
    portrait = { enabled = true, point = "LEFT", size = { 32, 32 }, class = false, model = false, showSeparator = true },
    auras = {
        enabled = false,
        separateBuffsAndDebuffs = false,
        buffsAndDebuffs = {
            enabled = true,
            point = { "BOTTOMLEFT", "TOPLEFT", 0, 12 },
            initialAnchor = "BOTTOMLEFT",
            growthX = "RIGHT",
            growthY = "UP",
            iconSize = 32,
            spacing = 2,
            numColumns = 6,
            numBuffs = 16,
            numDebuffs = 16,
            showDuration = true,
            desaturate = false,
            showStealableBuffs = true,
            showBuffType = false,
            showDebuffType = true,
            gap = true,
            minDuration = 0,
            maxDuration = 0
        },
        buffs = {
            enabled = true,
            point = { "TOPLEFT", "BOTTOMLEFT", 0, -7 },
            initialAnchor = "TOPLEFT",
            growthX = "RIGHT",
            growthY = "DOWN",
            iconSize = 32,
            spacing = 2,
            numColumns = 6,
            num = 32,
            showDuration = true,
            desaturate = false,
            showStealableBuffs = true,
            showBuffType = false,
            minDuration = 0,
            maxDuration = 0,
            filter = { whitelist = AURA_FILTER_WHITELIST, blacklist = AURA_FILTER_BLACKLIST }
        },
        debuffs = {
            enabled = true,
            point = { "BOTTOMLEFT", "TOPLEFT", 0, 12 },
            initialAnchor = "BOTTOMLEFT",
            growthX = "RIGHT",
            growthY = "UP",
            iconSize = 32,
            spacing = 2,
            numColumns = 6,
            num = 16,
            showDuration = true,
            desaturate = false,
            showStealableBuffs = true,
            showDebuffType = true,
            minDuration = 0,
            maxDuration = 0,
            filter = { whitelist = AURA_FILTER_WHITELIST, blacklist = AURA_FILTER_BLACKLIST }
        }
    },
    auraWatch = { enabled = false, iconSize = 12, countFontSize = 9 },
    castbar = {
        enabled = true,
        size = { 200, 16 },
        point = { "TOPLEFT", "BOTTOMLEFT", 0, -5 },
        showIcon = true,
        showIconOutside = false,
        showSpark = true,
        font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        fontSize = 10,
        fontOutline = "NONE",
        fontShadow = true
    },
    highlight = { enabled = true, colorShadow = true, colorBorder = true, debuffs = true, onlyDispellableDebuffs = false, threat = true, target = true, targetClassColor = false },
    assistantIndicator = { enabled = true, size = { 16, 16 }, point = { "CENTER", "TOPLEFT", 0, 0 } },
    combatIndicator = { enabled = true, size = { 24, 24 }, point = { "CENTER", "RIGHT", 0, 0 } },
    groupRoleIndicator = { enabled = true, size = { 20, 20 }, point = { "CENTER", "TOPRIGHT", 0, 0 } },
    masterLooterIndicator = { enabled = true, size = { 14, 14 }, point = { "CENTER", "TOPLEFT", 16, 0 } },
    leaderIndicator = { enabled = true, size = { 14, 14 }, point = { "CENTER", "TOPLEFT", 0, 0 } },
    phaseIndicator = { enabled = true, size = { 16, 16 }, point = { "CENTER", "TOP", 0, 0 } },
    pvpIndicator = { enabled = true, size = { 24, 24 }, point = { "CENTER", "LEFT", 0, 0 } },
    pvpClassificationIndicator = { enabled = true, size = { 24, 24 }, point = { "CENTER", "LEFT", 0, 0 } },
    questIndicator = { enabled = true, size = { 32, 32 }, point = { "CENTER", "RIGHT", 2, 0 } },
    raidRoleIndicator = { enabled = true, size = { 14, 14 }, point = { "CENTER", "TOPRIGHT", 0, 0 } },
    readyCheckIndicator = { enabled = true, size = { 24, 24 }, point = { "CENTER", "RIGHT", 0, 0 } },
    raidTargetIndicator = { enabled = true, size = { 20, 20 }, point = { "CENTER", "TOP", 0, 0 } },
    restingIndicator = { enabled = true, size = { 24, 24 }, point = { "CENTER", "RIGHT", 0, 0 } },
    resurrectIndicator = { enabled = true, size = { 32, 32 }, point = { "CENTER", "CENTER", 0, 0 } },
    summonIndicator = { enabled = true, size = { 32, 32 }, point = { "CENTER", "CENTER", 0, 0 } },
    trinket = { enabled = false, size = { 40, 40 }, point = { "LEFT", "RIGHT", 5, 0 } },
    diminishingReturnsTracker = { enabled = false, iconSize = 24, iconSpacing = 10, point = { "LEFT", "RIGHT", 50, 0 } }
}

local DEFAULT_UNIT_CONFIG_NO_INDICATORS = R:CopyTable(DEFAULT_UNIT_CONFIG, {
    assistantIndicator = { enabled = false },
    combatIndicator = { enabled = false },
    groupRoleIndicator = { enabled = false },
    masterLooterIndicator = { enabled = false },
    leaderIndicator = { enabled = false },
    phaseIndicator = { enabled = false },
    pvpIndicator = { enabled = false },
    pvpClassificationIndicator = { enabled = false },
    questIndicator = { enabled = false },
    raidRoleIndicator = { enabled = false },
    readyCheckIndicator = { enabled = false },
    restingIndicator = { enabled = false },
    resurrectIndicator = { enabled = false },
    summonIndicator = { enabled = false }
})

local DEFAULT_GROUP_UNIT_CONFIG = R:CopyTable(DEFAULT_UNIT_CONFIG, { unitAnchorPoint = "TOP", unitSpacing = 50 })

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
    middleClickFocus = true,
    font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
    statusbars = {
        health = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        healthPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Kait1"),
        power = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        powerPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        additionalPower = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        additionalPowerPrediction = R.Libs.SharedMedia:Fetch("statusbar", "Kait1"),
        classPower = R.Libs.SharedMedia:Fetch("statusbar", "Redux"),
        castbar = R.Libs.SharedMedia:Fetch("statusbar", "Redux")
    },
    colors = {
        health = { 49 / 255, 207 / 255, 37 / 255 },
        mana = { 0 / 255, 140 / 255, 255 / 255 },
        rage = oUF.colors.power["RAGE"],
        energy = oUF.colors.power["ENERGY"],
        focus = oUF.colors.power["FOCUS"],
        runicPower = oUF.colors.power["RUNIC_POWER"],
        comboPoints = oUF.colors.power["COMBO_POINTS"],
        castbar = { 255 / 255, 175 / 255, 0 / 255 },
        castbar_Shielded = { 175 / 255, 175 / 255, 175 / 255 },
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
            ["SHAMAN"] = { 0.0, 0.44, 0.87 },
            ["WARLOCK"] = oUF.colors.class["WARLOCK"],
            ["WARRIOR"] = oUF.colors.class["WARRIOR"]
        },
        auraHighlight = { Magic = { 0.2, 0.6, 1, 0.45 }, Curse = { 0.6, 0, 1, 0.45 }, Disease = { 0.6, 0.4, 0, 0.45 }, Poison = { 0, 0.6, 0, 0.45 }, blendMode = "ADD" },
        targetHighlight = { 1, 1, 1 },
        colorHealthClass = true,
        colorHealthSmooth = false,
        colorHealthDisconnected = true,
        colorPowerClass = false,
        colorPowerSmooth = false,
        colorPowerDisconnected = true
    },
    buffFrame = { point = { "TOPRIGHT", "UIParent", "TOPRIGHT", -215, -13 }, buffs = { iconSize = 36 }, debuffs = { iconSize = 36 }, tempEnchants = { iconSize = 36 } },
    player = R:CopyTable(DEFAULT_UNIT_CONFIG, {
        power = { energyManaRegen = true, powerPrediction = true, insetPoint = { "RIGHT", "BOTTOMRIGHT", -10, 0 } },
        portrait = { size = { 36, 36 } },
        castbar = { size = { 250, 24 }, point = { "BOTTOM", "UIParent", "BOTTOM", 0, 200 }, detached = true, showSafeZone = true },
        highlight = { target = false }
    }),
    target = R:CopyTable(DEFAULT_UNIT_CONFIG, {
        point = { "TOPLEFT", "UIParent", "BOTTOM", 150, 350 },
        health = { value = { point = { "LEFT", "LEFT", 5, 0 } }, percent = { point = { "BOTTOMLEFT", "TOPLEFT", 2, 0 } } },
        power = { insetPoint = { "LEFT", "BOTTOMLEFT", 10, 0 } },
        name = { point = { "BOTTOMRIGHT", "TOPRIGHT", -2, 0 }, justifyH = "RIGHT", tag = "[name:sub(20)] [difficultycolor][level][shortclassification]|r" },
        portrait = { size = { 36, 36 }, point = "RIGHT" },
        auras = {
            enabled = true,
            buffs = { filter = { whitelist = { Personal = true, NonPersonal = true, CastByUnit = true, Dispellable = true, PlayerBuffs = true, RaidBuffs = true } } },
            debuffs = { filter = { whitelist = { Personal = true, Boss = true, Dispellable = true, CrowdControl = true, RaidDebuffs = true } } }
        },
        combatIndicator = { point = { "CENTER", "LEFT", 0, 0 } },
        pvpIndicator = { point = { "CENTER", "RIGHT", 0, 0 } },
        highlight = { target = false }
    }),
    targettarget = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
        size = { 95, 24 },
        point = { "TOPLEFT", addonName .. "Target", "TOPRIGHT", 10, 0 },
        health = { value = { enabled = false }, percent = { enabled = false } },
        power = { enabled = false },
        name = { size = { 95, 10 }, point = { "CENTER", "CENTER", 0, 0 }, fontSize = 11, fontShadow = false, justifyH = "CENTER", tag = "[name]" },
        portrait = { enabled = false },
        castbar = { enabled = false },
        pvpIndicator = { enabled = false }
    }),
    pet = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
        size = { 120, 28 },
        point = { "TOPLEFT", addonName .. "Player", "BOTTOMLEFT", 5, -10 },
        health = { value = { enabled = false, point = { "CENTER", "CENTER", 0, 0 }, fontSize = 12 }, percent = { enabled = false } },
        power = { enabled = false },
        name = { size = { 95, 10 }, point = { "CENTER", "CENTER", 0, 0 }, fontSize = 11, justifyH = "CENTER", tag = "[name]" },
        portrait = { enabled = false },
        castbar = { enabled = false },
        pvpIndicator = { enabled = false }
    }),
    focus = R:CopyTable(DEFAULT_UNIT_CONFIG, {
        point = { "TOP", "UIParent", "TOP", 0, -250 },
        health = { value = { point = { "LEFT", "LEFT", 5, 0 } }, percent = { point = { "BOTTOMLEFT", "TOPLEFT", 2, 0 } } },
        name = { point = { "BOTTOMRIGHT", "TOPRIGHT", -2, 0 }, justifyH = "RIGHT", tag = "[name:sub(20)] [difficultycolor][level][shortclassification]|r" },
        portrait = { point = "RIGHT" },
        auras = {
            enabled = true,
            buffs = { filter = { whitelist = { Personal = true, NonPersonal = true, CastByUnit = true, Dispellable = true, PlayerBuffs = true, RaidBuffs = true } } },
            debuffs = { filter = { whitelist = { Personal = true, Boss = true, Dispellable = true, CrowdControl = true, RaidDebuffs = true } } }
        },
        pvpIndicator = { point = { "CENTER", "RIGHT", 0, 0 } },
        highlight = { target = false }
    }),
    focustarget = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
        size = { 95, 24 },
        point = { "TOPLEFT", addonName .. "Focus", "TOPRIGHT", 10, 0 },
        health = { value = { enabled = false }, percent = { enabled = false } },
        power = { enabled = false },
        name = { size = { 95, 10 }, point = { "CENTER", "CENTER", 0, 0 }, fontShadow = false, justifyH = "CENTER", tag = "[name]" },
        portrait = { enabled = false },
        castbar = { enabled = false },
        pvpIndicator = { enabled = false }
    }),
    party = R:CopyTable(DEFAULT_HEADER_UNIT_CONFIG,
                        { size = { 180, 30 }, point = { "BOTTOMRIGHT", "UIParent", "BOTTOM", -350, 450 }, pvpIndicator = { enabled = false }, unitAnchorPoint = "BOTTOM", groupAnchorPoint = "BOTTOM" }),
    raid = R:CopyTable(DEFAULT_HEADER_UNIT_CONFIG, {
        size = { 90, 36 },
        point = { "BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 20, 280 },
        health = { value = { enabled = false }, percent = { enabled = false } },
        power = { size = { 70, 8 }, value = { enabled = false } },
        name = { size = { 80, 10 }, point = { "TOP", "TOP", 0, -8 }, fontSize = 12, fontShadow = false, justifyH = "CENTER", tag = "[name]" },
        portrait = { enabled = false },
        auraWatch = { enabled = true },
        castbar = { enabled = false },
        pvpIndicator = { enabled = false },
        unitAnchorPoint = "LEFT",
        unitSpacing = 10,
        groupAnchorPoint = "TOP",
        showParty = false,
        showRaid = true
    }),
    assist = R:CopyTable(DEFAULT_HEADER_UNIT_CONFIG, {
        size = { 120, 30 },
        point = { "BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 20, 850 },
        health = { value = { enabled = false }, percent = { enabled = false } },
        power = { size = { 70, 8 }, value = { enabled = false } },
        name = { size = { 80, 10 }, point = { "TOP", "TOP", 0, -8 }, fontSize = 12, fontShadow = false, justifyH = "CENTER", tag = "[name]" },
        portrait = { enabled = false },
        castbar = { enabled = false },
        pvpIndicator = { enabled = false },
        unitAnchorPoint = "TOP",
        unitSpacing = 10,
        showParty = false,
        showRaid = true
    }),
    tank = R:CopyTable(DEFAULT_HEADER_UNIT_CONFIG, {
        size = { 120, 30 },
        point = { "BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 20, 650 },
        health = { value = { enabled = false }, percent = { enabled = false } },
        power = { size = { 70, 8 }, value = { enabled = false } },
        name = { size = { 80, 10 }, point = { "TOP", "TOP", 0, -8 }, fontSize = 12, fontShadow = false, justifyH = "CENTER", tag = "[name]" },
        portrait = { enabled = false },
        castbar = { enabled = false },
        pvpIndicator = { enabled = false },
        unitAnchorPoint = "TOP",
        unitSpacing = 10,
        showParty = false,
        showRaid = true
    }),
    arena = R:CopyTable(DEFAULT_GROUP_UNIT_CONFIG, {
        size = { 180, 30 },
        point = { "BOTTOMLEFT", "UIParent", "BOTTOM", 350, 450 },
        health = { value = { point = { "LEFT", "LEFT", 5, 0 } }, percent = { point = { "BOTTOMLEFT", "TOPLEFT", 2, 0 } } },
        name = { point = { "BOTTOMRIGHT", "TOPRIGHT", -2, 0 }, justifyH = "RIGHT", tag = "[name:sub(20)] [difficultycolor][level][shortclassification]|r" },
        portrait = { point = "RIGHT" },
        auras = {
            enabled = true,
            buffs = { filter = { whitelist = { Personal = true, Dispellable = true, PlayerBuffs = true, TurtleBuffs = true } } },
            debuffs = { filter = { whitelist = { Personal = true, Dispellable = true, CrowdControl = true, RaidDebuffs = true } } }
        },
        pvpIndicator = { enabled = false },
        trinket = { enabled = true },
        diminishingReturnsTracker = { enabled = true },
        unitAnchorPoint = "BOTTOM"
    }),
    boss = R:CopyTable(DEFAULT_GROUP_UNIT_CONFIG, {
        size = { 180, 30 },
        point = { "BOTTOMLEFT", "UIParent", "BOTTOM", 350, 450 },
        health = { value = { point = { "LEFT", "LEFT", 5, 0 } }, percent = { point = { "BOTTOMLEFT", "TOPLEFT", 2, 0 } } },
        name = { point = { "BOTTOMRIGHT", "TOPRIGHT", -2, 0 }, justifyH = "RIGHT", tag = "[name:sub(20)] [difficultycolor][level][shortclassification]|r" },
        portrait = { point = "RIGHT" },
        auras = {
            enabled = true,
            buffs = { filter = { whitelist = { Personal = true, NonPersonal = true, CastByUnit = true, Dispellable = true, RaidBuffs = true } } },
            debuffs = { filter = { whitelist = { Personal = true, Boss = true, Dispellable = true, CrowdControl = true, RaidDebuffs = true } } }
        },
        pvpIndicator = { enabled = false },
        unitAnchorPoint = "BOTTOM"
    }),
    nameplates = {
        enabled = true,
        friendlyPlayer = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
            size = { 160, 14 },
            point = { "CENTER" },
            health = { value = { point = { "CENTER", "CENTER", 0, 0 }, fontSize = 12 }, percent = { enabled = false } },
            power = { enabled = false },
            name = { size = { 140, 10 }, tag = "[name]", point = { "BOTTOMLEFT", "TOPLEFT", 2, 5 } },
            level = { enabled = true, point = { "BOTTOMRIGHT", "TOPRIGHT", 2, 5 } },
            portrait = { enabled = false },
            auras = {
                enabled = true,
                buffs = { filter = { whitelist = { Personal = true, TurtleBuffs = true }, blacklist = { BlockNoDuration = true } } },
                debuffs = { filter = { whitelist = { Personal = true, Dispellable = true, CrowdControl = true }, blacklist = { BlockNoDuration = true } } }
            },
            highlight = { targetArrows = true },
            pvpIndicator = { enabled = false }
        }),
        enemyPlayer = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
            size = { 160, 14 },
            point = { "CENTER" },
            health = { value = { point = { "CENTER", "CENTER", 0, 0 }, fontSize = 12 }, percent = { enabled = false } },
            power = { enabled = false },
            name = { size = { 140, 10 }, tag = "[name]", point = { "BOTTOMLEFT", "TOPLEFT", 2, 5 } },
            level = { enabled = true, point = { "BOTTOMRIGHT", "TOPRIGHT", 2, 5 } },
            portrait = { enabled = false },
            auras = {
                enabled = true,
                buffs = { filter = { maxDuration = 300, whitelist = { Dispellable = true, PlayerBuffs = true, TurtleBuffs = true } } },
                debuffs = { filter = { whitelist = { Personal = true, CrowdControl = true }, blacklist = { BlockNoDuration = true } } }
            },
            highlight = { targetArrows = true },
            pvpIndicator = { enabled = false }
        }),
        friendlyNpc = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
            size = { 160, 14 },
            point = { "CENTER" },
            health = { value = { point = { "CENTER", "CENTER", 0, 0 }, fontSize = 12 }, percent = { enabled = false } },
            power = { enabled = false },
            name = { size = { 140, 10 }, tag = "[name]", point = { "BOTTOMLEFT", "TOPLEFT", 2, 5 } },
            level = { enabled = true, point = { "BOTTOMRIGHT", "TOPRIGHT", 2, 5 } },
            portrait = { enabled = false },
            auras = {
                enabled = true,
                buffs = { filter = { whitelist = { Personal = true, TurtleBuffs = true }, blacklist = { BlockNoDuration = true } } },
                debuffs = { filter = { whitelist = { Dispellable = true, RaidDebuffs = true, CrowdControl = true } } }
            },
            highlight = { targetArrows = true },
            pvpIndicator = { enabled = false }
        }),
        enemyNpc = R:CopyTable(DEFAULT_UNIT_CONFIG_NO_INDICATORS, {
            size = { 160, 14 },
            point = { "CENTER" },
            health = { value = { point = { "CENTER", "CENTER", 0, 0 }, fontSize = 12 }, percent = { enabled = false } },
            power = { enabled = false },
            name = { size = { 140, 10 }, tag = "[name]", point = { "BOTTOMLEFT", "TOPLEFT", 2, 5 } },
            level = { enabled = true, point = { "BOTTOMRIGHT", "TOPRIGHT", 2, 5 } },
            portrait = { enabled = false },
            auras = {
                enabled = true,
                buffs = { filter = { whitelist = { RaidBuffs = true, Dispellable = true, CastByUnit = true }, blacklist = { BlockNoDuration = true } } },
                debuffs = { filter = { whitelist = { Personal = true, Dispellable = true, CrowdControl = true }, blacklist = { BlockNoDuration = true } } }
            },
            highlight = { targetArrows = true },
            pvpIndicator = { enabled = false }
        }),
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
            nameplateMinAlpha = 0.4,
            nameplateMaxAlpha = 1,
            nameplateMinAlphaDistance = 0,
            nameplateMaxAlphaDistance = 40,
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
})
