local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.OUT_OF_RANGE_MODES = {Button = "Button", Hotkey = "Hotkey"}

R:RegisterModuleConfig(BS, {
    enabled = true,
    border = R.media.textures.buttons.borderThick,
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
        font = R.config.defaults.profile.fonts.normal,
        fontSize = 11,
        fontOutline = "OUTLINE",
        hideKeybindText = false,
        hideMacroText = true,
        gloss = true,
        replaceBorders = true
    },
    auras = {font = R.config.defaults.profile.fonts.normal, fontSize = 10, fontOutline = "OUTLINE", minSizeToShowDuration = 30, gloss = true},
    items = {backdrop = R.media.textures.buttons.backdrop, font = R.config.defaults.profile.fonts.normal, fontSize = 12, fontOutline = "OUTLINE", gloss = true, replaceBorders = true},
    microMenu = {font = R.config.defaults.profile.fonts.normal, fontSize = 10, fontOutline = "OUTLINE", gloss = true}
})
