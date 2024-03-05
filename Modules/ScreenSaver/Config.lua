local addonName, ns = ...
local R = _G.ReduxUI
local SS = R.Modules.ScreenSaver

R:RegisterModuleConfig(SS, {
    enabled = true,
    font = R.media.defaultFont,
    fontSize = 20,
    fontOutline = "OUTLINE",
    fontShadow = false,
    fader = R.config.faders.onShow
})
