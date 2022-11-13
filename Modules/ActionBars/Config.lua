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
        keyBoundTarget = "ACTIONBUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 5},
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
        hideHotkey = false,
        hideMacro = true,
        flyoutDirection = "UP"
    },
    actionBar2 = {
        enabled = true,
        keyBoundTarget = "MULTIACTIONBAR1BUTTON",
        page = 6,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 45},
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
        hideHotkey = false,
        hideMacro = true,
        flyoutDirection = "UP"
    },
    actionBar3 = {
        enabled = true,
        keyBoundTarget = "MULTIACTIONBAR2BUTTON",
        page = 5,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 85},
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
        hideHotkey = false,
        hideMacro = true,
        flyoutDirection = "UP"
    },
    actionBar4 = {
        enabled = true,
        keyBoundTarget = "MULTIACTIONBAR3BUTTON",
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
        hideHotkey = false,
        hideMacro = true,
        flyoutDirection = "LEFT"
    },
    actionBar5 = {
        enabled = true,
        keyBoundTarget = "MULTIACTIONBAR4BUTTON",
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
        hideHotkey = false,
        hideMacro = true,
        flyoutDirection = "LEFT"
    },
    actionBar6 = {
        enabled = false,
        keyBoundTarget = "REDUXUIBAR6BUTTON",
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
        hideHotkey = false,
        hideMacro = true,
        flyoutDirection = "UP"
    },
    actionBar7 = {
        enabled = false,
        keyBoundTarget = "REDUXUIBAR7BUTTON",
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
        hideHotkey = false,
        hideMacro = true,
        flyoutDirection = "UP"
    },
    actionBar8 = {
        enabled = false,
        keyBoundTarget = "REDUXUIBAR8BUTTON",
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
        hideHotkey = false,
        hideMacro = true,
        flyoutDirection = "UP"
    },
    actionBar9 = {
        enabled = false,
        keyBoundTarget = "REDUXUIBAR9BUTTON",
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
        hideHotkey = false,
        hideMacro = true,
        flyoutDirection = "UP"
    },
    actionBar10 = {
        enabled = false,
        keyBoundTarget = "REDUXUIBAR10BUTTON",
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
        hideHotkey = false,
        hideMacro = true,
        flyoutDirection = "UP"
    },
    stanceBar = {
        enabled = true,
        keyBoundTarget = "SHAPESHIFTBUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 95},
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
        showGrid = true,
        hideHotkey = false
    },
    petBar = {
        enabled = true,
        keyBoundTarget = "BONUSACTIONBUTTON",
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 135},
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
        showGrid = true,
        hideHotkey = false
    },
    vehicleExitBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 135},
        fader = R.config.faders.onShow,
        columnDirection = "Right",
        rowDirection = "Down",
        buttons = 12,
        buttonsPerRow = 6,
        buttonSize = 32,
        columnSpacing = 2,
        rowSpacing = 2,
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
