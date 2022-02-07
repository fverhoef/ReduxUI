local addonName, ns = ...
local R = _G.ReduxUI
local SS = R.Modules.ScreenSaver

R:RegisterModuleConfig(SS, {
    enabled = true,
    font = {R.config.defaults.profile.fonts.normal, 20, "OUTLINE"},
    fader = R.config.faders.onShow
})
