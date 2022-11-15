local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap
local L = R.L

R:RegisterModuleConfig(MM, {
    enabled = true,
    point = { "TOPRIGHT", "UIParent", "TOPRIGHT", -13, -13 },
    size = { 220, 220 },
    showNorthTag = true,
    zoneText = { enabled = true, showBackground = true, font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"), fontSize = 14, fontOutline = "OUTLINE", fontShadow = true, justifyH = "CENTER", showBorder = true },
    infoPanel = { enabled = true, showBackground = true, showTime = true },
    buttonFrame = { enabled = true, iconSize = 28, buttonSpacing = 3, collapsed = true, showBorder = true, fader = R.config.faders.onShow }
})
