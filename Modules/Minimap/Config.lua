local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap
local L = R.L

MM.Styles = { Vanilla = "Blizzard - Vanilla", Modern = "Blizzard - Modern" }

R:RegisterModuleConfig(MM, {
    enabled = true,
    point = { "TOPRIGHT", "UIParent", "TOPRIGHT", -13, -13 },
    size = { 220, 220 },
    style = MM.Styles.Vanilla,
    showNorthTag = true,
    showWorldMap = false,
    calendarText = { enabled = true, font = R.media.defaultFont, fontSize = 10, fontOutline = "NORMAL", fontShadow = true, justifyH = "CENTER" },
    timeText = { enabled = true, font = R.media.defaultFont, fontSize = 12, fontOutline = "NORMAL", fontShadow = true, justifyH = "CENTER" },
    zonePanel = {
        enabled = true,
        showBorder = true,
        zoneText = { enabled = true, font = R.media.defaultFont, fontSize = 12, fontOutline = "NORMAL", fontShadow = true, justifyH = "LEFT" }
    },
    buttonFrame = { enabled = true, iconSize = 28, buttonSpacing = 3, collapsed = true, showBorder = true, fader = R.config.faders.onShow }
})
