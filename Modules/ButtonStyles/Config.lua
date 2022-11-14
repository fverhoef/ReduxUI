local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.OUT_OF_RANGE_MODES = {Button = "Button", Hotkey = "Hotkey"}

R:RegisterModuleConfig(BS, {
    enabled = true,
    border = R.media.textures.buttons.border,
    outOfRangeColoring = BS.OUT_OF_RANGE_MODES.Button,
    colors = {
        border = {0.5, 0.5, 0.5, 1},
        pushed = {1, 200 / 255, 0, 1},
        outOfRange = {0.8, 0.1, 0.1},
        usable = {1.0, 1.0, 1.0},
        notEnoughMana = {0.5, 0.5, 1.0},
        notUsable = {0.4, 0.4, 0.4}
    },
    actions = {
        backdrop = R.media.textures.buttons.backdrop,
        font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
        fontSize = 11,
        fontOutline = "OUTLINE",
        hideKeybindText = false,
        hideMacroText = true
    },
    auras = {font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"), fontSize = 10, fontOutline = "OUTLINE", minSizeToShowDuration = 30},
    items = {backdrop = R.media.textures.buttons.backdrop, font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"), fontSize = 12, fontOutline = "OUTLINE"},
    microMenu = {font = R.Libs.SharedMedia:Fetch("font", "Expressway Free"), fontSize = 10, fontOutline = "OUTLINE"}
})
