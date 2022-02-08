local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap
local L = R.L

R:RegisterModuleConfig(MM, {
    enabled = true,
    point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -13, -13},
    size = {190, 190},
    enableMailGlow = false,
    showNorthTag = true,
    zoneText = {
        enabled = true,
        showBackground = true,
        font = R.config.defaults.profile.fonts.normal,
        fontSize = 14,
        fontOutline = "OUTLINE",
        fontShadow = true,
        justifyH = "CENTER"
    },
    infoPanel = {enabled = true, showBackground = true, showTime = true},
    mask = R.media.textures.minimap.minimapMask1,
    border = {enabled = false},
    shadow = {enabled = false},
    buttonFrame = {enabled = true, iconSize = 22, buttonSpacing = 2, collapsed = true}
})