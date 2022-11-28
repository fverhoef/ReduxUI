local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

AB.UPDATE_DEFAULT_MODE = {[""] = "Never", ANY_CLICK = "Any Click", LEFT_CLICK = "Left Click", RIGHT_CLICK = "Right Click", MIDDLE_CLICK = "Middle Click"}
AB.COLUMN_DIRECTIONS = {"Right", "Left"}
AB.ROW_DIRECTIONS = {"Up", "Down"}
AB.DEFAULT_COOLDOWN_LABELS = {5, 15, 30, 60, 120, 180, 300}
AB.COOLDOWN_FILTERS = {NONE = "NONE"}

R:RegisterModuleConfig(AB, {
    enabled = true,
    statusbars = {experience = R.Libs.SharedMedia:Fetch("statusbar", "Redux"), reputation = R.Libs.SharedMedia:Fetch("statusbar", "Redux")},
    colors = {},
    mainMenuBarArt = {enabled = true, fader = R.config.faders.onShow, style = "Default - Gryphon", stackBottomBars = false},
    microButtonAndBags = {enabled = true, point = {"BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0}, fader = R.config.faders.mouseOver},
    actionBar1 = {
        enabled = true,
        buttonType = "ACTIONBUTTON",
        page = 1,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 50},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = true,
        border = true,
        shadow = true,
        clickOnDown = true,
        showGrid = true,
        flyoutDirection = "UP"
    },
    actionBar2 = {
        enabled = true,
        buttonType = "MULTIACTIONBAR1BUTTON",
        page = 6,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 90},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        clickOnDown = true,
        showGrid = true,
        flyoutDirection = "UP"
    },
    actionBar3 = {
        enabled = true,
        buttonType = "MULTIACTIONBAR2BUTTON",
        page = 5,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 128},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        clickOnDown = true,
        showGrid = true,
        flyoutDirection = "UP"
    },
    actionBar4 = {
        enabled = true,
        buttonType = "MULTIACTIONBAR3BUTTON",
        page = 3,
        point = {"RIGHT", "UIParent", "RIGHT", -5, 0},
        fader = R.config.faders.mouseOver,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 1,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        clickOnDown = true,
        showGrid = true,
        flyoutDirection = "LEFT"
    },
    actionBar5 = {
        enabled = true,
        buttonType = "MULTIACTIONBAR4BUTTON",
        page = 4,
        point = {"RIGHT", "UIParent", "RIGHT", -43, 0},
        fader = R.config.faders.mouseOver,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 1,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        clickOnDown = true,
        showGrid = true,
        flyoutDirection = "LEFT"
    },
    actionBar6 = {
        enabled = false,
        buttonType = "REDUXUIBAR6BUTTON",
        page = 7,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        clickOnDown = true,
        showGrid = true,
        flyoutDirection = "UP"
    },
    actionBar7 = {
        enabled = false,
        buttonType = "REDUXUIBAR7BUTTON",
        page = 8,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        clickOnDown = true,
        showGrid = true,
        flyoutDirection = "UP"
    },
    actionBar8 = {
        enabled = false,
        buttonType = "REDUXUIBAR8BUTTON",
        page = 9,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        clickOnDown = true,
        showGrid = true,
        flyoutDirection = "UP"
    },
    actionBar9 = {
        enabled = false,
        buttonType = "REDUXUIBAR9BUTTON",
        page = 10,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        clickOnDown = true,
        showGrid = true,
        flyoutDirection = "UP"
    },
    actionBar10 = {
        enabled = false,
        buttonType = "REDUXUIBAR10BUTTON",
        page = 11,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 36,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        clickOnDown = true,
        showGrid = true,
        flyoutDirection = "UP"
    },
    stanceBar = {
        enabled = true,
        buttonType = "SHAPESHIFTBUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 166},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 32,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        showGrid = false
    },
    petBar = {
        enabled = true,
        buttonType = "BONUSACTIONBUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 166},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 32,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false,
        showGrid = false
    },
    vehicleExitBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 166},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 32,
        columnSpacing = 2,
        rowSpacing = 2,
        backdrop = false,
        border = false,
        shadow = false
    },
    totemBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 225},
        fader = R.config.faders.onShow,
        buttonSize = 32,
        columnSpacing = 5,
        backdrop = false,
        border = false,
        shadow = false
    },
    extraActionBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 305},
        fader = R.config.faders.onShow
    },
    zoneBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 225},
        fader = R.config.faders.onShow
    },
    experienceBar = {
        Enabled = true,
        Point = {"BOTTOM", "UIParent", "BOTTOM", 0, 25},
        Size = { 452, 14 }
    },
    reputationBar = {
        Enabled = true,
        Point = {"BOTTOM", "UIParent", "BOTTOM", 0, 8},
        Size = { 452, 11 }
    },
    systemInfo = {
        enabled = true,
        lowLatencyTreshold = 70,
        lowLatencyColor = {0 / 255, 175 / 255, 0 / 255},
        mediumLatencyTreshold = 120,
        mediumLatencyColor = {225 / 255, 150 / 255, 0 / 255},
        highLatencyColor = {225 / 255, 0 / 255, 0 / 255},
        lowFpsTreshold = 20,
        lowFpsColor = {225 / 255, 0 / 255, 0 / 255},
        mediumFpsTreshold = 50,
        mediumFpsColor = {225 / 255, 150 / 255, 0 / 255},
        highFpsColor = {0 / 255, 175 / 255, 0 / 255},
        addonsToDisplay = 10
    }
})
